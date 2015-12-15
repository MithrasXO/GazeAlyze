function varargout = GA_gui_events_import(varargin)
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

% Last Modified by GUIDE v2.5 06-Feb-2013 15:28:51

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

% set figure width/heigth
fpos = get(gcf, 'position');
%scrnsz = get(0, 'screensize');
v = get(0,'MonitorPositions');
scrnsz =v(1,:);
fwidth = min([fpos(3), scrnsz(3)-20]);
fheight = min([fpos(4), scrnsz(4)-100]);
set(gcf, 'position', [10 scrnsz(4)-30 fwidth fheight]);

% determine the position of the scrollbar & its limits
swidth = max([.03, 16/scrnsz(3)]);
ypos = [1-swidth 0 swidth 1];
ymax = 0;
ymin = -3*(fpos(4)-fheight);

bpos = get(handles.scrollpanel,'Position');
bpos_old=bpos(2);
bpos(2)=fheight-bpos(4);
set(handles.scrollpanel, 'position', bpos);
apos = get(handles.preview,'Position');
apos(2)=apos(2) -(bpos_old -bpos(2));
set(handles.preview, 'position', apos);


% build the callback that will be executed on scrolling
if verLessThan('matlab','8.4.0')
    % execute code for R2014a or earlier
    clbk2 = ['set(',num2str(handles.scrollpanel,'%.13f'),',''position'',[', ...
        num2str(bpos(1)),' ',num2str(bpos(2)),'-get(gcbo,''value'') ', num2str(bpos(3)), ...
        ' ', num2str(bpos(4)),'])'];
    clbk1 = ['set(',num2str(handles.preview,'%.13f'),',''position'',[', ...
        num2str(apos(1)),' ',num2str(apos(2)),'-get(gcbo,''value'') ', num2str(apos(3)), ...
        ' ', num2str(apos(4)),'])'];
else
    % execute code for R2014b or later    
    clbk2 = ['set(handles.scrollpanel,''position'',[', ...
        num2str(bpos(1)),' ',num2str(bpos(2)),'-get(''sld'',''value'') ', num2str(bpos(3)), ...
        ' ', num2str(bpos(4)),'])'];
    clbk1 = ['set(handles.preview,''position'',[', ...
        num2str(apos(1)),' ',num2str(apos(2)),'-get(''sld'',''value'') ', num2str(apos(3)), ...
        ' ', num2str(apos(4)),'])'];
    
end
clbk = [clbk2 ',' clbk1];



% create the slider
if ymax > ymin
    sld = uicontrol('style','slider', ...
        'units','normalized','position',ypos, ...
        'callback',clbk,'min',ymin,'max',ymax,'value',0);   
end;
if strcmp(mainGUIdata.data.eye.cond.type, 'start/stop marker')
    
    
    %     if (mainGUIdata.data.eye.cond.stop.fix_at_end == 0)
    %         plot_arrow( 5,2,5,5,'linewidth',2,'color',[1 0.0 0.0])
    %         text(5,1,'cond-marker')
    %         plot_arrow( 8,3,8,5,'linewidth',2,'color',[1 0.0 0.0],'facecolor',[1 0.0 0.0])
    %         text(8,2,'stop-marker')
    %         rectangle('Position',[5,5,3,2], 'FaceColor','r')
    %     end
    %
    %     if (mainGUIdata.data.eye.cond.stop.fix_at_end == 1)
    %         plot_arrow( 5,2,5,5,'linewidth',2,'color',[1 0.0 0.0])
    %         text(5,1,'stop-marker')
    %         plot_arrow( 8,3,8,5,'linewidth',2,'color',[1 0.0 0.0],'facecolor',[1 0.0 0.0])
    %         text(8,2,'cond-marker')
    %         rectangle('Position',[5,5,3,2], 'FaceColor','r')
    %     end
    
    set(handles.rb_startstop, 'Value', 1)
    set(handles.rb_start, 'Enable', 'on')
    set(handles.rb_end, 'Enable', 'on')
    set(handles.ed_stop_string, 'Enable', 'on')
    
    set(handles.ed_timing, 'Enable', 'off')
    
end

if strcmp(mainGUIdata.data.eye.cond.type, 'single marker/fixed length')
    
    set(handles.rb_singlemarker, 'Value', 1)
    set(handles.rb_start, 'Enable', 'off')
    set(handles.rb_end, 'Enable', 'off')
    set(handles.ed_stop_string, 'Enable', 'off')
    set(handles.ed_timing, 'Enable', 'on')
