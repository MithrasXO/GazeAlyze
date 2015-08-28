function varargout = GA_gui_hmap_color(varargin)
% HEATMAP_COLOR M-file for heatmap_color.fig
%      HEATMAP_COLOR, by itself, creates a new HEATMAP_COLOR or raises the existing
%      singleton*.
%
%      H = HEATMAP_COLOR returns the handle to a new HEATMAP_COLOR or the handle to
%      the existing singleton*.
%
%      HEATMAP_COLOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATMAP_COLOR.M with the given input arguments.
%
%      HEATMAP_COLOR('Property','Value',...) creates a new HEATMAP_COLOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before heatmap_color_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to heatmap_color_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help heatmap_color

% Last Modified by GUIDE v2.5 04-Jun-2010 13:19:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @heatmap_color_OpeningFcn, ...
    'gui_OutputFcn',  @heatmap_color_OutputFcn, ...
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


% --- Executes just before heatmap_color is made visible.
function heatmap_color_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to heatmap_color (see VARARGIN)

handles.output = hObject;

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(handles.mainGUIhandle);

defcolor(1,:) = get(handles.col1,'BackgroundColor');
defcolor(2,:) = get(handles.col2,'BackgroundColor');
defcolor(3,:) = get(handles.col3,'BackgroundColor');
defcolor(4,:) = get(handles.col4,'BackgroundColor');
defcolor(5,:) = get(handles.col5,'BackgroundColor');
defcolor(6,:) = get(handles.col6,'BackgroundColor');
defcolor(7,:) = get(handles.col7,'BackgroundColor');
defcolor(8,:) = get(handles.col8,'BackgroundColor');
defcolor(9,:) = get(handles.col9,'BackgroundColor');
defcolor(10,:) = get(handles.col10,'BackgroundColor');
defcolor(11,:) = get(handles.col11,'BackgroundColor');
defcolor(12,:) = get(handles.col12,'BackgroundColor');
defcolor(13,:) = get(handles.col13,'BackgroundColor');
defcolor(14,:) = get(handles.col14,'BackgroundColor');
defcolor(15,:) = get(handles.col15,'BackgroundColor');

if strcmp(mainGUIdata.data.eye.heatmap.color.fixtype, 'countfix')
    set(handles.rbcount, 'Value', 1)
    handles.fixtype = 'countfix';
end

if strcmp(mainGUIdata.data.eye.heatmap.color.fixtype, 'fixtime')
    set(handles.rbtime, 'Value', 1)
    handles.fixtype = 'fixtime';
end

if isempty(mainGUIdata.data.eye.heatmap.color.fixtype)
    set(handles.rbcount, 'Value', 1)
    handles.fixtype = 'countfix';
end

handles.defcolor = defcolor;

