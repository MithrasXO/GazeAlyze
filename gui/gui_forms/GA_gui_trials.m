function varargout = GA_gui_trials(varargin)
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

% Last Modified by GUIDE v2.5 03-Nov-2010 17:45:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_files_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_files_OutputFcn, ...
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
function GA_gui_files_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batchjobs (see VARARGIN)

% Choose default command line output for editprocedures
handles.output = hObject;


h = findobj('type','figure','tag','GA_mainWin');
parentGUIdata = guidata(h);


if strcmp(parentGUIdata.data.eye.include.trials, 'all');
    parentGUIdata.data.eye.include.trials = '';
end

set(handles.edit_trial, 'String', parentGUIdata.data.eye.include.trials);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchjobs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_files_OutputFcn(hObject, eventdata, handles)
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

h = findobj('type','figure','tag','GA_mainWin');
parentGUIdata = guidata(h);

lbstring = get(parentGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Trials updated <<<'}];

if isempty(get(handles.edit_trial, 'String'))
    if ~strcmpi(parentGUIdata.data.eye.include.trials,'all')
        parentGUIdata.data.eye.include.trials = 'all';
        lbstring = [lbstring; 'trials = all'];
    end;
elseif ~strcmpi(parentGUIdata.data.eye.include.trials,get(handles.edit_trial, 'String'))
    parentGUIdata.data.eye.include.trials = get(handles.edit_trial, 'String');
    lbstring = [lbstring; ['trials = ' parentGUIdata.data.eye.include.trials]];
end

%*************


%[parentGUIdata.data.eye.include.trials, lbstring ] =  GA_gui_get(lbstring, 'trial numbers: ', parentGUIdata.data.eye.include.trials, handles.edit_trial, 'String');

if ~strcmp(lbstring{end},'>>> Trials updatet <<<')
    set(parentGUIdata.listbox_progress, 'String', lbstring);
    set(parentGUIdata.listbox_progress, 'Max', length(lbstring));
    set(parentGUIdata.listbox_progress, 'Value', length(lbstring));
    set(parentGUIdata.uipt_save, 'Enable', 'on');
end;


GA_gui_set(parentGUIdata, 1)



close;

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;





function edit_trial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial as text
%        str2double(get(hObject,'String')) returns contents of edit_trial as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_event.
function rb_event_Callback(hObject, eventdata, handles)
% hObject    handle to rb_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_event


% --- Executes on button press in rb_order.
function rb_order_Callback(hObject, eventdata, handles)
% hObject    handle to rb_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_order
