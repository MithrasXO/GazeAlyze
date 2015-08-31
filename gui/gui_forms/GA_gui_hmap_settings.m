function varargout = GA_gui_hmap_settings(varargin)
% HEATMAP_CREATION M-file for heatmap_creation.fig
%      HEATMAP_CREATION, by itself, creates a new HEATMAP_CREATION or raises the existing
%      singleton*.
%
%      H = HEATMAP_CREATION returns the handle to a new HEATMAP_CREATION or the handle to
%      the existing singleton*.
%
%      HEATMAP_CREATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATMAP_CREATION.M with the given input arguments.
%
%      HEATMAP_CREATION('Property','Value',...) creates a new HEATMAP_CREATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before heatmap_creation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to heatmap_creation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help heatmap_creation

% Last Modified by GUIDE v2.5 15-May-2010 16:33:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @heatmap_creation_OpeningFcn, ...
    'gui_OutputFcn',  @heatmap_creation_OutputFcn, ...
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


% --- Executes just before heatmap_creation is made visible.
function heatmap_creation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to heatmap_creation (see VARARGIN)

% Choose default command line output for heatmap_creation
handles.output = hObject;

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);

handles.grouptype = 'all';

if isfield(mainGUIdata, 'data')
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.bcolor)
        set(handles.txt_bc_color, 'BackgroundColor', mainGUIdata.data.eye.heatmap.creation.bcolor)
    end
    
    set(handles.edit_incdata, 'String', mainGUIdata.data.eye.heatmap.dir.datafile)
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.shiftpic)
        set(handles.edit_shift_x, 'String', num2str(mainGUIdata.data.eye.heatmap.creation.shiftpic(1)))
        set(handles.edit_shift_y, 'String', num2str(mainGUIdata.data.eye.heatmap.creation.shiftpic(2)))
    end
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.bocolor)
        
        if strcmp(mainGUIdata.data.eye.heatmap.creation.bocolor,'none')
            set(handles.txt_boc_color, 'String', '-none-')
            set(handles.txt_boc_color, 'BackgroundColor', [0.94 0.94 0.94])
        else
            
            set(handles.txt_boc_color, 'BackgroundColor', mainGUIdata.data.eye.heatmap.creation.bocolor)
            
        end
    end
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.fixradius)
        set(handles.edit_fixrad, 'String', num2str(mainGUIdata.data.eye.heatmap.creation.fixradius))
    end
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.transparency)
        set(handles.edit_trans, 'String', num2str(mainGUIdata.data.eye.heatmap.creation.transparency))
    end
    
    %     if ~isempty(mainGUIdata.data.eye.heatmap.creation.filter)
    %         set(handles.txt_bc_color, 'String', mainGUIdata.data.eye.heatmap.creation.filter)
    %     end
    
    if ~isempty(mainGUIdata.data.eye.heatmap.creation.filteratt)
        set(handles.edit_filteratt, 'String', num2str(mainGUIdata.data.eye.heatmap.creation.filteratt))
    end
    
    
end

if isfield(mainGUIdata, 'data')
    
    if ~isempty(mainGUIdata.data.eye.heatmap.screen)
        if ~isempty(mainGUIdata.data.eye.defaultscreen)
        set(handles.edit_screen_x, 'String', mainGUIdata.data.eye.defaultscreen(2))
        set(handles.edit_screen_y, 'String', mainGUIdata.data.eye.defaultscreen(4))
        end
    end 
    
    
    if (mainGUIdata.data.eye.heatmap.dir.usecorrection == 1)
        set(handles.cb_correct, 'Value', 1)
        
    end
    if strcmp(mainGUIdata.data.eye.heatmap.group.type, 'all')
        
        set(handles.txt_subj, 'Enable', 'off')
        set(handles.edit_incdata, 'Enable', 'off')
        set(handles.pb_browse_file, 'Enable', 'off')
       
        handles.grouptype='all';
        set(handles.rball, 'Value', 1)
        
    end
    
    if strcmp(mainGUIdata.data.eye.heatmap.group.type, 'file')
        set(handles.txt_subj, 'Enable', 'on')
        set(handles.edit_incdata, 'Enable', 'on')
        set(handles.pb_browse_file, 'Enable', 'on')

        handles.grouptype='file';
        set(handles.rbfile, 'Value', 1)
        
    end
    
    
    if ~isempty(mainGUIdata.data.eye.heatmap.groups)
        
        handles.groups = mainGUIdata.data.eye.heatmap.groups;
        
        sizegroup = length (mainGUIdata.data.eye.heatmap.groups);
        
        set(handles.pop_group, 'String', 1:sizegroup)
        set(handles.editnum, 'String', mainGUIdata.data.eye.heatmap.groups{1,1})
        handles.selcontent =1;
    end
    
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes heatmap_creation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = heatmap_creation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_screen_x_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to edit_screen_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_screen_x as text
%        str2double(get(hObject,'String')) returns contents of edit_screen_x as a double


