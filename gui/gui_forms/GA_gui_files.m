function varargout = GA_gui_files(varargin)
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

% Last Modified by GUIDE v2.5 15-Oct-2010 16:26:33

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
path = parentGUIdata.data.eye.dir.raw;
files = dir(path);
files = files([files.isdir]==0);
pathcontent = {files.name}';

%filter path content
if ~strcmp(parentGUIdata.data.eye.dir.fileid,'')
    strPos = strfind(parentGUIdata.data.eye.dir.fileid,'$id');
    %placeholder '$id' exists
    if ~isempty(strPos)
        if strPos>1
            Prefix = parentGUIdata.data.eye.dir.fileid(1:strPos-1);
            included = strncmpi(pathcontent, Prefix, length(Prefix));
            pathcontent = pathcontent(included);
            pathcontent = cellfun(@(x) strrep(x,Prefix,''),pathcontent, 'UniformOutput', false);
        end;
        if length(parentGUIdata.data.eye.dir.fileid) - strPos + 3 > 0
            Suffix = parentGUIdata.data.eye.dir.fileid(strPos + 3:end);
            included = cellfun(@(x) strcmp(x(end-length(Suffix)+1:end),Suffix),pathcontent);
            pathcontent = pathcontent(included);
            pathcontent = cellfun(@(x) strrep(x,Suffix,''),pathcontent, 'UniformOutput', false);
        end;
        %placeholder '$id' exists not
    else
        strPos = strfind(parentGUIdata.data.eye.dir.fileid,'.');
        Suffix = parentGUIdata.data.eye.dir.fileid(strPos(end):end);
        pathcontent = cellfun(@(x) strrep(x,Suffix,''),pathcontent, 'UniformOutput', false);
    end;
else    
    pathcontent = cellfun(@(x) strrep(x,'.txt',''),pathcontent, 'UniformOutput', false);
end;


handles.flag_all = 0;
if strcmp(parentGUIdata.data.eye.include.files, 'all');
    parentGUIdata.data.eye.include.files = '';
    handles.flag_all = 1;
    set(handles.lb_in, 'String', pathcontent);
    set(handles.lb_ex, 'String', '');
else
    if ~isempty(pathcontent)
        included = ismember(pathcontent, parentGUIdata.data.eye.include.files);
        if any(included)
            set(handles.lb_in, 'String', pathcontent(included));
            pathcontent(included,:) = [];
        end;
        if ~isempty(pathcontent)
            set(handles.lb_ex, 'String', pathcontent);
        end;
    end;
end;
if isempty(get(handles.lb_ex, 'String'))
    set(handles.lb_ex, 'Value', 0);
else
    set(handles.lb_ex, 'Value', 1);
end;
if isempty(get(handles.lb_in, 'String'))
    set(handles.lb_in, 'Value', 0);
else
    set(handles.lb_in, 'Value', 1);
end;

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

if isempty(get(handles.lb_in, 'String')) || handles.flag_all==1 || isempty(get(handles.lb_ex, 'String'))
    parentGUIdata.data.eye.include.files = 'all';
else
    parentGUIdata.data.eye.include.files = get(handles.lb_in, 'String');
    if ~iscell(parentGUIdata.data.eye.include.files)
        parentGUIdata.data.eye.include.files = {parentGUIdata.data.eye.include.files};
    end;
end
set(parentGUIdata.uipt_save, 'Enable', 'on');
GA_gui_set(parentGUIdata, 1)

close;

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on selection change in lb_ex.
function lb_ex_Callback(hObject, eventdata, handles)
% hObject    handle to lb_ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_ex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_ex


% --- Executes during object creation, after setting all properties.
function lb_ex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_in.
function lb_in_Callback(hObject, eventdata, handles)
% hObject    handle to lb_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_in contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_in


% --- Executes during object creation, after setting all properties.
function lb_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_inone.
function pb_inone_Callback(hObject, eventdata, handles)
% hObject    handle to pb_inone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clickedContent = get(handles.lb_ex,'Value');
contents_lb_ex = get(handles.lb_ex,'String');
if ischar(contents_lb_ex)
    contents_lb_ex= {contents_lb_ex};
end;
lb_in_string = get(handles.lb_in,'String');

