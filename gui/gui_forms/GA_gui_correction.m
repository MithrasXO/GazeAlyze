function varargout = GA_gui_correction(varargin)
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

% Last Modified by GUIDE v2.5 26-Jan-2011 17:31:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_correction_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_correction_OutputFcn, ...
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
function GA_gui_correction_OpeningFcn(hObject, eventdata, handles, varargin)
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


method=[0 0 0 0 0];
switch mainGUIdata.data.eye.corr.method
    case 'longfix'
        method(1)=1;
    case 'meanfix'
        method(2)=1;
    case 'firstfix'
        method(3)=1;
    case 'lastfix'
        method(4)=1;
    case 'medpath'
        method(5)=1;
end;
set(handles.rad_fix,'Value',method(1));
set(handles.rb_mean_fix,'Value',method(2));
set(handles.rb_first_fix,'Value',method(3));
set(handles.rb_last_fix,'Value',method(4));
set(handles.rad_med,'Value',method(5));

if mainGUIdata.data.eye.corr.fix.sepmark == 1;
set(handles.rb_seperate,'Value',1);
end
if mainGUIdata.data.eye.corr.fix.sepmark == 0;
set(handles.rb_trial,'Value',1);
end


set(handles.cb_blocked,'Value',mainGUIdata.data.eye.corr.blocked);
set(handles.cb_last_sac,'Value',mainGUIdata.data.eye.corr.lastsac);

if ~isempty(mainGUIdata.data.eye.corr.dur)
    set(handles.ed_fix_dur,'String',mainGUIdata.data.eye.corr.dur);
else
    set(handles.ed_fix_dur,'String',mainGUIdata.data.eye.cond.fix.duration);
end

if ~isempty(mainGUIdata.data.eye.corr.ons)
    set(handles.ed_fix_onset,'String',mainGUIdata.data.eye.corr.ons);
else
    set(handles.ed_fix_onset,'String',mainGUIdata.data.eye.cond.fix.offset);
end

if ~isempty(mainGUIdata.data.eye.corr.fix.xy)
    set(handles.ed_x,'String',num2str(mainGUIdata.data.eye.corr.fix.xy(1,1)));
end;

if ~isempty(mainGUIdata.data.eye.corr.fix.xy)
    set(handles.ed_y,'String',num2str(mainGUIdata.data.eye.corr.fix.xy(1,2)));
end;

guidata(hObject, handles);
% UIWAIT makes gui_events wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_correction_OutputFcn(hObject, eventdata, handles)
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
mainGUIdata = guidata(handles.mainGUIhandle);
method=[0 0 0 0 0];
method=[0 0 0 0 0];
switch mainGUIdata.data.eye.corr.method
    case 'longfix'
        method(1)=1;
    case 'meanfix'
        method(2)=1;
    case 'firstfix'
        method(3)=1;
    case 'lastfix'
        method(4)=1;
    case 'medpath'
        method(5)=1;
end;

lbstring = get(mainGUIdata.listbox_progress, 'String');

lbstring = [lbstring; {'>>> Correction Settings updated <<<'}];
[mainGUIdata.data.eye.corr.fix.sepmark, lbstring ] =  GA_gui_get(lbstring, 'fix inside trial: ', mainGUIdata.data.eye.corr.fix.sepmark, handles.rb_seperate, 'Value');


[mainGUIdata.data.eye.corr.ons, lbstring ] =  GA_gui_get(lbstring, 'corr onset: ', mainGUIdata.data.eye.corr.ons, handles.ed_fix_onset, 'String');
[mainGUIdata.data.eye.corr.dur, lbstring ]  = GA_gui_get(lbstring, 'corr duration: ', mainGUIdata.data.eye.corr.dur, handles.ed_fix_dur, 'String');


