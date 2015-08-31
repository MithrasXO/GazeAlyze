function varargout = GA_gui_custom_datatype(varargin)
% GA_GUI_CUSTOM_DATATYPE M-file for GA_gui_custom_datatype.fig
%      GA_GUI_CUSTOM_DATATYPE, by itself, creates a new GA_GUI_CUSTOM_DATATYPE or raises the existing
%      singleton*.
%
%      H = GA_GUI_CUSTOM_DATATYPE returns the handle to a new GA_GUI_CUSTOM_DATATYPE or the handle to
%      the existing singleton*.
%
%      GA_GUI_CUSTOM_DATATYPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI_CUSTOM_DATATYPE.M with the given input arguments.
%
%      GA_GUI_CUSTOM_DATATYPE('Property','Value',...) creates a new GA_GUI_CUSTOM_DATATYPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_gui_custom_datatype_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_custom_datatype_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_custom_datatype

% Last Modified by GUIDE v2.5 18-Apr-2010 10:28:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GA_gui_custom_datatype_OpeningFcn, ...
                   'gui_OutputFcn',  @GA_gui_custom_datatype_OutputFcn, ...
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


% --- Executes just before GA_gui_custom_datatype is made visible.
function GA_gui_custom_datatype_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_custom_datatype (see VARARGIN)

% Choose default command line output for GA_gui_custom_datatype
handles.output = hObject;

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(handles.mainGUIhandle);
try
    str2double(mainGUIdata.data.eye.datatype_custval)
    mainGUIdata.data.eye.datatype_custval = '';
catch ex %#ok<NASGU>
    
end
if ~isempty(mainGUIdata.data.eye.datatype_custval)
set(handles.editcust, 'String', mainGUIdata.data.eye.datatype_custval)
end;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GA_gui_custom_datatype wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_custom_datatype_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editcust_Callback(hObject, eventdata, handles)
% hObject    handle to editcust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editcust as text
%        str2double(get(hObject,'String')) returns contents of editcust as a double


% --- Executes during object creation, after setting all properties.
function editcust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editcust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_browse.
function pb_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.m','Select list of included files') ;
if PathName ~=0
set(handles.editcust, 'String', [PathName '\' FileName ]);
end

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close GA_gui_custom_datatype

% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIdata = guidata(handles.mainGUIhandle);


lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Custom datatype-stettings updated <<<'}];


[mainGUIdata.data.eye.datatype_custval, lbstring ] =  GA_gui_get(lbstring, 'custom datatype converter file-path: ', mainGUIdata.data.eye.datatype_custval, handles.editcust, 'String');

if ~strcmp(lbstring{end},'>>> Custom datatype-stettings updated <<<')
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


% --- Executes on button press in pb_openrw.
function pb_openrw_Callback(hObject, eventdata, handles)
% hObject    handle to pb_openrw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open GA_ilabConvertFileTemplate.m
