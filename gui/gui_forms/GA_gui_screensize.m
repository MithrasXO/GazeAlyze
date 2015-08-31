function varargout = GA_gui_screensize(varargin)
% SCREENSIZE M-file for screensize.fig
%      SCREENSIZE, by itself, creates a new SCREENSIZE or raises the existing
%      singleton*.
%
%      H = SCREENSIZE returns the handle to a new SCREENSIZE or the handle to
%      the existing singleton*.
%
%      SCREENSIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCREENSIZE.M with the given input arguments.
%
%      SCREENSIZE('Property','Value',...) creates a new SCREENSIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before screensize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to screensize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help screensize

% Last Modified by GUIDE v2.5 17-Apr-2010 13:37:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @screensize_OpeningFcn, ...
    'gui_OutputFcn',  @screensize_OutputFcn, ...
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


% --- Executes just before screensize is made visible.
function screensize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to screensize (see VARARGIN)

handles.output = hObject;

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);


if  ~isempty(mainGUIdata.data.eye.defaultscreen)
    
    set(handles.editSSX, 'String', mainGUIdata.data.eye.defaultscreen(1,2));
    set(handles.editSSY, 'String', mainGUIdata.data.eye.defaultscreen(1,4));
    
    
    
    if  ( mainGUIdata.data.eye.defaultscreen(1,2) ~= mainGUIdata.data.eye.blink.limits(1,2) || mainGUIdata.data.eye.defaultscreen(1,4) ~= mainGUIdata.data.eye.blink.limits(1,4) )
        
        set(handles.cb_diff, 'Value', 1);
        set(handles.editBLX, 'Enable', 'on');
        set(handles.editBLY, 'Enable', 'on');
        set(handles.editBLX, 'String', mainGUIdata.data.eye.blink.limits(1,2));
        set(handles.editBLY, 'String', mainGUIdata.data.eye.blink.limits(1,4));
        
    end;
end;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes screensize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = screensize_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editSSX_Callback(hObject, eventdata, handles)
% hObject    handle to editSSX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSSX as text
%        str2double(get(hObject,'String')) returns contents of editSSX as a double


% --- Executes during object creation, after setting all properties.
function editSSX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSSX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSSY_Callback(hObject, eventdata, handles)
% hObject    handle to editSSY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSSY as text
%        str2double(get(hObject,'String')) returns contents of editSSY as a double


% --- Executes during object creation, after setting all properties.
function editSSY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSSY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUIdata = guidata(handles.mainGUIhandle);

if  get(handles.cb_diff, 'Value')==0
    set(handles.editBLX, 'String',(get(handles.editSSX, 'String')));
    set(handles.editBLY, 'String',(get(handles.editSSY, 'String')));
end


lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> ScreenSettings updatet <<<'}];

if isempty(mainGUIdata.data.eye.defaultscreen)
mainGUIdata.data.eye.defaultscreen = [0 0 0 0];
end

if isempty(mainGUIdata.data.eye.blink.limits)
mainGUIdata.data.eye.blink.limits = [0 0 0 0];
end

[mainGUIdata.data.eye.defaultscreen(2), lbstring ] =  GA_gui_get(lbstring, 'screensize x: ', mainGUIdata.data.eye.defaultscreen(2), handles.editSSX, 'String');
[mainGUIdata.data.eye.defaultscreen(4), lbstring ] =  GA_gui_get(lbstring, 'screensize y: ', mainGUIdata.data.eye.defaultscreen(4), handles.editSSY, 'String');

[mainGUIdata.data.eye.blink.limits(2), lbstring ] =  GA_gui_get(lbstring, 'blinklimit x: ', mainGUIdata.data.eye.blink.limits(2), handles.editBLX, 'String');
[mainGUIdata.data.eye.blink.limits(4), lbstring ] =  GA_gui_get(lbstring, 'blinklimit y: ', mainGUIdata.data.eye.blink.limits(4), handles.editBLY, 'String');

if ~strcmp(lbstring{end},'>>> ScreenSettings updatet <<<')
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


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;



function editBLX_Callback(hObject, eventdata, handles)
% hObject    handle to editBLX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBLX as text
%        str2double(get(hObject,'String')) returns contents of editBLX as a double


% --- Executes during object creation, after setting all properties.
function editBLX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBLX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBLY_Callback(hObject, eventdata, handles)
% hObject    handle to editBLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBLY as text
%        str2double(get(hObject,'String')) returns contents of editBLY as a double


% --- Executes during object creation, after setting all properties.
function editBLY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_diff.
function cb_diff_Callback(hObject, eventdata, handles)
% hObject    handle to cb_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_diff
if  get(handles.cb_diff, 'Value')==1
    
    set(handles.editBLX, 'Enable', 'on');
    set(handles.editBLY, 'Enable', 'on');
end

if  get(handles.cb_diff, 'Value')==0
    
    set(handles.editBLX, 'Enable', 'off');
    set(handles.editBLY, 'Enable', 'off');
    
    set(handles.editBLX, 'String', '');
    set(handles.editBLY, 'String', '');
    
end


guidata(hObject, handles);

% --- Executes on key press with focus on editSSX and none of its controls.
function editSSX_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editSSX (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on key press with focus on editSSY and none of its controls.
function editSSY_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editSSY (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
