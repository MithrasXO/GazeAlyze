function varargout = GA_gui_jobs(varargin)
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

% Last Modified by GUIDE v2.5 31-May-2010 10:39:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_jobs_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_jobs_OutputFcn, ...
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
function GA_gui_jobs_OpeningFcn(hObject, eventdata, handles, varargin)
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

if  mainGUIdata.data.eye.jobs.convert
    set(handles.cb_import, 'Value', 1);
end;

if  mainGUIdata.data.eye.jobs.blinks    
    set(handles.cb_blinks, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.filter    
    set(handles.cb_smooth, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.fixations    
    set(handles.cb_fix, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.saccades    
    set(handles.cb_saccades, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.consistency    
    set(handles.cb_consistency, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.plot    
    set(handles.cb_plot, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.analysis    
    set(handles.cb_analysis, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.heatmaps
    set(handles.cb_heatmaps, 'Value', 1);    
end;

if  mainGUIdata.data.eye.jobs.email
    set(handles.cb_email, 'Value', 1);
    set(handles.ed_email, 'Enable', 'on');
    set(handles.ed_email, 'String', mainGUIdata.data.eye.email_adress);
else
    set(handles.ed_email, 'String', mainGUIdata.data.eye.email_adress);  
end;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchjobs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_jobs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in cb_blinks.
function cb_blinks_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blinks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_blinks


% --- Executes on button press in cb_smooth.
function cb_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to cb_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_smooth

% --- Executes on button press in cb_fix.
function cb_fix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix


% --- Executes on button press in cb_saccades.
function cb_saccades_Callback(hObject, eventdata, handles)
% hObject    handle to cb_saccades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_saccades


% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



mainGUIdata = guidata(handles.mainGUIhandle);


lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Batch Tasks set <<<'}];

[mainGUIdata.data.eye.jobs.convert, lbstring ] =  GA_gui_get(lbstring, 'task convert: ', mainGUIdata.data.eye.jobs.convert, handles.cb_import, 'Value');
[mainGUIdata.data.eye.jobs.blinks, lbstring ] =  GA_gui_get(lbstring, 'task filter blinks: ', mainGUIdata.data.eye.jobs.blinks, handles.cb_blinks, 'Value');
[mainGUIdata.data.eye.jobs.filter, lbstring ]  = GA_gui_get(lbstring, 'task filter/smooth: ', mainGUIdata.data.eye.jobs.filter, handles.cb_smooth, 'Value');
[mainGUIdata.data.eye.jobs.fixations, lbstring ]  = GA_gui_get(lbstring, 'task fixations: ',mainGUIdata.data.eye.jobs.fixations, handles.cb_fix, 'Value');
[mainGUIdata.data.eye.jobs.saccades, lbstring ]  = GA_gui_get(lbstring, 'task saccades: ',mainGUIdata.data.eye.jobs.saccades, handles.cb_saccades, 'Value');
[mainGUIdata.data.eye.jobs.consistency, lbstring ]  = GA_gui_get(lbstring, 'task proof consitency: ' ,mainGUIdata.data.eye.jobs.consistency, handles.cb_consistency, 'Value');
[mainGUIdata.data.eye.jobs.plot, lbstring ]  = GA_gui_get(lbstring,  'task plot data: ',mainGUIdata.data.eye.jobs.plot, handles.cb_plot, 'Value');
[mainGUIdata.data.eye.jobs.analysis, lbstring ]  = GA_gui_get(lbstring, 'task analyse data: ', mainGUIdata.data.eye.jobs.analysis, handles.cb_analysis, 'Value');
[mainGUIdata.data.eye.jobs.heatmaps, lbstring ]  = GA_gui_get(lbstring, 'task create heatmaps: ',mainGUIdata.data.eye.jobs.heatmaps,  handles.cb_heatmaps, 'Value');
[mainGUIdata.data.eye.jobs.correction, lbstring ]  = GA_gui_get(lbstring, 'task correct data: ',mainGUIdata.data.eye.jobs.correction,  handles.cb_correction, 'Value');

[mainGUIdata.data.eye.jobs.email, lbstring ]  = GA_gui_get(lbstring, 'send email: ',mainGUIdata.data.eye.jobs.email,  handles.cb_email, 'Value');
[mainGUIdata.data.eye.email_adress, lbstring ]  = GA_gui_get(lbstring, 'email: ',mainGUIdata.data.eye.email_adress,  handles.ed_email, 'String');

if isfield(handles, 'smtp')
    if ~strcmp(handles.smtp, mainGUIdata.data.eye.email_smtp)
        mainGUIdata.data.eye.email_smtp = handles.smtp;
        lbstring = [lbstring; ['email SMTP: ' handles.smtp]];
    end
end

if ~strcmp(lbstring{end},'>>> Batch Tasks set <<<')
     set(mainGUIdata.listbox_progress, 'String', lbstring);
     set(mainGUIdata.listbox_progress, 'Max', length(lbstring));
     set(mainGUIdata.listbox_progress, 'Value', length(lbstring));
     set(mainGUIdata.uipt_save, 'Enable', 'on');
 end;
 
%Generate Data for Listbox Parameter Overview
GA_gui_set(mainGUIdata, 1)

close;


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in cb_import.
function cb_import_Callback(hObject, eventdata, handles)
% hObject    handle to cb_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_import


% --- Executes on button press in cb_analysis.
function cb_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to cb_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_analysis


% --- Executes on button press in cb_consistency.
function cb_consistency_Callback(hObject, eventdata, handles)
% hObject    handle to cb_consistency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_consistency


% --- Executes on button press in cb_plot.
function cb_plot_Callback(hObject, eventdata, handles)
% hObject    handle to cb_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_plot


% --- Executes on button press in cb_correction.
function cb_correction_Callback(hObject, eventdata, handles)
% hObject    handle to cb_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_correction


% --- Executes on button press in cb_heatmaps.
function cb_heatmaps_Callback(hObject, eventdata, handles)
% hObject    handle to cb_heatmaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_heatmaps


% --- Executes on button press in cb_email.
function cb_email_Callback(hObject, eventdata, handles)
% hObject    handle to cb_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_email
if get(hObject,'Value')
    set(handles.ed_email, 'Enable', 'on');
    
else
        set(handles.ed_email, 'Enable', 'off');
end

function ed_email_Callback(hObject, eventdata, handles)
% hObject    handle to ed_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_email as text
%        str2double(get(hObject,'String')) returns contents of ed_email as a double


% --- Executes during object creation, after setting all properties.
function ed_email_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_SMTP.
function pb_SMTP_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SMTP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
mainGUI = guidata(mainGUI_handle);


prompt = {'Enter SMTP Server:'};
dlg_title = 'SMTP Server';
num_lines = 1;
if isfield(handles, 'smtp')
    def = {handles.smtp};
else
    if isempty(mainGUI.data.eye.email_smtp)
        def = {''};
    else
        def = {mainGUI.data.eye.email_smtp};
    end
end
handles.smtp  = cell2mat(inputdlg(prompt,dlg_title,num_lines, def));

guidata(hObject, handles);
