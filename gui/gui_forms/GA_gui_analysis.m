function varargout = GA_gui_analysis(varargin)
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

% Last Modified by GUIDE v2.5 09-Dec-2015 17:22:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_analysis_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_analysis_OutputFcn, ...
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
function GA_gui_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
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


%checkboxes
set(handles.cb_qual, 'Value', mainGUIdata.data.eye.stats.qual);
set(handles.cb_sort, 'Value', mainGUIdata.data.eye.stats.sort);
set(handles.cb_fix_abs_cum, 'Value', mainGUIdata.data.eye.stats.fix.da_cum);
set(handles.cb_fix_abs_mean, 'Value', mainGUIdata.data.eye.stats.fix.da_mean);
set(handles.cb_fix_rel_cum, 'Value', mainGUIdata.data.eye.stats.fix.dr_cum);
set(handles.cb_fix_rel_mean, 'Value', mainGUIdata.data.eye.stats.fix.dr_mean);
set(handles.cb_nrfix, 'Value', mainGUIdata.data.eye.stats.fix.nr);
set(handles.cb_nafix, 'Value', mainGUIdata.data.eye.stats.fix.na);
set(handles.cb_fix_sacc, 'Value', mainGUIdata.data.eye.stats.fix.sacrat);
set(handles.cb_covar, 'Value', mainGUIdata.data.eye.stats.covar);
set(handles.cb_trl_valid, 'Value', mainGUIdata.data.eye.stats.valid);

set(handles.cb_separat, 'Value', mainGUIdata.data.eye.stats.separatrows);

set(handles.cb_report_dur, 'Value', mainGUIdata.data.eye.stats.trldur);
set(handles.cb_path_spat, 'Value', mainGUIdata.data.eye.stats.scanspat);

set(handles.cb_init_fix, 'Value', mainGUIdata.data.eye.stats.fix.first);
set(handles.cb_fix_order, 'Value', mainGUIdata.data.eye.stats.fix.order);
set(handles.cb_first_fix_ons, 'Value', mainGUIdata.data.eye.stats.fix.firstons);
set(handles.cb_first_fix_dur, 'Value', mainGUIdata.data.eye.stats.fix.firstdur);

set(handles.cb_roi_valid_all, 'Value', mainGUIdata.data.eye.stats.roi.all_stim_only);
set(handles.cb_first_sacc_dir, 'Value', mainGUIdata.data.eye.stats.sac.firstdir);
set(handles.cb_first_sacc_lat, 'Value', mainGUIdata.data.eye.stats.sac.firstlat);

set(handles.cb_agg_roi_norm, 'Value', mainGUIdata.data.eye.stats.roi.norm);
set(handles.cb_corr, 'Value', mainGUIdata.data.eye.stats.corr);

%listboxes
set(handles.lb_times_used, 'String', mainGUIdata.data.eye.stats.times);

set(handles.lb_exp_used, 'String', mainGUIdata.data.eye.stats.roi_exp);

roiall = [];
if ~any(strcmp(mainGUIdata.data.eye.stats.roi_exp,'screen'))
    roiall{1} = 'screen';
end;
%1.rois could be disabled
%2.roi names could be multi use for different pics
%3.roi names could be already used in selected list.
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ~any(strcmp(roiall,mainGUIdata.data.eye.ROI(i).name)) && ~any(strcmp(mainGUIdata.data.eye.stats.roi_exp,mainGUIdata.data.eye.ROI(i).name))
        roiall{end + 1} = mainGUIdata.data.eye.ROI(i).name;
    end;
end;
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ...
            ~any(strcmp(roiall,['tag_' mainGUIdata.data.eye.ROI(i).tag1]))  && ...
            ~any(strcmp(mainGUIdata.data.eye.stats.roi_exp,['tag_' mainGUIdata.data.eye.ROI(i).tag1]))
        roiall{end + 1} = ['tag_' mainGUIdata.data.eye.ROI(i).tag1];
    end;
