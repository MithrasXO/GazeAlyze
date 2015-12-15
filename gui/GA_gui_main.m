function varargout = GA_gui_main(varargin)
% GA_gui_main M-file for GA_gui_main.fig
%      GA_gui_main, by itself, creates a new GA_gui_main or raises the existing
%      singleton*.
%
%      H = GA_gui_main returns the handle to a new GA_gui_main or the handle to
%      the existing singleton*.
%
%      GA_gui_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_gui_main.M with the given input arguments.
%
%      GA_gui_main('Property','Value',...) creates a new GA_gui_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GA_gui_main before GA_gui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_main_OpeningFcn via varargin.
%
%      *See GA_gui_main Options on GUIDE's Tools menu.  Choose "GA_gui_main allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_main

% Last Modified by GUIDE v2.5 18-Mar-2013 13:45:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_main_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_main_OutputFcn, ...
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


% --- Executes just before GA_gui_main is made visible.
function GA_gui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_main (see VARARGIN)

% Choose default command line output for GA_gui_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GA_gui_main wait for user response (see UIRESUME)
% uiwait(handles.GA_mainWin);
set(gcf,'CloseRequestFcn',@closereqfun)

function closereqfun(src,evnt)
% User-defined close request function
% to display a question dialog box
handles = guidata(gcf);

if strcmp(get(handles.uipt_run, 'Enable'), 'on')
    
    selection = questdlg('Save the changes to your controlfile?',...
        'Close Request Function',...
        'Yes','No','Cancel','Yes');
    switch selection,
        case 'Yes',
            
            if isfield(handles, 'temp')
%                 if handles.data.eye.rois_in_mat
%                     save(fullfile(handles.temp.path, [handles.temp.file(1:end-2) '_rois.mat']),  '-struct', 'handles.data.eye', 'ROI');
%                     handles.data.eye = rmfield(handles.data.eye,'ROI');
%                 end;
                
                mfiledata = gencode(handles.data);
                
                mfiledatasize = length(mfiledata);
                
                fid = fopen([handles.temp.path handles.temp.file], 'w');
                
                fprintf(fid,'%s\n', ['function [eye] = ' handles.temp.file(1:end-2) '()']);
                
                for k=1:mfiledatasize
                    
                    mfiledata{1,k}= mfiledata{1,k}(5:end);
                    fprintf(fid,'%s\n', mfiledata{1,k});
                    
                end;
                
            else
                [FileName,PathName] = uiputfile('*.m','Save As...');
                
                handles.temp.path = PathName;
                handles.temp.file = FileName;
                
                if FileName~=0
                    set(handles.txt_control,'String', FileName);
                    
%                     if handles.data.eye.rois_in_mat
%                         save(fullfile(handles.temp.path, [handles.temp.file(1:end-2) '_rois.mat']),  '-struct', 'handles.data.eye', 'ROI');
%                         handles.data = rmfield(handles.data.eye,'ROI');
%                     end;
                    
                    mfiledata = gencode(handles.data);
                    
                    mfiledatasize = length(mfiledata);
                    
                    fid = fopen([PathName FileName], 'w');
                    
                    fprintf(fid,'%s\n', ['function [eye] = ' handles.temp.file(1:end-2) '()']);
                    
                    for k=1:mfiledatasize
                        
                        mfiledata{1,k}= mfiledata{1,k}(5:end);
                        fprintf(fid,'%s\n', mfiledata{1,k});
                        
                    end;
                end;
            end
            
            fclose('all');
            delete(gcf)
            
        case 'No'
            delete(gcf)
        case 'Cancel'
            return;
    end
else
    delete(gcf)
end
% check whether GazeAlyze is on the path
% remove gazealyze path
[pth]=fileparts(which('gazealyze'));
if ~isempty(strfind(path, pth))
    rmpath(genpath(pth));
    addpath(pth);
end;
close all

