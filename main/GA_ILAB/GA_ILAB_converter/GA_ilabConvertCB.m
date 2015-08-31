function ilabConvertCB()
% ILABCONVERTCB -- Switchyard to various convert functions
%   Figures out what type of file is being parsed and then
%   calls the appropriate conversion routine
%   Invokes the Dataset Properties review dialog.

% Authors: Darren Gitelman, Roger Ray
% $Id: ilabConvertCB.m 1.17 2004-10-08 18:55:23-05 drg Exp drg $

persistent CONVERTPATH

if ~isempty(CONVERTPATH) & isdir(CONVERTPATH)
    cd(CONVERTPATH)
end;

AP = ilabGetAnalysisParms;
ILAB = [];

% -----------------------------
%  Select a file
% -----------------------------
[fname, pname] = uigetfile(AP.file.Ext,...
   					'Select a raw eye movement file', 100, 100);
drawnow
  
if (fname(1) == 0) return; end;

CONVERTPATH = pname;
cd(CONVERTPATH)

% ------------------------------ 
% Check if file can be opened
% ------------------------------ 
fid = fopen([pname fname]);
if fid == -1
  errStr = {[fname ' could not be opened for reading'];...
            'Check file permissions'};
  errordlg(errStr,'ILAB ERROR', 'modal');
  return;
end;

% Try to read the initial line as ASCII. This works for ASL-EYEDAT,
% ISCAN-BINARY, and IVIEW-DAT files even though other parts of these files
% may be actually binary. It will not work for CORTEX files.
tmp = fgetl(fid);
% fclose(fid);

if strncmpi('EYEDAT',tmp,6)               % ASL FILE 5000
    ILAB = ilabConvertASL(pname, fname, 5);
    
elseif strncmp('[File_Description]',tmp,17)  % ASL FILE 6000
    % do an additional check by reading the second line
    tmp = fgetl(fid);
    if str2num(tmp(length(strtok(tmp))+1:end)) > 600
       ILAB = ilabConvertASL(pname, fname, 6);
    else
        errordlg('Unrecognized file format. Inform programmer.','ILAB CONVERSION ERROR','modal')
    end
    
elseif strncmpi('ISCAN DATA FILE',tmp,15) % ISCAN DATA FILE
    ILAB = ilabConvertISCAN(pname, fname);
    
elseif strncmpi('ISCAN ASCII FILE',tmp,16) % ISCAN ASCII FILE
    ILAB = ilabConvertISCAN(pname,fname);
    
elseif strfind(tmp,'Fileversion')    % IVIEW FILE
    ILAB = ilabConvertIVIEW(pname, fname);
    
else
    % This may be a true binary file such as a CORTEX file or it may be the
    % old ISCAN format. 
    % If the first 6 elements of tmp contain zeros then this is not an
    % ASCII file and there is no way it can be old iscan. Assume it is a
    % CORTEX file for now. Why don't developers identify their files
    % in some definite way?
    if ~any(tmp == 0)
        % perhaps this is an old type iscan file
        % send the data to the convert iscan module
        ILAB = ilabConvertISCAN(pname, fname);
    else
        % Send to the CORTEX convertor.
        % May have to implement checking status of conversion later...
        % For now there are no other file choices, so if the user
        % inputs some random file that is their problem.
        ILAB = ilabConvertCORTEX(pname, fname);
    end
end

% check if conversion returned anything
if isempty(ILAB)
    h = errordlg('Could not convert datafile for unknown reasons.','ILAB CONVERSION ERROR','modal');
    uiwait(h)
    return
elseif isfield(ILAB,'error')
    h = errordlg(ILAB.error,'ILAB CONVERSION ERROR','modal');
    uiwait(h)
    return
end

% show the data properties dialog
ilabReviewILABCB('init', ILAB);

return;

