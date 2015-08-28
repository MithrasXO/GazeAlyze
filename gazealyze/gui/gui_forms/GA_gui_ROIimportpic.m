function varargout = GA_gui_importroipic(varargin)
% IMPORTROIPIC M-file for importroipic.fig
%      IMPORTROIPIC, by itself, creates a new IMPORTROIPIC or raises the existing
%      singleton*.
%
%      H = IMPORTROIPIC returns the handle to a new IMPORTROIPIC or the handle to
%      the existing singleton*.
%
%      IMPORTROIPIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTROIPIC.M with the given input arguments.
%
%      IMPORTROIPIC('Property','Value',...) creates a new IMPORTROIPIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before importroipic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to importroipic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help importroipic

% Last Modified by GUIDE v2.5 22-Feb-2010 13:12:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @importroipic_OpeningFcn, ...
    'gui_OutputFcn',  @importroipic_OutputFcn, ...
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


% --- Executes just before importroipic is made visible.
function importroipic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to importroipic (see VARARGIN)

% Choose default command line output for importroipic
handles.output = hObject;

ROIeditGUIhandle = cell2mat(varargin);

handles.ROIeditGUIhandle = ROIeditGUIhandle;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes importroipic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = importroipic_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_browse.
function pb_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select picture-folder') ;

set(handles.edit_dir, 'String', directory_name);

guidata(hObject, handles);



% --- Executes on selection change in pop_color_1.
function pop_color_1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color_1


% --- Executes during object creation, after setting all properties.
function pop_color_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_type_1.
function pop_type_1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_type_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_type_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_type_1


% --- Executes during object creation, after setting all properties.
function pop_type_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_type_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_valid_1.
function pop_valid_1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_valid_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_valid_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_valid_1


% --- Executes during object creation, after setting all properties.
function pop_valid_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_valid_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_1.
function cb_1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_1
set (handles.cb_2, 'Enable', 'on')


% --- Executes on selection change in pop_color_2.
function pop_color_2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color_2


% --- Executes during object creation, after setting all properties.
function pop_color_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in pop_type_2.
function pop_type_2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_type_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_type_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_type_2


% --- Executes during object creation, after setting all properties.
function pop_type_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_type_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_valid_2.
function pop_valid_2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_valid_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_valid_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_valid_2


% --- Executes during object creation, after setting all properties.
function pop_valid_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_valid_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_2.
function cb_2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_2
set (handles.cb_3, 'Enable', 'on')

% --- Executes on selection change in pop_color_3.
function pop_color_3_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color_3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color_3


% --- Executes during object creation, after setting all properties.
function pop_color_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_type_3.
function pop_type_3_Callback(hObject, eventdata, handles)
% hObject    handle to pop_type_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_type_3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_type_3


% --- Executes during object creation, after setting all properties.
function pop_type_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_type_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_valid_3.
function pop_valid_3_Callback(hObject, eventdata, handles)
% hObject    handle to pop_valid_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_valid_3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_valid_3


% --- Executes during object creation, after setting all properties.
function pop_valid_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_valid_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_3.
function cb_3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_3
set (handles.cb_4, 'Enable', 'on')

% --- Executes on selection change in pop_color_4.
function pop_color_4_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color_4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color_4


% --- Executes during object creation, after setting all properties.
function pop_color_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_type_4.
function pop_type_4_Callback(hObject, eventdata, handles)
% hObject    handle to pop_type_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_type_4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_type_4


% --- Executes during object creation, after setting all properties.
function pop_type_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_type_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_valid_4.
function pop_valid_4_Callback(hObject, eventdata, handles)
% hObject    handle to pop_valid_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_valid_4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_valid_4


% --- Executes during object creation, after setting all properties.
function pop_valid_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_valid_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_4.
function cb_4_Callback(hObject, eventdata, handles)
% hObject    handle to cb_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_4
set (handles.cb_5, 'Enable', 'on')

% --- Executes on selection change in pop_color_5.
function pop_color_5_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color_5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color_5


% --- Executes during object creation, after setting all properties.
function pop_color_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_type_5.
function pop_type_5_Callback(hObject, eventdata, handles)
% hObject    handle to pop_type_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_type_5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_type_5


% --- Executes during object creation, after setting all properties.
function pop_type_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_type_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_valid_5.
function pop_valid_5_Callback(hObject, eventdata, handles)
% hObject    handle to pop_valid_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_valid_5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_valid_5


