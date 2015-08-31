function [ILAB, ANALYSISPARMS] = GA_ilabConvertIVIEW(pname, fname, ANALYSISPARMS)
% ILABCONVERTIVIEW -- converts an iView.dat ascii data file
%   [datamat, dataidx, hz, subject, filedate, filetime, description, ver] = 
%   ILABCONVERTIVIEW(pname, fname) Converts iView.dat file to a list of ILAB
%   compatible variables

% Authors: Darren Gitelman, Roger Ray (based on convert asl function)
% $Id: ilabConvertIVIEW.m 1.16 2004-10-08 18:47:20-05 drg Exp drg $

% Initialize variables
% --------------------------------
ILAB          = GA_ilabcreateILABstruct();
ILAB.path     = pname;
ILAB.fname    = fname;
ILAB.type     = 'iview';
[p, f, e]     = fileparts(fname);
ILAB.subject  = f;

datapts     = [];
offsetcal   = [];

tab =  9;   % tab character ascii value
space = 32; % space character ascii value

% user defined codes
%------------------------------------------------------

SC.START       = ANALYSISPARMS.trialCodes.start;
SC.TARGET      = ANALYSISPARMS.trialCodes.target;
SC.STOP        = ANALYSISPARMS.trialCodes.end;

% --------------------------------
%  Open the file for reading as ascii
% --------------------------------
fid = fopen([pname fname],'r');
if fid == -1
    ILAB = [];
    ILAB.error = 'IVIEW: Could not open data file';
    return;
end;

%----------------------------------------------------------------------
% Set up header description variables. The fileformat and 
% fileversion history are not known so it is unclear whether
% the current code will convert other versions. 
%----------------------------------------------------------------------
fileverstr  = sprintf('fileversion:');
fileverl    = 14;
fileformstr = sprintf('fileformat:');
fileforml   = 13;
subjstr     = sprintf('subject:');
subjl       = 10;
datestr     = sprintf('date:');
datel       = 7;
descstr     = sprintf('description:');
descl       = 14;
numptsstr   = sprintf('# of pts recorded:');
numptsl     = 20;
offsetstr   = sprintf('offset of calibration area:');
offsetl     = 29;
sizestr     = sprintf('size of calibration area:');
sizel       = 27;
sampstr     = sprintf('sample rate:');
sampl       = 13;

%----------------------------------------------------------------------
% Actually read the header strings then parse.
%----------------------------------------------------------------------
filevertmp  = fgetl(fid);
fileformtmp = fgetl(fid);
subjtmp     = fgetl(fid);
datetmp     = fgetl(fid);
desctmp     = fgetl(fid);
numptstmp   = fgetl(fid);
offsettmp   = fgetl(fid);
sizetmp     = fgetl(fid);
samptmp     = fgetl(fid);

%----------------------------------------------------------------------
% Check each header string for proper format and extract data.
% All variables are already initialized to empty
%----------------------------------------------------------------------
ILAB.type  = 'iview';
if strfind(lower(filevertmp),fileverstr)
    ver.num = filevertmp(fileverl+1:end);
end
if strfind(lower(fileformtmp),fileformstr)
    ver.num = [ver.num,' / ',fileformtmp(fileforml+1:end)];
else
    ver.num = [ver.num,' / '];
end
ILAB.vers = ver.num;
if strfind(lower(subjtmp),subjstr)
    ILAB.subject   = subjtmp(subjl+1:end);
end
if strfind(lower(datetmp),datestr)
    ILAB.date      = datetmp(datel+1:end);
end
if strfind(lower(desctmp),descstr)
    ILAB.comment   = desctmp(descl+1:end);
end
if strfind(lower(numptstmp),numptsstr)
    datapts       = str2num(numptstmp(numptsl+1:end));
end
if strfind(lower(offsettmp),offsetstr)
    offsetcal     = str2mat(offsettmp(offsetl+1:end));
end
% The coordSys information is not preserved. Users should know this to
% select the proper coordinate system
if strfind(lower(sizetmp),sizestr)
    coordsys      = str2mat(sizetmp(sizel+1:end));
end
if strfind(lower(samptmp),sampstr)
    ILAB.acqRate  = str2num(samptmp(sampl+1:end));
    ILAB.acqIntvl = 1000/ILAB.acqRate;
end

%----------------------------------------------------------------------
% Dump the next line.
%----------------------------------------------------------------------
junk = fgetl(fid);

%----------------------------------------------------------------------
% Unfortunately the IVIEW format is not constant with respect to exported data.
% We need the Set, ScreenH, ScreenV, and PupilH columns. Other columns are
% ignored for now. Since this line is ascii we must figure out the column
% locations of the data. It appears this line is tab delimited.
%----------------------------------------------------------------------
datalabel  = fgetl(fid);
setloc     = findstr('Set',datalabel);
screenHloc = findstr('ScreenH',datalabel);
screenVloc = findstr('ScreenV',datalabel);
pupHloc    = findstr('Diam H',datalabel);

tabloc     = find(datalabel == tab);
if isempty(tabloc)
    datalabel = maskDataLabel(datalabel);
    tabloc = find(datalabel == space);