disp(' ');
disp('Thanks for using GazeAlyze.');
disp('_____________________________________________________________________________________________');
disp('GazeAlyze (c) 20010-2015 Christoph Berger & Martin Winkels, University of Rostock, Germany');


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%--------------------------------------------------------------------------
%Menu 1 File
%--------------------------------------------------------------------------

function Menu_File_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu1_1_New_Callback(hObject, eventdata, handles)
% hObject    handle to Menu1_1_New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.data.eye]=GA_new_cntrl_template();
%
set(handles.uipt_save, 'Enable', 'on');
set(handles.uipt_run, 'Enable', 'on');
%
% set(handles.uit_corr, 'Enable', 'on');
% set(handles.uit_corre, 'Enable', 'on');
% set(handles.uit_import, 'Enable', 'on');
% set(handles.uit_preproc, 'Enable', 'on');

set(handles.Menu1_4_Save, 'Enable', 'off');
set(handles.Menu1_5_SaveAs, 'Enable', 'on');
set(handles.Menu1_6_Print, 'Enable', 'off');
set(handles.Menu_Data, 'Enable', 'on');
set(handles.Menu_Trials, 'Enable', 'on');
set(handles.Menu_Preprocessing, 'Enable', 'on');
set(handles.Menu_Directories, 'Enable', 'on');
set(handles.Menu_ROIS, 'Enable', 'on');
set(handles.Menu_Plot, 'Enable', 'on');
set(handles.Menu_Correction, 'Enable', 'on');
set(handles.Menu_Analysis, 'Enable', 'on');
set(handles.Menu_Batch, 'Enable', 'on');
set(handles.Menu_Heatmaps, 'Enable', 'on');
set(handles.Menu_IncludeExclude, 'Enable', 'on');

set(handles.listbox_progress, 'String', 'new datafile created');
set(handles.listbox_progress,'Value',[])
set(handles.listbox_overview, 'ListboxTop', 1);

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')

set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

if isfield(handles, 'temp')
    
    handles = rmfield(handles, 'temp');
    
end

set(handles.txt_control,'String', 'new controlfile');

%Generate Data for Listbox Parameter Overview
GA_gui_set(handles, 1)

guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu1_2_Load_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to Menu1_2_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[FileName,PathName] = uigetfile('*.m','Select File...');

if FileName~=0
    
    cd(PathName)
    [handles.data.eye] = eval(FileName(1:end-2));
    
    handles.temp.path=PathName;
    handles.temp.file=FileName;
    
    %set(handles.uipt_save, 'Enable', 'on');
    set(handles.uipt_run, 'Enable', 'on');
    %     set(handles.uit_corr, 'Enable', 'on');
    % set(handles.uit_corre, 'Enable', 'on');
    % set(handles.uit_import, 'Enable', 'on');
    % set(handles.uit_preproc, 'Enable', 'on');
    
    
    set(handles.Menu1_4_Save, 'Enable', 'on');
    set(handles.Menu1_5_SaveAs, 'Enable', 'on');
    set(handles.Menu1_6_Print, 'Enable', 'on');
    set(handles.Menu_Data, 'Enable', 'on');
    set(handles.Menu_Trials, 'Enable', 'on');
    set(handles.Menu_Preprocessing, 'Enable', 'on');
    set(handles.Menu_Directories, 'Enable', 'on');
    set(handles.Menu_ROIS, 'Enable', 'on');
    set(handles.Menu_Plot, 'Enable', 'on');
    set(handles.Menu_Correction, 'Enable', 'on');
    set(handles.Menu_Analysis, 'Enable', 'on');
    set(handles.Menu_Batch, 'Enable', 'on');
    set(handles.Menu_Heatmaps, 'Enable', 'on');
    set(handles.Menu_IncludeExclude, 'Enable', 'on');
    
    set(handles.Menu2_1_viewpoint,'Checked', 'off')    
    set(handles.Menu2_2_Iscan,'Checked', 'off')
    set(handles.Menu2_3_Iview,'Checked', 'off')
    set(handles.Menu2_4_Tobi,'Checked', 'off')    
    set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
    
    set(handles.Menu2_6_ASL,'Checked', 'off')
    set(handles.Menu2_7_CB,'Checked', 'off')
    set(handles.Menu2_8_Cortex,'Checked', 'off')
    set(handles.Menu2_9_tfCB,'Checked', 'off')
    set(handles.Menu2_10_custom,'Checked', 'off')
    
    set(handles.listbox_progress, 'String', 'Data has been loaded!');
    set(handles.listbox_progress,'Value',[])
    set(handles.listbox_progress,'ListboxTop',1)
    set(handles.listbox_progress,'Max',2)
    
    if strcmp(handles.data.eye.datatype, 'Viewpoint')
        set(handles.Menu2_1_viewpoint,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'ASL')
        set(handles.Menu2_6_ASL,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'CB')
        set(handles.Menu2_7_CB,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'CORTEX')
        set(handles.Menu2_8_Cortex,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'ISCAN')
        set(handles.Menu2_2_Iscan,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'IVIEW')
        set(handles.Menu2_3_Iview,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'Tobii')
        set(handles.Menu2_4_Tobi,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'MonkeyLogic')
        set(handles.Menu2_5_MonkeyLogic,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'TextFileCB')
        set(handles.Menu2_9_tfCB,'Checked', 'on')
        
    elseif strcmp(handles.data.eye.datatype, 'Custom')
        set(handles.Menu2_10_custom,'Checked', 'on')
        
    end
    set(handles.txt_control,'String', FileName);
    
    %Generate Data for Listbox Parameter Overview
    GA_gui_set(handles, 1)
    