end;
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ...
            ~any(strcmp(roiall,['tag_' mainGUIdata.data.eye.ROI(i).tag2]))  && ...
            ~any(strcmp(mainGUIdata.data.eye.stats.roi_exp,['tag_' mainGUIdata.data.eye.ROI(i).tag2]))
        roiall{end + 1} = ['tag_' mainGUIdata.data.eye.ROI(i).tag2];
    end;
end;
set(handles.lb_exp_all, 'String', roiall);
roiall = [];
if ~any(strcmp(mainGUIdata.data.eye.stats.fix.relrois,'screen'))
    roiall{1} = 'screen';
end;
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ~any(strcmp(roiall,mainGUIdata.data.eye.ROI(i).name)) && ~any(strcmp(mainGUIdata.data.eye.stats.fix.relrois,mainGUIdata.data.eye.ROI(i).name))
        roiall{end + 1} = mainGUIdata.data.eye.ROI(i).name;
    end;
end;
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ~any(strcmp(roiall,['tag_' mainGUIdata.data.eye.ROI(i).tag1])) && ~any(strcmp(mainGUIdata.data.eye.stats.fix.relrois,['tag_' mainGUIdata.data.eye.ROI(i).tag1]))
        roiall{end + 1} = ['tag_' mainGUIdata.data.eye.ROI(i).tag1];
    end;
end;
for i=1:length(mainGUIdata.data.eye.ROI)
    if mainGUIdata.data.eye.ROI(i).enabled && ~any(strcmp(roiall,['tag_' mainGUIdata.data.eye.ROI(i).tag2])) && ~any(strcmp(mainGUIdata.data.eye.stats.fix.relrois,['tag_' mainGUIdata.data.eye.ROI(i).tag2]))
        roiall{end + 1} = ['tag_' mainGUIdata.data.eye.ROI(i).tag2];
    end;
end;
set(handles.lb_fix_rel_all_rois, 'String', roiall);
set(handles.lb_fix_rel_used_rois, 'String', mainGUIdata.data.eye.stats.fix.relrois);

%edits
if ~isempty(mainGUIdata.data.eye.stats.fname)
    set(handles.ed_fname, 'String', mainGUIdata.data.eye.stats.fname);
end;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchjobs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_analysis_OutputFcn(hObject, eventdata, handles)
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
stats = mainGUIdata.data.eye.stats;
lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> Analysis updated <<<'}];

[stats.fix.da_cum, lbstring ] =  GA_gui_get(lbstring, 'abs fix dur cumulative: ', stats.fix.da_cum, handles.cb_fix_abs_cum, 'Value');
[stats.fix.da_mean, lbstring ] =  GA_gui_get(lbstring, 'abs fix dur mean: ', stats.fix.da_mean, handles.cb_fix_abs_mean, 'Value');
[stats.fix.dr_mean, lbstring ] =  GA_gui_get(lbstring, 'rel fix dur mean: ', stats.fix.dr_mean, handles.cb_fix_rel_mean, 'Value');
[stats.fix.dr_cum, lbstring ] =  GA_gui_get(lbstring, 'rel fix dur cumulative: ', stats.fix.dr_cum, handles.cb_fix_rel_cum, 'Value');
[stats.roi.all_stim_only, lbstring ] =  GA_gui_get(lbstring, 'use only rois valid for all pics: ', stats.roi.all_stim_only, handles.cb_roi_valid_all, 'Value');
[stats.fix.nr, lbstring ] =  GA_gui_get(lbstring, 'rel fix count: ', stats.fix.nr, handles.cb_nrfix, 'Value');
[stats.fix.na, lbstring ] =  GA_gui_get(lbstring, 'abs fix count: ', stats.fix.na, handles.cb_nafix, 'Value');
[stats.fix.sacrat, lbstring ] =  GA_gui_get(lbstring, 'fix sacc ratio: ', stats.fix.sacrat, handles.cb_fix_sacc, 'Value');
[stats.scanspat, lbstring ] =  GA_gui_get(lbstring, 'scanpath spat: ', stats.scanspat, handles.cb_path_spat, 'Value');
[stats.fix.first, lbstring ] =  GA_gui_get(lbstring, 'first fixed roi : ', stats.fix.first, handles.cb_init_fix, 'Value');
[stats.sac.firstdir, lbstring ] =  GA_gui_get(lbstring, 'first sacc dir : ', stats.sac.firstdir, handles.cb_first_sacc_dir, 'Value');
[stats.sac.firstlat, lbstring ] =  GA_gui_get(lbstring, 'first sacc latenz : ', stats.sac.firstlat, handles.cb_first_sacc_lat, 'Value');
[stats.fix.firstons, lbstring ] =  GA_gui_get(lbstring, 'first fix onset : ', stats.fix.firstons, handles.cb_first_fix_ons, 'Value');
[stats.fix.firstdur, lbstring ] =  GA_gui_get(lbstring, 'first fix duration : ', stats.fix.firstdur, handles.cb_first_fix_dur, 'Value');