if ~isempty(contents_lb_ex)
    
    for i=1:length(clickedContent)
        lb_in_string = [lb_in_string; contents_lb_ex(clickedContent(i))];
    end
    
    for i=1:length(clickedContent)
        contents_lb_ex{clickedContent(i),:} = [];
    end;
    contents_lb_ex(cellfun('isempty',contents_lb_ex)) = [];
    
    set(handles.lb_ex,'String',contents_lb_ex);
    set(handles.lb_in,'String',lb_in_string);
    if isempty(get(handles.lb_ex, 'String'))
        set(handles.lb_ex, 'Value', 0);
    else
        set(handles.lb_ex, 'Value', 1);
    end;
    if isempty(get(handles.lb_in, 'String'))
        set(handles.lb_in, 'Value', 0);
    else
        set(handles.lb_in, 'Value', 1);
    end;
    
    handles.flag_all = 0;
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in pb_outone.
function pb_outone_Callback(hObject, eventdata, handles)
% hObject    handle to pb_outone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clickedContent = get(handles.lb_in,'Value');
contents_lb_in = get(handles.lb_in,'String');
if ischar(contents_lb_in)
    contents_lb_in= {contents_lb_in};
end;

lb_ex_string = get(handles.lb_ex,'String');

if ~isempty(contents_lb_in)
    
    for i=1:length(clickedContent)
        lb_ex_string = [lb_ex_string; contents_lb_in(clickedContent(i))];
    end
    
    for i=1:length(clickedContent)
        contents_lb_in{clickedContent(i),:} = [];
    end;
    contents_lb_in(cellfun('isempty',contents_lb_in)) = [];
    
    set(handles.lb_ex,'String',lb_ex_string);
    set(handles.lb_in,'String',contents_lb_in);
    if isempty(get(handles.lb_ex, 'String'))
        set(handles.lb_ex, 'Value', 0);
    else
        set(handles.lb_ex, 'Value', 1);
    end;
    if isempty(get(handles.lb_in, 'String'))
        set(handles.lb_in, 'Value', 0);
    else
        set(handles.lb_in, 'Value', 1);
    end;
    
end
handles.flag_all = 0;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_outall.
function pb_outall_Callback(hObject, eventdata, handles)
% hObject    handle to pb_outall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents_lb_in = get(handles.lb_in,'String');
if ischar(contents_lb_in)
    contents_lb_in = {contents_lb_in};
end;
lb_ex_string = get(handles.lb_ex,'String');

if ~isempty(contents_lb_in)
    
    for i=1:length(contents_lb_in)
        lb_ex_string = [lb_ex_string; contents_lb_in(i)];
    end
    
    set(handles.lb_ex,'String',lb_ex_string);
    set(handles.lb_in,'String','');
    if isempty(get(handles.lb_ex, 'String'))
        set(handles.lb_ex, 'Value', 0);
    else
        set(handles.lb_ex, 'Value', 1);
    end;
    if isempty(get(handles.lb_in, 'String'))
        set(handles.lb_in, 'Value', 0);
    else
        set(handles.lb_in, 'Value', 1);
    end;
    
end

% --- Executes on button press in pb_inall.
function pb_inall_Callback(hObject, eventdata, handles)
% hObject    handle to pb_inall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents_lb_ex = get(handles.lb_ex,'String');
if ischar(contents_lb_ex)
    contents_lb_ex= {contents_lb_ex};
end;

lb_in_string = get(handles.lb_in,'String');

if ~isempty(contents_lb_ex)
    
    for i=1:length(contents_lb_ex)
        lb_in_string = [lb_in_string; contents_lb_ex(i)];
    end
    
    set(handles.lb_ex,'String','');
    set(handles.lb_ex, 'Value', 0);
    set(handles.lb_in,'String',lb_in_string);
    if isempty(get(handles.lb_in, 'String'))
        set(handles.lb_in, 'Value', 0);
    else
        set(handles.lb_in, 'Value', 1);
    end;
    
end
handles.flag_all= 1;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in tb_raw.
function tb_raw_Callback(hObject, eventdata, handles)
% hObject    handle to tb_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tb_conv, 'Value', 0);
set(handles.lb_in,'String','');
set(handles.lb_in,'Value', 0);

