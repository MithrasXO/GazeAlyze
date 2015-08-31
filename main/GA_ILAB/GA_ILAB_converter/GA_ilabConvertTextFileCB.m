function ilabConvertTextFileCB()
% ILABCONVERTTEXTFILECB - converts a tab delimited text file to ILAB format
% The initial version will assume a simplifed file design and ask a series
% of questions of the user. This can be integrated into a dialog later.

% Authors: Darren Gitelman
% $Id: ilabConvertTextFileCB.m 1.1 2004-04-29 17:10:47-05 drg Exp drg $

persistent CONVERTPATH

if ~isempty(CONVERTPATH),  cd(CONVERTPATH); end;

% initialize output variables.
datamat     = [];
serialidx   = [];
hz          = [];
subject     = [];
filedate    = [];
filetime    = [];
description = [];
ver.num     = 0.9;
ver.type    = 'text';

% choose a text file
[fname, pname] = uigetfile('*.*','Select a TEXT data file');
drawnow
  
if (fname(1) == 0) return; end;

CONVERTPATH = pname;   %  Save the path to the data file
cd(CONVERTPATH)

% choose a delimiter
dl = questdlg('Choose a column delimiter','Convert Text File','Tab','Comma','Space','Tab');

switch dl
    case 'Tab'
        dl = '\t';
    case 'Comma';
        dl = ',';
    case 'Space'
        dl = ' ';
end

% number of columns
ncols = inputdlg('Enter the number of colums','Convert Text File');
ncols = str2num(char(ncols));
if ncols < 2
    errordlg('Not enough data columns. There must be at least 2 columns.','ILAB ERROR','modal');
    return
end

% assemble the textread format string. Assume numbers are floats.
% this should work for either integers or floats
format = [];
for i = 1:ncols
    format = [format, '%f'];
    if i < ncols
        format = [format, dl];
    end
end

% read the data
out = cell(1,ncols);
try
    [out{:}] = textread(fullfile(pname,fname),format,'whitespace',dl);
catch
    errordlg('Could not parse the text file. The number of columns or the delimiter must be incorrect.',...
        'ILAB ERROR','modal');
    return
end

% figure out which columns represent Horiz eye data, Vertical eye data,
% pupil data and start/stop codes
horizcol = [];
vertcol  = [];
pupilcol = 0;
auxcol   = 0;
horizcol = inputdlg('Enter column number for Horizontal Eye Data.','Convert Text File');
horizcol = str2num(char(horizcol));
vertcol  = inputdlg('Enter column number for Vertical Eye Data.','Convert Text File');
vertcol  = str2num(char(vertcol));
if isempty(horizcol) | isempty(vertcol) | ...
        (horizcol > ncols) | (vertcol > ncols)
    errordlg('Must have both Horizontal and Vertical Eye Data','ILAB ERROR','modal');
    return
end
if ncols > 2
    pupilcol = inputdlg('Enter column number of Pupil Data or 0 for none','Convert Text File');
    pupilcol = str2num(char(pupilcol));
    if isempty(pupilcol)
        pupilcol = 0;
    end
    auxcol   = inputdlg('Enter column number for trial starts and stops or 0 for none',...
        'Convert Text File');
    auxcol   = str2num(char(auxcol));
    if isempty(auxcol)
        auxcol = 0;
    end
end

% setup datamat from the column information
datamat(:,1) = out{horizcol};
datamat(:,2) = out{vertcol};
datamat = [datamat, zeros(size(datamat,1),2)];

if auxcol ~= 0
    datamat(:,3) = out{auxcol};
end
if pupilcol ~= 0
    datamat(:,4) = out{pupilcol};
end

% enter other variable values
% This while loop blocks clicking OK with no entry and exits the
% conversion process if the user clicks cancel
while 1
    hz          = inputdlg('Enter the data sampling rate in Hz.','Convert Text File');
    % assume the user canceled and just exit the routine
    if isempty(hz)
        h = warndlg('Conversion cancelled','ILAB WARNING','modal');
        uiwait(h);
        return
    else
        % if empty then the user clicked ok but didn't enter anything
        if ~isempty(hz{1})
            hz          = str2num(char(hz));
            % check one last time. If hz is empty then whatever the user
            % entered could not be converted to a number.
            if ~isempty(hz)
                break
            end
        end
    end
end

subject     = inputdlg('Enter the subject ID (or leave blank)','Convert Text File');
subject     = char(subject);
filedate    = inputdlg('Enter the file creation date (or leave blank)','Convert Text File');
filedate    = char(filedate);
filedate    = inputdlg('Enter the file creation time (or leave blank)','Convert Text File');
filedate    = char(filedate);
description = inputdlg('Enter a description (or leave blank)','Convert Text File');
description = char(description);

% setup the serial index.
% ------------------------------------------------------------------------------
% Checks to see if serialidx is empty, if so, will put a start and stop at both
% ends of the datamat in the code column.  Assumes one trial was done.
% ------------------------------------------------------------------------------
AP = ilabGetAnalysisParms;
if nnz(datamat(:,3)) == 0
    datamat(1,3) = AP.trialCodes.start(1);
    datamat(end,3) = AP.trialCodes.end(1);
    h = warndlg({'No Serial codes found!';'Placed Start and Stop codes in data.'},...
        'ILAB Warning', 'modal');
    uiwait(h);
end
% dataidx = find(datamat(:,3:3));

% ------------------------------------------------------------------------------
%   Try to create a trial index array, dataidx,
%   structured as in earlier versions of ilab (start, <target>, stop)
% _______________________________________________________________________________

iStart = find(ismember(datamat(:,3), AP.trialCodes.start));
iStop = find(ismember(datamat(:,3), AP.trialCodes.end));
iTarget = find(ismember(datamat(:,3), AP.trialCodes.target));
nStartCodes = length(iStart);
nStopCodes = length(iStop);
nTargetCodes = length(iTarget);

nTrials = max(nStartCodes, nStopCodes);

% changed so that dataidx is always 3 columns
%-------------------------------------------------------------------
dataidx = zeros(nTrials, 3);

if nStartCodes > 0
    dataidx(1:nStartCodes,1) = iStart;
end;

if nStopCodes > 0
    if nStartCodes > 0
        k = max(find(iStart <= iStop(1) ));  % position first stop code after likely start
        if isempty(k) | (k < 1) | (nStopCodes+k-1 > nTrials),    k = 1;      end;
    else
        k = 1;
    end;
    dataidx(k:nStopCodes+k-1,2) = iStop;
end;

if nTargetCodes > 0
    k = max(find(iStart <= iTarget(1)));  % position first target code after likely start
    if isempty(k) | (k < 1) | (nTargetCodes+k-1 > nTrials),     k = 1;   end;
    dataidx(k:nTargetCodes+k-1,3) = iTarget;   
    %  dataidx = dataidx(:,[1 3 2]);
end;

% create the ILAB variable
ILAB = ilabEYEDATA2ILAB(fname, pname, datamat, dataidx, hz,...
                        subject, filedate, filetime, description, ver);

% show the data properties dialog
ilabReviewILABCB('init', ILAB);

return;