if isfield(mainGUIdata, 'data')
    
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color1)
        set(handles.col1, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color1)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color2)
        set(handles.col2, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color2)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color3)
        set(handles.col3, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color3)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color4)
        set(handles.col4, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color4)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color5)
        set(handles.col5, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color5)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color6)
        set(handles.col6, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color6)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color7)
        set(handles.col7, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color7)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color8)
        set(handles.col8, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color8)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color9)
        set(handles.col9, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color9)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color10)
        set(handles.col10, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color10)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color11)
        set(handles.col11, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color11)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color12)
        set(handles.col12, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color12)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color13)
        set(handles.col13, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color13)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color14)
        set(handles.col14, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color14)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.color15)
        set(handles.col15, 'BackgroundColor', mainGUIdata.data.eye.heatmap.color.color15)
    end
    
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage0)
        set(handles.ed01, 'String', mainGUIdata.data.eye.heatmap.color.stage0)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage1)
        set(handles.ed12, 'String', mainGUIdata.data.eye.heatmap.color.stage1)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage2)
        set(handles.ed23, 'String', mainGUIdata.data.eye.heatmap.color.stage2)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage3)
        set(handles.ed34, 'String', mainGUIdata.data.eye.heatmap.color.stage3)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage4)
        set(handles.ed45, 'String', mainGUIdata.data.eye.heatmap.color.stage4)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage5)
        set(handles.ed56, 'String', mainGUIdata.data.eye.heatmap.color.stage5)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage6)
        set(handles.ed67, 'String', mainGUIdata.data.eye.heatmap.color.stage6)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage7)
        set(handles.ed78, 'String', mainGUIdata.data.eye.heatmap.color.stage7)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage8)
        set(handles.ed89, 'String', mainGUIdata.data.eye.heatmap.color.stage8)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage9)
        set(handles.ed910, 'String', mainGUIdata.data.eye.heatmap.color.stage9)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage10)
        set(handles.ed1011, 'String', mainGUIdata.data.eye.heatmap.color.stage10)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage11)
        set(handles.ed1112, 'String', mainGUIdata.data.eye.heatmap.color.stage11)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage12)
        set(handles.ed1213, 'String', mainGUIdata.data.eye.heatmap.color.stage12)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage13)
        set(handles.ed1314, 'String', mainGUIdata.data.eye.heatmap.color.stage13)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage14)
        set(handles.ed1415, 'String', mainGUIdata.data.eye.heatmap.color.stage14)
    end
    if ~isempty(mainGUIdata.data.eye.heatmap.color.stage15)
        set(handles.ed15end, 'String', mainGUIdata.data.eye.heatmap.color.stage15)
    end
    
    
    
end

usrcolor(1,:) = get(handles.col1,'BackgroundColor');
usrcolor(2,:) = get(handles.col2,'BackgroundColor');
usrcolor(3,:) = get(handles.col3,'BackgroundColor');
usrcolor(4,:) = get(handles.col4,'BackgroundColor');
usrcolor(5,:) = get(handles.col5,'BackgroundColor');
usrcolor(6,:) = get(handles.col6,'BackgroundColor');
usrcolor(7,:) = get(handles.col7,'BackgroundColor');
usrcolor(8,:) = get(handles.col8,'BackgroundColor');
usrcolor(9,:) = get(handles.col9,'BackgroundColor');
usrcolor(10,:) = get(handles.col10,'BackgroundColor');
usrcolor(11,:) = get(handles.col11,'BackgroundColor');
usrcolor(12,:) = get(handles.col12,'BackgroundColor');
usrcolor(13,:) = get(handles.col13,'BackgroundColor');
usrcolor(14,:) = get(handles.col14,'BackgroundColor');
usrcolor(15,:) = get(handles.col15,'BackgroundColor');
handles.usrcolor = usrcolor;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes heatmap_creation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = heatmap_color_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_screen_x_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
mainGUI = guidata(mainGUI_handle);


% if get(handles.rbcount, 'Value')==1
%     mainGUI.data.eye.heatmap.color.fixtype = 'countfix';
% else
%     mainGUI.data.eye.heatmap.color.fixtype = 'fixtime';
% end