end
if isempty(tabloc)
    fclose(fid);
    ILAB = [];
    ILAB.error = 'IVIEW: Could not figure out format of data header string.';
    ilabProgressBar('clear');    
    return
end

% ---------------------------------------------------------------------
% Read the data
% ---------------------------------------------------------------------
rawdata  = fread(fid,'uchar');
fclose(fid);

% ---------------------------------------------------------------------
% converts rawdata into datamat with corresponding integer values
% ---------------------------------------------------------------------
datamat  = char(rawdata);
[data, ncols, errmsg, nxtindex] = sscanf(datamat,'%i');

% --------------------------------------------------------------------------
% reshape datamat into a  matrix
% --------------------------------------------------------------------------
try
    datamat  = reshape(data,[size(data,1)/datapts datapts]);
    datamat  = datamat';
catch
    %-----------------------------------------------------------------
    % reshape didn't work so we may not have the correct
    % number of datapoints
    %-----------------------------------------------------------------
    firstEOL = min(find(datamat == 10));
    numSpace = length(find(datamat(1:firstEOL) == 32));
    datamat = reshape(data,(numSpace+1),length(data)/(numSpace+1));
    datamat = datamat';
end

% Add a dummy column to datamat for indexing empty columns
%---------------------------------------------------------------------------
datamat = [datamat, zeros(size(datamat,1),1)];

% Make sure there is only one of each label type
% then find the data columns by comparison with the tabs vector
% ---------------------------------------------------------------------
if prod(size(screenHloc)) == 1 & prod(size(screenVloc)) == 1
    screenHcol = size(find(screenHloc > tabloc),2) + 1;
    screenVcol = size(find(screenVloc > tabloc),2) + 1;
else
    ilabProgressBar('clear');
    ILAB = [];
    ILAB.error = 'IVIEW: One or more data columns has been duplicated or not saved.';
    return
end
if isempty(setloc)
    setcol  = size(datamat,2);
else
    setcol  = size(find(setloc     > tabloc),2) + 1;
end
if isempty(pupHloc)
    pupHcol = size(datamat,2);
else
    pupHcol = size(find(pupHloc    > tabloc),2) + 1;
end

% ---------------------------------------------------------------------
% Find the ends of trials.
% ---------------------------------------------------------------------
endidx   = find(diff(datamat(:,setcol)));

% --------------------------------------------------------------------------
% Reorganize the columns of datamat and throw away extra columns
% [ScreenH ScreenV Set Pupil H]
% --------------------------------------------------------------------------
datamat  = [datamat(:,screenHcol), datamat(:,screenVcol),...
        zeros(size(datamat,1),1), datamat(:,pupHcol)];

% ---------------------------------------------------------------------
% If trialidx is empty then there were no defined trials. In this
% case define start as first data point and end as last.
% ---------------------------------------------------------------------
if isempty(endidx)
    datamat(1,3)   = SC.START(1);
    datamat(end,3) = SC.STOP(1);
    h = errordlg({'No Serial codes found!';'Placed Start and Stop codes in data.'},...
        'ILAB Warning', 'modal');
    uiwait(h);    
    startidx = 1;
    endidx   = length(datamat);
else
    startidx = endidx + 1;
    if startidx(1) > 1
        startidx = [1;startidx];
    end
    if endidx(end) < size(datamat,1)
        endidx = [endidx;size(datamat,1)];
    end
end

% ---------------------------------------------------------------------
% At this point I don't see any way of differentiating trial types in IVIEW.
% That is, it appears that the set column is linearly increasing and one
% cannot designate the set number according to trial type. Thus, although
% the set column differentiates different trials, the user cannot determine
% what the set number will be. Therefore, the start and end codes will 
% just be set to the first one of each type. 
% ILAB doesn't yet use this information anyway.
% There also does not seem to be a way to set up a target
% ---------------------------------------------------------------------
datamat(startidx,3) = SC.START(1);
datamat(endidx,3)   = SC.STOP(1);

% dataidx is now always 3 columns
dataidx = [startidx endidx];
dataidx(:,3) = NaN;

ILAB.data   = datamat;
ILAB.index  = dataidx;
ILAB.trials = size(dataidx,1);

return

%----------------------------------------------------------------------
%  INTERNAL FUNCTIONS
%----------------------------------------------------------------------
function datalabel = maskDataLabel(datalabel)
% This function attempts to parse the header string when spaces separate
% the labels rather than tabs. It masks off known labels and thereby
% removes spaces that are internal to some of the labels, for example
% 'Pupil H'. It will miss labels that are currently unknown since I
% don't have an IVIEW system.

% only have to mask off labels with known spaces. These are the only labels
% with spaces that I know about. DRG.
labels = {'Pupil H';'Pupil V';'C.R. H';'C.R. V';'Diam H';'Diam V'};

for i = 1:length(labels)
   tmp = strfind(datalabel,labels{i});
   if ~isempty(tmp)
       datalabel(tmp:tmp+length(labels{i})-1) = 0;
   end
end