[stats.fix.order, lbstring ] =  GA_gui_get(lbstring, 'roi fix order: ', stats.fix.order, handles.cb_fix_order, 'Value');
[stats.roi.norm, lbstring ] =  GA_gui_get(lbstring, 'area normed rois: ', stats.roi.norm, handles.cb_agg_roi_norm, 'Value');
[stats.corr, lbstring ] =  GA_gui_get(lbstring, 'use correction params: ', stats.corr, handles.cb_corr, 'Value');
[stats.valid, lbstring ] =  GA_gui_get(lbstring, 'report trial validation: ', stats.valid, handles.cb_trl_valid, 'Value');
[stats.qual, lbstring ] =  GA_gui_get(lbstring, 'global data quality report : ', stats.qual, handles.cb_qual, 'Value');
[stats.sort, lbstring ] =  GA_gui_get(lbstring, 'sort for condition number: ', stats.sort, handles.cb_sort, 'Value');
[stats.covar, lbstring ] =  GA_gui_get(lbstring, 'report covariates: ', stats.covar, handles.cb_covar, 'Value');
[stats.trldur, lbstring ] =  GA_gui_get(lbstring, 'report trial dur: ', stats.trldur, handles.cb_report_dur, 'Value');
[stats.separatrows, lbstring ] =  GA_gui_get(lbstring, 'report each trial in separat row: ', stats.separatrows, handles.cb_separat, 'Value');
[stats.times, lbstring ] =  GA_gui_get(lbstring, 'times: ', stats.times, handles.lb_times_used, 'String');
[stats.roi_exp, lbstring ] =  GA_gui_get(lbstring, 'analysis rois: ', stats.roi_exp, handles.lb_exp_used, 'String');
[stats.fix.relrois, lbstring ] =  GA_gui_get(lbstring, 'related rois: ', stats.fix.relrois, handles.lb_fix_rel_used_rois, 'String');

if ~strcmp(get(handles.ed_fname, 'String'),'GA_SPSS.txt (default)')
    [stats.fname, lbstring ] =  GA_gui_get(lbstring, 'analysis file name: ', stats.fname, handles.ed_fname, 'String');
end

mainGUIdata.data.eye.stats= stats;

if ~strcmp(lbstring{end},'>>> Analysis updated <<<')
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

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in cb_dafix.
function cb_dafix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_dafix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_dafix


% --- Executes on button press in cb_path_spat.
function cb_path_spat_Callback(hObject, eventdata, handles)
% hObject    handle to cb_path_spat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_path_spat

% --- Executes on button press in cb_cum_abs.
function cb_cum_abs_Callback(hObject, eventdata, handles)
% hObject    handle to cb_cum_abs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_cum_abs

% --- Executes on button press in pb_fix_rel_use.
function pb_fix_rel_use_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fix_rel_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%selected string
selected = get(handles.lb_fix_rel_all_rois,'Value');
sel_string_all = get(handles.lb_fix_rel_all_rois, 'String');
sel_string = sel_string_all(selected);