end;



guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu1_3_Edit_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to Menu1_3_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.m','Select the M-file');

if FileName~=0
    
    open([PathName FileName]);
    
end;


% --------------------------------------------------------------------
function Menu1_4_Save_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
% hObject    handle to Menu1_4_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'temp')
    
    mfiledata = gencode(handles.data);
    
    mfiledatasize = length(mfiledata);
    
    fid = fopen([handles.temp.path handles.temp.file], 'w');
    
    fprintf(fid,'%s\n', ['function [eye] = ' handles.temp.file(1:end-2) '()']);
    
    for k=1:mfiledatasize
        
        mfiledata{1,k}= mfiledata{1,k}(5:end);
        
        fprintf(fid,'%s\n', mfiledata{1,k});
        
    end;
    
else
    [FileName,PathName] = uiputfile('*.m','Save As...');
    
    
    
    handles.temp.path = PathName;
    handles.temp.file = FileName;
    
    if FileName~=0
        set(handles.txt_control,'String', FileName);
        
%         if handles.data.eye.rois_in_mat
%             save(fullfile(handles.temp.path, [handles.temp.file(1:end-2) '_rois.mat']),  '-struct', 'handles.data.eye', 'ROI');
%             handles.data.eye = rmfield(handles.data.eye,'ROI');
%         end;
        
        mfiledata = gencode(handles.data);
        
        mfiledatasize = length(mfiledata);
        
        fid = fopen([PathName FileName], 'w');
        
        fprintf(fid,'%s\n', ['function [eye] = ' handles.temp.file(1:end-2) '()']);
        
        for k=1:mfiledatasize
            
            mfiledata{1,k}= mfiledata{1,k}(5:end);
            
            fprintf(fid,'%s\n', mfiledata{1,k});
            
        end;
        
        fclose('all');
        
        set(handles.Menu1_4_Save, 'Enable', 'on');
        set(handles.Menu1_6_Print, 'Enable', 'on');
    end;
end

lbstring = get(handles.listbox_progress, 'String');
lbstring = [lbstring; {'>>> file saved <<<'}];
set(handles.listbox_progress, 'String', lbstring);
set(handles.listbox_progress, 'Max', length(lbstring));
set(handles.listbox_progress, 'Value', length(lbstring));

set(handles.uipt_save, 'Enable', 'off');

fclose('all');
guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu1_5_SaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to Menu1_5_SaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uiputfile('*.m','Save As...');

handles.temp.path = PathName;
handles.temp.file = FileName;

