function [ILAB, flag_error] = GA_ilabConvert(strSystem, path, file, import)

global eye;

flag_error = 0;
ILAB=[];

%=====================================================================
% SETUP ILAB VARIABLE SECTION
%=====================================================================

ILAB = GA_ilabcreateILABstruct();

% This will return the following structure. The data type is in parentheses
% ILAB =    path: []            Path to selected data file (string)
%          fname: []            Name of selected data file (string)
%           type: []            Type of eye data file, e.g. ASL or ISCAN (string)
%           vers: []            Version of the eye data file (double, scalar)
%        subject: []            Subject ID (string)
%           date: []            Date of run (string)
%           time: []            Time of run (string)
%        comment: []            Comments (string)
%       coordSys: [1x1 struct]  Leave alone.
%        acqRate: []            Data acquisition speed, e.g., 60 or 120 (double, scalar)
%       acqIntvl: []            Acquisition interval in msecs (i.e., 1000/acqRate (double, scalar)
%           data: []            Actual data. (double, matrix) Must be organized as n x 3 or
%                               n x 4 matrix. Column order is horizontal eye data,
%                               vertical eye data, trial start/end markers, and
%                               pupil data. Pupil data is optional. Trial start/end
%                               markers are numbers that ILAB interprets as the start
%                               and end of trials based on the trial codes. For example,
%                               if the start code is 1, end code is 255, there is 1 trial,
%                               there are n data points, then ILAB.data(1,3) = 1,
%                               and ILAB.data(n,3) = 255, and the rest of ILAB.data(:,3)
%                               would be 0.
%         trials: 0             Number of trials (double, scalar)
%          index: []            Index to start and end of each trial. (n x 3)
%                               Column 1 is for trial starts, Column 2 for ends
%                               and column 3 for targets or just NaN. Using
%                               the previous example if there was one trial
%                               and no targets then ILAB.index = [1 n NaN];
%                               Where n is replaced by the actual last line
%                               number of the data.
%          image: [1x1 struct]  Leave alone
%     trialCodes: []            Leave alone
%
% ********************************************************************
% The code must fill in fields acqRate, acqIntvl, data, index, and
% trials. All other fields can be left empty.
% ********************************************************************

ILAB.path  = path;
ILAB.fname = file;
ILAB.type  = strSystem;
ILAB.vers  = import.header.ProductVersion;
ILAB.subject = file(1:length(file)-4);
ILAB.date = import.header.date;
ILAB.time = import.header.time;

ILAB.coordSys.name = [strSystem import.header.ScreenSize];
%ILAB.coordSys.name = [import.type import.ScreenSize];
%
% ILAB.coordSys.data     = [];
% ILAB.coordSys.params.h = [1,0];
% ILAB.coordSys.params.v = [1,0];
% ILAB.coordSys.screen   = [eye.blink.limits(2),eye.blink.limits(4)];
% ILAB.coordSys.eyetrack = [eye.blink.limits(2),eye.blink.limits(4)];
ILAB.coordSys.data     = [];
ILAB.coordSys.params.h = [1,0];
ILAB.coordSys.params.v = [1,0];

flag_default=0;
if isfield(eye,'defaultscreen')
    flag_default=0;
    if isempty(eye.defaultscreen)
    elseif max(eye.defaultscreen)>0
        flag_default=1;
    end
end;
if flag_default
    x_screen= eye.defaultscreen(1,2);
    y_screen= eye.defaultscreen(1,4);
else
    screenval = regexp(import.header.ScreenSize, ' ', 'split');
    screenval = str2double(screenval);
    x_screen= screenval(1);
    y_screen= screenval(2);
end;

ILAB.coordSys.screen   = [x_screen , y_screen];
ILAB.coordSys.eyetrack = [x_screen , y_screen];

if ~isnumeric(import.header.FrameRate)
    import.header.FrameRate = str2double(import.header.FrameRate);
end;
ILAB.acqRate = import.header.FrameRate;
ILAB.acqIntvl = 1000 / import.header.FrameRate;


%allocating and declaration
markStartIndx = [];
markerCode = [];
markEndIndx= [];

%allocating für ILAB-Marker-Code
markerCodeall = zeros(length(import.data(:,1)),1);

%liste aller Marker, zeigt auf startmarker
cond = cell(length(import.marker.values),1);

%es werden jedes einzelne Marker-Label in den Daten gesucht.
%als Daten dienen die Liste aller Values und zugehörige Zeiten in Reheinfolge ihres auftretens
% liste der marker ist fortlaufende liste mit einmaligem nennen aller möglichen marker

%cond values allways a string containing single values seprarated by
%semicolons
startvalues = regexp(eye.cond.start.values, ';', 'split');
startvalues = strtrim(startvalues);
idx_0 = ~strcmp(startvalues,'');
startvalues=startvalues(idx_0);
eval(['codes = [' eye.cond.start.codes '];']);

for i=1:length(startvalues)
    nested=[];
    %cond string occures in some other cond strings
    for j=1:length(startvalues)
        if ~isempty(strfind(startvalues{j}, startvalues{i})) && j~=i
            nested(end+1)=j;
        end;
    end;
    %markierung der marker mit spez. value, erstes auftreten im cond-value
    %über alle daten
    if isnumeric(import.marker.values)
       cond(import.marker.values == str2double(startvalues{i}))={1};
    else
    for k = 1:length(import.marker.values)
        % wenn der i-te aus der Labelliste, dann markiert.
        cond{k} = strfind(import.marker.values{k,1}, startvalues{i});
        if ~isempty(cond{k})
            for j=1:length(nested)
                if ~isempty(strfind(import.marker.values{k,1}, startvalues{nested(j)}))
                    cond{k} = [];
                    break;
                end;
            end;
        end;
    end;
    end;
    Index= zeros(1,length(cond));
    for j=length(cond):-1:1
        if isempty(cond{j})
            Index(j)=[];
        elseif(cond{j}==0)
            Index(j)=[];
            %indizes dieser spez. marker im ges. file
        else
            Index(j)=j;
        end;
    end;    
    %time of cond marker
    timcond = import.marker.times(Index,1);
    
    %Länge des Trials:
    if strcmpi(eye.cond.type, 'single marker/fixed length')
        %eventuell offset?
        timstart = timcond + eye.cond.offset ./ 1000;
        timend   = timstart + eye.cond.duration ./ 1000;
    elseif strcmpi(eye.cond.type, 'start/stop marker')
        if isnumeric(import.marker.values)
            stopIdx = find(import.marker.values == str2double(eye.cond.stop.val));
        else
            stopIdx = find(strcmp(import.marker.values , eye.cond.stop.val));
        end;
        stopTimes = import.marker.times(stopIdx);
        timstop = zeros(length(timcond),1);
        for j=1:length(timcond)
            stopTimes = stopTimes(stopTimes>timcond(j));
            timstop(j) =  stopTimes(1);
        end
        if eye.cond.stop.fix_at_end
            timend = timstop;
            timstart = timcond;
        else
            timend = timcond;
            timstart = timstop;
        end;
        timstart = timstart + eye.cond.offset ./ 1000;
    end;
    %Einzelauswertung geblockter trials
    if eye.cond.flag_blocked
        timstart_bl = zeros(1,length(Index) * eye.cond.block.trlcnt);
        for j = 1 : length(Index)
            timstart_bl((j-1)*eye.cond.block.trlcnt + 1 ) = timstart(j);
            for k=2:eye.cond.block.trlcnt
                timstart_bl((j-1)*eye.cond.block.trlcnt + k ) = timstart(j) + k*(eye.cond.block.trlblank + eye.cond.duration) ./ 1000;
            end;
        end;
        timstart = timstart_bl;
        %Länge des Trials:
        if strcmpi(eye.cond.type, 'single marker/fixed length')
            timend = timstart + eye.cond.duration ./1000;
        elseif strcmpi(eye.cond.type, 'start/stop marker')
            if isnumeric(import.marker.values)
                stopIdx = find(import.marker.values == str2double(eye.cond.stop.val));
            else
                stopIdx = find(strcmp(import.marker.values , eye.cond.stop.val));
            end;
            stopTimes = import.marker.times(stopIdx);
            timend = zeros(length(timstart),1);
            for j=1:length(timstart)
                stopTimes = stopTimes(stopTimes>timstart(j));
                timend(j) =  stopTimes(1);
            end
        end;
    end;
    %allocating
    markStartIndx=zeros(length(timend),1);
    markEndIndx=zeros(length(timend),1);
    for j = 1:length(timend)
        %finden der indizes der startzeiten
        markStartIndx(j) = find(import.data(:,1)>=timstart(j),1,'first');
        if timend(j)> import.data(end,1)
            markEndIndx(j) = length(import.data(:,1));
        else
            %finden der indizes der endzeiten
            markEndIndx(j) = find(import.data(:,1)>=timend(j),1,'first');
        end;
    end;
    %trials closed together?
    %% find taken Indices (allready used as marker)
    used = find(markerCodeall(markStartIndx,1));
    %adding 1 (next Index) if used
    markStartIndx(used) = markStartIndx(used) + 1;
    %start code is code number corresponding to Cond Value
    markerCodeall(markStartIndx,1) = codes(i);
    % find taken Indices (allready used as start marker)
    used = find(markerCodeall(markEndIndx,1));
    %adding 1 (next Index) if used
    markEndIndx(used) = markEndIndx(used) - 1;
    %Endcode
    markerCodeall(markEndIndx,1) = 255;
    
    a=find(markerCodeall==255);
    b=find(markerCodeall~=255 & markerCodeall~=0);
    
    if length(a)~=length(b)
        disp(['error bei trial:' startvalues{i}]);
    end;
end;

%++++++++++++++++++++++++
%convert fixation trials
%++++++++++++++++++++++++
if eye.cond.flag_fixedgaze
    if isnumeric(import.marker.values)
        cond = (import.marker.values ==str2double(eye.cond.fix.string));
    else
        cond = strfind(import.marker.values, eye.cond.fix.string);
        cond = ~cellfun('isempty',cond);
    end;    
    fixons  = import.marker.times(cond);
    %eventuell offset?
    fixons = fixons + eye.cond.fix.offset ./ 1000;
    fixend   = fixons + eye.cond.fix.duration ./ 1000;
    
    %allocating
    fixonsIX=zeros(length(fixons),1);
    fixendIX=zeros(length(fixons),1);
    for j = 1:length(fixonsIX)
        %finden der indizes der startzeiten
        fixonsIX(j) = find(import.data(:,1)>=fixons(j),1,'first');
        %finden der indizes der endzeiten
        fixendIX(j) = find(import.data(:,1)>=fixend(j),1,'first');
    end;
    
    %check if fixation overlaps trial -->error
    trialmark=find(markerCodeall==255);
    for j = 1:length(fixonsIX)
        overlap = find(trialmark >= fixonsIX(j) & trialmark <= fixendIX(j));
        if ~isempty(overlap)
            fixonsIX(j)=trialmark(overlap)+1;
        end;
    end;
    
    trialmark = find(markerCodeall~=255 & markerCodeall~=0);
    for j = 1:length(fixonsIX)
        overlap = find(trialmark >= fixonsIX(j) & trialmark <= fixendIX(j));
        if ~isempty(overlap)
            fixendIX(j)=trialmark(overlap)-1;
        end;
    end;
    
    for j = 1:length(fixonsIX)
        if any(trialmark >= fixonsIX(j) & trialmark <= fixendIX(j));
            error('error by importing file: fixation and trial period mismatch');
        end;
    end;
    %Startcode fixation
    markerCodeall(fixonsIX,1) = max(codes) + 1;
    %Endcode fixation
    markerCodeall(fixendIX,1) = 255;
    
    a=find(markerCodeall==255);
    b=find(markerCodeall~=255 & markerCodeall~=0);
    
    if length(a)~=length(b)
        disp('error at fixation import');
    end;
end

%data zusammenfügen
ILAB.data= [import.data(:,2:3) markerCodeall zeros(length(import.data(:,1)),1)];

%trials
ILAB.trials= length(find(markerCodeall~=0 & markerCodeall~=255));

%Index
nans = ones(ILAB.trials,1)*NaN;
startIndizes = find(markerCodeall~=255 &  markerCodeall~=0);
endIndizes   = find(markerCodeall==255);
ILAB.index= [ startIndizes endIndizes nans];