% --- Executes during object creation, after setting all properties.
function pop_valid_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_valid_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_5.
function cb_5_Callback(hObject, eventdata, handles)
% hObject    handle to cb_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_5

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path = get(handles.edit_dir, 'String');


contents = cellstr(get(handles.pop_pictype,'String'));
selcontent =contents(get(handles.pop_pictype,'Value'));

if strcmp(selcontent, '*.jpg');
    
    pictures= dir([path '/*.jpg']);
    
end

if strcmp(selcontent, '*.png');
    
    pictures= dir([path '/*.png']);
    
end


ROIv(1,1).detect = get(handles.cb_1, 'Value');
ROIv(1,1).enabled = get(handles.cb_en1, 'Value');
ROIv(1,1).name = get(handles.edit_1, 'String');
contents = cellstr(get(handles.pop_color_1,'String'));
ROIv(1,1).color = cell2mat(contents(get(handles.pop_color_1,'Value')));
contents = cellstr(get(handles.pop_type_1,'String'));
ROIv(1,1).type =cell2mat(contents(get(handles.pop_type_1,'Value')));
contents = cellstr(get(handles.pop_valid_1,'String'));
ROIv(1,1).valid =cell2mat(contents(get(handles.pop_valid_1,'Value')));

ROIv(1,2).detect = get(handles.cb_2, 'Value');
ROIv(1,2).enabled = get(handles.cb_en2, 'Value');
ROIv(1,2).name = get(handles.edit_2, 'String');
contents = cellstr(get(handles.pop_color_2,'String'));
ROIv(1,2).color = cell2mat(contents(get(handles.pop_color_2,'Value')));
contents = cellstr(get(handles.pop_type_2,'String'));
ROIv(1,2).type =cell2mat(contents(get(handles.pop_type_2,'Value')));
contents = cellstr(get(handles.pop_valid_2,'String'));
ROIv(1,2).valid =cell2mat(contents(get(handles.pop_valid_2,'Value')));

ROIv(1,3).detect = get(handles.cb_3, 'Value');
ROIv(1,3).enabled = get(handles.cb_en3, 'Value');
ROIv(1,3).name = get(handles.edit_3, 'String');
contents = cellstr(get(handles.pop_color_3,'String'));
ROIv(1,3).color = cell2mat(contents(get(handles.pop_color_3,'Value')));
contents = cellstr(get(handles.pop_type_3,'String'));
ROIv(1,3).type =cell2mat(contents(get(handles.pop_type_3,'Value')));
contents = cellstr(get(handles.pop_valid_3,'String'));
ROIv(1,3).valid =cell2mat(contents(get(handles.pop_valid_3,'Value')));

ROIv(1,4).detect = get(handles.cb_4, 'Value');
ROIv(1,4).enabled = get(handles.cb_en4, 'Value');
ROIv(1,4).name = get(handles.edit_4, 'String');
contents = cellstr(get(handles.pop_color_4,'String'));
ROIv(1,4).color = cell2mat(contents(get(handles.pop_color_4,'Value')));
contents = cellstr(get(handles.pop_type_4,'String'));
ROIv(1,4).type =cell2mat(contents(get(handles.pop_type_4,'Value')));
contents = cellstr(get(handles.pop_valid_4,'String'));
ROIv(1,4).valid =cell2mat(contents(get(handles.pop_valid_4,'Value')));

ROIv(1,5).detect = get(handles.cb_5, 'Value');
ROIv(1,5).enabled = get(handles.cb_en5, 'Value');
ROIv(1,5).name = get(handles.edit_5, 'String');
contents = cellstr(get(handles.pop_color_5,'String'));
ROIv(1,5).color = cell2mat(contents(get(handles.pop_color_5,'Value')));
contents = cellstr(get(handles.pop_type_5,'String'));
ROIv(1,5).type =cell2mat(contents(get(handles.pop_type_5,'Value')));
contents = cellstr(get(handles.pop_valid_5,'String'));
ROIv(1,5).valid =cell2mat(contents(get(handles.pop_valid_5,'Value')));

color.red = [255 0 0];
color.green = [0 255 0];
color.blue = [0 0 255];
color.turquoise = [0 255 255];
color.violet = [255 0 255];
color.black = [0 0 0];
color.white = [255 255 255];

ROIvdetect=0;

for h=1:5
    
    if ROIv(1,h).detect == 1
        
        ROIvdetect = ROIvdetect+1;
        
    end
end


