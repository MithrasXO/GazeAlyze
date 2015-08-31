function varargout = GA_gui_stim_sequence(varargin)

% GA_GUI_STIM_SEQUENCE M-file for GA_gui_stim_sequence.fig
%      GA_GUI_STIM_SEQUENCE, by itself, creates a new GA_GUI_STIM_SEQUENCE or raises the existing
%      singleton*.
%
%      H = GA_GUI_STIM_SEQUENCE returns the handle to a new GA_GUI_STIM_SEQUENCE or the handle to
%      the existing singleton*.
%
%      GA_GUI_STIM_SEQUENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI_STIM_SEQUENCE.M with the given input arguments.
%
%      GA_GUI_STIM_SEQUENCE('Property','Value',...) creates a new GA_GUI_STIM_SEQUENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_gui_stim_sequence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_stim_sequence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_stim_sequence

% Last Modified by GUIDE v2.5 04-May-2010 17:05:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GA_gui_stim_sequence_OpeningFcn, ...
                   'gui_OutputFcn',  @GA_gui_stim_sequence_OutputFcn, ...
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


% --- Executes just before GA_gui_stim_sequence is made visible.
function GA_gui_stim_sequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_stim_sequence (see VARARGIN)

% Choose default command line output for GA_gui_stim_sequence
handles.output = hObject;

%Update handles structure
parent = cell2mat(varargin);
handles.mainGUIhandle = parent.mainGUIhandle;
handles.parentfig = parent.fig_editdir;
mainGUIdata = guidata(parent.mainGUIhandle);


stim = mainGUIdata.data.eye.stim;
set(handles.ed_pic,'String', stim.pic);
set(handles.ed_col,'String', num2str(stim.col));
set(handles.ed_row,'String', num2str(stim.row));
set(handles.ed_cov,'String', num2str(stim.covar));


handles.stimsequ = ['"picname:' strrep(stim.pic,'"','') ', column:' num2str(stim.col)  ', covariates:' num2str(stim.covar) ', first row:' num2str(stim.row) '"'];
guidata(hObject, handles);

% UIWAIT makes GA_gui_stim_sequence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_stim_sequence_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIdata = guidata(handles.mainGUIhandle);

stim = mainGUIdata.data.eye.stim;

lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Stimulus Sequence Description updated <<<'}];

[stim.pic, lbstring ]  = GA_gui_get(lbstring, 'pic name: ', stim.pic, handles.ed_pic, 'String');
[stim.col, lbstring ] =  GA_gui_get(lbstring, 'column with picnames: ', stim.col, handles.ed_col, 'String');
[stim.row, lbstring ]  = GA_gui_get(lbstring, 'first data row: ', stim.row, handles.ed_row, 'String');
[stim.covar, lbstring ]  = GA_gui_get(lbstring, 'columns with covariates: ', stim.covar, handles.ed_cov, 'String');

mainGUIdata.data.eye.stim = stim;
rows_lb = size(lbstring,1);
if ~strcmp(lbstring{end},'>>> Stimulus Sequence Description updated <<<')
    set(mainGUIdata.listbox_progress, 'String', lbstring);
    set(mainGUIdata.listbox_progress, 'Max', length(lbstring));
    set(mainGUIdata.listbox_progress, 'Value', length(lbstring));
    set(mainGUIdata.uipt_save, 'Enable', 'on');
end;


parent=guidata(handles.parentfig);
set(parent.tx_seq,'String', ['"picname:' strrep(stim.pic,'"','') ', column:' num2str(stim.col)  ', covariates:' num2str(stim.covar) ', first row:' num2str(stim.row) '"']);


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


function ed_fname_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fname as text
%        str2double(get(hObject,'String')) returns contents of ed_fname as a double


% --- Executes during object creation, after setting all properties.
function ed_fname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_col_Callback(hObject, eventdata, handles)
% hObject    handle to ed_col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_col as text
%        str2double(get(hObject,'String')) returns contents of ed_col as a double
val= get(handles.ed_col,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_col,'String',num2str(val));

% --- Executes during object creation, after setting all properties.
function ed_col_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_row_Callback(hObject, eventdata, handles)
% hObject    handle to ed_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_row as text
%        str2double(get(hObject,'String')) returns contents of ed_row as a double
val= get(handles.ed_row,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_row,'String',num2str(val));

% --- Executes during object creation, after setting all properties.
function ed_row_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



function ed_pic_Callback(hObject, eventdata, handles)
% hObject    handle to ed_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_pic as text
%        str2double(get(hObject,'String')) returns contents of ed_pic as a double


% --- Executes during object creation, after setting all properties.
function ed_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_cov_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cov as text
%        str2double(get(hObject,'String')) returns contents of ed_cov as a double


% --- Executes during object creation, after setting all properties.
function ed_cov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