end

set(handles.rb_end,'Value', ~mainGUIdata.data.eye.cond.stop.fix_at_end);
set(handles.rb_start,'Value', mainGUIdata.data.eye.cond.stop.fix_at_end);

if ~isempty(mainGUIdata.data.eye.cond.duration)
    set(handles.ed_timing,'String',mainGUIdata.data.eye.cond.duration);
end

if ~isempty(mainGUIdata.data.eye.cond.offset)
    set(handles.ed_offset,'String',mainGUIdata.data.eye.cond.offset);
end

if ~isempty(mainGUIdata.data.eye.cond.start.values)
    set(handles.ed_val_strings,'String',mat2str(mainGUIdata.data.eye.cond.start.values));
end
if ~isempty(mainGUIdata.data.eye.cond.start.codes)
    set(handles.ed_cond_codes,'String',mat2str(mainGUIdata.data.eye.cond.start.codes));
end

if ~isempty(mainGUIdata.data.eye.cond.stop.val)
    set(handles.ed_stop_string,'String',mainGUIdata.data.eye.cond.stop.val);
end

if mainGUIdata.data.eye.cond.flag_blocked == 0
    set(handles.chk_blocked,'Value',0);
    set(handles.ed_block_trlcnt,'Enable','off');
    set(handles.ed_block_blank,'Enable','off');
else
    set(handles.chk_blocked,'Value',1);
end

if mainGUIdata.data.eye.cond.flag_fixedgaze == 0
    set(handles.chk_fixedgaze,'Value',0);
    set(handles.ed_fix_string,'Enable','off');
    set(handles.ed_fix_dur,'Enable','off');
    set(handles.ed_fix_ons,'Enable','off');
else
    set(handles.chk_fixedgaze,'Value',1);
end

if ~isempty(mainGUIdata.data.eye.cond.block.trlcnt)
    set(handles.ed_block_trlcnt,'String',mainGUIdata.data.eye.cond.block.trlcnt);
end
if ~isempty(mainGUIdata.data.eye.cond.block.trlblank)
    set(handles.ed_block_blank,'String',mainGUIdata.data.eye.cond.block.trlblank);
end

if ~isempty(mainGUIdata.data.eye.cond.fix.duration)
    set(handles.ed_fix_dur,'String',mainGUIdata.data.eye.cond.fix.duration);
end
if ~isempty(mainGUIdata.data.eye.cond.fix.string)
    set(handles.ed_fix_string,'String',mainGUIdata.data.eye.cond.fix.string);
end
if ~isempty(mainGUIdata.data.eye.cond.fix.offset)
    set(handles.ed_fix_ons,'String',mainGUIdata.data.eye.cond.fix.offset);
end



axes(handles.preview)

hold on



set(gca, 'XTick', []);
set(gca, 'YTick', []);
%axis off;
set(gca,'XColor','w');
set(gca,'YColor','w');


%set(gca, 'xcolor ','white', 'xtick ',[])

title('trial settings preview');

plotpreview(handles);




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




% --- Executes on button press in chk_blocked.
function chk_blocked_Callback(hObject, eventdata, handles)
% hObject    handle to chk_blocked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_blocked
if get(hObject,'Value')==1
    set(handles.ed_block_trlcnt,'Enable','On');
    set(handles.ed_block_blank,'Enable','On');
    set(handles.tx_trls_in_block,'Enable','On');
    set(handles.tx_span,'Enable','On');
else
    set(handles.ed_block_trlcnt,'Enable','Off');
    set(handles.ed_block_blank,'Enable','Off');
    set(handles.tx_trls_in_block,'Enable','Off');
    set(handles.tx_span,'Enable','Off');
end;

plotpreview(handles);

function ed_block_trlcnt_Callback(hObject, eventdata, handles)
% hObject    handle to ed_block_trlcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_block_trlcnt as text
%        str2double(get(hObject,'String')) returns contents of ed_block_trlcnt as a double


% --- Executes during object creation, after setting all properties.
function ed_block_trlcnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_block_trlcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_block_blank_Callback(hObject, eventdata, handles)
% hObject    handle to ed_block_blank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_block_blank as text
%        str2double(get(hObject,'String')) returns contents of ed_block_blank as a double


