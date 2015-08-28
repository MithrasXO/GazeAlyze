function varargout = GA_gui_events_ILAB(varargin)
% GUI_EVENTS M-file for gui_events.fig
%      GUI_EVENTS, by itself, creates a new GUI_EVENTS or raises the existing
%      singleton*.
%
%      H = GUI_EVENTS returns the handle to a new GUI_EVENTS or the handle to
%      the existing singleton*.
%
%      GUI_EVENTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EVENTS.M with the given input arguments.
%
%      GUI_EVENTS('Property','Value',...) creates a new GUI_EVENTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_events_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_events_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_events

% Last Modified by GUIDE v2.5 05-May-2010 14:31:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_events_OpeningFcn, ...
    'gui_OutputFcn',  @gui_events_OutputFcn, ...
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


% --- Executes just before gui_events is made visible.
function gui_events_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_events (see VARARGIN)

% Choose default command line output for gui_events
handles.output = hObject;

% Update handles structure

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);

if ~isempty(mainGUIdata.data.eye.cond.ILAB.fixcodes)
    set(handles.ed_fix_codes,'String',mainGUIdata.data.eye.cond.ILAB.fixcodes);
end

guidata(hObject, handles);
% UIWAIT makes gui_events wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_events_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function ed_trial_codes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_trial_codes (see GCBO)
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
mainGUIdata.data.eye.cond.count = length(mainGUIdata.data.eye.cond.start.values);
lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Events updated <<<'}];
[mainGUIdata.data.eye.cond.ILAB.fixcodes, lbstring ] =  GA_gui_get(lbstring, 'fix codes: ', mainGUIdata.data.eye.cond.ILAB.fixcodes, handles.ed_fix_codes, 'String');

if ~strcmp(lbstring{end},'>>> Events updated <<<')
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

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes during object creation, after setting all properties.
function chk_blocked_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chk_blocked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ed_trial_codes_Callback(hObject, eventdata, handles)
% hObject    handle to ed_trial_codes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_trial_codes as text
%        str2double(get(hObject,'String')) returns contents of ed_trial_codes as a double



function ed_fix_string_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fix_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fix_string as text
%        str2double(get(hObject,'String')) returns contents of ed_fix_string as a double


% --- Executes during object creation, after setting all properties.
function ed_fix_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fix_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_fix_ons_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fix_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fix_ons as text
%        str2double(get(hObject,'String')) returns contents of ed_fix_ons as a double


% --- Executes during object creation, after setting all properties.
function ed_fix_ons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fix_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_fix_dur_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fix_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fix_dur as text
%        str2double(get(hObject,'String')) returns contents of ed_fix_dur as a double


% --- Executes during object creation, after setting all properties.
function ed_fix_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fix_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_fix_codes_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fix_codes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fix_codes as text
%        str2double(get(hObject,'String')) returns contents of ed_fix_codes as a double


% --- Executes during object creation, after setting all properties.
function ed_fix_codes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fix_codes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
