function varargout = GA_gui_editdir(varargin)

% GA_GUI_EDITDIR M-file for GA_gui_editdir.fig
%      GA_GUI_EDITDIR, by itself, creates a new GA_GUI_EDITDIR or raises the existing
%      singleton*.
%
%      H = GA_GUI_EDITDIR returns the handle to a new GA_GUI_EDITDIR or the handle to
%      the existing singleton*.
%
%      GA_GUI_EDITDIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI_EDITDIR.M with the given input arguments.
%
%      GA_GUI_EDITDIR('Property','Value',...) creates a new GA_GUI_EDITDIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_gui_editdir_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_editdir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_editdir

% Last Modified by GUIDE v2.5 22-Dec-2010 13:01:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_editdir_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_editdir_OutputFcn, ...
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


% --- Executes just before GA_gui_editdir is made visible.
function GA_gui_editdir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_editdir (see VARARGIN)

% Choose default command line output for GA_gui_editdir
handles.output = hObject;
mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);

% Stack order for taborder
uistack(handles.pb_dir_cancel, 'bottom')
uistack(handles.pb_dir_ok, 'bottom')


if strcmp( mainGUIdata.data.eye.include.files, 'all')
    handles.vp='';
else
    handles.vp = mainGUIdata.data.eye.include.files;
end

if ~isempty(mainGUIdata.data.eye.dir.raw)
    set(handles.ed_dir_raw, 'String', mainGUIdata.data.eye.dir.raw);
end;

if ~isempty(mainGUIdata.data.eye.dir.conv)
    set(handles.ed_dir_mat, 'String', mainGUIdata.data.eye.dir.conv);
end;

if ~isempty(mainGUIdata.data.eye.dir.stim)
    set(handles.ed_stimuli, 'String', mainGUIdata.data.eye.dir.stim);
end;

if ~isempty(mainGUIdata.data.eye.dir.stimseq)
    set(handles.ed_stim_seq, 'String', mainGUIdata.data.eye.dir.stimseq);
end;

if ~isempty(mainGUIdata.data.eye.dir.results)
    set(handles.ed_out_results, 'String', mainGUIdata.data.eye.dir.results);
end;

stim = mainGUIdata.data.eye.stim;
set(handles.tx_seq,'String', ['"picname:' strrep(stim.pic,'"','') ', seq-file descritption column:' num2str(stim.col) ', first row:' num2str(stim.row) '"']);

if ~isempty(mainGUIdata.data.eye.dir.fileid)    
    strind = strfind(mainGUIdata.data.eye.dir.fileid, '.');
    strind = max(strind);
    set(handles.ed_filename, 'String',mainGUIdata.data.eye.dir.fileid(1:strind-1));
    set(handles.ed_fileextention, 'String',mainGUIdata.data.eye.dir.fileid(strind+1:end));
end

set(handles.ed_resfilename, 'String',mainGUIdata.data.eye.dir.fileid);

% Update handles structure
guidata(hObject, handles);
% fig_size = get( handles.pb_stim, 'Position');
% fig_size_gcf = get( gcf, 'Position');
% 
% fig_size_gcf(3) = max(fig_size(1) + fig_size(3),fig_size_gcf(1) + fig_size_gcf(3)) - fig_size_gcf(1);
% 
% set( gcf, 'Units', 'Normalized', 'Position', fig_size_gcf );

% UIWAIT makes GA_gui_editdir wait for user response (see UIRESUME)
% uiwait(handles.fig_editdir);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_editdir_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_dir_ok.
function pb_dir_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dir_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUIdata = guidata(handles.mainGUIhandle);


lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Directorys updated <<<'}];

[mainGUIdata.data.eye.dir.fileid, lbstring ] =  GA_gui_get(lbstring, 'file ID: ', mainGUIdata.data.eye.dir.fileid, handles.ed_resfilename, 'String');
[mainGUIdata.data.eye.dir.raw, lbstring ] =  GA_gui_get(lbstring, 'raw directory: ', mainGUIdata.data.eye.dir.raw, handles.ed_dir_raw, 'String');
[mainGUIdata.data.eye.dir.conv, lbstring ] =  GA_gui_get(lbstring, 'converted files directory: ', mainGUIdata.data.eye.dir.conv, handles.ed_dir_mat, 'String');
[mainGUIdata.data.eye.dir.stim, lbstring ] =  GA_gui_get(lbstring, 'stimulation directory: ', mainGUIdata.data.eye.dir.stim, handles.ed_stimuli, 'String');
[mainGUIdata.data.eye.dir.stimseq, lbstring ] =  GA_gui_get(lbstring, 'stimulation sequences directory: ', mainGUIdata.data.eye.dir.stimseq, handles.ed_stim_seq, 'String');
[mainGUIdata.data.eye.dir.results, lbstring ] =  GA_gui_get(lbstring, 'results directory: ', mainGUIdata.data.eye.dir.results, handles.ed_out_results, 'String');