% --- Executes during object creation, after setting all properties.
function ed_block_blank_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_block_blank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_timing_Callback(hObject, eventdata, handles)
% hObject    handle to ed_timing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_timing as text
%        str2double(get(hObject,'String')) returns contents of ed_timing as a double


% --- Executes during object creation, after setting all properties.
function ed_timing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_timing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ed_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ed_stop_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_offset_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_val_strings_Callback(hObject, eventdata, handles)
% hObject    handle to ed_val_strings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_val_strings as text
%        str2double(get(hObject,'String')) returns contents of ed_val_strings as a double


% --- Executes during object creation, after setting all properties.
function ed_val_strings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_val_strings (see GCBO)
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
lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Events updated <<<'}];

if (get(handles.rb_startstop, 'Value') == 1)
    [mainGUIdata.data.eye.cond.type, lbstring ] =  GA_gui_get(lbstring, 'trials limited by: ', mainGUIdata.data.eye.cond.type, handles.rb_startstop, 'String');
end

if (get(handles.rb_singlemarker, 'Value') == 1)
    [mainGUIdata.data.eye.cond.type, lbstring ] =  GA_gui_get(lbstring, 'trials limited by: ', mainGUIdata.data.eye.cond.type, handles.rb_singlemarker, 'String');
end
[mainGUIdata.data.eye.cond.offset, lbstring ]  = GA_gui_get(lbstring, 'offset: ', mainGUIdata.data.eye.cond.offset, handles.ed_offset, 'String');
[mainGUIdata.data.eye.cond.duration, lbstring ] =  GA_gui_get(lbstring, 'duration: ', mainGUIdata.data.eye.cond.duration, handles.ed_timing, 'String');


[mainGUIdata.data.eye.cond.start.codes, lbstring ]  = GA_gui_get(lbstring, 'cond codes: ' ,mainGUIdata.data.eye.cond.start.codes, handles.ed_cond_codes, 'String');
[mainGUIdata.data.eye.cond.start.values, lbstring ]  = GA_gui_get(lbstring, 'values: ' ,mainGUIdata.data.eye.cond.start.values, handles.ed_val_strings, 'String');
[mainGUIdata.data.eye.cond.stop.val, lbstring ]  = GA_gui_get(lbstring,  'stopmarker: ',mainGUIdata.data.eye.cond.stop.val, handles.ed_stop_string, 'String');
[mainGUIdata.data.eye.cond.stop.fix_at_end, lbstring ]  = GA_gui_get(lbstring,  'cond marker at trial start: ',mainGUIdata.data.eye.cond.stop.fix_at_end, handles.rb_start, 'Value');

[mainGUIdata.data.eye.cond.flag_blocked, lbstring ]  = GA_gui_get(lbstring, 'blocked trials: ', mainGUIdata.data.eye.cond.flag_blocked, handles.chk_blocked, 'Value');
[mainGUIdata.data.eye.cond.flag_fixedgaze, lbstring ]  = GA_gui_get(lbstring, 'fixed gaze: ', mainGUIdata.data.eye.cond.flag_fixedgaze, handles.chk_fixedgaze, 'Value');

[mainGUIdata.data.eye.cond.block.trlcnt, lbstring ]  = GA_gui_get(lbstring, 'trials per block: ',mainGUIdata.data.eye.cond.block.trlcnt,  handles.ed_block_trlcnt, 'String');
[mainGUIdata.data.eye.cond.block.trlblank, lbstring ]  = GA_gui_get(lbstring, 'blank: ', mainGUIdata.data.eye.cond.block.trlblank, handles.ed_block_blank, 'String');
[mainGUIdata.data.eye.cond.fix.duration, lbstring ]  = GA_gui_get(lbstring, 'fix duration: ', mainGUIdata.data.eye.cond.fix.duration, handles.ed_fix_dur, 'String');
[mainGUIdata.data.eye.cond.fix.string, lbstring ]  = GA_gui_get(lbstring, 'fix string: ', mainGUIdata.data.eye.cond.fix.string, handles.ed_fix_string, 'String');
[mainGUIdata.data.eye.cond.fix.offset, lbstring ]  = GA_gui_get(lbstring, 'fix offset: ', mainGUIdata.data.eye.cond.fix.offset, handles.ed_fix_ons, 'String');
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