% --- Executes during object creation, after setting all properties.
function edit_screen_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_screen_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_screen_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_screen_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_screen_y as text
%        str2double(get(hObject,'String')) returns contents of edit_screen_y as a double


% --- Executes during object creation, after setting all properties.
function edit_screen_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_screen_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fixrad_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixrad as text
%        str2double(get(hObject,'String')) returns contents of edit_fixrad as a double


% --- Executes during object creation, after setting all properties.
function edit_fixrad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trans_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trans as text
%        str2double(get(hObject,'String')) returns contents of edit_trans as a double


% --- Executes during object creation, after setting all properties.
function edit_trans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filteratt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filteratt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filteratt as text
%        str2double(get(hObject,'String')) returns contents of edit_filteratt as a double


% --- Executes during object creation, after setting all properties.
function edit_filteratt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filteratt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_shift_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shift_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shift_x as text
%        str2double(get(hObject,'String')) returns contents of edit_shift_x as a double


% --- Executes during object creation, after setting all properties.
function edit_shift_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_shift_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_shift_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shift_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shift_y as text
%        str2double(get(hObject,'String')) returns contents of edit_shift_y as a double


% --- Executes during object creation, after setting all properties.
function edit_shift_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_shift_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_bc_color.
function pb_bc_color_Callback(hObject, eventdata, handles)
% hObject    handle to pb_bc_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    c = uisetcolor;
    set(handles.txt_bc_color, 'BackgroundColor', c)
catch ME %#ok<NASGU>
    
    
end
guidata(hObject, handles);


% --- Executes on button press in pb_bc_default.
function pb_bc_default_Callback(hObject, eventdata, handles)
% hObject    handle to pb_bc_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_bc_color, 'BackgroundColor', 'black')

% --- Executes on button press in pb_boc_color.
function pb_boc_color_Callback(hObject, eventdata, handles)
% hObject    handle to pb_boc_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    c = uisetcolor;
    set(handles.txt_boc_color, 'BackgroundColor', c)
    set(handles.txt_boc_color, 'String', '')
catch ME %#ok<NASGU>
    
    
end

guidata(hObject, handles);


% --- Executes on button press in pb_boc_default.
function pb_boc_default_Callback(hObject, eventdata, handles)
% hObject    handle to pb_boc_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_boc_color, 'BackgroundColor', 'black')
set(handles.txt_boc_color, 'String', '')

% --- Executes on selection change in pop_filtermethod.
function pop_filtermethod_Callback(hObject, eventdata, handles)
% hObject    handle to pop_filtermethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_filtermethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_filtermethod


% --- Executes during object creation, after setting all properties.
function pop_filtermethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_filtermethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_fr_default.
function pb_fr_default_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fr_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_fixrad, 'String', 50)

% --- Executes on button press in pb_ht_default.
function pb_ht_default_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ht_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_trans, 'String', 0.6)

% --- Executes on button press in pb_fss_default.
function pb_fss_default_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fss_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_filteratt, 'String', 10)


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

mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
mainGUI = guidata(mainGUI_handle);


