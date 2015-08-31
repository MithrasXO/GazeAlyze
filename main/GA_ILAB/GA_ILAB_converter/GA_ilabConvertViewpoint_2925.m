function [import, ILAB, flag_error] = GA_ilabConvertViewpoint(varargin)

global eye;

path = varargin{1};
file = varargin{2};
flag_error = 0;
ILAB=[];
import=[];

%=====================================================================
% SETUP ILAB VARIABLE SECTION
%=====================================================================

[import, flag_error] = GA_VP2GA(path,file);

if flag_error
    return;
end;

[ILAB, flag_error] = GA_ilabConvert('Viewpoint', path, file, import);

% convert Viewpoint data (0<x,y>1) in ilab format (pixel): 
ILAB.data(:,1) = round(ILAB.data(:,1) * ILAB.coordSys.screen(1));
ILAB.data(:,2) = round(ILAB.data(:,2) * ILAB.coordSys.screen(2));

function [import, flag_error] = GA_VP2GA(path_raw, file)
% GA_VP2GA -> conversion of ViewPoint .txt files to GazeAlyze eye variable
global eye;

flag_error=0;
import=[];
%--------------------------------------------------------------------------
% Open file and segment
%--------------------------------------------------------------------------

fid = fopen(fullfile(path_raw,file), 'r');

headdata = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',42);
%eof-pos

if any(~strcmp(headdata{1,1},'3') & ~strcmp(headdata{1,1},'5') & ~strcmp(headdata{1,1},'6') & ~strcmp(headdata{1,1},'7') & ~strcmp(headdata{1,1},'16') )
    disp(['error by importing viewpoint data: ' file ', header deformed']);
    disp(['moving ' file ' to ' fullfile(eye.dir.raw, 'error')]);
    if ~isdir(fullfile(eye.dir.raw, 'error'))
        mkdir(fullfile(eye.dir.raw, 'error'));
    end
    fclose(fid);
    movefile(fullfile(eye.dir.raw, file), fullfile(eye.dir.raw, 'error', file));
    flag_error=1;
    return;
end;

pos = ftell(fid);

idxtime = textscan(fid, '%d8%f32%*[^\n]');

fseek(fid,pos,'bof');

markval = textscan(fid, '%*d8%*f32%s%*[^\n]');

idx = idxtime{1};

time = idxtime{1,2};

%asynchrone marker
async = (idx == 12);

fseek(fid,pos,'bof');


%--------------------------------------------------------------------------
% Marker sync/async
%--------------------------------------------------------------------------


if isempty(find(async,1))
    import.marker.mod = 'sync';
    data = textscan(fid, '%f32 %f32 %f32 %f32 %f32 %s %f32 %f32 %f32 %f32 %f32 %s %s %s %s');
    data_len = size(data{1,3},1);
    dataarray = [];
    for i=2:5
        dataarray = [dataarray,data{1,i}(1:data_len)]; %#ok<AGROW>
    end;
    idx_0 = find(dataarray(:,1)==0);
    if ~isempty(idx_0)
        idx_0(idx_0==1) = [];
        dataarray(idx_0,1) = dataarray(idx_0-1,1) + (dataarray(idx_0-1,2)/1000);
    end;
    dataarray(:,2)=[];
    import.data = dataarray;
    import.roi = data{1,6}(1:data_len);
    %markervalue aller marker im file
    import.marker.values = strcat(data{1,12}(1:data_len),data{1,13}(1:data_len),data{1,14}(1:data_len),data{1,15}(1:data_len));
    markIndxall = find(~strcmp(import.marker.values,''));
    import.marker.values = import.marker.values(markIndxall);
    %timepoint aller marker im file
    import.marker.times = dataarray(markIndxall,1);    
else
    import.marker.mod = 'async';
    markval=markval{1};
    import.marker.values = markval(async);
    import.marker.times  = time(async);
    datsect=diff(find(async));
    data = textscan(fid, '%f32 %f32 %f32 %f32 %f32 %s %f32 %f32 %f32 %f32 %f32 %s %s %s %s',find(async,1)-1);
    %scipping marker
    textscan(fid, '%*[^\n]',1);
    for i=1:length(datsect)
        data= [data; textscan(fid, '%f32 %f32 %f32 %f32 %f32 %s %f32 %f32 %f32 %f32 %f32 %s %s %s %s',datsect(i)-1)]; %#ok<AGROW>
        textscan(fid, '%*[^\n]',1);
    end;
    dataarray = vertcat(data{:,2});
    for i=4:5
        dataarray = [dataarray vertcat(data{:,i})]; %#ok<AGROW>
    end;
    import.data = dataarray;
end;
fclose(fid);
%--------------------------------------------------------------------------
% fill eye-variable with fileinformationns and data
%--------------------------------------------------------------------------

import.path = eye.dir.conv;
import.fname = file;

import.header.ProductVersion = getHeader(headdata,1,4);
import.header.ExecutableFileVersion = getHeader(headdata,2,5);
import.header.ProgramBuildDate = getHeader(headdata,3,5);
import.header.CustomerSerialNumber = getHeader(headdata,4,5);
import.header.CustomerName = getHeader(headdata,5,4);
import.header.CustomerOrganization = getHeader(headdata,6,4);
import.header.TimeValues = getHeader(headdata,8,4);
import.header.TimeStamp = getHeader(headdata,9,3);
import.header.DataFormat = getHeader(headdata,10,3);
import.header.Storing = getHeader(headdata,11,3);
import.header.ScreenSize = getHeader(headdata,12,3);
import.header.ViewingDistance = getHeader(headdata,13,3);
import.header.ImageShape = getHeader(headdata,14,3);
import.header.FrameRate = getHeader(headdata,23,4);

dateparts = strfind(import.header.TimeStamp, ' ');
datemax = max(size(import.header.TimeStamp));
import.header.date = import.header.TimeStamp(1:dateparts(3)-2);
import.header.time = import.header.TimeStamp(dateparts(3):datemax);



labels=getHeader(headdata,22,2);

labtab = strfind(labels,char(32));

import.header.data_labels{1}=labels(1:labtab(1));

for i=1: length(labtab)-1
    import.header.data_labels{i+1}=labels(labtab(i):labtab(i+1));
end;


%--------------------------------------------------------------------------
% All done!
%--------------------------------------------------------------------------

function str =  getHeader(header, row, col)

str = '';
for k = col:length(header)
    str = [str char(header{1,k}{row,1}) ' ']; %#ok<AGROW>
end
str= strtrim(str);