h = findobj('type','figure','tag','GA_mainWin');
parentGUIdata = guidata(h);
path = parentGUIdata.data.eye.dir.raw;
files = dir(path);
files = files([files.isdir]==0);
pathcontent = {files.name}';

%filter path content
if ~strcmp(parentGUIdata.data.eye.dir.fileid,'')
    strPos = strfind(parentGUIdata.data.eye.dir.fileid,'$id');
    %placeholder '$id' exists
    if ~isempty(strPos)
        if strPos>1
            Prefix = parentGUIdata.data.eye.dir.fileid(1:strPos-1);
            included = strncmpi(pathcontent, Prefix, length(Prefix));
            pathcontent = pathcontent(included);
            pathcontent = cellfun(@(x) strrep(x,Prefix,''),pathcontent, 'UniformOutput', false);
        end;
        if length(parentGUIdata.data.eye.dir.fileid)- strPos + 3 > 0
            Suffix = parentGUIdata.data.eye.dir.fileid(strPos + 3:end);
            included = cellfun(@(x) strcmp(x(end-length(Suffix)+1:end),Suffix),pathcontent);
            pathcontent = pathcontent(included);
            pathcontent = cellfun(@(x) strrep(x,Suffix,''),pathcontent, 'UniformOutput', false);
        end;
        %placeholder '$id' exists not
    else
        strPos = strfind(parentGUIdata.data.eye.dir.fileid,'.');
        Suffix = parentGUIdata.data.eye.dir.fileid(strPos(end):end);
        pathcontent = cellfun(@(x) strrep(x,Suffix,''),pathcontent, 'UniformOutput', false);
    end;
else    
    pathcontent = cellfun(@(x) strrep(x,'.txt',''),pathcontent, 'UniformOutput', false);
end;

if strcmp(parentGUIdata.data.eye.include.files, 'all');
    parentGUIdata.data.eye.include.files = '';
    handles.flag_all = 1;
    set(handles.lb_in, 'String', pathcontent);
    set(handles.lb_ex, 'String', '');
else
    if ~isempty(pathcontent)
        included = ismember(pathcontent, parentGUIdata.data.eye.include.files);
        if any(included)
            set(handles.lb_in, 'String', pathcontent(included));
            pathcontent(included,:) = [];
        end;
    end;
    set(handles.lb_ex, 'String', pathcontent);
end;

if isempty(get(handles.lb_ex, 'String'))
    set(handles.lb_ex, 'Value', 0);
else
    set(handles.lb_ex, 'Value', 1);
end;
if isempty(get(handles.lb_in, 'String'))
    set(handles.lb_in, 'Value', 0);
else
    set(handles.lb_in, 'Value', 1);
end;

% --- Executes on button press in tb_conv.
function tb_conv_Callback(hObject, eventdata, handles)
% hObject    handle to tb_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tb_raw, 'Value', 0);
set(handles.lb_in,'String','');
set(handles.lb_in,'Value', 0);

h = findobj('type','figure','tag','GA_mainWin');
parentGUIdata = guidata(h);
path = parentGUIdata.data.eye.dir.conv;
files = dir(fullfile(path, '*_GA.mat'));
files = files([files.isdir]==0);
pathcontent = {files.name}';
pathcontent = cellfun(@(x) strrep(x,'_GA.mat',''),pathcontent, 'UniformOutput', false);

if strcmp(parentGUIdata.data.eye.include.files, 'all');
    parentGUIdata.data.eye.include.files = '';
    handles.flag_all = 1;
    set(handles.lb_in, 'String', pathcontent);
    set(handles.lb_ex, 'String', '');
else
    if ~isempty(pathcontent)
        included = ismember(pathcontent, parentGUIdata.data.eye.include.files);
        if any(included)
            set(handles.lb_in, 'String', pathcontent(included));
            pathcontent(included,:) = [];
        end;
    end;
    set(handles.lb_ex, 'String', pathcontent);
end;
if isempty(get(handles.lb_ex, 'String'))
    set(handles.lb_ex, 'Value', 0);
else
    set(handles.lb_ex, 'Value', 1);
end;
if isempty(get(handles.lb_in, 'String'))
    set(handles.lb_in, 'Value', 0);
else
    set(handles.lb_in, 'Value', 1);
end;