lbstring = get(mainGUI.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Heatmap Settings updatet <<<'}];

if isempty(mainGUI.data.eye.heatmap.screen)
mainGUI.data.eye.heatmap.screen = [0 0 0 0];
end
    
[mainGUI.data.eye.heatmap.screen(1,2), lbstring ] =  GA_gui_get(lbstring, 'heatmap screensize x: ', mainGUI.data.eye.heatmap.screen(1,2), handles.edit_screen_x, 'String');
[mainGUI.data.eye.heatmap.screen(1,4), lbstring ] =  GA_gui_get(lbstring, 'heatmap screensize y: ', mainGUI.data.eye.heatmap.screen(1,4), handles.edit_screen_y, 'String');
[mainGUI.data.eye.heatmap.dir.usecorrection, lbstring ] =  GA_gui_get(lbstring, 'use correction factors: ', mainGUI.data.eye.heatmap.dir.usecorrection, handles.cb_correct, 'Value');

if isempty(mainGUI.data.eye.heatmap.creation.bcolor)
mainGUI.data.eye.heatmap.creation.bcolor = [0 0 0];
end

if ~isequal(mainGUI.data.eye.heatmap.creation.bcolor, get(handles.txt_bc_color, 'BackgroundColor'))
    mainGUI.data.eye.heatmap.creation.bcolor=   get(handles.txt_bc_color, 'BackgroundColor');
    lbstring = [lbstring; ['basic backgroundcolor: ' mainGUI.data.eye.heatmap.creation.bcolor]];
end

shiftpic =[str2double(get(handles.edit_shift_x, 'String')) str2double(get(handles.edit_shift_y, 'String'))] ;
if isempty(mainGUI.data.eye.heatmap.creation.shiftpic)
mainGUI.data.eye.heatmap.creation.shiftpic = [0, 0];
end
if ~isequal(mainGUI.data.eye.heatmap.creation.shiftpic, shiftpic) 
    
    mainGUI.data.eye.heatmap.creation.shiftpic =[str2double(get(handles.edit_shift_x, 'String')) str2double(get(handles.edit_shift_y, 'String'))] ;
    lbstring = [lbstring; ['shift-picture(x-y): ' num2str(mainGUI.data.eye.heatmap.creation.shiftpic(1)) ' - ' num2str(mainGUI.data.eye.heatmap.creation.shiftpic(2))]];
end

if strcmp(get(handles.txt_boc_color,'String'),'-none-')
    
    if ~strcmp(mainGUI.data.eye.heatmap.creation.bocolor, 'none')
        mainGUI.data.eye.heatmap.creation.bocolor = 'none';
        lbstring = [lbstring; ['basic heatmapcolor: ' mainGUI.data.eye.heatmap.creation.bocolor]];
    end
else
    
    try
        
        if ~(mainGUI.data.eye.heatmap.creation.bocolor==get(handles.txt_boc_color, 'BackgroundColor'))
            
            mainGUI.data.eye.heatmap.creation.bocolor=get(handles.txt_boc_color, 'BackgroundColor');
            lbstring = [lbstring; ['basic heatmapcolor: ' mainGUI.data.eye.heatmap.creation.bocolor]];
        end
        
    catch ME
        mainGUI.data.eye.heatmap.creation.bocolor=get(handles.txt_boc_color, 'BackgroundColor');
        lbstring = [lbstring; ['basic heatmapcolor: ' mainGUI.data.eye.heatmap.creation.bocolor]];
    end
end

[mainGUI.data.eye.heatmap.creation.fixradius, lbstring ] =  GA_gui_get(lbstring, 'fixation radius: ', mainGUI.data.eye.heatmap.creation.fixradius, handles.edit_fixrad, 'String');
[mainGUI.data.eye.heatmap.creation.transparency, lbstring ] =  GA_gui_get(lbstring, 'transparency: ', mainGUI.data.eye.heatmap.creation.transparency, handles.edit_trans, 'String');
[mainGUI.data.eye.heatmap.creation.filteratt, lbstring ] =  GA_gui_get(lbstring, 'filter attributes: ', mainGUI.data.eye.heatmap.creation.filteratt, handles.edit_filteratt, 'String');

%set(handles.txt_bc_color, 'String',
%mainGUI.data.eye.heatmap.creation.filter)
%mainGUI.data.eye.heatmap.creation.filteratt =
%str2double(get(handles.filteratt, 'String'));

if ~strcmp(mainGUI.data.eye.heatmap.group.type, handles.grouptype)
    mainGUI.data.eye.heatmap.group.type = handles.grouptype;
    lbstring = [lbstring; ['grouptype: ' mainGUI.data.eye.heatmap.group.type]];
end

[mainGUI.data.eye.heatmap.dir.datafile, lbstring ] =  GA_gui_get(lbstring, 'datafile-destination: ', mainGUI.data.eye.heatmap.dir.datafile, handles.edit_incdata, 'String');


if strcmp(handles.grouptype, 'mangroup')
    
    if ~isequal(mainGUI.data.eye.heatmap.groups,handles.groups)
        lbstring = [lbstring; ['Groups: >--modified/added/deleted']]; %#ok<NBRAK>
        if isfield(mainGUI.data.eye.heatmap, 'groups')
            mainGUI.data.eye.heatmap= rmfield(mainGUI.data.eye.heatmap, 'groups');
        end
        if isfield(handles, 'groups')
            for i=1:length(handles.groups)
                mainGUI.data.eye.heatmap.groups{1,i}  = handles.groups{1,i};
            end
        end
    end
end


if ~strcmp(lbstring{end},'>>> Heatmap General Settings updatet <<<')
    set(mainGUI.listbox_progress, 'String', lbstring);
    set(mainGUI.listbox_progress, 'Max', length(lbstring));
    set(mainGUI.listbox_progress, 'Value', length(lbstring));
    set(mainGUI.uipt_save, 'Enable', 'on');
end;


% Generate Listbox Overview / Pass data to main window (main-window)
GA_gui_set(mainGUI, 1)


close;


% --- Executes during object creation, after setting all properties.
function txt_boc_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_boc_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_trans.
function pb_trans_Callback(hObject, eventdata, handles)
% hObject    handle to pb_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_boc_color, 'String', '-none-')
set(handles.txt_boc_color, 'BackgroundColor', [0.94 0.94 0.94])