lbstring = get(mainGUI.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Heatmap-Colormaps updatet <<<'}];


if ~strcmp(mainGUI.data.eye.heatmap.color.fixtype, handles.fixtype)
    lbstring = [lbstring; ['fixtype: ' handles.fixtype]];
    mainGUI.data.eye.heatmap.color.fixtype = handles.fixtype;
end

[mainGUI.data.eye.heatmap.color.stage0, lbstring] =  GA_gui_get(lbstring, '1.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage0), handles.ed01, 'String');
[mainGUI.data.eye.heatmap.color.stage1, lbstring] =  GA_gui_get(lbstring, '2.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage1), handles.ed12, 'String');
[mainGUI.data.eye.heatmap.color.stage2, lbstring] =  GA_gui_get(lbstring, '3.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage2), handles.ed23, 'String');
[mainGUI.data.eye.heatmap.color.stage3, lbstring] =  GA_gui_get(lbstring, '4.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage3), handles.ed34, 'String');
[mainGUI.data.eye.heatmap.color.stage4, lbstring] =  GA_gui_get(lbstring, '5.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage4), handles.ed45, 'String');
[mainGUI.data.eye.heatmap.color.stage5, lbstring] =  GA_gui_get(lbstring, '6.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage5), handles.ed56, 'String');
[mainGUI.data.eye.heatmap.color.stage6, lbstring] =  GA_gui_get(lbstring, '7.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage6), handles.ed67, 'String');
[mainGUI.data.eye.heatmap.color.stage7, lbstring] =  GA_gui_get(lbstring, '8.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage7), handles.ed78, 'String');
[mainGUI.data.eye.heatmap.color.stage8, lbstring] =  GA_gui_get(lbstring, '9.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage8), handles.ed89, 'String');
[mainGUI.data.eye.heatmap.color.stage9, lbstring] =  GA_gui_get(lbstring, '10.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage9), handles.ed910, 'String');
[mainGUI.data.eye.heatmap.color.stage10, lbstring] =  GA_gui_get(lbstring, '11.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage10), handles.ed1011, 'String');
[mainGUI.data.eye.heatmap.color.stage11, lbstring] =  GA_gui_get(lbstring, '12.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage11), handles.ed1112, 'String');
[mainGUI.data.eye.heatmap.color.stage12, lbstring] =  GA_gui_get(lbstring, '13.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage12), handles.ed1213, 'String');
[mainGUI.data.eye.heatmap.color.stage13, lbstring] =  GA_gui_get(lbstring, '14.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage13), handles.ed1314, 'String');
[mainGUI.data.eye.heatmap.color.stage14, lbstring] =  GA_gui_get(lbstring, '15.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage14), handles.ed1415, 'String');
[mainGUI.data.eye.heatmap.color.stage15, lbstring] =  GA_gui_get(lbstring, '16.step value ->-> ', str2double(mainGUI.data.eye.heatmap.color.stage15), handles.ed15end, 'String');

% [mainGUI.data.eye.heatmap.color.color1, lbstring] =  GA_gui_get(lbstring, 'Color step-1 ->-> ', mainGUI.data.eye.heatmap.color.color1, handles.col1, 'BackgroundColor');

mainGUI.data.eye.heatmap.color.color1 = get(handles.col1, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color2 = get(handles.col2, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color3 = get(handles.col3, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color4 = get(handles.col4, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color5 = get(handles.col5, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color6 = get(handles.col6, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color7 = get(handles.col7, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color8 = get(handles.col8, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color9 = get(handles.col9, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color10 = get(handles.col10, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color11 = get(handles.col11, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color12 = get(handles.col12, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color13 = get(handles.col13, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color14 = get(handles.col14, 'BackgroundColor');
mainGUI.data.eye.heatmap.color.color15 = get(handles.col15, 'BackgroundColor');

if ~strcmp(lbstring{end},'>>> Heatmap-Colormaps updatet <<<')
    set(mainGUI.listbox_progress, 'String', lbstring);
    set(mainGUI.listbox_progress, 'Max', length(lbstring));
    set(mainGUI.listbox_progress, 'Value', length(lbstring));
    set(mainGUI.uipt_save, 'Enable', 'on');
end;


% Generate Listbox Overview / Pass data to main window (main-window)
GA_gui_set(mainGUI, 1)


close;




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



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed01_Callback(hObject, eventdata, handles)
% hObject    handle to ed01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed01 as text
%        str2double(get(hObject,'String')) returns contents of ed01 as a double


% --- Executes during object creation, after setting all properties.
function ed01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed34_Callback(hObject, eventdata, handles)
% hObject    handle to ed34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed34 as text
%        str2double(get(hObject,'String')) returns contents of ed34 as a double


% --- Executes during object creation, after setting all properties.
function ed34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed56_Callback(hObject, eventdata, handles)
% hObject    handle to ed56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed56 as text
%        str2double(get(hObject,'String')) returns contents of ed56 as a double


% --- Executes during object creation, after setting all properties.
function ed56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed78_Callback(hObject, eventdata, handles)
% hObject    handle to ed78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed78 as text
%        str2double(get(hObject,'String')) returns contents of ed78 as a double


% --- Executes during object creation, after setting all properties.
function ed78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed89_Callback(hObject, eventdata, handles)
% hObject    handle to ed89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed89 as text
%        str2double(get(hObject,'String')) returns contents of ed89 as a double


% --- Executes during object creation, after setting all properties.
function ed89_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed23_Callback(hObject, eventdata, handles)
% hObject    handle to ed23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed23 as text
%        str2double(get(hObject,'String')) returns contents of ed23 as a double


% --- Executes during object creation, after setting all properties.
function ed23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed45_Callback(hObject, eventdata, handles)
% hObject    handle to ed45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed45 as text
%        str2double(get(hObject,'String')) returns contents of ed45 as a double


% --- Executes during object creation, after setting all properties.
function ed45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed67_Callback(hObject, eventdata, handles)
% hObject    handle to ed67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed67 as text
%        str2double(get(hObject,'String')) returns contents of ed67 as a double


% --- Executes during object creation, after setting all properties.
function ed67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed12_Callback(hObject, eventdata, handles)
% hObject    handle to ed12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed12 as text
%        str2double(get(hObject,'String')) returns contents of ed12 as a double


% --- Executes during object creation, after setting all properties.
function ed12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed32_Callback(hObject, eventdata, handles)
% hObject    handle to ed32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed32 as text
%        str2double(get(hObject,'String')) returns contents of ed32 as a double


% --- Executes during object creation, after setting all properties.
function ed32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed52_Callback(hObject, eventdata, handles)
% hObject    handle to ed52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed52 as text
%        str2double(get(hObject,'String')) returns contents of ed52 as a double


% --- Executes during object creation, after setting all properties.
function ed52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed72_Callback(hObject, eventdata, handles)
% hObject    handle to ed72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed72 as text
%        str2double(get(hObject,'String')) returns contents of ed72 as a double


% --- Executes during object creation, after setting all properties.
function ed72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed82_Callback(hObject, eventdata, handles)
% hObject    handle to ed82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed82 as text
%        str2double(get(hObject,'String')) returns contents of ed82 as a double


% --- Executes during object creation, after setting all properties.
function ed82_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed22_Callback(hObject, eventdata, handles)
% hObject    handle to ed22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed22 as text
%        str2double(get(hObject,'String')) returns contents of ed22 as a double


% --- Executes during object creation, after setting all properties.
function ed22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed42_Callback(hObject, eventdata, handles)
% hObject    handle to ed42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed42 as text
%        str2double(get(hObject,'String')) returns contents of ed42 as a double


% --- Executes during object creation, after setting all properties.
function ed42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed62_Callback(hObject, eventdata, handles)
% hObject    handle to ed62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed62 as text
%        str2double(get(hObject,'String')) returns contents of ed62 as a double


% --- Executes during object creation, after setting all properties.
function ed62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbChooseColor1.
function pbChooseColor1_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

c = uisetcolor;
if c ~= 0
    set(handles.col1, 'BackgroundColor', c)
end;


% --- Executes on selection change in popcolorm.
function popcolorm_Callback(hObject, eventdata, handles)
% hObject    handle to popcolorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popcolorm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popcolorm
handles.selected = get(hObject,'Value');

choosecolor(handles)

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popcolorm_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to popcolorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbChooseColor2.
function pbChooseColor2_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col2, 'BackgroundColor', c)
end;


% --- Executes on button press in pbChooseColor3.
function pbChooseColor3_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col3, 'BackgroundColor', c)
end;


% --- Executes on button press in pbChooseColor4.
function pbChooseColor4_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col4, 'BackgroundColor', c)
end;


% --- Executes on button press in pbChooseColor5.
function pbChooseColor5_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col5, 'BackgroundColor', c)
end;


% --- Executes on button press in pbChooseColor6.
function pbChooseColor6_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col6, 'BackgroundColor', c)
end;


% --- Executes on button press in pbChooseColor7.
function pbChooseColor7_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

c = uisetcolor;
if c ~= 0
    set(handles.col7, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor8.
function pbChooseColor8_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col8, 'BackgroundColor', c)
end;


function ed910_Callback(hObject, eventdata, handles)
% hObject    handle to ed910 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed910 as text
%        str2double(get(hObject,'String')) returns contents of ed910 as a double


% --- Executes during object creation, after setting all properties.
function ed910_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed910 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed1011_Callback(hObject, eventdata, handles)
% hObject    handle to ed1011 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed1011 as text
%        str2double(get(hObject,'String')) returns contents of ed1011 as a double


% --- Executes during object creation, after setting all properties.
function ed1011_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed1011 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed92_Callback(hObject, eventdata, handles)
% hObject    handle to ed92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed92 as text
%        str2double(get(hObject,'String')) returns contents of ed92 as a double


% --- Executes during object creation, after setting all properties.
function ed92_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed102_Callback(hObject, eventdata, handles)
% hObject    handle to ed102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed102 as text
%        str2double(get(hObject,'String')) returns contents of ed102 as a double


% --- Executes during object creation, after setting all properties.
function ed102_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbChooseColor9.
function pbChooseColor9_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col9, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor10.
function pbChooseColor10_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col10, 'BackgroundColor', c)
end;


function ed1112_Callback(hObject, eventdata, handles)
% hObject    handle to ed1112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed1112 as text
%        str2double(get(hObject,'String')) returns contents of ed1112 as a double


% --- Executes during object creation, after setting all properties.
function ed1112_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed1112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed112_Callback(hObject, eventdata, handles)
% hObject    handle to ed112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed112 as text
%        str2double(get(hObject,'String')) returns contents of ed112 as a double


% --- Executes during object creation, after setting all properties.
function ed112_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed122_Callback(hObject, eventdata, handles)
% hObject    handle to ed122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed122 as text
%        str2double(get(hObject,'String')) returns contents of ed122 as a double


% --- Executes during object creation, after setting all properties.
function ed122_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to ed122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed122 as text
%        str2double(get(hObject,'String')) returns contents of ed122 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed1314_Callback(hObject, eventdata, handles)
% hObject    handle to ed1314 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed1314 as text
%        str2double(get(hObject,'String')) returns contents of ed1314 as a double


% --- Executes during object creation, after setting all properties.
function ed1314_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed1314 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed132_Callback(hObject, eventdata, handles)
% hObject    handle to ed132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed132 as text
%        str2double(get(hObject,'String')) returns contents of ed132 as a double


% --- Executes during object creation, after setting all properties.
function ed132_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed1415_Callback(hObject, eventdata, handles)
% hObject    handle to ed1415 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed1415 as text
%        str2double(get(hObject,'String')) returns contents of ed1415 as a double


% --- Executes during object creation, after setting all properties.
function ed1415_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed1415 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed142_Callback(hObject, eventdata, handles)
% hObject    handle to ed142 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed142 as text
%        str2double(get(hObject,'String')) returns contents of ed142 as a double


% --- Executes during object creation, after setting all properties.
function ed142_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed142 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed151_Callback(hObject, eventdata, handles)
% hObject    handle to ed151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed151 as text
%        str2double(get(hObject,'String')) returns contents of ed151 as a double


% --- Executes during object creation, after setting all properties.
function ed151_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed15end_Callback(hObject, eventdata, handles)
% hObject    handle to ed15end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed15end as text
%        str2double(get(hObject,'String')) returns contents of ed15end as a double


% --- Executes during object creation, after setting all properties.
function ed15end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed15end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbChooseColor11.
function pbChooseColor11_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col11, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor12.
function pbChooseColor12_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col12, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor13.
function pbChooseColor13_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col13, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor14.
function pbChooseColor14_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col14, 'BackgroundColor', c)
end;

% --- Executes on button press in pbChooseColor15.
function pbChooseColor15_Callback(hObject, eventdata, handles)
% hObject    handle to pbChooseColor15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
if c ~= 0
    set(handles.col15, 'BackgroundColor', c)
end;

% --- Executes during object creation, after setting all properties.
function ed1213_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed1213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_testhm.
function pb_testhm_Callback(hObject, eventdata, handles)
% hObject    handle to pb_testhm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
mainGUI = guidata(mainGUI_handle);


testeye =  mainGUI.data.eye;
testeye.heatmap.color.fixtype = handles.fixtype;


testeye.heatmap.color.stage0 =  str2double(get(handles.ed01, 'String'));
testeye.heatmap.color.stage1 = str2double(get(handles.ed12, 'String')) ;
testeye.heatmap.color.stage2 =  str2double(get(handles.ed23, 'String'));
testeye.heatmap.color.stage3 = str2double( get(handles.ed34, 'String'));
testeye.heatmap.color.stage4 = str2double( get(handles.ed45,'String'));
testeye.heatmap.color.stage5 = str2double(get(handles.ed56, 'String'));
testeye.heatmap.color.stage6 = str2double(get(handles.ed67, 'String')) ;
testeye.heatmap.color.stage7 = str2double( get(handles.ed78, 'String'));
testeye.heatmap.color.stage8 = str2double( get(handles.ed89, 'String')) ;
testeye.heatmap.color.stage9 = str2double(get(handles.ed910, 'String')) ;
testeye.heatmap.color.stage10 =  str2double(get(handles.ed1011, 'String'));
testeye.heatmap.color.stage11 = str2double(get(handles.ed1112, 'String'));
testeye.heatmap.color.stage12 = str2double( get(handles.ed1213, 'String'));
testeye.heatmap.color.stage13 = str2double( get(handles.ed1314, 'String'));
testeye.heatmap.color.stage14 = str2double( get(handles.ed1415, 'String'));
testeye.heatmap.color.stage15 = str2double(  get(handles.ed15end, 'String')); 


testeye.heatmap.color.color1 = get(handles.col1, 'BackgroundColor');
testeye.heatmap.color.color2 = get(handles.col2, 'BackgroundColor');
testeye.heatmap.color.color3 = get(handles.col3, 'BackgroundColor');
testeye.heatmap.color.color4 = get(handles.col4, 'BackgroundColor');
testeye.heatmap.color.color5 = get(handles.col5, 'BackgroundColor');
testeye.heatmap.color.color6 = get(handles.col6, 'BackgroundColor');
testeye.heatmap.color.color7 = get(handles.col7, 'BackgroundColor');
testeye.heatmap.color.color8 = get(handles.col8, 'BackgroundColor');
testeye.heatmap.color.color9 = get(handles.col9, 'BackgroundColor');
testeye.heatmap.color.color10 = get(handles.col10, 'BackgroundColor');
testeye.heatmap.color.color11 = get(handles.col11, 'BackgroundColor');
testeye.heatmap.color.color12 = get(handles.col12, 'BackgroundColor');
testeye.heatmap.color.color13 = get(handles.col13, 'BackgroundColor');
testeye.heatmap.color.color14 = get(handles.col14, 'BackgroundColor');
testeye.heatmap.color.color15 = get(handles.col15, 'BackgroundColor');

GA_heatmap(testeye);

% --- Executes on selection change in popsteps.
function popsteps_Callback(hObject, eventdata, handles)
% hObject    handle to popsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popsteps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popsteps
selected = get(hObject,'Value');
switch selected
    
    case 1
        
    case 2
        set(handles.ed01, 'String', '')
        set(handles.ed12, 'String', '')
        set(handles.ed23, 'String', '')
        set(handles.ed34, 'String', '')
        set(handles.ed45, 'String', '')
        set(handles.ed56, 'String', '')
        set(handles.ed67, 'String', '')
        set(handles.ed78, 'String', '')
        set(handles.ed89, 'String', '')
        set(handles.ed910, 'String', '')
        set(handles.ed1011, 'String', '')
        set(handles.ed1112, 'String', '')
        set(handles.ed1213, 'String', '')
        set(handles.ed1314, 'String', '')
        set(handles.ed1415, 'String', '')
        set(handles.ed15end, 'String', '')
        
        
    case 3
        mainGUI = guidata(handles.mainGUIhandle);
        
        if isfield(mainGUI, 'data')
            
            if ~isempty(mainGUI.data.eye.heatmap.color.stage0)
                set(handles.ed01, 'String', mainGUI.data.eye.heatmap.color.stage0)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage1)
                set(handles.ed12, 'String', mainGUI.data.eye.heatmap.color.stage1)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage2)
                set(handles.ed23, 'String', mainGUI.data.eye.heatmap.color.stage2)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage3)
                set(handles.ed34, 'String', mainGUI.data.eye.heatmap.color.stage3)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage4)
                set(handles.ed45, 'String', mainGUI.data.eye.heatmap.color.stage4)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage5)
                set(handles.ed56, 'String', mainGUI.data.eye.heatmap.color.stage5)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage6)
                set(handles.ed67, 'String', mainGUI.data.eye.heatmap.color.stage6)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage7)
                set(handles.ed78, 'String', mainGUI.data.eye.heatmap.color.stage7)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage8)
                set(handles.ed89, 'String', mainGUI.data.eye.heatmap.color.stage8)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage9)
                set(handles.ed910, 'String', mainGUI.data.eye.heatmap.color.stage9)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage10)
                set(handles.ed1011, 'String', mainGUI.data.eye.heatmap.color.stage10)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage11)
                set(handles.ed1112, 'String', mainGUI.data.eye.heatmap.color.stage11)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage12)
                set(handles.ed1213, 'String', mainGUI.data.eye.heatmap.color.stage12)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage13)
                set(handles.ed1314, 'String', mainGUI.data.eye.heatmap.color.stage13)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage14)
                set(handles.ed1415, 'String', mainGUI.data.eye.heatmap.color.stage14)
            end
            if ~isempty(mainGUI.data.eye.heatmap.color.stage15)
                set(handles.ed15end, 'String', mainGUI.data.eye.heatmap.color.stage15)
            end
        end
        
    case 4
        step = [1:15 999]'; 
        
    case 5
        step = [2 : 2 : 30 999]' ; 
        
    case 6
        step = [3 : 3 : 45 999]';
        
    case 7
        step = [10 : 10 : 150 9999]'; 
        
    case 8
        step = [6:20 999]'; 
        
    case 9
        step = [12 : 2 : 40 999]' ; 
        
    case 10
       step = [18 : 3 : 60 999]';
        
    case 11
        step = [20 : 20 : 300 9999]'; 
        
end

if exist('step','var')
    steps(step, handles)
end


% --- Executes during object creation, after setting all properties.
function popsteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormap(cmap, handles)

set(handles.col1, 'BackgroundColor', cmap(1,:))
set(handles.col2, 'BackgroundColor', cmap(2,:))
set(handles.col3, 'BackgroundColor', cmap(3,:))
set(handles.col4, 'BackgroundColor', cmap(4,:))
set(handles.col5, 'BackgroundColor', cmap(5,:))
set(handles.col6, 'BackgroundColor', cmap(6,:))
set(handles.col7, 'BackgroundColor', cmap(7,:))
set(handles.col8, 'BackgroundColor', cmap(8,:))
set(handles.col9, 'BackgroundColor', cmap(9,:))
set(handles.col10, 'BackgroundColor', cmap(10,:))
set(handles.col11, 'BackgroundColor', cmap(11,:))
set(handles.col12, 'BackgroundColor', cmap(12,:))
set(handles.col13, 'BackgroundColor', cmap(13,:))
set(handles.col14, 'BackgroundColor', cmap(14,:))
set(handles.col15, 'BackgroundColor', cmap(15,:))

function colormapinverse(cmap, handles)

set(handles.col1, 'BackgroundColor', cmap(15,:))
set(handles.col2, 'BackgroundColor', cmap(14,:))
set(handles.col3, 'BackgroundColor', cmap(13,:))
set(handles.col4, 'BackgroundColor', cmap(12,:))
set(handles.col5, 'BackgroundColor', cmap(11,:))
set(handles.col6, 'BackgroundColor', cmap(10,:))
set(handles.col7, 'BackgroundColor', cmap(9,:))
set(handles.col8, 'BackgroundColor', cmap(8,:))
set(handles.col9, 'BackgroundColor', cmap(7,:))
set(handles.col10, 'BackgroundColor', cmap(6,:))
set(handles.col11, 'BackgroundColor', cmap(5,:))
set(handles.col12, 'BackgroundColor', cmap(4,:))
set(handles.col13, 'BackgroundColor', cmap(3,:))
set(handles.col14, 'BackgroundColor', cmap(2,:))
set(handles.col15, 'BackgroundColor', cmap(1,:))


function steps(step, handles)
set(handles.ed01, 'String', step(1))
set(handles.ed12, 'String', step(2))
set(handles.ed23, 'String', step(3))
set(handles.ed34, 'String', step(4))
set(handles.ed45, 'String', step(5))
set(handles.ed56, 'String', step(6))
set(handles.ed67, 'String', step(7))
set(handles.ed78, 'String', step(8))
set(handles.ed89, 'String', step(9))
set(handles.ed910, 'String', step(10))
set(handles.ed1011, 'String', step(11))
set(handles.ed1112, 'String', step(12))
set(handles.ed1213, 'String', step(13))
set(handles.ed1314, 'String', step(14))
set(handles.ed1415, 'String', step(15))
set(handles.ed15end, 'String', step(16))

function choosecolor(handles)


if ~isfield(handles, 'selected')

        cmap = handles.usrcolor;

else
    
    switch handles.selected
        
        case 1
            cmap = handles.usrcolor;
            
        case 2
            cmap = handles.defcolor;
            
        case 3
            cmap = handles.usrcolor;
            
        case 4
            cmap = jet(15);
            
        case 5
            cmap = hsv(15);
            
        case 6
            cmap = hot(15);
            
        case 7
            cmap = cool(15);
            
        case 8
            cmap = spring(15);
            
        case 9
            cmap = summer(15);
            
        case 10
            cmap = autumn(15);
            
        case 11
            cmap = winter(15);
            
        case 12
            cmap = gray(15);
            
        case 13
            cmap = bone(15);
            
        case 14
            cmap = copper(15);
            
        case 15
            cmap = pink(15);
    end
    
end

if exist('cmap','var')
    
    if ~get(handles.cb_inverse, 'Value')
        colormap(cmap, handles)
    else
        colormapinverse(cmap, handles)
    end
    
end

function ed1213_Callback(hObject, eventdata, handles)
% hObject    handle to ed1213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed1213 as text
%        str2double(get(hObject,'String')) returns contents of ed1213 as a double


% --- Executes during object creation, after setting all properties.
function ui_time_fix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_time_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in ui_time_fix.
function ui_time_fix_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ui_time_fix 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.rbcount, 'Value')==1
    handles.fixtype = 'countfix';
else
    handles.fixtype = 'fixtime';
end

guidata(hObject, handles);


% --- Executes on button press in cb_inverse.
function cb_inverse_Callback(hObject, eventdata, handles)
% hObject    handle to cb_inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choosecolor(handles)
% Hint: get(hObject,'Value') returns toggle state of cb_inverse
