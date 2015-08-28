function varargout = GA_gui_ROIimport(varargin)
% BATCHJOBS M-file for batchjobs.fig
%      BATCHJOBS, by itself, creates a new BATCHJOBS or raises the existing
%      singleton*.
%
%      H = BATCHJOBS returns the handle to a new BATCHJOBS or the handle to
%      the existing singleton*.
%
%      BATCHJOBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHJOBS.M with the given input arguments.
%
%      BATCHJOBS('Property','Value',...) creates a new BATCHJOBS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batchjobs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batchjobs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batchjobs

% Last Modified by GUIDE v2.5 20-May-2010 10:50:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_ROIimport_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_ROIimport_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before batchjobs is made visible.
function GA_gui_ROIimport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batchjobs (see VARARGIN)

% Choose default command line output for editprocedures
handles.output = hObject;

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);

%listboxes
set(handles.ed_dir, 'String', mainGUIdata.data.eye.import.ROIall.file);

set(handles.ed_row_head, 'String', num2str(mainGUIdata.data.eye.import.ROIall.row_head));
set(handles.ed_row_data, 'String', num2str(mainGUIdata.data.eye.import.ROIall.row_data));
set(handles.ed_col_pics, 'String', num2str(mainGUIdata.data.eye.import.ROIall.col_pics));
set(handles.ed_pattern, 'String', mainGUIdata.data.eye.import.ROIall.picfilter);

handles.ROI = mainGUIdata.data.eye.import.ROI;

listboxstring= '';


for k=1:length(handles.ROI);
    if ~handles.ROI(k).col_roi_name == 0
        listboxstring = [listboxstring; {[ 'name: ' num2str(handles.ROI(1,k).col_roi_name) ' ||   tag: ' num2str(handles.ROI(1,k).col_roi_tag) ' ||   data start: ' num2str(handles.ROI(1,k).col_roi_data) ' ||   orientation: ' num2str(handles.ROI(1,k).flag_BH) ]}];    
    else
        handles.ROI(:,k)= [];
    end
end

if ~isempty(listboxstring)
    set(handles.lb_rois, 'String', listboxstring);
    set(handles.lb_rois,'Max',length(listboxstring))
   set(handles.lb_rois,'Value',[]);   
