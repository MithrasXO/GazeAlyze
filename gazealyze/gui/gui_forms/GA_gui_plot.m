function varargout = GA_gui_plot(varargin)
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

% Last Modified by GUIDE v2.5 26-Nov-2012 19:17:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_plot_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_plot_OutputFcn, ...
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
function GA_gui_plot_OpeningFcn(hObject, eventdata, handles, varargin)
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

plot = mainGUIdata.data.eye.plot;
stim = mainGUIdata.data.eye.stim;


set(handles.cb_trial,'Value',plot.trl.path);
set(handles.cb_fix,'Value',plot.trl.fix);
set(handles.cb_fix_med,'Value',plot.fix.med);
set(handles.cb_fix_path,'Value',plot.fix.path);
set(handles.cb_entire_trial,'Value',plot.all);
set(handles.cb_corr,'Value',plot.corr);
set(handles.cb_white,'Value',plot.white);

if ~isempty(plot.xy)
    set(handles.ed_x,'String',num2str(plot.xy(1)));
    set(handles.ed_y,'String',num2str(plot.xy(2)));
end;
if ~isempty(plot.dur)
    set(handles.ed_dur,'String',plot.dur);
end;

if ~isempty(plot.ons)
    set(handles.ed_onset,'String',plot.ons);
end;

if plot.trl.path || plot.trl.fix


    set(handles.ed_dur,'Enable','On');
    set(handles.tx_dur,'Enable','On');
    set(handles.ed_onset,'Enable','On');
    set(handles.tx_fix_ons,'Enable','On');

end;

if plot.fix.path || plot.fix.med

    set(handles.ed_dur,'Enable','On');
    set(handles.tx_dur,'Enable','On');
    set(handles.ed_onset,'Enable','On');
    set(handles.tx_fix_ons,'Enable','On');
else
   
    if ~plot.trl.path && ~plot.trl.fix
        set(handles.ed_dur,'Enable','Off');
        set(handles.tx_dur,'Enable','Off');
        set(handles.ed_onset,'Enable','Off');
        set(handles.tx_fix_ons,'Enable','Off');
    end;
end;

if plot.all==1
    set(handles.ed_onset, 'Enable', 'off');
    set(handles.ed_dur, 'Enable', 'off');
    set(handles.tx_fix_ons, 'Enable', 'off');
    set(handles.tx_dur, 'Enable', 'off');
else
    set(handles.cb_entire_trial, 'Value', 1);
end

guidata(hObject, handles);
% UIWAIT makes gui_events wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_plot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function ed_trial_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_trial_dur (see GCBO)
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

plot = mainGUIdata.data.eye.plot;

lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Plot Settings updated <<<'}];

[plot.corr, lbstring ] =  GA_gui_get(lbstring, 'plot corrected data: ', plot.corr, handles.cb_corr, 'Value');
[plot.trl.path, lbstring ] =  GA_gui_get(lbstring, 'trial path: ', plot.trl.path, handles.cb_trial, 'Value');
[plot.trl.fix, lbstring ] =  GA_gui_get(lbstring, 'trial fixations: ', plot.trl.fix, handles.cb_fix, 'Value');
[plot.fix.med, lbstring ]  = GA_gui_get(lbstring, 'median fix period: ', plot.fix.med, handles.cb_fix_med, 'Value');
[plot.fix.path, lbstring ]  = GA_gui_get(lbstring, 'path fix period: ',plot.fix.path, handles.cb_fix_path, 'Value');
[plot.all, lbstring ]  = GA_gui_get(lbstring, 'use entire trial: ',plot.all, handles.cb_entire_trial, 'Value');
[plot.ons, lbstring ]  = GA_gui_get(lbstring, 'onset: ' ,plot.ons, handles.ed_onset, 'String');
[plot.dur, lbstring ]  = GA_gui_get(lbstring,  'duration: ',plot.dur, handles.ed_dur, 'String');
[plot.xy(1), lbstring ]  = GA_gui_get(lbstring, 'origin of fix cross: ',plot.xy(1),  handles.ed_x, 'String');
[plot.xy(2), lbstring ]  = GA_gui_get(lbstring, 'origin of fix cross: ',plot.xy(2),  handles.ed_y, 'String');
[plot.white, lbstring ]  = GA_gui_get(lbstring, 'plot on white screen: ',plot.white, handles.cb_white, 'Value');

mainGUIdata.data.eye.plot = plot;
rows_lb = size(lbstring,1);
if ~strcmp(lbstring{end},'>>> Plot Settings updated <<<')
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



function ed_trial_dur_Callback(hObject, eventdata, handles)
% hObject    handle to ed_trial_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_trial_dur as text
%        str2double(get(hObject,'String')) returns contents of ed_trial_dur as a double



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



function ed_dur_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dur as text
%        str2double(get(hObject,'String')) returns contents of ed_dur as a double


% --- Executes during object creation, after setting all properties.
function ed_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_onset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_onset as text
%        str2double(get(hObject,'String')) returns contents of ed_onset as a double


% --- Executes during object creation, after setting all properties.
function ed_onset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in grp_select.
function grp_select_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in grp_select
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in cb_entire_trial.
function cb_entire_trial_Callback(hObject, eventdata, handles)
% hObject    handle to cb_entire_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.ed_onset, 'Enable', 'off');
    set(handles.ed_dur, 'Enable', 'off');
    set(handles.tx_fix_ons, 'Enable', 'off');
    set(handles.tx_dur, 'Enable', 'off');
else
    set(handles.ed_onset, 'Enable', 'on');
    set(handles.ed_dur, 'Enable', 'on');
    set(handles.tx_fix_ons, 'Enable', 'on');
    set(handles.tx_dur, 'Enable', 'on');
end
% Hint: get(hObject,'Value') returns toggle state of cb_entire_trial


% --- Executes on button press in cb_sep_fix_mark.
function cb_sep_fix_mark_Callback(hObject, eventdata, handles)
% hObject    handle to cb_sep_fix_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_sep_fix_mark

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


% --- Executes during object creation, after setting all properties.
function ed_sequence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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


% --- Executes on button press in cb_corr.
function cb_corr_Callback(hObject, eventdata, handles)
% hObject    handle to cb_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_corr


% --- Executes on button press in cb_blocked.
function cb_blocked_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blocked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_blocked


% --- Executes on button press in cb_fix_path.
function cb_fix_path_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_path


% --- Executes on button press in cb_fix_med.
function cb_fix_med_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_med (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_med


% --- Executes on button press in cb_trial.
function cb_trial_Callback(hObject, eventdata, handles)
% hObject    handle to cb_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_trial


% --- Executes on button press in cb_fix.
function cb_fix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix


% --- Executes on button press in cb_fix_path.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_path


% --- Executes on button press in cb_fix_med.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_med (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_med


% --- Executes on button press in cb_corr.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to cb_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_corr


% --- Executes on button press in cb_fix_fix.
function cb_fix_fix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_fix


% --- Executes on button press in cb_white.
function cb_white_Callback(hObject, eventdata, handles)
% hObject    handle to cb_white (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_white