if ~isequal(handles.vp, mainGUIdata.data.eye.include.files)
    
    mainGUIdata.data.eye.include.files = handles.vp;
    
    lbstring = [lbstring; ['-Files inclued/exclued-']];
end;

if strcmp(handles.vp, '')
    mainGUIdata.data.eye.include.files= 'all';
end

if ~strcmp(lbstring{end},'>>> Directorys updated <<<')
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


% --- Executes on button press in pb_dir_cancel.
function pb_dir_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dir_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in pb_seq_desc.
function pb_seq_desc_Callback(hObject, eventdata, handles)
% hObject    handle to pb_seq_desc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_stim_sequence(handles);


% --- Executes on button press in pb_includeexclude.
function pb_includeexclude_Callback(hObject, eventdata, handles)
% hObject    handle to pb_includeexclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ed_dir_raw_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dir_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dir_raw as text
%        str2double(get(hObject,'String')) returns contents of ed_dir_raw as a double


% --- Executes during object creation, after setting all properties.
function ed_dir_raw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dir_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to ed_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_stimuli as text
%        str2double(get(hObject,'String')) returns contents of ed_stimuli as a double


% --- Executes during object creation, after setting all properties.
function ed_stimuli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_stim_seq_Callback(hObject, eventdata, handles)
% hObject    handle to ed_stim_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_stim_seq as text
%        str2double(get(hObject,'String')) returns contents of ed_stim_seq as a double


% --- Executes during object creation, after setting all properties.
function ed_stim_seq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_stim_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_out_results_Callback(hObject, eventdata, handles)
% hObject    handle to ed_out_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_out_results as text
%        str2double(get(hObject,'String')) returns contents of ed_out_results as a double


% --- Executes during object creation, after setting all properties.
function ed_out_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_out_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_dir_mat_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dir_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dir_mat as text
%        str2double(get(hObject,'String')) returns contents of ed_dir_mat as a double


% --- Executes during object creation, after setting all properties.
function ed_dir_mat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dir_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_editraw.
function pb_editraw_Callback(hObject, eventdata, handles)
% hObject    handle to pb_editraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select folder') ;

if ~isnumeric(directory_name)
    set(handles.ed_dir_raw, 'String', directory_name);
end


% --- Executes on button press in pb_edit_conv.
function pb_edit_conv_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edit_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select folder') ;

if ~isnumeric(directory_name)
    set(handles.ed_dir_mat, 'String', directory_name);
end

% --- Executes on button press in pb_edit_result.
function pb_edit_result_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select folder') ;

if ~isnumeric(directory_name)
    set(handles.ed_out_results, 'String', directory_name);
end


% --- Executes on button press in pb_stim.
function pb_stim_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select folder') ;

if ~isnumeric(directory_name)
    set(handles.ed_stimuli, 'String', directory_name);
end


% --- Executes on button press in pb_stimseq.
function pb_stimseq_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stimseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir('','Select folder') ;

if ~isnumeric(directory_name)
    set(handles.ed_stim_seq, 'String', directory_name);
end


% --- Executes on button press in pb_change.
function pb_change_Callback(hObject, eventdata, handles)
% hObject    handle to pb_change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ed_filename_Callback(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (strfind(get(handles.ed_fileextention, 'String'),'.'))
ext = get(handles.ed_fileextention, 'String');
ext = strrep(ext,'.', '');
set(handles.ed_fileextention, 'String', ext);  
end

set(handles.ed_resfilename, 'String',[get(hObject,'String') '.' get(handles.ed_fileextention, 'String')]);


% Hints: get(hObject,'String') returns contents of ed_filename as text
%        str2double(get(hObject,'String')) returns contents of ed_filename as a double


% --- Executes during object creation, after setting all properties.
function ed_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_resfilename_Callback(hObject, eventdata, handles)
% hObject    handle to ed_resfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_resfilename as text
%        str2double(get(hObject,'String')) returns contents of ed_resfilename as a double


% --- Executes during object creation, after setting all properties.
function ed_resfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_resfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_fileextention_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fileextention (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fileextention as text
%        str2double(get(hObject,'String')) returns contents of ed_fileextention as a double
if (strfind(get(handles.ed_fileextention, 'String'),'.'))
ext = get(handles.ed_fileextention, 'String');
ext = strrep(ext,'.', '');
set(handles.ed_fileextention, 'String', ext);  
end

set(handles.ed_resfilename, 'String',[get(handles.ed_filename,'String') '.' get(handles.ed_fileextention, 'String')]);


% --- Executes during object creation, after setting all properties.
function ed_fileextention_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fileextention (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
