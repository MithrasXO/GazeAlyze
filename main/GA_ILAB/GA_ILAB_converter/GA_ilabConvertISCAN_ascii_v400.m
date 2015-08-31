function [import, ILAB, flag_error] = GA_ilabConvertISCAN_ascii_v400(varargin)

global eye;

path = varargin{1};
file = varargin{2};
flag_error = 0;
ILAB=[];
import=[];

%=====================================================================
% SETUP ILAB VARIABLE SECTION
%=====================================================================

[import, flag_error] = GA_ISCAN2GA(path,file);

if flag_error
    return;
end;

[ILAB, flag_error] = GA_ilabConvert('ISCAN',path, file, import);

% convert ISCAN data (0<x,y>512) in ilab format (pixel): 
ILAB.data(:,1) = round(ILAB.data(:,1) * ILAB.coordSys.screen(1))/512;
%ILAB.data(:,2) = round((512 - ILAB.data(:,2)) * ILAB.coordSys.screen(2))/512;
ILAB.data(:,2) = round(ILAB.data(:,2) * ILAB.coordSys.screen(2))/512;

function [import, flag_error] = GA_ISCAN2GA(path_raw, file)
% GA_ISCAN2GA -> conversion of ISCAN ascii files to GazeAlyze eye variable
global eye;

flag_error=0;
import=[];
%--------------------------------------------------------------------------
% Open file and segment
%--------------------------------------------------------------------------

fid = fopen(fullfile(path_raw,file), 'r');

%find parts: header, label, data
firstCol = textscan(fid, '%s%*[^\n]','delimiter','\t');
headIX = find(~cellfun('isempty',strfind(firstCol{1,1},'DATA SUMMARY TABLE')));
datIX=find(~cellfun('isempty',strfind(firstCol{1,1},'Sample #')));
labelIX=find(~cellfun('isempty',strfind(firstCol{1,1},'DATA INFO')));
% if max(headIX) > min(datIX) ||max(headIX) > min(labelIX) || length(labelIX) > 1
%     disp(['error by importing ISCAN data: ' file ', header deformed']);
%     disp(['moving ' file ' to ' fullfile(eye.dir.raw, 'error')]);
%     if ~isdir(fullfile(eye.dir.raw, 'error'))
%         mkdir(fullfile(eye.dir.raw, 'error'));
%     end
%     fclose(fid);
%     movefile(fullfile(eye.dir.raw, file), fullfile(eye.dir.raw, 'error', file));
%     flag_error=1;
%     return;
% end;
frewind(fid);
headdata = textscan(fid, '%s %s %s %s %s %s %s %s',headIX,'delimiter','\t');
skipdata = textscan(fid, '%*[^\n]',labelIX-headIX,'delimiter','\t');
labels = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s',1,'delimiter','\t');

%here cols with point of regard will be determined. already in pixel.. extend for other cols
x_col = find(~cellfun('isempty',(cellfun(@(x) strfind(x,'POR H1A'), labels))));
y_col = find(~cellfun('isempty',(cellfun(@(x) strfind(x,'POR V1A'), labels))));
mark_col = find(~cellfun('isempty',(cellfun(@(x) strfind(x,'Ser Inp'), labels))));

skip = textscan(fid, '%*[^\n]',1,'delimiter','\t');

data = textscan(fid, [repmat('%f32 ',1, mark_col) '%*[^\n]'], 'delimiter','\t');
fclose(fid);

%--------------------------------------------------------------------------
% fill eye-variable with fileinformationns and data
%--------------------------------------------------------------------------

%can be extended..
import.path = eye.dir.conv;
import.fname = file;
import.header.RunsRecorded = getHeader(headdata,'Runs Recorded:', 'row');
import.header.SampsRecorded = getHeader(headdata,'Samps Recorded:', 'row');
import.header.date = getHeader(headdata,'Date', 'col');
import.header.time = getHeader(headdata,'Start Time', 'col');
import.header.Samples = getHeader(headdata,'Samples', 'col');
import.header.FrameRate = str2double(getHeader(headdata,'Samps/Sec', 'col'));
import.header.RunTime = getHeader(headdata,'Run Secs', 'col');
import.header.ImageFile = getHeader(headdata,'Image File', 'col');
import.header.Description = getHeader(headdata,'Description', 'col');
import.header.ProductVersion = 'ISCAN ascii v 4.00';
import.header.data_labels =labels;

if isempty(eye.defaultscreen)
    error('ISCAN data provides no information about the screen size. Please set screen size first in the menu under Preprocessing..');
else
    %screensize info is not provided
    import.header.ScreenSize = sprintf('%d %d', eye.defaultscreen(2), eye.defaultscreen(4));
end;
%--------------------------------------------------------------------------
% ISCAN Marker seems to be always sync
%--------------------------------------------------------------------------
import.marker.mod = 'sync';

import.marker.values = data{11}(data{11}~=0);
import.marker.values = import.marker.values;
import.marker.times  = data{1}(data{11}~=0);
%x y POR data already in pix
%only POR data will be imported, change for special needs..
import.data =[data{1} data{x_col} data{y_col}];

%change timestamp in from samplpoint in sec..
import.data(:,1) = import.data(:,1) ./import.header.FrameRate ;
import.marker.times  = import.marker.times ./import.header.FrameRate ;

function str =  getHeader(header, strTitle, strtype)

str = '';
if strcmpi(strtype,'row')
    row = find(~cellfun('isempty',strfind(header{1,1},strTitle)),1,'first');
    str = char(header{1,2}{row,1});
else
    row = 1 + find(~cellfun('isempty',strfind(header{1,1},'RUN INFORMATION TABLE')),1,'first');
    for k = 2:length(header)
        if strcmpi(strtrim(header{1,k}{row,1}),strTitle)
            str = strtrim(header{1,k}{row+1,1});
        end;
    end;
end;