[mainGUIdata.data.eye.corr.blocked, lbstring ]  = GA_gui_get(lbstring, 'same corr to blocked trials: ',mainGUIdata.data.eye.corr.blocked, handles.cb_blocked, 'Value');
[mainGUIdata.data.eye.corr.fix.xy(1), lbstring ]  = GA_gui_get(lbstring, 'fix cross pos x: ',mainGUIdata.data.eye.corr.fix.xy(1), handles.ed_x, 'String');
[mainGUIdata.data.eye.corr.fix.xy(2), lbstring ]  = GA_gui_get(lbstring, 'fix cross pos y: ' ,mainGUIdata.data.eye.corr.fix.xy(2), handles.ed_y, 'String');
[method(1), lbstring ]  = GA_gui_get(lbstring, 'use longest fixation: ' ,method(1), handles.rad_fix, 'Value');
[method(2), lbstring ]  = GA_gui_get(lbstring, 'use mean fixation: ' ,method(2), handles.rb_mean_fix, 'Value');
[method(3), lbstring ]  = GA_gui_get(lbstring, 'use first fixation: ' ,method(3), handles.rb_first_fix, 'Value');
[method(4), lbstring ]  = GA_gui_get(lbstring, 'use last fixation: ' ,method(4), handles.rb_last_fix, 'Value');
[method(5), lbstring ]  = GA_gui_get(lbstring, 'use median of scanpath: ' ,method(5), handles.rad_med, 'Value');
[mainGUIdata.data.eye.corr.lastsac, lbstring ]  = GA_gui_get(lbstring, 'mark trial as bad if saccade is last event: ',mainGUIdata.data.eye.corr.lastsac, handles.cb_last_sac, 'Value');

if method(1)==1
    mainGUIdata.data.eye.corr.method = 'longfix';    
elseif method(2)==1
    mainGUIdata.data.eye.corr.method =  'meanfix';
elseif method(3)==1
    mainGUIdata.data.eye.corr.method = 'firstfix';
elseif method(4)==1
    mainGUIdata.data.eye.corr.method =  'lastfix';
elseif method(5)==1
    mainGUIdata.data.eye.corr.method =  'medpath';    
end;

if ~strcmp(lbstring{end},'>>> Correction Settings updated <<<')
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



function ed_fix_onset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fix_onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fix_onset as text
%        str2double(get(hObject,'String')) returns contents of ed_fix_onset as a double


% --- Executes during object creation, after setting all properties.
function ed_fix_onset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fix_onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in cb_fix.
function cb_fix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix
if get(handles.cb_fix,'Value');
    set(handles.cb_blocked,'Enable','On');
else
    set(handles.cb_blocked,'Enable','Off');
end;

% --- Executes on button press in cb_blocked.
function cb_blocked_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blocked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_blocked



function ed_y_Callback(hObject, eventdata, handles)
% hObject    handle to ed_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_y as text
%        str2double(get(hObject,'String')) returns contents of ed_y as a double


% --- Executes during object creation, after setting all properties.
function ed_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_x_Callback(hObject, eventdata, handles)
% hObject    handle to ed_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_x as text
%        str2double(get(hObject,'String')) returns contents of ed_x as a double


% --- Executes during object creation, after setting all properties.
function ed_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in cb_last_sac.
function cb_last_sac_Callback(hObject, eventdata, handles)
% hObject    handle to cb_last_sac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_last_sac


% --- Executes when selected object is changed in uipanel10.
function uipanel10_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel10
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
mainGUIdata = guidata(handles.mainGUIhandle);

if strcmp(get(handles.ed_fix_dur, 'String'), '0')
    if mainGUIdata.data.eye.corr.dur == 0
        if get(handles.rb_seperate, 'Value') == 1
            
            
            
            set(handles.ed_fix_dur,'String',mainGUIdata.data.eye.cond.fix.duration);
            
            set(handles.ed_fix_onset,'String',mainGUIdata.data.eye.cond.fix.offset);
            
        end
    end
end


% --- Executes during object creation, after setting all properties.
function uipanel10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