if FileName~=0
    set(handles.txt_control,'String', FileName);
    
%     if handles.data.eye.rois_in_mat
%         save(fullfile(handles.temp.path, [handles.temp.file(1:end-2) '_rois.mat']),  '-struct', 'handles.data.eye', 'ROI');
%         handles.data.eye = rmfield(handles.data.eye,'ROI');
%     end;
    mfiledata = gencode(handles.data);
    
    mfiledatasize = length(mfiledata);
    
    fid = fopen([PathName FileName], 'w');
    
    fprintf(fid,'%s\n', ['function [eye] = ' handles.temp.file(1:end-2) '()']);
    
    for k=1:mfiledatasize
        
        mfiledata{1,k}= mfiledata{1,k}(5:end);
        
        fprintf(fid,'%s\n', mfiledata{1,k});
        
    end;
    
    fclose('all');
    
    set(handles.Menu1_4_Save, 'Enable', 'on');
    set(handles.Menu1_6_Print, 'Enable', 'on');
    
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'>>> file saved <<<'}];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Max', length(lbstring));
    set(handles.listbox_progress, 'Value', length(lbstring));
    
end;
guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu1_6_Print_Callback(hObject, eventdata, handles)
% hObject    handle to Menu1_6_Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%SPÄTER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function Menu1_7_Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Menu1_7_Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close all;




%--------------------------------------------------------------------------
%Menu 2 DataType
%--------------------------------------------------------------------------


function Menu_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu2_1_viewpoint_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_1_viewpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'Viewpoint';

