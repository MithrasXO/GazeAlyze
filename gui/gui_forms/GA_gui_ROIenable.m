function varargout = GA_gui_ROIenable(varargin)
% ENABLEROI M-file for enableROI.fig
%      ENABLEROI, by itself, creates a new ENABLEROI or raises the existing
%      singleton*.
%
%      H = ENABLEROI returns the handle to a new ENABLEROI or the handle to
%      the existing singleton*.
%
%      ENABLEROI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENABLEROI.M with the given input arguments.
%
%      ENABLEROI('Property','Value',...) creates a new ENABLEROI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before enableROI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to enableROI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help enableROI

% Last Modified by GUIDE v2.5 04-Jun-2010 18:43:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @enableROI_OpeningFcn, ...
                   'gui_OutputFcn',  @enableROI_OutputFcn, ...
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


% --- Executes just before enableROI is made visible.
function enableROI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to enableROI (see VARARGIN)

% Choose default command line output for enableROI
handles.output = hObject;

mainGUIhandle = varargin{1};

handles.mainGUIhandle = mainGUIhandle;

mainGUIdata = guidata(mainGUIhandle);

guidata(mainGUIhandle, mainGUIdata);

%%%Daten MainGUI abfragen

handles.ROI = mainGUIdata.data.eye.ROI;



numROIs = size(handles.ROI);

listboxstring= '';

set(handles.lb_rois,'Value',1)
handles.roiindex =1;


for k=1:numROIs(2)
    if ~handles.ROI(1,k).name==0
            
            listboxstring = [listboxstring; {sprintf( '%s -> %s',handles.ROI(1,k).name , handles.ROI(1,k).valid)}];
    else
        handles.ROI(:,k)= [];
    end
end

if ~isempty(listboxstring)
set (handles.cb_enabled, 'Value', handles.ROI(1,handles.roiindex).enabled); 
set(handles.lb_rois, 'String', listboxstring);
end





% Update handles structure
guidata(hObject, handles);

% UIWAIT makes enableROI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = enableROI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lb_rois.
function lb_rois_Callback(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_rois

handles.roiindex = get(hObject,'Value');

set (handles.cb_enabled, 'Value', handles.ROI(1,handles.roiindex).enabled);

set (handles.ed_name, 'String', handles.ROI(1,handles.roiindex).name);
set (handles.ed_valid, 'String', handles.ROI(1,handles.roiindex).valid);
set (handles.ed_tag1, 'String', handles.ROI(1,handles.roiindex).tag1);
set (handles.ed_tag2, 'String', handles.ROI(1,handles.roiindex).tag2);
set (handles.ed_type, 'String', handles.ROI(1,handles.roiindex).type);



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



function edit_gazeroi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gazeroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gazeroi as text
%        str2double(get(hObject,'String')) returns contents of edit_gazeroi as a double


% --- Executes during object creation, after setting all properties.
function edit_gazeroi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gazeroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_enabled.
function cb_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to cb_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_enabled
if ~isempty(handles.ROI)
    
handles.ROI(1,handles.roiindex).enabled = get(hObject, 'Value');
guidata(hObject, handles);
end

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pb_ok.
function pb_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUIdata = guidata(handles.mainGUIhandle);


if ~isequal(mainGUIdata.data.eye.ROI,handles.ROI)
    
    lbstring = get(mainGUIdata.listbox_progress, 'String');
    lbstring = [lbstring; {'>>> ROI enabled/disabeld <<<'}];
    
    
    for i=1:length(mainGUIdata.data.eye.ROI)
        
        if ~mainGUIdata.data.eye.ROI(1,i).enabled  == handles.ROI(1,i).enabled
            
            if handles.ROI(1,i).enabled == 1
                lbstring = [lbstring; ['ROI enabled: ' handles.ROI(1,i).name]];
            end
            if handles.ROI(1,i).enabled == 0
                lbstring = [lbstring; ['ROI diabled: ' handles.ROI(1,i).name]];
            end
            
        end
        
    end
    
    mainGUIdata.data.eye.ROI=handles.ROI;
    set(mainGUIdata.listbox_progress, 'String', lbstring);
    set(mainGUIdata.listbox_progress, 'Max', length(lbstring));
    set(mainGUIdata.listbox_progress, 'Value', length(lbstring));
    set(mainGUIdata.uipt_save, 'Enable', 'on');
end;


%Generate Data for Listbox Parameter Overview
mfiledata = gencode(mainGUIdata.data);
mfiledatasize = length(mfiledata);

for k=1:mfiledatasize
       mfiledata{1,k}= mfiledata{1,k}(5:end);
end

mfiledata= (mfiledata)';
set(mainGUIdata.listbox_overview, 'String', mfiledata);


% Update handles structure
guidata(handles.mainGUIhandle, mainGUIdata);
guidata(hObject, handles);

close;

% --- Executes on button press in pb_en_all.
function pb_en_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_en_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.ROI)
    for k=1:length(handles.ROI)
        handles.ROI(1,k).enabled = 1;
    end
    handles.roiindex=1;
    set (handles.cb_enabled, 'Value', handles.ROI(1,handles.roiindex).enabled);
    
set(handles.lb_rois,'Value',1)
end
guidata(hObject, handles);


% --- Executes on button press in pb_dis_all.
function pb_dis_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dis_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.ROI)
    for k=1:length(handles.ROI)
        handles.ROI(1,k).enabled = 0;
    end
        handles.roiindex=1;
    set (handles.cb_enabled, 'Value', handles.ROI(1,handles.roiindex).enabled);
    
set(handles.lb_rois,'Value',1)
end
guidata(hObject, handles);



function ed_name_Callback(hObject, eventdata, handles)
% hObject    handle to ed_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_name as text
%        str2double(get(hObject,'String')) returns contents of ed_name as a double


% --- Executes during object creation, after setting all properties.
function ed_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_valid_Callback(hObject, eventdata, handles)
% hObject    handle to ed_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_valid as text
%        str2double(get(hObject,'String')) returns contents of ed_valid as a double


% --- Executes during object creation, after setting all properties.
function ed_valid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_tag1_Callback(hObject, eventdata, handles)
% hObject    handle to ed_tag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_tag1 as text
%        str2double(get(hObject,'String')) returns contents of ed_tag1 as a double


% --- Executes during object creation, after setting all properties.
function ed_tag1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_tag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_tag2_Callback(hObject, eventdata, handles)
% hObject    handle to ed_tag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_tag2 as text
%        str2double(get(hObject,'String')) returns contents of ed_tag2 as a double


% --- Executes during object creation, after setting all properties.
function ed_tag2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_tag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_type_Callback(hObject, eventdata, handles)
% hObject    handle to ed_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_type as text
%        str2double(get(hObject,'String')) returns contents of ed_type as a double


% --- Executes during object creation, after setting all properties.
function ed_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