function ed_offset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_offset_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_offset_1 as text
%        str2double(get(hObject,'String')) returns contents of ed_offset_1
%        as a double
plotpreview(handles);


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



function ed_stop_string_Callback(hObject, eventdata, handles)
% hObject    handle to ed_stop_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_stop_string as text
%        str2double(get(hObject,'String')) returns contents of ed_stop_string as a double


% --- Executes when selected object is changed in uiptiming.
function uiptiming_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uiptiming
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in chk_fixedgaze.
function chk_fixedgaze_Callback(hObject, eventdata, handles)
% hObject    handle to chk_fixedgaze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')==1
    
    
    set(handles.chk_fixedgaze,'Value',1);
    set(handles.ed_fix_string,'Enable','on');
    set(handles.ed_fix_dur,'Enable','on');
    set(handles.ed_fix_ons,'Enable','on');
else
    set(handles.chk_fixedgaze,'Value',0);
    set(handles.ed_fix_string,'Enable','off');
    set(handles.ed_fix_dur,'Enable','off');
    set(handles.ed_fix_ons,'Enable','off');
end;

plotpreview(handles);


% Hint: get(hObject,'Value') returns toggle state of chk_fixedgaze


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

if (get(handles.rb_startstop, 'Value') == 1)
    
    set(handles.rb_start, 'Enable', 'on');
    set(handles.rb_end, 'Enable', 'on');
    set(handles.ed_stop_string, 'Enable', 'on');
    
    set(handles.ed_timing, 'Enable', 'off');
    
    
else
    set(handles.rb_start, 'Enable', 'off');
    set(handles.rb_end, 'Enable', 'off');
    set(handles.ed_stop_string, 'Enable', 'off');
    
    set(handles.ed_timing, 'Enable', 'on');
    
end