%del from selection list
len = length(sel_string_all);
if len > 0
    index = 1:len;
    sel_string_all = sel_string_all(find(index ~= selected),1);
    set(handles.lb_fix_rel_all_rois, 'String', sel_string_all, 'Value', min(selected, length(sel_string_all)));
end;

%add to list oft used strings and sort
prev_str = get(handles.lb_fix_rel_used_rois, 'String');
prev_str(end + 1) = sel_string;
[prev_str, IX] = sort(prev_str);
set(handles.lb_fix_rel_used_rois, 'String', prev_str, 'Value', find(IX==length(prev_str)));

% --- Executes on button press in pb_fix_rel_del.
function pb_fix_rel_del_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fix_rel_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%selected string
selected = get(handles.lb_fix_rel_used_rois,'Value');
sel_string_all = get(handles.lb_fix_rel_used_rois, 'String');
sel_string = sel_string_all(selected);

%del from selection list
len = length(sel_string_all);
if len > 0
    index = 1:len;
    sel_string_all = sel_string_all(find(index ~= selected),1);
    set(handles.lb_fix_rel_used_rois, 'String', sel_string_all, 'Value', min(selected, length(sel_string_all)));
end;

%add to list of strings and sort
prev_str = get(handles.lb_fix_rel_all_rois, 'String');
prev_str(end + 1) = sel_string;
[prev_str, IX] = sort(prev_str);
set(handles.lb_fix_rel_all_rois, 'String', prev_str, 'Value', find(IX==length(prev_str)));


% --- Executes on selection change in lb_fix_rel_used_rois.
function lb_fix_rel_used_rois_Callback(hObject, eventdata, handles)
% hObject    handle to lb_fix_rel_used_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_fix_rel_used_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_fix_rel_used_rois


% --- Executes during object creation, after setting all properties.
function lb_fix_rel_used_rois_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_fix_rel_used_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_fix_rel_all_rois.
function lb_fix_rel_all_rois_Callback(hObject, eventdata, handles)
% hObject    handle to lb_fix_rel_all_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_fix_rel_all_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_fix_rel_all_rois


% --- Executes during object creation, after setting all properties.
function lb_fix_rel_all_rois_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_fix_rel_all_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cb_fix_abs_mean.
function cb_fix_abs_mean_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_abs_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_abs_mean


% --- Executes on button press in cb_fix_rel_cum.
function cb_fix_rel_cum_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_rel_cum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_rel_cum


% --- Executes on button press in cb_fix_rel_mean.
function cb_fix_rel_mean_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_rel_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_rel_mean


% --- Executes on button press in cb_nafix.
function cb_nafix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_nafix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_nafix


% --- Executes on button press in cb_nrfix.
function cb_nrfix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_nrfix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_nrfix


% --- Executes on button press in pb_exp_use.
function pb_exp_use_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exp_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string
selected = get(handles.lb_exp_all,'Value');
sel_string_all = get(handles.lb_exp_all, 'String');
sel_string = sel_string_all(selected);

%del from selection list
len = length(sel_string_all);
if len > 0
    index = 1:len;
    sel_string_all = sel_string_all(find(index ~= selected),1);
    set(handles.lb_exp_all, 'String', sel_string_all, 'Value', min(selected, length(sel_string_all)));
end;

%add to list oft used strings and sort
prev_str = get(handles.lb_exp_used, 'String');
prev_str(end + 1) = sel_string;
[prev_str, IX] = sort(prev_str);
set(handles.lb_exp_used, 'String', prev_str, 'Value', find(IX==length(prev_str)));

% --- Executes on button press in pb_exp_del.
function pb_exp_del_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exp_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string
selected = get(handles.lb_exp_used,'Value');
sel_string_all = get(handles.lb_exp_used, 'String');
sel_string = sel_string_all(selected);

%del from selection list
len = length(sel_string_all);
if len > 0
    index = 1:len;
    sel_string_all = sel_string_all(find(index ~= selected),1);
    set(handles.lb_exp_used, 'String', sel_string_all, 'Value', min(selected, length(sel_string_all)));
