function table = ilabMkFixationTbl(fixList, layoutType)
global eye;

% ILABMKFIXATIONTBL -- Makes a table of fixation results.
%   TABLE = ILABMKFIXATIONTBL(fixList, layoutType) -- Makes an ASCII formatted table
%   from the list of fixation results table is returned as a cell array, with
%   the title line as the first cell.
%   fixList - The list of fixations (cf. ilabMkFixationList)
%   layoutType - string ['listbox' | 'spreadsheet'] which determines the
%               type of table produced.
%   Listbox layout has space-padded fields with no line delimiters
%   Spreadsheet layout has tab-delimited fields which end with a '\n' character.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabMkFixationTbl.m 1.5 2002-10-06 17:44:08-05 drg Exp $


%  Layout type codes
%  --------------------
LISTBOX = 1;
SPREADSHEET = 2;

table = [];
acqIntvl = eye.ILAB.acqIntvl;

if isempty(fixList), return; end;

% --------------------------------------------------------------
%  Change layoutType to an integer for simpler testing in logic
% --------------------------------------------------------------
if strcmpi(layoutType, 'listbox')
  layoutType = LISTBOX;
else
  layoutType = SPREADSHEET;
end;


if layoutType == LISTBOX
  tTitle = str2mat('Trial  Fix    x    y    xDir   Dist  Start  Duration  %Zero',...
  [blanks(32) 'px     ms      ms']);
  fmtStr = '%4d %4d   %5.0f %5.0f     %3s  %5.0f   %6.0f  %7.0f  %5.0f';
else
  tTitle = sprintf('Trial\tFix\tx\ty\txDir\tDist\tStart\tDuration\t%%Zero\n');
  fmtStr = '%d\t%d\t%5.0f\t%5.0f\t%3s\t%7.0f\t%7.0f\t%7.0f\t%5.0f\n';
end;

N = size(fixList,1);

table = cell(N+1,1);
table{1,1} = tTitle;

% set up the shft text array. 
shft = 32*ones(size(fixList,1),3);

%  Create an array with strings (L, -, R)   
k = find(fixList(:,4) ==  0); shft(k,2) = '-';
k = find(fixList(:,4) ==  1); shft(k,3) = 'R';
k = find(fixList(:,4) == -1); shft(k,1) = 'L';

warning off all

%  Loop over each line in the list
%  -------------------------------------------
for n = 1:N
    fixStartTime = fixList(n,6) * acqIntvl;
    fixDurTime   = fixList(n,7) * acqIntvl;
    table{n+1,1} = sprintf(fmtStr, fixList(n,1), n, fixList(n,2:3), shft(n,:),...
        fixList(n,5), fixStartTime, fixDurTime, fixList(n,8));
end;

warning on all

return;
