function varargout = GA_gui_ilabset(varargin)
% GA_GUI_ILABSET M-file for GA_gui_ilabset.fig
%      GA_GUI_ILABSET, by itself, creates a new GA_GUI_ILABSET or raises the existing
%      singleton*.
%
%      H = GA_GUI_ILABSET returns the handle to a new GA_GUI_ILABSET or the handle to
%      the existing singleton*.
%
%      GA_GUI_ILABSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI_ILABSET.M with the given input arguments.
%
%      GA_GUI_ILABSET('Property','Value',...) creates a new GA_GUI_ILABSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_gui_ilabset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_ilabset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_ilabset

% Last Modified by GUIDE v2.5 30-Sep-2011 17:44:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GA_gui_ilabset_OpeningFcn, ...
                   'gui_OutputFcn',  @GA_gui_ilabset_OutputFcn, ...
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


% --- Executes just before GA_gui_ilabset is made visible.
function GA_gui_ilabset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_ilabset (see VARARGIN)

handles.output = hObject;

mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
handles.mainGUIhandle = mainGUI_handle;
mainGUI = guidata(mainGUI_handle);

if  mainGUI.data.eye.jobs.blinks    
    set(handles.cb_blinks, 'Value', 1);    
end;

if  mainGUI.data.eye.jobs.filter    
    set(handles.cb_smooth, 'Value', 1);    
end;

if  mainGUI.data.eye.jobs.fixations    
    set(handles.cb_fix, 'Value', 1);    
end;

if  mainGUI.data.eye.jobs.saccades    
    set(handles.cb_saccades, 'Value', 1);    
end;

if ~isempty(mainGUI.data.eye.jobs.ILAB)
    set(handles.ed_advanced_ILAB, 'String', mainGUI.data.eye.jobs.ILAB);
end;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GA_gui_ilabset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_ilabset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
lbstring = [lbstring; {'>>> ILAB-process Settings updatet <<<'}];

[mainGUI.data.eye.jobs.blinks, lbstring ] =  GA_gui_get(lbstring, 'task filter blinks: ', mainGUI.data.eye.jobs.blinks, handles.cb_blinks, 'Value');
[mainGUI.data.eye.jobs.filter, lbstring ]  = GA_gui_get(lbstring, 'task filter/smooth: ', mainGUI.data.eye.jobs.filter, handles.cb_smooth, 'Value');
[mainGUI.data.eye.jobs.fixations, lbstring ]  = GA_gui_get(lbstring, 'task fixations: ',mainGUI.data.eye.jobs.fixations, handles.cb_fix, 'Value');
[mainGUI.data.eye.jobs.saccades, lbstring ]  = GA_gui_get(lbstring, 'task saccades: ',mainGUI.data.eye.jobs.saccades, handles.cb_saccades, 'Value');
[mainGUI.data.eye.jobs.ILAB, lbstring ] =  GA_gui_get(lbstring, 'file for advanced ILAB settings: ', mainGUI.data.eye.jobs.ILAB, handles.ed_advanced_ILAB, 'String');

if ~strcmp(lbstring{end},'>>> ILAB-process Settings updatet <<<')
     set(mainGUI.listbox_progress, 'String', lbstring);
     set(mainGUI.listbox_progress, 'Max', length(lbstring));
     set(mainGUI.listbox_progress, 'Value', length(lbstring));
     set(mainGUI.uipt_save, 'Enable', 'on');
 end;
 
%Generate Data for Listbox Parameter Overview
GA_gui_set(mainGUI, 1)

close;

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



function ed_advanced_ILAB_Callback(hObject, eventdata, handles)
% hObject    handle to ed_advanced_ILAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_advanced_ILAB as text
%        str2double(get(hObject,'String')) returns contents of ed_advanced_ILAB as a double


% --- Executes during object creation, after setting all properties.
function ed_advanced_ILAB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_advanced_ILAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_advanced.
function pb_advanced_Callback(hObject, eventdata, handles)
% hObject    handle to pb_advanced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = mfilename('fullpath'); 
[pathstr, name, ext] = fileparts(p);
pathstr = strrep(pathstr,'gui_forms','GA_ILAB');
pathstr = strrep(pathstr,'gui','main');
[filename, pathname] = uigetfile('*.m','Select ILAB settings file', fullfile(pathstr,'GA_ilabAnalysisParms.m'));
if ~isequal(filename,0)      
    set(handles.ed_advanced_ILAB, 'String', fullfile(pathname,filename));
end


% --- Executes on button press in pb_edit.
function pb_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strFile = get(handles.ed_advanced_ILAB, 'String');
if strcmp(strFile, 'default file')     
    strFile = 'GA_ilabAnalysisParms.m';    
end;

if (2 == exist (strFile,'file'))
    
    open(strFile);
    
else
    
    [FileName,PathName] = uigetfile('*.m','Select the M-file');
    
    if FileName~=0
        
        open([PathName FileName]);
    end;
    
end;