end;

%add to list oft used strings and sort
prev_str = get(handles.lb_exp_all, 'String');
prev_str(end + 1) = sel_string;
[prev_str, IX] = sort(prev_str);
set(handles.lb_exp_all, 'String', prev_str, 'Value', find(IX==length(prev_str)));

% --- Executes on selection change in lb_exp_used.
function lb_exp_used_Callback(hObject, eventdata, handles)
% hObject    handle to lb_exp_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_exp_used contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_exp_used


% --- Executes during object creation, after setting all properties.
function lb_exp_used_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_exp_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_exp_all.
function lb_exp_all_Callback(hObject, eventdata, handles)
% hObject    handle to lb_exp_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_exp_all contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_exp_all


% --- Executes during object creation, after setting all properties.
function lb_exp_all_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_exp_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_fix_sacc.
function cb_fix_sacc_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_sacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_sacc


% --- Executes during object creation, after setting all properties.
function ed_ons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_init_fix.
function cb_init_fix_Callback(hObject, eventdata, handles)
% hObject    handle to cb_init_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_init_fix


% --- Executes on button press in cb_fix_order.
function cb_fix_order_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_order


% --- Executes on selection change in lb_time_used.
function lb_time_used_Callback(hObject, eventdata, handles)
% hObject    handle to lb_time_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_time_used contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_time_used


% --- Executes during object creation, after setting all properties.
function lb_time_used_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_time_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in rb_time_perc.
function rb_time_perc_Callback(hObject, eventdata, handles)
% hObject    handle to rb_time_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_time_perc


% --- Executes on button press in rb_time_abs.
function rb_time_abs_Callback(hObject, eventdata, handles)
% hObject    handle to rb_time_abs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_time_abs


% --- Executes on button press in cb_fix_abs_cum.
function cb_fix_abs_cum_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fix_abs_cum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fix_abs_cum



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ons as text
%        str2double(get(hObject,'String')) returns contents of ed_ons as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_times_use.
function pb_times_use_Callback(hObject, eventdata, handles)
% hObject    handle to pb_times_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string
ons = get(handles.ed_ons,'string');
offs = get(handles.ed_offs,'string');


if get(handles.rb_times_abs,'Value')
    if get(handles.chk_ons_end,'Value')
        ons = ['end-' ons];
    end;
    if get(handles.chk_off_end,'Value')
        offs = ['end-' offs];
    end;
    selected = [ons '_' offs 'ms'];
else
    selected = [ons '_' offs '%'];
end;

%add to list oft used strings and sort
prev_str = get(handles.lb_times_used, 'String');
if ~any(strcmp(prev_str,selected))
    
    prev_str{end + 1} = selected;
    [prev_str, IX] = sort(prev_str);
    set(handles.lb_times_used, 'String', prev_str, 'Value', find(IX==length(prev_str)));
end;

% --- Executes on button press in pb_times_del.
function pb_times_del_Callback(hObject, eventdata, handles)
% hObject    handle to pb_times_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected string
selected = get(handles.lb_times_used,'Value');
sel_string_all = get(handles.lb_times_used, 'String');
sel_string = sel_string_all(selected);

%del from selection list
len = length(sel_string_all);
if len > 0
    index = 1:len;
    sel_string_all = sel_string_all(find(index ~= selected),1);
    set(handles.lb_times_used, 'String', sel_string_all, 'Value', min(selected, length(sel_string_all)));
end;

% --- Executes on selection change in lb_times_used.
function lb_times_used_Callback(hObject, eventdata, handles)
% hObject    handle to lb_times_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_times_used contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_times_used