for k=1:ROIvdetect
    
    if strcmp(ROIv(1,k).color, 'red')
        
        ROIvcolor = color.red;
        
    elseif strcmp(ROIv(1,k).color, 'green')
        
        ROIvcolor = color.green;
        
    elseif strcmp(ROIv(1,k).color, 'blue')
        
        ROIvcolor = color.blue;
        
    elseif strcmp(ROIv(1,k).color, 'turquoise')
        
        ROIvcolor = color.turquoise;
        
    elseif strcmp(ROIv(1,k).color, 'violet')
        
        ROIvcolor = color.violet;
        
    elseif strcmp(ROIv(1,k).color, 'black')
        
        ROIvcolor = color.black;
        
    elseif strcmp(ROIv(1,k).color, 'white')
        
        ROIvcolor = color.white;
    end
    
    
    for i=1:length(pictures)
        
        
        
        A = imread([path '/' pictures(i).name]);
        
        for xsec=1:size(A,2)
            
            for ysec=1:size(A,1)
                
                if A(ysec,xsec,1)== ROIvcolor(1,1) && A(ysec,xsec,2) == ROIvcolor(1,2) && A(ysec,xsec,3)== ROIvcolor(1,3)
                    
                    
                    if exist('ListXY', 'var')
                        
                        ListXY =[ListXY; [xsec,ysec]];
                        
                    else
                        ListXY = [xsec,ysec];
                    end
                end
            end
        end
        
        
        ROIres(k,i).enabled = ROIv(1,k).enabled;
        ROIres(k,i).name = [pictures(i).name(1:end-4) ' - ' ROIv(1,k).name];
        
        %xmin xmax
        ROIres(k,i).x = [min(ListXY(:,1)) max(ListXY(:,1))];
        %ymin ymax
        ROIres(k,i).y = [min(ListXY(:,2)) max(ListXY(:,2))];
        
        ROIres(k,i).type = ROIv(1,k).type;
        
        if strcmp(ROIv(1,k).valid, 'all')
            ROIres(k,i).valid = 'all';
        else
            ROIres(k,i).valid = pictures(i).name(1:end-4);
        end
        
        ROIres(k,i).tag1 = ['ROI-Number: ' num2str(k)];
        ROIres(k,i).tag2 = ROIv(1,k).color();
        
        clear ListXY
        
    end
    
end

ROIeditGUI = guidata(handles.ROIeditGUIhandle);

if isempty(ROIeditGUI.ROI)
    sizeROI=0;
    ROIeditGUI = rmfield(ROIeditGUI, 'ROI');
else
    sizeROI = length(ROIeditGUI.ROI);
end

sizeROIres = size(ROIres);




for i=1:sizeROIres(1)
    for k=1:sizeROIres(2)
        sizeROI = sizeROI+1;
        ROIeditGUI.ROI(1,sizeROI) = ROIres(k,i);
    end
end

listboxstring= '';



for k=1:length(ROIeditGUI.ROI)
    
    listboxstring = [listboxstring; {ROIeditGUI.ROI(1,k).name}];  %#ok<AGROW>
    
end;

set(ROIeditGUI.lb_rois, 'String', listboxstring);
set(ROIeditGUI.lb_rois,'Value',1)
guidata(handles.ROIeditGUIhandle, ROIeditGUI);


guidata(hObject, handles);

close;


% --- Executes on selection change in pop_pictype.
function pop_pictype_Callback(hObject, eventdata, handles)
% hObject    handle to pop_pictype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_pictype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_pictype


% --- Executes during object creation, after setting all properties.
function pop_pictype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_pictype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_1 as a double


% --- Executes during object creation, after setting all properties.
function edit_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_2 as a double


% --- Executes during object creation, after setting all properties.
function edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_3 as a double


% --- Executes during object creation, after setting all properties.
function edit_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_4 as text
%        str2double(get(hObject,'String')) returns contents of edit_4 as a double


% --- Executes during object creation, after setting all properties.
function edit_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_5 as text
%        str2double(get(hObject,'String')) returns contents of edit_5 as a double


% --- Executes during object creation, after setting all properties.
function edit_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_en1.
function cb_en1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_en1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_en1


% --- Executes on button press in cb_en2.
function cb_en2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_en2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_en2


% --- Executes on button press in cb_en3.
function cb_en3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_en3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_en3


% --- Executes on button press in cb_en4.
function cb_en4_Callback(hObject, eventdata, handles)
% hObject    handle to cb_en4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_en4


% --- Executes on button press in cb_en5.
function cb_en5_Callback(hObject, eventdata, handles)
% hObject    handle to cb_en5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_en5
