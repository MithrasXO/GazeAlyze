function GA_ilabSaveTblAsExcelCB()
% ILABSAVETBLASEXCELCB -- Saves analysis results in Excel-readable format
%   ILABSAVETBLASEXCELCB(action) saves one or more analysis result tables
%   in a tab-delimited file that can be imported by MS Excel. Action determines what
%   is done. A descriptive preamble is included.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabSaveTblAsExcelCB.m 1.4 2003-08-20 22:29:10-05 drg Exp $

writeTbls;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writeTbls

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global eye;
% --------------------------------------------------------------------
%  Loop over the selected checkboxes in the UI figure.
% --------------------------------------------------------------------

TBLWIN_TAGS = {'Fixation Results'; 'Gaze Results'; 'ROIStats Results'; 'Saccade Results'};
CKBOX_TAGS = {'SaveFixCkBox'; 'SaveGazeCkBox'; 'SaveROIStatsCkBox'; 'SaveSaccadesCkBox'};
TBLFN_TAGS  = {'_Fix'; '_Gaze'; '_ROIStats'; '_Saccades'};


for n = 1:4

    table = [];

    %  -------------------------------------------------------------
    %  Format the table data in spreadsheet layout
    %  Convert the cell array to a single long string
    %  Then write it to the file in a single write.
    %  -------------------------------------------------------------
    switch n

        case 1
            if isempty(eye.AP.fix.list)
                uiVal = 0;
                uiEna = 'off';
            else
                uiVal = 1;
                uiEna = 'on';
                preamble = sprintf('Fixations\n');
                table = GA_ilabMkFixationTbl(eye.AP.fix.list, 'spreadsheet');
            end;

        case 2
            if isempty(eye.AP.gaze.list)
                uiVal = 0;
                uiEna = 'off';
            else
                uiVal = 1;
                uiEna = 'on';
                preamble = sprintf('Gaze Maintenance\n');
                table = GA_ilabMkGazeTbl(eye.AP.gaze.list, 'spreadsheet');
            end;

        case 3
            if isempty(eye.AP.ROIStats.list)
                uiVal = 0;
                uiEna = 'off';
            else
                uiVal = 1;
                uiEna = 'on';
                preamble = sprintf('ROI Statistics\n');
                table = GA_ilabMkROIStatsTbl(eye.AP.ROIStats.list, 'spreadsheet');
            end;

        case 4
            if isempty(eye.AP.saccade.list)
                uiVal = 0;
                uiEna = 'off';
            else
                uiVal = 1;
                uiEna = 'on';

                table = GA_ilabMkSaccadeTbl(eye.AP.saccade.list, 'spreadsheet');
            end;
            preamble = sprintf('Saccade\n');

    end;

    if uiVal==1;

        % -----------------------------
        %  Select a file
        % -----------------------------

        name = eye.ILAB.fID;
        fname = [name TBLFN_TAGS{n} '.xls'];
        pname = eye.dir.conv;

        if (fname(1) ~= 0)

            % ------------------------------
            % Check if file can be opened
            % ------------------------------
            fid = fopen(fullfile(pname, fname), 'w');
            if fid == -1
                errStr = {[fname ' could not be opened for writing'];...
                    'Check directory permissions'};
                errordlg(errStr,'ILAB ERROR', 'modal');
                return;
            end;

            % add start code text header to header
            tabs = findstr(char(table{1}),char(9));
            if eye.AP.targets
                codestr = sprintf('start code\ttarget code\t');
            else
                codestr = sprintf('start code\t');
            end
            table{1} = [table{1}(1:tabs(1)),codestr,table{1}(tabs(1)+1:end)];

            % add in trial code information for sorting results in excel
            GA_ilabGetPlotParms;
            for i = 2:size(table,1)
                tabs = findstr(char(table{i}),char(9));
                % trial numbers are always characters to the left of the
                % fist tab.
                trial = str2num(table{i}(1:tabs(1)-1));
                if eye.AP.targets
                    codestr = sprintf('%i\t%i\t',eye.PP.data(eye.PP.index(trial,1),3),...
                        eye.PP.data(eye.PP.index(trial,3),3));
                else
                    codestr = sprintf('%i\t',eye.PP.data(eye.PP.index(trial,1),3));
                end

                table{i} = [table{i}(1:tabs(1)),codestr,table{i}(tabs(1)+1:end)];
            end

            % Fill out remainder of preamble
            % ------------------------------

            pStr = fmtPreamble(eye.AP);
            preamble = [preamble pStr];

            s = cat(2,table{:});   % Convert the cell array into a long string array
            s = [preamble'; s'];   % Merge the preamble with the spreadsheet
            fwrite(fid, s, 'char');

            fclose(fid);

            uiVal=0;

        end;   % fname not empty
    end;


end;     % endfor

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function preamble = fmtPreamble(AP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Formats a preamble to the tabular data which contains some
%     general information about the analysis
%
%  !Note!: The preamble info will not necessarily be correct
%          since it is possible to do several sequential analyses
%          with different basis and start/stop criteria.
%          The settings of the last analysis performed are reported.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if AP.basis == 0
    str = 'Coordinate';
else
    str ='Fixation';
end;
preamble = sprintf('%s-based calc\n', str);
preamble = sprintf('Analysis Limits\n');

switch AP.start.marker
    case 1,           str = 'Trial Start '; intvl =  AP.start.intvl;
    case 2,           str = 'Trial End ';   intvl = -AP.start.intvl;
    case 3,           str = 'Target ';      intvl =  AP.start.intvl;
end;  %endswitch

preamble = [preamble sprintf('%s  %+d ms\n', str, intvl)];

switch AP.end.marker
    case 1,           str = 'Trial End ';   intvl = -AP.end.intvl;
    case 2,           str = 'Trial Start '; intvl =  AP.end.intvl;
    case 3,           str = 'Target ';      intvl =  AP.end.intvl;
end;  %endswitch

preamble = [preamble sprintf('%s %+d ms\n', str, intvl)];

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