% --- Executes during object creation, after setting all properties.
function lb_times_used_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_times_used (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_ons_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ons as text
%        str2double(get(hObject,'String')) returns contents of ed_ons as a double

val= get(handles.ed_ons,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
set(handles.ed_ons,'String',num2str(val));

function ed_offs_Callback(hObject, eventdata, handles)
% hObject    handle to ed_offs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_offs as text
%        str2double(get(hObject,'String')) returns contents of ed_offs as a double
val= get(handles.ed_offs,'String');
s1 = regexp(val, '[0-9]');
val = str2double(val(s1));
if isnan(val)
    val=0;
end;
ons=str2double(get(handles.ed_ons,'String'));
if isnan(ons)
    ons=0;
end;
if get(handles.rb_times_rel,'Value') && val > 100
    val = 100;
end;
set(handles.ed_offs,'String',num2str(val));

% --- Executes during object creation, after setting all properties.
function ed_offs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_offs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel18.
function uipanel18_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel18
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.rb_times_rel,'Value')
    ons= str2double(get(handles.ed_ons,'String'));
    offs=str2double(get(handles.ed_offs,'String'));
    if offs > 100
        offs = 0;
    end;
    if ons >= 100
        ons = 0;
    end;
    set(handles.ed_ons,'String',num2str(ons));
    set(handles.ed_offs,'String',num2str(offs));
    set(handles.chk_ons_end,'Enable','Off');
    set(handles.chk_off_end,'Enable','Off');
else
    set(handles.chk_ons_end,'Enable','On');
    set(handles.chk_off_end,'Enable','On');
end;



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_dir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dir as text
%        str2double(get(hObject,'String')) returns contents of ed_dir as a double


% --- Executes during object creation, after setting all properties.
function ed_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in cb_agg_roi_norm.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to cb_agg_roi_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_agg_roi_norm


% --- Executes on button press in cb_corr.
function cb_corr_Callback(hObject, eventdata, handles)
% hObject    handle to cb_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_corr


% --- Executes on button press in cb_covar.
function cb_covar_Callback(hObject, eventdata, handles)
% hObject    handle to cb_covar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_covar


% --- Executes on button press in cb_report_dur.
function cb_report_dur_Callback(hObject, eventdata, handles)
% hObject    handle to cb_report_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_report_dur


% --- Executes on button press in cb_sort.
function cb_sort_Callback(hObject, eventdata, handles)
% hObject    handle to cb_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_sort


% --- Executes on button press in cb_agg_roi_norm.
function cb_agg_roi_norm_Callback(hObject, eventdata, handles)
% hObject    handle to cb_agg_roi_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_agg_roi_norm


% --- Executes on button press in chk_ons_end.
function chk_ons_end_Callback(hObject, eventdata, handles)
% hObject    handle to chk_ons_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_ons_end


% --- Executes on button press in chk_off_end.
function chk_off_end_Callback(hObject, eventdata, handles)
% hObject    handle to chk_off_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_off_end


% --- Executes on button press in cb_trl_valid.
function cb_trl_valid_Callback(hObject, eventdata, handles)
% hObject    handle to cb_trl_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_trl_valid


% --- Executes on button press in cb_first_sacc_dir.
function cb_first_sacc_dir_Callback(hObject, eventdata, handles)
% hObject    handle to cb_first_sacc_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_first_sacc_dir


% --- Executes on button press in cb_first_sacc_lat.
function cb_first_sacc_lat_Callback(hObject, eventdata, handles)
% hObject    handle to cb_first_sacc_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_first_sacc_lat


% --- Executes on button press in cb_qual.
function cb_qual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_qual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_qual


% --- Executes on button press in cb_separat.
function cb_separat_Callback(hObject, eventdata, handles)
% hObject    handle to cb_separat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_separat


% --- Executes on button press in cb_roi_valid_all.
function cb_roi_valid_all_Callback(hObject, eventdata, handles)
% hObject    handle to cb_roi_valid_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_roi_valid_all


% --- Executes on button press in cb_first_fix_ons.
function cb_first_fix_ons_Callback(hObject, eventdata, handles)
% hObject    handle to cb_first_fix_ons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_first_fix_ons


% --- Executes on button press in cb_first_fix_dur.
function cb_first_fix_dur_Callback(hObject, eventdata, handles)
% hObject    handle to cb_first_fix_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_first_fix_dur
