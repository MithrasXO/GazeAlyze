function [import, ILAB, flag_error] = GA_ilabConvertIVIEW_IDF_201(varargin)

global eye;

path = varargin{1};
file = varargin{2};
flag_error = 0;
ILAB=[];
import=[];

%=====================================================================
% SETUP ILAB VARIABLE SECTION
%=====================================================================

[import, flag_error] = GA_iView2GA(path,file);

if flag_error
    return;
end;

[ILAB, flag_error] = GA_ilabConvert('iView',path, file, import);




function [import, flag_error] = GA_iView2GA(path_raw, file)
% GA_iView2GA -> conversion of iView ascii files to GazeAlyze eye variable
global eye;

flag_error=0;
import=[];
%--------------------------------------------------------------------------
% Open file and segment
%--------------------------------------------------------------------------

fid = fopen(fullfile(path_raw,file), 'r');

%find parts: header, label, data 
firstCol = textscan(fid, '%s%*[^\n]','delimiter','\t');
headIX = find(~cellfun('isempty',strfind(firstCol{1,1},'##')));
datIX=find(cellfun('isempty',strfind(firstCol{1,1},'##')));
labelIX=find(~cellfun('isempty',strfind(firstCol{1,1},'Time')));
if max(headIX) > min(datIX) ||max(headIX) > min(labelIX) || length(labelIX) > 1
    disp(['error by importing iView data: ' file ', header deformed']);
    disp(['moving ' file ' to ' fullfile(eye.dir.raw, 'error')]);
    if ~isdir(fullfile(eye.dir.raw, 'error'))
        mkdir(fullfile(eye.dir.raw, 'error'));
    end
    fclose(fid);
    movefile(fullfile(eye.dir.raw, file), fullfile(eye.dir.raw, 'error', file));
    flag_error=1;
    return;
end;

frewind(fid);
headdata = textscan(fid, '%s %s %s %s %s %s',length(headIX),'delimiter','\t');
labels = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter','\t');  

%here cols with point of regard will be determined. already in pixel.. extend for other cols 
x_col = find(~cellfun('isempty',(cellfun(@(x) strfind(x,'POR X'), labels))));
y_col = find(~cellfun('isempty',(cellfun(@(x) strfind(x,'POR Y'), labels))));

pos = ftell(fid);
time = textscan(fid, '%f32%*[^\n]');
fseek(fid,pos,'bof');

markval = textscan(fid, '%*f32%s%d8%s%*[^\n]','delimiter','\t');

idx = markval{1};

%asynchrone marker
async = strcmp(idx,'MSG');

fseek(fid,pos,'bof');

%--------------------------------------------------------------------------
% iView Marker seems to be always async
%--------------------------------------------------------------------------
import.marker.mod = 'async';
markval=markval{3};
import.marker.values = markval(async);
import.marker.times  = time{1}(async);
datsect=diff(find(async));
%only POR data will be imported, change for special needs..
strformat = ['%f32 ' repmat('%*s',1, x_col-2) '%f32 %f32 %*[^\n]'];

data = textscan(fid, strformat, find(async,1)-1,'delimiter','\t');
%scipping marker
textscan(fid, '%*[^\n]',1);
for i=1:length(datsect)
    data= [data; textscan(fid, strformat, datsect(i)-1,'delimiter','\t')]; %#ok<AGROW>
    textscan(fid, '%*[^\n]',1);
end;
data= [data; textscan(fid, strformat, length(async)-find(async,1,'last'),'delimiter','\t')]; 
fclose(fid);
import.data =[];
%x y POR data already in pix
for i = 1: size(data,2) 
    import.data = [import.data, vertcat(data{:,i})];
end;
%change timestamp in from µsec in sec..
import.data(:,1) = import.data(:,1) ./1000000;
import.marker.times  = import.marker.times ./1000000;

%--------------------------------------------------------------------------
% fill eye-variable with fileinformationns and data
%--------------------------------------------------------------------------


%can be extended..
import.path = eye.dir.conv;
import.fname = file;
import.header.ConvertedFrom = getHeader(headdata,'Converted from:');
import.header.TimeStamp = getHeader(headdata,'Date:');
import.header.ProductVersion = getHeader(headdata,'Version:');
import.header.FrameRate = getHeader(headdata,'Sample Rate');
import.header.User = getHeader(headdata,'User');
import.header.Trial = getHeader(headdata,'Trial');
import.header.CalibrationType = getHeader(headdata,'Calibration Type');
import.header.ScreenSize = getHeader(headdata,'Calibration Area');
import.header.ViewingDistance = getHeader(headdata,'Head Distance');
import.header.ImageShape = getHeader(headdata,'Stimulus Dimension');
import.header.SampleCount = getHeader(headdata,'Number of Samples');
import.header.Reversed = getHeader(headdata,'Reversed');
import.header.Format = getHeader(headdata,'Format');

import.header.data_labels(1)=labels(1);
import.header.data_labels(2)=labels(x_col);
import.header.data_labels(3)=labels(y_col);

dateparts = strfind(import.header.TimeStamp, ' ');
datemax = max(size(import.header.TimeStamp));
import.header.date = import.header.TimeStamp(1:dateparts-1);
import.header.time = import.header.TimeStamp(dateparts+1:datemax);


function str =  getHeader(header, strTitle)

str = '';

row = find(~cellfun('isempty',strfind(header{1,1},strTitle)),1,'first');

for k = 2:length(header)
    str = [str char(header{1,k}{row,1}) ' ']; %#ok<AGROW>
end
str= strtrim(str);