end
set(handles.lb_rois,'Value',1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchjobs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_ROIimport_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUI = guidata(handles.mainGUIhandle);

lbstring = get(mainGUI.listbox_progress, 'String');
lbstring = [lbstring; {'>>> ROIimport updatet <<<'}];
[mainGUI.data.eye.import.ROIall.file, lbstring] =  GA_gui_get(lbstring, 'roi desc file: ', mainGUI.data.eye.import.ROIall.file, handles.ed_dir, 'String');
[mainGUI.data.eye.import.ROIall.row_head, lbstring] =  GA_gui_get(lbstring, 'row of header: ', mainGUI.data.eye.import.ROIall.row_head, handles.ed_row_head, 'String');
[mainGUI.data.eye.import.ROIall.row_data, lbstring] =  GA_gui_get(lbstring, 'row of data start: ', mainGUI.data.eye.import.ROIall.row_data, handles.ed_row_data, 'String');
[mainGUI.data.eye.import.ROIall.col_pics, lbstring] =  GA_gui_get(lbstring, 'column of picture name: ', mainGUI.data.eye.import.ROIall.col_pics, handles.ed_col_pics, 'String');
[mainGUI.data.eye.import.ROIall.picfilter, lbstring] =  GA_gui_get(lbstring, 'pic filter string: ', mainGUI.data.eye.import.ROIall.picfilter, handles.ed_pattern, 'String');

%sauberer machen? Derzeit ohne meldung wenn geändert...
mainGUI.data.eye.import.ROI = handles.ROI;

% [mainGUI.data.eye.heatmap.color.color1, lbstring] =  GA_gui_get(lbstring, 'Color step-1 ->-> ', mainGUI.data.eye.heatmap.color.color1, handles.col1, 'BackgroundColor');

if ~strcmp(lbstring{end},'>>> ROIimport updatet <<<')
    set(mainGUI.listbox_progress, 'String', lbstring);
    set(mainGUI.listbox_progress, 'Max', length(lbstring));
    set(mainGUI.listbox_progress, 'Value', length(lbstring));
    set(mainGUI.uipt_save, 'Enable', 'on');
end;

% Generate Listbox Overview / Pass data to main window (main-window)
GA_gui_set(mainGUI, 1)

% Update handles structure
guidata(handles.mainGUIhandle, mainGUI);
guidata(hObject, handles);

close;

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ons as text
%        str2double(get(hObject,'String')) returns contents of ed_ons as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_roi_use.
function pb_roi_use_Callback(hObject, eventdata, handles)
% hObject    handle to pb_roi_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string

handles.ROI(end+1).col_roi_name = str2double(get(handles.ed_col_name,'string'));
handles.ROI(end).col_roi_tag = str2double(get(handles.ed_col_tag,'string'));
handles.ROI(end).col_roi_data = str2double(get(handles.ed_col_data,'string'));
if get(handles.rb_BH,'Value') == 1
    handles.ROI(end).flag_BH = 1;
end
if get(handles.rb_PP,'Value') == 1
    handles.ROI(end).flag_BH = 2;
end

listboxstring= '';

set(handles.lb_rois,'Value',[])
set(handles.pb_Import, 'Enable','On');
for k=1:length(handles.ROI);
    if ~handles.ROI(k).col_roi_name==0
        listboxstring = [listboxstring; {[ 'name: ' num2str(handles.ROI(1,k).col_roi_name) ' ||   tag: ' num2str(handles.ROI(1,k).col_roi_tag) ' ||   data start: ' num2str(handles.ROI(1,k).col_roi_data) ' ||   orientation: ' num2str(handles.ROI(1,k).flag_BH) ]}];
    else
        handles.ROI(k)= [];
    end
end

if ~isempty(listboxstring)
    set(handles.lb_rois, 'String', listboxstring);
    set(handles.lb_rois,'Max',length(listboxstring))
    set(handles.lb_rois,'Value',length(listboxstring))    
end
guidata(hObject, handles);

% --- Executes on button press in pb_roi_del.
function pb_roi_del_Callback(hObject, eventdata, handles)
% hObject    handle to pb_roi_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string
if ~isempty(handles.ROI)     
    roiindex = get(hObject,'Value');
    handles.ROI(roiindex)= [];     
    listboxstring= '';    
    set(handles.pb_Import, 'Enable','On');
    for k=1:length(handles.ROI);
        listboxstring = [listboxstring; {[ 'name: ' num2str(handles.ROI(k).col_roi_name) ' ||   tag: ' num2str(handles.ROI(k).col_roi_tag) ' ||   data start: ' num2str(handles.ROI(k).col_roi_data) ' ||   orientation: ' num2str(handles.ROI(k).flag_BH) ]}];        
    end    
    if ~isempty(listboxstring)
        set(handles.lb_rois, 'String', listboxstring);
        set(handles.lb_rois,'Max',length(listboxstring))
        set(handles.lb_rois,'Value',length(listboxstring))    
    else
       set(handles.lb_rois, 'String', {});
       set(handles.ed_col_name, 'String', '');
       set(handles.ed_col_tag, 'String', '');
       set(handles.ed_col_data, 'String', '');
    end    
end

guidata(hObject, handles);

% --- Executes on selection change in lb_rois.
function lb_rois_Callback(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_rois
if ~isempty(handles.ROI)
    
    roiindex = get(hObject,'Value'); %Index aus dem Widget holen    
    set(handles.ed_col_name, 'String', handles.ROI(roiindex).col_roi_name);
    set(handles.ed_col_tag, 'String', handles.ROI(roiindex).col_roi_tag);
    set(handles.ed_col_data, 'String', handles.ROI(roiindex).col_roi_data);
    if  str2double(handles.ROI(roiindex).col_roi_data) == 1
        set(handles.rb_BH, 'Value', 1);
        set(handles.rb_PP, 'Value', 0);
    elseif str2double(handles.ROI(roiindex).col_roi_data) == 2
        set(handles.rb_PP, 'Value', 1);
        set(handles.rb_BH, 'Value', 0);
    end    
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lb_rois_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel18.
function uipanel18_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel18
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_dir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dir as text
%        str2double(get(hObject,'String')) returns contents of ed_dir as a double
set(handles.pb_Import, 'Enable','On');

% --- Executes during object creation, after setting all properties.
function ed_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_row_head_Callback(hObject, eventdata, handles)
% hObject    handle to ed_row_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_row_head as text
%        str2double(get(hObject,'String')) returns contents of ed_row_head as a double
val= get(handles.ed_row_head,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_row_head,'String',num2str(val));
set(handles.pb_Import, 'Enable','On');

% --- Executes during object creation, after setting all properties.
function ed_row_head_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_row_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_col_pics_Callback(hObject, eventdata, handles)
% hObject    handle to ed_col_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_col_pics as text
%        str2double(get(hObject,'String')) returns contents of ed_col_pics as a double
val= get(handles.ed_col_pics,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_col_pics,'String',num2str(val));
set(handles.pb_Import, 'Enable','On');

% --- Executes during object creation, after setting all properties.
function ed_col_pics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_col_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_row_data_Callback(hObject, eventdata, handles)
% hObject    handle to ed_row_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_row_data as text
%        str2double(get(hObject,'String')) returns contents of ed_row_data as a double
val= get(handles.ed_row_data,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_row_data,'String',num2str(val));
set(handles.pb_Import, 'Enable','On');

% --- Executes during object creation, after setting all properties.
function ed_row_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_row_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_col_name_Callback(hObject, eventdata, handles)
% hObject    handle to ed_col_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_col_name as text
%        str2double(get(hObject,'String')) returns contents of ed_col_name as a double
val= get(handles.ed_col_name,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_col_name,'String',num2str(val));

% --- Executes during object creation, after setting all properties.
function ed_col_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_col_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ed_col_tag_Callback(hObject, eventdata, handles)
% hObject    handle to ed_col_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_col_tag as text
%        str2double(get(hObject,'String')) returns contents of ed_col_tag as a double
val= get(handles.ed_col_tag,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_col_tag,'String',num2str(val));


% --- Executes during object creation, after setting all properties.
function ed_col_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_col_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_col_data_Callback(hObject, eventdata, handles)
% hObject    handle to ed_col_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_col_data as text
%        str2double(get(hObject,'String')) returns contents of ed_col_data as a double

val= get(handles.ed_col_data,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_col_data,'String',num2str(val));

% --- Executes during object creation, after setting all properties.
function ed_col_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_col_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_Import.
function pb_Import_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUI = guidata(handles.mainGUIhandle);

ROIall.file = get(handles.ed_dir, 'String');
ROIall.row_head = str2double(get(handles.ed_row_head, 'String'));
ROIall.row_data = str2double(get(handles.ed_row_data, 'String'));
ROIall.col_pics = str2double(get(handles.ed_col_pics, 'String'));
ROIall.picfilter = get(handles.ed_pattern, 'String');

mainGUI.data.eye.ROI = GA_import_roi(handles.ROI, ROIall);

% Update handles structure
guidata(handles.mainGUIhandle, mainGUI);
guidata(hObject, handles);


%Generate Data for Listbox Parameter Overview
mfiledata = gencode(mainGUI.data);
mfiledatasize = length(mfiledata);

for k=1:mfiledatasize
    mfiledata{1,k}= mfiledata{1,k}(5:end);
end;

mfiledata= (mfiledata)';
set(mainGUI.listbox_overview, 'String', mfiledata);

set(handles.pb_Import, 'Enable','Off');


% --- Executes on button press in pb_browse.
function pb_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.txt', 'Pick an file');


set(handles.ed_dir, 'String', fullfile(pathname, filename));

guidata(hObject, handles);



function ed_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to ed_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_pattern as text
%        str2double(get(hObject,'String')) returns contents of ed_pattern as a double
set(handles.pb_Import, 'Enable','On');

% --- Executes during object creation, after setting all properties.
function ed_pattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