if  ~strcmp(get(handles.Menu2_1_viewpoint,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = Viewpoint'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'on')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_6_ASL_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_6_ASL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype='ASL';

% Construct a questdlg with three options
choice = questdlg('ASL Datatype 5000 or 6000:', ...
    'ASL Datatype', ...
    '5000','6000','6000');
% Handle response
switch choice
    case '5000'
        handles.data.eye.datatype_custval = '5';
        
    case '6000'
        handles.data.eye.datatype_custval = '6';
end


if ~strcmp(get(handles.Menu2_6_ASL,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = ASL'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

lbstring = get(handles.listbox_progress, 'String');
lbstring = [lbstring; {'ASL value updatet:!'}];
lbstring = [lbstring; ['ASL Type = ' handles.data.eye.datatype_custval]];
set(handles.listbox_progress, 'String', lbstring);
set(handles.listbox_progress, 'Value', []);

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'on')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')


guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_7_CB_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_7_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype = 'CB';

if ~strcmp(get(handles.Menu2_7_CB,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = CB'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'on')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_8_Cortex_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_8_Cortex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'CORTEX';

if ~strcmp(get(handles.Menu2_8_Cortex,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = CORTEX'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'on')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_2_Iscan_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_2_Iscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype='ISCAN';

if ~strcmp(get(handles.Menu2_2_Iscan,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = ISCAN'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'on')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')


guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_3_Iview_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_3_Iview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'IVIEW';

if ~strcmp(get(handles.Menu2_3_Iview,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = IVIEW'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'on')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu2_4_Tobi_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_4_Tobi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'Tobii';

if ~strcmp(get(handles.Menu2_4_Tobi,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = Tobii'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'on')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu2_5_MonkeyLogic_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_5_MonkeyLogic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.eye.datatype= 'MonkeyLogic';

if ~strcmp(get(handles.Menu2_5_MonkeyLogic,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = MonkeyLogic'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'on')
set(handles.Menu2_9_tfCB,'Checked', 'on')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu2_9_tfCB_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_9_tfCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'TextFileCB';

if ~strcmp(get(handles.Menu2_9_tfCB,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = TextFileCB'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'on')
set(handles.Menu2_10_custom,'Checked', 'off')

guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu2_10_custom_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2_10_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.eye.datatype= 'Custom';

if ~strcmp(get(handles.Menu2_10_custom,'Checked'), 'on')
    lbstring = get(handles.listbox_progress, 'String');
    lbstring = [lbstring; {'Datatype updatet!'}];
    lbstring = [lbstring; 'Data-Type = Custom'];
    set(handles.listbox_progress, 'String', lbstring);
    set(handles.listbox_progress, 'Value', []);
end

set(handles.Menu2_1_viewpoint,'Checked', 'off')
set(handles.Menu2_6_ASL,'Checked', 'off')
set(handles.Menu2_7_CB,'Checked', 'off')
set(handles.Menu2_8_Cortex,'Checked', 'off')
set(handles.Menu2_2_Iscan,'Checked', 'off')
set(handles.Menu2_3_Iview,'Checked', 'off')
set(handles.Menu2_4_Tobi,'Checked', 'off')
set(handles.Menu2_5_MonkeyLogic,'Checked', 'off')
set(handles.Menu2_9_tfCB,'Checked', 'off')
set(handles.Menu2_10_custom,'Checked', 'on')

GA_gui_custom_datatype(handles.GA_mainWin);

guidata(hObject, handles);

%--------------------------------------------------------------------------
%Menu 3 Import
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function Menu_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu3_1_TrialWizz_Callback(hObject, eventdata, handles)
% hObject    handle to Menu3_1_TrialWizz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(handles.data.eye.datatype,'viewpoint') || strcmpi(handles.data.eye.datatype,'iview')|| strcmpi(handles.data.eye.datatype,'iscan')|| strcmpi(handles.data.eye.datatype,'monkeylogic')
    GA_gui_events_import(handles.GA_mainWin);
elseif strcmpi(handles.data.eye.datatype,'Tobii') 
    GA_gui_events_import_eprime(handles.GA_mainWin);
else
    GA_gui_events_ILAB(handles.GA_mainWin);
end;


% --------------------------------------------------------------------
function Menu3_2_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu3_2_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('import',handles.data.eye)



%--------------------------------------------------------------------------
%Menu 4 Preprocessing
%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Preprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Preprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu4_1_screensize_Callback(hObject, eventdata, handles)
% hObject    handle to Menu4_1_screensize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_screensize(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu4_2_ilabset_Callback(hObject, eventdata, handles)
% hObject    handle to Menu4_2_ilabset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_ilabset();

% --------------------------------------------------------------------
function Menu4_4_RunCheck_Callback(hObject, eventdata, handles)
% hObject    handle to Menu4_4_RunCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('consistency',handles.data.eye)


% --------------------------------------------------------------------
function Menu4_5_RunILAB_Callback(hObject, eventdata, handles)
% hObject    handle to Menu4_5_RunILAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('preprocessing',handles.data.eye)



%--------------------------------------------------------------------------
%Menu5 Directories
%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Directories_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Directories (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu5_1_EditD_Callback(hObject, eventdata, handles)
% hObject    handle to Menu5_1_EditD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_editdir(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu5_2_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Menu5_2_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_files(handles.GA_mainWin);



%--------------------------------------------------------------------------
%Menu6 ROIs
%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_ROIS_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_ROIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu6_1_NewROI_Callback(hObject, eventdata, handles)
% hObject    handle to Menu6_1_NewROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig = GA_gui_ROIeditor(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu6_2_EditROI_Callback(hObject, eventdata, handles)
% hObject    handle to Menu6_2_EditROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_ROIenable(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu6_3_ImportROI_Callback(hObject, eventdata, handles)
% hObject    handle to Menu6_3_ImportROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu6_3_1_Importfile_Callback(hObject, eventdata, handles)
% hObject    handle to Menu6_3_1_Importfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_ROIimport(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu6_3_2_Importpic_Callback(hObject, eventdata, handles)
% hObject    handle to Menu6_3_2_Importpic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_ROIimportpic(handles.GA_mainWin);




%--------------------------------------------------------------------------
%Menu7 Inspection
%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu7_1_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Menu7_1_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_plot(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu7_2_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu7_2_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('plot',handles.data.eye)



%--------------------------------------------------------------------------
%Menu8 Correction
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Menu_Correction_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu8_1_CorrSettings_Callback(hObject, eventdata, handles)
% hObject    handle to Menu8_1_CorrSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_correction(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu8_2_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu8_2_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('correction',handles.data.eye)



%--------------------------------------------------------------------------
%Menu9 Analysis
%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu9_1_ExportSettings_Callback(hObject, eventdata, handles)
% hObject    handle to Menu9_1_ExportSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_analysis(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu9_2_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu9_2_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('analysis',handles.data.eye)



%--------------------------------------------------------------------------
%Menu10 Batch
% -------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Batch_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu10_1_Settings_Callback(hObject, eventdata, handles)
% hObject    handle to Menu10_1_Settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_jobs(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu10_2_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu9_2_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

oldlistboxstring= get(handles.listbox_progress, 'String');

listboxstring = [oldlistboxstring; {'Starting BatchMode... '};];

set(handles.listbox_progress, 'String', listboxstring);

GA_controler('Batch',handles.data.eye)

oldlistboxstring= get(handles.listbox_progress, 'String');

listboxstring = [oldlistboxstring; {'...Finished BatchMode!'};];

set(handles.listbox_progress, 'String', listboxstring);

% Update handles structure
guidata(hObject, handles);



%--------------------------------------------------------------------------
%Menu11 Heatmaps
% -------------------------------------------------------------------------


% --------------------------------------------------------------------
function Menu_Heatmaps_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Heatmaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu11_2_HM_settings_Callback(hObject, eventdata, handles)
% hObject    handle to Menu11_2_HM_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_hmap_settings(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu11_3_HM_Colors_Callback(hObject, eventdata, handles)
% hObject    handle to Menu11_3_HM_Colors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_hmap_color(handles.GA_mainWin);


% --------------------------------------------------------------------
function Menu11_4_HM_run_Callback(hObject, eventdata, handles)
% hObject    handle to Menu11_4_HM_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_controler('heatmaps',handles.data.eye)



%--------------------------------------------------------------------------
%Menu12 Help
% -------------------------------------------------------------------------

% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu12_1_Doc_Callback(hObject, eventdata, handles)
% hObject    handle to Menu12_1_Doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu12_2_About_Callback(hObject, eventdata, handles)
% hObject    handle to Menu12_2_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_gui_about();







% --- Executes on selection change in listbox_progress.
function listbox_progress_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_progress contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_progress


% --- Executes during object creation, after setting all properties.
function listbox_progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox_progress.
function listbox_progress_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox_progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_clear_log.
function pb_clear_log_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.listbox_progress,'String', []);

% --- Executes on button press in pb_save_log.
function pb_save_log_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_Saveoverview.
function pb_Saveoverview_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Saveoverview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_ClearOverview.
function pb_ClearOverview_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ClearOverview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox_overview.
function listbox_overview_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_overview contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_overview


% --- Executes during object creation, after setting all properties.
function listbox_overview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_ClearLog.
function pb_ClearLog_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ClearLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox_progress, 'String', '');

% --- Executes on button press in pb_SaveLog.
function pb_SaveLog_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SaveLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.txt');

if FileName~=0
    
    progresslog_content = get(handles.listbox_progress, 'String');
    
    fileID = fopen([PathName FileName],'w+');
    fprintf(fileID,'%s\n',progresslog_content{:,1});
    
    fclose(fileID);
end


% --------------------------------------------------------------------
function Menu_IncludeExclude_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_IncludeExclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_IncludeExclude_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_IncludeExclude_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

GA_gui_files;


% --------------------------------------------------------------------
function Menu_IncludeExclude_Pictures_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_IncludeExclude_Pictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

GA_gui_pics;



% --------------------------------------------------------------------
function Menu_IncludeExclude_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_IncludeExclude_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

GA_gui_trials;


% --------------------------------------------------------------------
function uit_corr_OffCallback(hObject, eventdata, handles)
% hObject    handle to uit_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uit_corr_OnCallback(hObject, eventdata, handles)
% hObject    handle to uit_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