% --- Executes during object creation, after setting all properties.
function pb_trans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit_screen_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_screen_x as text
%        str2double(get(hObject,'String')) returns contents of edit_screen_x as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_screen_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit_screen_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_screen_y as text
%        str2double(get(hObject,'String')) returns contents of edit_screen_y as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_screen_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_correct.
function cb_correct_Callback(hObject, eventdata, handles)
% hObject    handle to cb_correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_correct



function edit_incdata_Callback(hObject, eventdata, handles)
% hObject    handle to edit_incdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_incdata as text
%        str2double(get(hObject,'String')) returns contents of edit_incdata as a double


% --- Executes during object creation, after setting all properties.
function edit_incdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_incdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_browse_file.
function pb_browse_file_Callback(hObject, eventdata, handles)
% hObject    handle to pb_browse_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.xls;*.xlsx','Select list of included files') ;
if PathName ~=0
    set(handles.edit_incdata, 'String', fullfile(PathName, FileName));
end


% --- Executes on selection change in pop_group.
function pop_group_Callback(hObject, eventdata, handles)
% hObject    handle to pop_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_group contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_group
handles.selcontent=cell2mat({get(hObject,'Value')});

set(handles.editnum, 'String', num2str((handles.groups{1,handles.selcontent})))
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_addgroup.
function pb_addgroup_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addgroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'groups')
    sizegroup = length (handles.groups);
    handles.groups{1,sizegroup+1} = get(handles.editnum, 'String');
    
    set(handles.pop_group, 'String', 1:sizegroup+1)
    set(handles.pop_group, 'Value', sizegroup+1)
    handles.selcontent = sizegroup;
else
    
    sizegroup = 0;
    handles.groups{1,sizegroup+1} = get(handles.editnum, 'String');
    
    set(handles.pop_group, 'String', 1:sizegroup+1)
    set(handles.pop_group, 'Value', sizegroup+1)
    handles.selcontent = 1;
    
end
guidata(hObject, handles);



function editnum_Callback(hObject, eventdata, handles)
% hObject    handle to editnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editnum as text
%        str2double(get(hObject,'String')) returns contents of editnum as a double


% --- Executes during object creation, after setting all properties.
function editnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_delete.
function pb_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'groups')
    sizegroup= length(handles.groups);
    if sizegroup~=1
        handles.groups(:,handles.selcontent)=[];
        
        set(handles.pop_group, 'String', 1:sizegroup-1)
        
        set(handles.pop_group, 'Value', 1)
        handles.selcontent=1;
        
        set(handles.editnum, 'String', handles.groups{1,handles.selcontent})
    end
    if sizegroup==1
        set(handles.pop_group, 'String', '_')
        set(handles.editnum, 'String', '')
        set(handles.pop_group, 'Value', 1)
        handles= rmfield (handles, 'selcontent');
        handles= rmfield (handles, 'groups');
        
    end
end
guidata(hObject, handles);

% --- Executes when selected object is changed in ui_selection.
function ui_selection_SelectionChangeFcn(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
% hObject    handle to the selected object in ui_selection
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

if get(handles.rball, 'Value') == 1
    set(handles.txt_subj, 'Enable', 'off')
    set(handles.edit_incdata, 'Enable', 'off')
    set(handles.pb_browse_file, 'Enable', 'off')
    
   
    handles.grouptype='all';
    
end

if get(handles.rbfile, 'Value') == 1
    set(handles.txt_subj, 'Enable', 'on')
    set(handles.edit_incdata, 'Enable', 'on')
    set(handles.pb_browse_file, 'Enable', 'on')
    
  
    handles.grouptype='file';
    
end




guidata(hObject, handles);