plotpreview(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1





% --- Executes during object creation, after setting all properties.
function uipanel9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel6
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

plotpreview(handles);


function plotpreview(handles)

cla;

text(9,4,'time  -> ');
text(0.1,4,'time  -> ');


x = 0:10;
%creates a vector from 0 to 10, [0 1 2 3 . . . 10]
y = ones(1,11);
y= y*5;

%plots the x and y data
plot(x,y, 'Color', 'black');

if (get(handles.chk_blocked, 'Value') == 1)
    set(handles.txt_blocknote, 'Visible', 'on');
else
    set(handles.txt_blocknote, 'Visible', 'off');
end


if (get(handles.rb_startstop, 'Value') == 1)
    
    
    if (get(handles.rb_start, 'Value') == 1)
        
        set(handles.tx_stop, 'String', 'stop marker (sub)string');
        
        mArrow3([3 2 0],[3 5 0],'color','red');
        text(2,1,'cond-marker');
        mArrow3([7 2 0],[7 5 0],'color','red');
        text(6,1,'stop-marker');
        
        if (get(handles.chk_blocked, 'Value') == 1)
            
            if (str2double((get(handles.ed_offset, 'String'))) ==  0)
                
                rectangle('Position',[3,5,1,3], 'FaceColor','r');
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                text(3,6.5,'  block');
                text(3,6.5,'                                       block');
                text(3,9.5,'            span');
                text(3,8.5,'             <>');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                
            end;
            
            if (str2double((get(handles.ed_offset, 'String'))) >  0)
                
                
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                
                text(3,6.5,'                                       block');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                
                text(3,6.5,'-> offset ->', 'Color','b');
                
            end;
            
            if (str2double((get(handles.ed_offset, 'String'))) <  0)
                rectangle('Position',[1.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[3,5,1,3], 'FaceColor','r');
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                text(3,6.5,'  block');
                text(3,6.5,'                                       block');
                text(3,9.5,'            span');
                text(3,8.5,'             <>');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                text(1,6.5,'        block');
                text(1,9.5,'                   span');
                text(1,8.5,'                    <>');
                
                text(1,4,'       <- offset <-', 'Color','b');
            end
            
        else
            
            if (str2double((get(handles.ed_offset, 'String'))) ==  0)
                rectangle('Position',[3,5,4,3], 'FaceColor','r');
                
            end
            
            if (str2double((get(handles.ed_offset, 'String'))) >  0)
                
                rectangle('Position',[4.5,5,2.5,3], 'FaceColor','r');
                
                text(3,6.5,'-> offset ->', 'Color','b');
            end
            
            if (str2double((get(handles.ed_offset, 'String'))) <  0)
                rectangle('Position',[1.5,5,5.5,3], 'FaceColor','r');
                
                text(1,6.5,'       <- offset <-', 'Color','b');
            end
            
        end
        
        
    else
        
        set(handles.tx_stop, 'String', 'start marker (sub)string');
        
        mArrow3([3 2 0],[3 5 0],'color','red');
        text(2,1,'start-marker');
        mArrow3([7 2 0],[7 5 0],'color','red');
        text(6,1,'cond-marker');
        
        if (get(handles.chk_blocked, 'Value') == 1)
            
            if (str2double((get(handles.ed_offset, 'String'))) ==  0)
                
                rectangle('Position',[3,5,1,3], 'FaceColor','r');
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                text(3,6.5,'  block');
                text(3,6.5,'                                       block');
                text(3,9.5,'            span');
                text(3,8.5,'             <>');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                
            end;
            
            if (str2double((get(handles.ed_offset, 'String'))) >  0)
                
                
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                
                text(3,6.5,'                                       block');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                
                text(3,6.5,'-> offset ->', 'Color','b');
                
            end
            
            if (str2double((get(handles.ed_offset, 'String'))) <  0)
                rectangle('Position',[1.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[3,5,1,3], 'FaceColor','r');
                rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
                rectangle('Position',[6,5,1,3], 'FaceColor','r');
                text(3,6.5,'                     block');
                text(3,6.5,'  block');
                text(3,6.5,'                                       block');
                text(3,9.5,'            span');
                text(3,8.5,'             <>');
                text(3,9.5,'                               span');
                text(3,8.5,'                                <>');
                text(1,6.5,'        block');
                text(1,9.5,'                   span');
                text(1,8.5,'                    <>');
                
                text(1,4,'       <- offset <-', 'Color','b');
            end
            
        else
            
            if (str2double((get(handles.ed_offset, 'String'))) ==  0)
                rectangle('Position',[3,5,4,3], 'FaceColor','r');
                
            end
            
            if (str2double((get(handles.ed_offset, 'String'))) >  0)
                
                rectangle('Position',[4.5,5,2.5,3], 'FaceColor','r');
                
                text(3,6.5,'-> offset ->', 'Color','b');
            end
            
            if (str2double((get(handles.ed_offset, 'String'))) <  0)
                rectangle('Position',[1.5,5,5.5,3], 'FaceColor','r');
                
                text(1,6.5,'       <- offset <-', 'Color','b');
            end
            
        end
        
        
        
    end
end

if (get(handles.rb_singlemarker, 'Value') == 1)
    
    mArrow3([3 2 0],[3 5 0],'color','red');
    text(2,1,'cond-marker');
    
    if (get(handles.chk_blocked, 'Value') == 1)
        
        if (str2double((get(handles.ed_offset, 'String'))) ==  0)
            rectangle('Position',[3,5,1,3], 'FaceColor','r');
            rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
            rectangle('Position',[6,5,1,3], 'FaceColor','r');
            text(3,4,'               -> duration ->');
            text(3,6.5,'                     block');
            text(3,6.5,'  block');
            text(3,6.5,'                                       block');
            text(3,9.5,'            span');
            text(3,8.5,'             <>');
            text(3,9.5,'                               span');
            text(3,8.5,'                                <>');
        end
        
        if (str2double((get(handles.ed_offset, 'String'))) >  0)
            
            rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
            rectangle('Position',[6,5,1,3], 'FaceColor','r');
            rectangle('Position',[7.5,5,1,3], 'FaceColor','r');
            
            
            text(3,4,'                                 -> duration ->');
            text(3,6.5,'-> offset ->', 'Color','b');
            text(3,6.5,'                     block');
            text(3,6.5,'                                       block');
            text(3,6.5,'                                                         block');
            text(3,9.5,'                                                 span');
            text(3,8.5,'                                                  <>');
            text(3,9.5,'                               span');
            text(3,8.5,'                                <>');
        end
        
        if (str2double((get(handles.ed_offset, 'String'))) <  0)
            rectangle('Position',[1.5,5,1,3], 'FaceColor','r');
            rectangle('Position',[3,5,1,3], 'FaceColor','r');
            rectangle('Position',[4.5,5,1,3], 'FaceColor','r');
            
            
            text(1,4,'                               -> duration ->');
            text(1,4,'       <- offset <-', 'Color','b');
            text(3,6.5,'                     block');
            text(1,6.5,'         block');
            text(3,6.5,'  block');
            text(1,9.5,'                   span');
            text(1,8.5,'                    <>');
            text(3,9.5,'            span');
            text(3,8.5,'             <>');
        end
        
    else
        %         if (get(handles.chk_fixedgaze, 'Value') == 1)
        %
        %             mArrow3([2 3 0],[2 5 0],'color','green')
        %             text(1,2,'fix-marker')
        %
        %             if (str2double((get(handles.ed_offset, 'String'))) ==  0)
        %
        %
        %                 rectangle('Position',[2,5,1,3], 'FaceColor','g')
        %
        %                 rectangle('Position',[3,5,4,3], 'FaceColor','r')
        %                 text(3,6.5,'               -> duration ->', 'Color','w')
        %             end
        %
        %             if (str2double((get(handles.ed_offset, 'String'))) >  0)
        %
        %                 rectangle('Position',[4.5,5,4,3], 'FaceColor','r')
        %                 text(3,6.5,'                                 -> duration ->', 'Color','w')
        %                 text(3,6.5,'-> offset ->', 'Color','b')
        %             end
        %
        %             if (str2double((get(handles.ed_offset, 'String'))) <  0)
        %                 rectangle('Position',[1.5,5,4,3], 'FaceColor','r')
        %                 text(1,6.5,'                               -> duration ->', 'Color','w')
        %                 text(1,6.5,'       <- offset <-', 'Color','b')
        %             end
        %
        %         else
        
        if (str2double((get(handles.ed_offset, 'String'))) ==  0)
            
            rectangle('Position',[3,5,4,3], 'FaceColor','r');
            text(3,6.5,'               -> duration ->', 'Color','w');
        end
        
        if (str2double((get(handles.ed_offset, 'String'))) >  0)
            
            rectangle('Position',[4.5,5,4,3], 'FaceColor','r');
            text(3,6.5,'                                 -> duration ->', 'Color','w');
            text(3,6.5,'-> offset ->', 'Color','b');
        end
        
        if (str2double((get(handles.ed_offset, 'String'))) <  0)
            rectangle('Position',[1.5,5,4,3], 'FaceColor','r');
            text(1,6.5,'                               -> duration ->', 'Color','w');
            text(1,6.5,'       <- offset <-', 'Color','b');
        end
        
        %         end
    end
    
end



function h = mArrow3(p1,p2,varargin)
%mArrow3 - plot a 3D arrow as patch object (cylinder+cone)
%
% syntax:   h = mArrow3(p1,p2)
%           h = mArrow3(p1,p2,'propertyName',propertyValue,...)
%
% with:     p1:         starting point
%           p2:         end point
%           properties: 'color':      color according to MATLAB specification
%                                     (see MATLAB help item 'ColorSpec')
%                       'stemWidth':  width of the line
%                       'tipWidth':   width of the cone
%
%           Additionally, you can specify any patch object properties. (For
%           example, you can make the arrow semitransparent by using
%           'facealpha'.)
%
% example1: h = mArrow3([0 0 0],[1 1 1])
%           (Draws an arrow from [0 0 0] to [1 1 1] with default properties.)
%
% example2: h = mArrow3([0 0 0],[1 1 1],'color','red','stemWidth',0.02,'facealpha',0.5)
%           (Draws a red semitransparent arrow with a stem width of 0.02 units.)
%
% hint:     use light to achieve 3D impression
%

propertyNames = {'edgeColor'};
propertyValues = {'none'};

%% evaluate property specifications
for argno = 1:2:nargin-2
    switch varargin{argno}
        case 'color'
            propertyNames = {propertyNames{:},'facecolor'};
            propertyValues = {propertyValues{:},varargin{argno+1}};
        case 'stemWidth'
            if isreal(varargin{argno+1})
                stemWidth = varargin{argno+1};
            else
                warning('mArrow3:stemWidth','stemWidth must be a real number');
            end
        case 'tipWidth'
            if isreal(varargin{argno+1})
                tipWidth = varargin{argno+1};
            else
                warning('mArrow3:tipWidth','tipWidth must be a real number');
            end
        otherwise
            propertyNames = {propertyNames{:},varargin{argno}};
            propertyValues = {propertyValues{:},varargin{argno+1}};
    end
end

%% default parameters
if ~exist('stemWidth','var')
    ax = axis;
    if numel(ax)==4
        stemWidth = norm(ax([2 4])-ax([1 3]))/300;
    elseif numel(ax)==6
        stemWidth = norm(ax([2 4 6])-ax([1 3 5]))/300;
    end
end
if ~exist('tipWidth','var')
    tipWidth = 3*stemWidth;
end
tipAngle = 22.5/180*pi;
tipLength = tipWidth/tan(tipAngle/2);
ppsc = 50;  % (points per small circle)
ppbc = 250; % (points per big circle)

%% ensure column vectors
p1 = p1(:);
p2 = p2(:);

%% basic lengths and vectors
x = (p2-p1)/norm(p2-p1); % (unit vector in arrow direction)
y = cross(x,[0;0;1]);    % (y and z are unit vectors orthogonal to arrow)
if norm(y)<0.1
    y = cross(x,[0;1;0]);
end
y = y/norm(y);
z = cross(x,y);
z = z/norm(z);

%% basic angles
theta = 0:2*pi/ppsc:2*pi; % (list of angles from 0 to 2*pi for small circle)
sintheta = sin(theta);
costheta = cos(theta);
upsilon = 0:2*pi/ppbc:2*pi; % (list of angles from 0 to 2*pi for big circle)
sinupsilon = sin(upsilon);
cosupsilon = cos(upsilon);

%% initialize face matrix
f = NaN([ppsc+ppbc+2 ppbc+1]);

%% normal arrow
if norm(p2-p1)>tipLength
    % vertices of the first stem circle
    for idx = 1:ppsc+1
        v(idx,:) = p1 + stemWidth*(sintheta(idx)*y + costheta(idx)*z);
    end
    % vertices of the second stem circle
    p3 = p2-tipLength*x;
    for idx = 1:ppsc+1
        v(ppsc+1+idx,:) = p3 + stemWidth*(sintheta(idx)*y + costheta(idx)*z);
    end
    % vertices of the tip circle
    for idx = 1:ppbc+1
        v(2*ppsc+2+idx,:) = p3 + tipWidth*(sinupsilon(idx)*y + cosupsilon(idx)*z);
    end
    % vertex of the tiptip
    v(2*ppsc+ppbc+4,:) = p2;
    
    % face of the stem circle
    f(1,1:ppsc+1) = 1:ppsc+1;
    % faces of the stem cylinder
    for idx = 1:ppsc
        f(1+idx,1:4) = [idx idx+1 ppsc+1+idx+1 ppsc+1+idx];
    end
    % face of the tip circle
    f(ppsc+2,:) = 2*ppsc+3:(2*ppsc+3)+ppbc;
    % faces of the tip cone
    for idx = 1:ppbc
        f(ppsc+2+idx,1:3) = [2*ppsc+2+idx 2*ppsc+2+idx+1 2*ppsc+ppbc+4];
    end
    
    %% only cone v
else
    tipWidth = 2*sin(tipAngle/2)*norm(p2-p1);
    % vertices of the tip circle
    for idx = 1:ppbc+1
        v(idx,:) = p1 + tipWidth*(sinupsilon(idx)*y + cosupsilon(idx)*z);
    end
    % vertex of the tiptip
    v(ppbc+2,:) = p2;
    % face of the tip circle
    f(1,:) = 1:ppbc+1;
    % faces of the tip cone
    for idx = 1:ppbc
        f(1+idx,1:3) = [idx idx+1 ppbc+2];
    end
end

%% draw
fv.faces = f;
fv.vertices = v;
h = patch(fv);
for propno = 1:numel(propertyNames)
    try
        set(h,propertyNames{propno},propertyValues{propno});
    catch
        disp(lasterr);
    end
end


% --- Executes on key press with focus on ed_offset and none of its controls.
function ed_offset_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ed_offset (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
drawnow;
plotpreview(handles)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ed_offset.
function ed_offset_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ed_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ed_cond_codes_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cond_codes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cond_codes as text
%        str2double(get(hObject,'String')) returns contents of ed_cond_codes as a double


% --- Executes during object creation, after setting all properties.
function ed_cond_codes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cond_codes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
