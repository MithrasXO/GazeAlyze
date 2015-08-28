function table = ilabMkSaccadeTbl(saccadeList, layoutType)
global eye;
% ILABMKSACCADETBL -- Makes table of Saccade results
%   TABLE =  ILABMKSACCADETBL(saccadeList, layoutType) -- Makes an ASCII formatted
%   table from the list of saccade results. Table is returned as a cell array
%   with the title line as the first cell.
%   saccadeList - The list of saccades (cf. ilabMkSaccadeList)
%   layoutType - string ['listbox' | 'spreadsheet'] which determines the
%                type of table produced.
%   Listbox layout has space-padded fields with no line delimiters
%   Spreadsheet layout has tab-delimited fields which end with a '\n' character.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabMkSaccadeTbl.m 1.3 2004-02-17 23:34:37-06 drg Exp $

% -----------------------------------------
% Get acquisition interval
% -----------------------------------------
acqIntvl = eye.ILAB.acqIntvl;

%  Layout type codes
%  --------------------
LISTBOX = 1;
SPREADSHEET = 2;

table = [];

if isempty(saccadeList), return; end;

% --------------------------------------------------------------
%  Change layoutType to an integer for simpler testing in logic
% --------------------------------------------------------------
if strcmp(lower(layoutType), 'listbox')
  layoutType = LISTBOX;
else
  layoutType = SPREADSHEET;
end;


if layoutType == LISTBOX
  tTitle = str2mat(['Trial Sacc#  Start   End     vPeak    vMean    SRT   ttPeak  dist  %Zero'],...
  [blanks(14) ' ms     ms    deg/sec   deg/sec   ms     ms']);
  fmtStr = '%4d  %4d   %6.0f  %6.0f     %5.1f    %5.1f   %6.0f   %6.0f   %5.1f %4.0f';
else
  tTitle = sprintf('Trial\tSacc#\tStart\tEnd\tpeak vel\tmean vel\tsac React Time\ttime-to-Peak\tdist(deg)\t%%Zero\n');
  fmtStr = '%d\t%d\t%5.0f\t%5.0f\t%4.1s\t%4.1f\t%5.0f\t%5.0f\t%4.1f\t%5.0f\n';
end;

N = size(saccadeList,1);

table = cell(N+1,1);
table{1,1} = tTitle;

% convert start and stop index into msecs
saccadeList(:,3) = saccadeList(:,3)* acqIntvl;
saccadeList(:,4) = saccadeList(:,4)* acqIntvl;

%  Loop over each line in the list
%  -------------------------------------------
for n = 1:N
   table{n+1,1} = sprintf(fmtStr, saccadeList(n,:));
end;

return;
