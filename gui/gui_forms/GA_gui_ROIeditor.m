function varargout = GA_gui_ROIeditor(varargin)

% GA_GUI_ROIEDITOR M-file for GA_gui_ROIeditor.fig
%      GA_GUI_ROIEDITOR, by itself, creates a new GA_GUI_ROIEDITOR or raises the existing
%      singleton*.
%
%      H = GA_GUI_ROIEDITOR returns the handle to a new GA_GUI_ROIEDITOR or the handle to
%      the existing singleton*.
%
%      GA_GUI_ROIEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GA_GUI_ROIEDITOR.M with the given input arguments.
%
%      GA_GUI_ROIEDITOR('Property','Value',...) creates a new GA_GUI_ROIEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GA_gui_ROIeditor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GA_gui_ROIeditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GA_gui_ROIeditor

% Last Modified by GUIDE v2.5 08-Dec-2011 17:04:11

%%%%
%Rectangle is saved with 4 X-Y points (left, right, upper, lower)
%Ellipse is saved with 1 X-Y point and 2 valuies (middlex, middle y, width, height)
%Polygon is saved with several X-Y points (1...n)
%


% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GA_gui_ROIeditor_OpeningFcn, ...
    'gui_OutputFcn',  @GA_gui_ROIeditor_OutputFcn, ...
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



% --- Executes just before GA_gui_ROIeditor is made visible.
function GA_gui_ROIeditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GA_gui_ROIeditor (see VARARGIN)



% Choose default command line output for GA_gui_ROIeditor
handles.output = hObject;
handles.LWidth = 1;
handles.LColor= 'red';
handles.roi_timepoint=1;
set(handles.ed_tp,'String', handles.roi_timepoint)

%%%Daten MainGUI abfragen

mainGUIhandle = varargin{1};
handles.mainGUIhandle = mainGUIhandle;
mainGUIdata = guidata(mainGUIhandle);
guidata(mainGUIhandle, mainGUIdata);

handles.roimode=mainGUIdata.data.eye.roi_mode;
if strcmp(handles.roimode,'dynamic')
    set(handles.tb_Video,'Value',1);
else
    set(handles.tb_Video,'Value',0);
end;
if get(handles.tb_Video,'Value') == 0
    set(handles.txt_Video,'String', 'Static Picture');
    set(handles.txt_Video,'ForeGroundColor', [0,0,0]);
    set(handles.pb_LoadImage,'String', 'Load Image');
else
    set(handles.txt_Video,'String', 'Video');
    set(handles.pb_LoadImage,'String', 'Load Video');
    set(handles.txt_Video,'ForeGroundColor', [.7,0,.7]);
    handles.roicrtl=ui_roicontrol;
    set(handles.roicrtl.hdelete, 'Callback', {@roi_delete, handles});
    set(handles.roicrtl.hrecord, 'Callback', {@roi_record, handles});
    set(handles.roicrtl.hback, 'Callback', {@roi_back, handles});
    set(handles.roicrtl.hforward, 'Callback', {@roi_forward, handles});
    set(handles.roicrtl.hend, 'Callback', {@roi_endpoint, handles});
end;

%vertical slider

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
bpos(2)=fheight-bpos(4);
set(handles.scrollpanel, 'position', bpos);

if ymax>ymin
    % build the callback that will be executed on scrolling
    clbk = ['set(',num2str(handles.scrollpanel,'%.13f'),',''position'',[', ...
        num2str(bpos(1)),' ',num2str(bpos(2)),'-get(gcbo,''value'') ', num2str(bpos(3)), ...
        ' ', num2str(bpos(4)),'])'];
    % create the slider
    uicontrol('style','slider', ...
        'units','normalized','position',ypos, ...
        'callback',clbk,'min',ymin,'max',ymax,'value',0);
end;

%%%Daten MainGUI abfragen

if isfield(mainGUIdata.data.eye,'ROI')
    handles.ROI = mainGUIdata.data.eye.ROI;
end;

whiteim = ones(600,800);
handles.hIm = imshow(whiteim);
handles.hSP = imscrollpanel(hObject,handles.hIm);

set(handles.hSP,'Units','normalized',...
    'Position',[0.16756521739130434 0.054409090909090906 0.8295652173913046 0.9070454545454545])

hold on
numROIs = 0;
if isfield(mainGUIdata.data.eye,'ROI')
    numROIs = length(handles.ROI);
end;
listboxstring= '';

set(handles.lb_rois,'Value',[])


for k=1:numROIs
    if ~handles.ROI(k).name==0
        listboxstring = [listboxstring; {sprintf( '%s -> %s -> %d points',handles.ROI(k).name , handles.ROI(1,k).valid, length(handles.ROI(1,k).time))}];
    else
        handles.ROI(k)= [];
    end
end

if ~isempty(listboxstring)
    set(handles.lb_rois, 'String', listboxstring);
    handles.roiindex =1;
    handles.roi_timepoint = length(handles.ROI(1,handles.roiindex).time);
    handles = ROIset(handles);
end

handles.picname = '';

guidata(hObject, handles);
% UIWAIT makes GA_gui_ROIeditor wait for user response (see UIRESUME)
% uiwait(handles.ROIeditor);


% --- Outputs from this function are returned to the command line.
function varargout = GA_gui_ROIeditor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  BUTTONS
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

% --- Executes on button press in pb_impfrompic.
function pb_impfrompic_Callback(hObject, eventdata, handles)
% hObject    handle to pb_impfrompic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GA_gui_ROIimportpic(handles.ROIeditor);

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pb_OK.
close;

% --- Executes on button press in pb_setsize.
function pb_setsize_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Enter size x(pixel):','Enter size y(pixel):'};
dlg_title = 'Resolution of white field';
num_lines = 1;
def = {'800','600'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(answer)
    
    if isfield(handles, 'plot')
        
        delete(handles.plot);
        handles=rmfield(handles, 'plot');
    end
    if isfield(handles, 'hSP')
        
        delete(handles.hSP);
        
    end
    whiteim = ones(str2double(answer{2,1}),str2double(answer{1,1}));
    
    handles.hIm = imshow(whiteim);
    % imshow(base_picture, 'XData', [81 720], 'YData', [1 480],  'InitialMagnification', 100);
    handles.hSP = imscrollpanel(handles.ROIeditor,handles.hIm);
    
    set(handles.hSP,'Units','normalized',...
        'Position',[0.16756521739130434 0.054409090909090906 0.8295652173913046 0.9070454545454545])
    
    hold on
    
    [handles] = plotit(handles);
    
end

guidata(hObject, handles);


% --- Executes on button press in pb_deleteRoi.
function pb_deleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.ROI) && isfield(handles, 'roiindex')
    
    content = cellstr(get(handles.lb_rois,'String'));
    
    delroi = content{handles.roiindex,1};
    pos = strfind(delroi,' ->');
    delroiname = delroi(1:pos(1)-1);
    delroivalid = delroi(pos(1)+4:pos(2)-1);
    
    numROIs = length(handles.ROI);
    
    if isfield(handles, 'plot')
        if ishandle(handles.plot)
            delete(handles.plot);
        end;
        handles = rmfield(handles, 'plot');
    end
    for i=1:numROIs
        if strcmp(handles.ROI(1,i).name, delroiname) &&  strcmp(handles.ROI(1,i).valid, delroivalid)
            handles.ROI(:,i)= [];
            break
        end
    end
    
    numROIs = length(handles.ROI);
    
    %listboxstring= get(handles.lb_rois, 'String');
    listboxstring= '';
    
    set(handles.lb_rois,'Value',1)
    
    for k=1:numROIs
        listboxstring = [listboxstring; {sprintf( '%s -> %s -> %d points',handles.ROI(k).name , handles.ROI(1,k).valid, length(handles.ROI(1,k).time))}];
    end;
    if numROIs>0
        set(handles.ed_tp, 'String', length(handles.ROI(1,numROIs).time))
    else
        set(handles.ed_tp, 'String', 0)
    end;
    set(handles.lb_rois, 'String', listboxstring);
    
    if ~isempty(handles.ROI)
        if handles.roiindex > length(listboxstring)
            handles.roiindex=handles.roiindex-1;
        end
        handles = ROIset(handles);
    else
        handles = new(handles);
    end
end
guidata(hObject, handles);


% --- Executes on button press in pb_draw.
function pb_draw_Callback(hObject, eventdata, handles)
% hObject    handle to pb_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(handles.roimode,'dynamic')
    roi_record(handles.ROIeditor, eventdata, handles);
else
    if handles.roi_timepoint==0
        handles.roi_timepoint=1;
    end;
    if isfield(handles, 'plot')
        delete(handles.plot);
        handles=rmfield(handles, 'plot');
    end
    
    if get(handles.rb_rec_lowleft, 'Value') == 1 ||get(handles.rb_rec_center, 'Value') == 1
        set(handles.rb_rec_lowleft, 'Value', 1)
        handles.draw = imrect();
    end
    
    if get(handles.rb_ell_center, 'Value') == 1 || get(handles.rb_ell_lowleft, 'Value') == 1
        handles.draw = imellipse();
    end
    
    if get(handles.rb_poly, 'Value') == 1
        handles.draw = impoly();
    end
    
    
    
    guidata(hObject, handles);
end;


% --- Executes on button press in pb_ExportRois.
function pb_ExportRois_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ExportRois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.mat', 'Export to...');

if FileName~=0
    ROI = handles.ROI; %#ok<NASGU>
    save([PathName FileName], 'ROI')
end
guidata(hObject, handles);

% --- Executes on button press in pb_FullSizeImage.
function pb_FullSizeImage_Callback(hObject, eventdata, handles)
% hObject    handle to pb_FullSizeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_ImportRois.
function pb_ImportRois_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ImportRois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat', 'Export to...');
if FileName~=0
    if exist(fullfile(PathName,FileName), 'file')
        
        load([PathName FileName])
        
        handles.ROI=ROI;
        
        numROIs = length(handles.ROI);
        
        listboxstring= '';
        
        set(handles.lb_rois,'Value',[])
        
        for k=1:numROIs
            if ~handles.ROI(k).name==0
                listboxstring = [listboxstring; {sprintf( '%s -> %s -> %d points',handles.ROI(k).name , handles.ROI(1,k).valid, length(handles.ROI(1,k).time))}];
            else
                handles.ROI(k)= [];
            end
        end
        
        if ~isempty(listboxstring)
            set(handles.lb_rois, 'String', listboxstring);
            handles.roiindex =1;
            handles.roi_timepoint = length(handles.ROI(1,handles.roiindex).time);
            handles = ROIset(handles);
        end
    end;
end;

guidata(hObject, handles);

% --- Executes on button press in pb_LoadImage.
function pb_LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to pb_LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.tb_Video, 'Value') == 0
    [FileName,PathName] = uigetfile('*.jpg;*.png', 'Image File', 'Select Image File');
    
    if FileName~=0
        
        handles.roimode = 'static';
        
        if isfield(handles, 'plot')
            delete(handles.plot);
            handles=rmfield(handles, 'plot');
        end
        
        if isfield(handles, 'hSP')
            delete(handles.hSP);
        end
        
        rgbX = imread([PathName,FileName]);
        %info = imfinfo([PathName, FileName]);
        
        handles.hIm = imshow(rgbX);
        % imshow(base_picture, 'XData', [81 720], 'YData', [1 480],  'InitialMagnification', 100);
        handles.hSP = imscrollpanel(handles.ROIeditor,handles.hIm);
        
        set(handles.hSP,'Units','normalized',...
            'Position',[0.16756521739130434 0.054409090909090906 0.8295652173913046 0.9070454545454545])
        
        handles.picname = FileName(1:end-4);
        
        hold on
        set(handles.edit_picname, 'String',FileName(1:end-4))
        [handles] = plotit(handles);
        
    end;
else
    [FileName,PathName] = uigetfile('*.avi;*.mpeg', 'Video File', 'Select Video File');
    
    if FileName~=0
        
        handles.roimode = 'dynamic';
        
        if isfield(handles, 'plot')
            delete(handles.plot);
            handles=rmfield(handles, 'plot');
        end
        
        if ishandle(handles.hSP)
            delete(handles.hSP);
        end
        
        handles.hIm = movieplayer([PathName,FileName],struct('hparent', handles));
        % imshow(base_picture, 'XData', [81 720], 'YData', [1 480],  'InitialMagnification', 100);
        handles.hSP = imscrollpanel(handles.ROIeditor,handles.hIm);
        rp = get(handles.hIm);
        
        set(handles.hSP,'Units','normalized',...
            'Position',[0.16756521739130434 0.054409090909090906 0.8295652173913046 0.9070454545454545])
        
        handles.picname = FileName(1:end-4);
        
        hold on
        set(handles.edit_picname, 'String',FileName(1:end-4))
        [handles] = plotit(handles);
    end;
end;

guidata(hObject, handles);


% --- Executes on button press in pb_NewROI.
function pb_NewROI_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to pb_NewROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = new(handles);
set(handles.pb_draw, 'Enable', 'off')
guidata(hObject, handles);


function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainGUIdata = guidata(handles.mainGUIhandle);

lbstring = get(mainGUIdata.listbox_progress, 'String');
lbstring = [lbstring; {'>>> ROI-list updated <<<'}];

mainGUIdata.data.eye.roi_mode = handles.roimode;
roi_change_flag=0;

if ~isfield(mainGUIdata.data.eye,'ROI')
    roi_change_flag =1;
elseif ~isequal(mainGUIdata.data.eye.ROI,handles.ROI)
    roi_change_flag =1;
end;

if roi_change_flag
    %Check on modified ROI
    if isfield(mainGUIdata.data.eye,'ROI')
        for i=1:length(mainGUIdata.data.eye.ROI)
            for k=1:length(handles.ROI)
                if isequal(mainGUIdata.data.eye.ROI(1,i).name,handles.ROI(1,k).name)
                    if ~isequal(mainGUIdata.data.eye.ROI(1,i),handles.ROI(1,k))
                        lbstring = [lbstring; ['ROI: '  handles.ROI(1,k).name ' >--modified']];
                    end
                end
            end
        end
        
        %Check on added ROI
        for i=1:length(mainGUIdata.data.eye.ROI)
            found = 0;
            for k=1:length(handles.ROI)
                if strcmp(mainGUIdata.data.eye.ROI(1,i).name, handles.ROI(1,k).name)
                    found = 1;
                    break;
                end
            end
            if(found == 0)
                lbstring = [lbstring; ['ROI: '  mainGUIdata.data.eye.ROI(1,i).name ' >--deleted']];
            end
        end
    end;
    %Check on deleted ROI
    for i=1:length(handles.ROI)
        found = 0;
        if isfield(mainGUIdata.data.eye,'ROI')
            for k=1:length(mainGUIdata.data.eye.ROI)
                if strcmp(mainGUIdata.data.eye.ROI(1,k).name, handles.ROI(1,i).name)
                    found = 1;
                end
            end
        end;
        if(found == 0)
            lbstring = [lbstring; ['ROI: '  handles.ROI(1,i).name ' >--added']];
        end
    end;
    mainGUIdata.data.eye.ROI=handles.ROI;
end

if ~strcmp(lbstring{end},'>>> ROI-list updated <<<')
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

set(mainGUIdata.uipt_save, 'Enable', 'on');

% Update handles structure
guidata(handles.mainGUIhandle, mainGUIdata);
guidata(hObject, handles);

close;

% --- Executes on button press in pb_SaveRoi.
function pb_SaveRoi_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SaveRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if strcmpi(handles.roimode,'dynamic');
%     notify(handles.roicrtl,'pause');
% end;

tp = handles.roi_timepoint;

if isempty(get(handles.edit_name, 'String')) ||  ...
        get(handles.rb_rec, 'Value') == 0 && ...
        get(handles.rb_ellipse, 'Value') == 0 && ...
        get(handles.rb_poly, 'Value') == 0
    
    msgbox('No ROI-Name given or no type selected!','Error','error')
    
elseif ~isfield(handles, 'draw')
    [handles] = ROIget(handles);
    
    if  1 == get(handles.rb_rec_lowleft, 'Value');
        
        handles.ROI(1,handles.roiindex).x{tp}=[str2double(get(handles.edit_x, 'String'));...
            str2double(get(handles.edit_x, 'String'))+ str2double(get(handles.edit_width, 'String'))];
        
        handles.ROI(1,handles.roiindex).y{tp}=[str2double(get(handles.edit_y, 'String'))- str2double(get(handles.edit_height, 'String'));...
            str2double(get(handles.edit_y, 'String'))];
        
        handles.ROI(1,handles.roiindex).type = 'rectangle';
        
    elseif 1 == get(handles.rb_rec_center, 'Value');
        
        handles.ROI(1,handles.roiindex).x{tp}=[str2double(get(handles.edit_x, 'String'))- str2double(get(handles.edit_width, 'String'))/2;...
            str2double(get(handles.edit_x, 'String'))+ str2double(get(handles.edit_width, 'String'))/2];
        
        handles.ROI(1,handles.roiindex).y{tp}=[str2double(get(handles.edit_y, 'String')) - str2double(get(handles.edit_height, 'String'))/2;...
            str2double(get(handles.edit_y, 'String'))+ str2double(get(handles.edit_height, 'String'))/2];
        
        handles.ROI(1,handles.roiindex).type = 'rectangle';
        
    elseif  1 == get(handles.rb_ell_center, 'Value');
        
        handles.ROI(1,handles.roiindex).x{tp} = [str2double(get(handles.edit_x, 'String'))-str2double(get(handles.edit_width, 'String'))/2;...
            str2double(get(handles.edit_x, 'String'))+ str2double(get(handles.edit_width, 'String'))/2];
        handles.ROI(1,handles.roiindex).y{tp} = [str2double(get(handles.edit_y, 'String'))-str2double(get(handles.edit_height, 'String'))/2;...
            str2double(get(handles.edit_y, 'String'))+str2double(get(handles.edit_height, 'String'))/2];
        
        handles.ROI(1,handles.roiindex).type = 'ellipse';
        
    elseif  1 == get(handles.rb_ell_lowleft, 'Value');
        
        handles.ROI(1,handles.roiindex).x{tp}=[str2double(get(handles.edit_x, 'String'));...
            str2double(get(handles.edit_x, 'String'))+ str2double(get(handles.edit_width, 'String'))];
        
        handles.ROI(1,handles.roiindex).y{tp}=[str2double(get(handles.edit_y, 'String'))- str2double(get(handles.edit_height, 'String'));...
            str2double(get(handles.edit_y, 'String'))];
        
        handles.ROI(1,handles.roiindex).type = 'ellipse';
        
    end
    [handles] = ROIset(handles);
    
elseif isfield(handles, 'draw')
    
    [handles] = ROIget(handles);
    
    if  1 == get(handles.rb_rec, 'Value');
        
        handles.ROI(1,handles.roiindex).type = 'rectangle';
        pos = round(getPosition(handles.draw));
        handles.ROI(1,handles.roiindex).x{tp}=[pos(1); (pos(1) + pos(3))];
        handles.ROI(1,handles.roiindex).y{tp}=[pos(2); (pos(2) + pos(4))];
        
    elseif  1 == get(handles.rb_ellipse, 'Value');
        
        handles.ROI(1,handles.roiindex).type = 'ellipse';
        pos = round(getPosition(handles.draw));
        handles.ROI(1,handles.roiindex).x{tp}=[pos(1); (pos(1) + pos(3))];
        handles.ROI(1,handles.roiindex).y{tp}=[pos(2); (pos(2) + pos(4))];
        
    elseif  1 == get(handles.rb_poly, 'Value');
        
        handles.ROI(1,handles.roiindex).type = 'polygon';
        pos = round(getPosition(handles.draw));
        handles.ROI(1,handles.roiindex).x{tp} = pos(:,1)';
        handles.ROI(1,handles.roiindex).y{tp} = pos(:,2)';
    end
    delete(handles.draw);
    handles = rmfield(handles, 'draw');
    [handles] = ROIset(handles);
end

guidata(hObject, handles);


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  LISTBOX
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


% --- Executes on selection change in lb_rois.
function lb_rois_Callback(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_rois
if ~isempty(handles.ROI)
    
    handles.roiindex = get(hObject,'Value'); %Index aus dem Widget holen
    
    handles = ROIset(handles);
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lb_rois_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lb_rois.
function lb_rois_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lb_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  POPMENUE
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


% --- Executes on selection change in pop_color.
function pop_color_Callback(hObject, eventdata, handles)
% hObject    handle to pop_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_color

sel_cont = cell2mat({get(hObject,'Value')});
content = cellstr(get(hObject,'String'));

handles.LColor = content{sel_cont,1};

if isfield(handles, 'plot')
    delete(handles.plot);
    handles = plotit(handles);
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_width.
function pop_width_Callback(hObject, eventdata, handles)
% hObject    handle to pop_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_width contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_width

handles.LWidth = cell2mat({get(hObject,'Value')});

if isfield(handles, 'plot')
    
    delete(handles.plot);
    
    handles = plotit(handles);
    
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  UIPANEL
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


% --- Executes during object creation, after setting all properties.
function uipanelImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  AXES
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


% --- Executes during object creation, after setting all properties.
function axesIm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesIm


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  EDIT
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

% --- Executes during object creation, after setting all properties.
function edit_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_width_Callback(hObject, eventdata, handles)
% hObject    handle to edit_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_height_Callback(hObject, eventdata, handles)
% hObject    handle to edit_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_picname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_picname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_picname as text
%        str2double(get(hObject,'String')) returns contents of edit_picname as a double


% --- Executes during object creation, after setting all properties.
function edit_picname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_picname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_tag1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tag1 as text
%        str2double(get(hObject,'String')) returns contents of edit_tag1 as a double


% --- Executes during object creation, after setting all properties.
function edit_tag1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tag2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tag2 as text
%        str2double(get(hObject,'String')) returns contents of edit_tag2 as a double


% --- Executes during object creation, after setting all properties.
function edit_tag2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  RADIOBUTTONS
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
function radio_up_SizeChangedFcn(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes when selected object is changed in radio_up.
function radio_up_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in radio_up
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.rb_rec, 'Value')==1)
    
    
    set(handles.rb_rec_lowleft, 'Enable', 'on')
    
    set(handles.rb_rec_center, 'Enable', 'on')
    set(handles.rb_ell_center, 'Enable', 'off')
    
    set(handles.rb_ell_center, 'Value', 0)
    set(handles.rb_rec_lowleft, 'Value', 1)
    set(handles.rb_ell_lowleft, 'Enable', 'off')
    set(handles.rb_ell_lowleft, 'Value', 0)
    
    set(handles.edit_x, 'Enable', 'on')
    set(handles.edit_y, 'Enable', 'on')
    set(handles.edit_width, 'Enable', 'on')
    set(handles.edit_height, 'Enable', 'on')
    
    set(handles.txt_x, 'String', 'x')
    set(handles.txt_y, 'String', 'y')
    
    set(handles.txt_width, 'String', 'width')
    set(handles.txt_height, 'String', 'height')
    set(handles.pb_draw, 'Enable', 'on')
    
    set(handles.txt_angle, 'String', 'angle')
    set(handles.ed_angle, 'Enable', 'on')
    
end

if (get(handles.rb_ellipse, 'Value')==1)
    
    set(handles.rb_rec_lowleft, 'Enable', 'off')
    
    set(handles.rb_rec_center, 'Enable', 'off')
    set(handles.rb_ell_center, 'Enable', 'on')
    set(handles.rb_ell_lowleft, 'Enable', 'on')
    set(handles.rb_rec_lowleft, 'Value', 0)
    
    set(handles.rb_rec_center, 'Value', 0)
    set(handles.rb_ell_center, 'Value', 0)
    set(handles.rb_ell_lowleft, 'Value', 1)
    
    set(handles.edit_x, 'Enable', 'on')
    set(handles.edit_y, 'Enable', 'on')
    set(handles.edit_width, 'Enable', 'on')
    set(handles.edit_height, 'Enable', 'on')
    
    set(handles.txt_x, 'String', 'x')
    set(handles.txt_y, 'String', 'y')
    
    set(handles.txt_width, 'String', 'width')
    set(handles.txt_height, 'String', 'height')
    set(handles.pb_draw, 'Enable', 'on')
    
    set(handles.txt_angle, 'String', 'angle')
    set(handles.ed_angle, 'Enable', 'on')
    
end

if (get(handles.rb_poly, 'Value')==1)
    
    set(handles.rb_rec_lowleft, 'Enable', 'off')
    
    set(handles.rb_rec_center, 'Enable', 'off')
    set(handles.rb_ell_center, 'Enable', 'off')
    set(handles.rb_rec_lowleft, 'Value', 0)
    
    set(handles.rb_rec_center, 'Value', 0)
    set(handles.rb_ell_center, 'Value', 0)
    set(handles.rb_ell_lowleft, 'Enable', 'off')
    set(handles.rb_ell_lowleft, 'Value', 0)
    
    set(handles.edit_x, 'Enable', 'off')
    set(handles.edit_y, 'Enable', 'off')
    set(handles.edit_width, 'Enable', 'off')
    set(handles.edit_height, 'Enable', 'off')
    
    set(handles.txt_x, 'String', '-off-')
    set(handles.txt_y, 'String', '-off-')
    
    set(handles.txt_width, 'String', '-off-')
    set(handles.txt_height, 'String', '-off-')
    set(handles.pb_draw, 'Enable', 'on')
    
    set(handles.txt_angle, 'String', '-off-')
    set(handles.ed_angle, 'Enable', 'off')
    
end

guidata(hObject, handles);


% --- Executes when selected object is changed in radio_sub.
function radio_sub_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in radio_sub
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
tp = handles.roi_timepoint;
if isfield(handles, 'roiindex')
    
    if (get(handles.rb_rec_lowleft, 'Value')==1)
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1));
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(2));
        
    elseif (get(handles.rb_rec_center, 'Value')==1)
        
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1)+ str2double(get(handles.edit_width, 'String'))/2);
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(2)- str2double(get(handles.edit_height, 'String'))/2);
        
    elseif (get(handles.rb_ell_lowleft, 'Value')==1)
        
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1));
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(2));
        
    elseif (get(handles.rb_ell_center, 'Value')==1)
        
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1)+ str2double(get(handles.edit_width, 'String'))/2);
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(1)+ str2double(get(handles.edit_height, 'String'))/2);
        
    end
    set(handles.ed_angle, 'String', handles.ROI(1,handles.roiindex).angle(1,tp));
end

guidata(hObject, handles);


% --- Executes when selected object is changed in ROIValid.
function ROIValid_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ROIValid
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.rb_all, 'Value')==1)
    
    set(handles.edit_picname, 'Enable', 'off')
    set(handles.edit_picname, 'String', 'Picture-Name')
    
elseif (get(handles.rb_selpic, 'Value')==1)
    
    if isfield(handles,'roiindex')
        
        if strcmp(handles.ROI(1,handles.roiindex).valid, 'all')
            
            set(handles.edit_picname, 'Enable', 'on')
            set(handles.edit_picname, 'String', handles.picname)
            
        else
            set(handles.edit_picname, 'Enable', 'on')
            set(handles.edit_picname, 'String', handles.ROI(1,handles.roiindex).valid)
        end
        
    else
        set(handles.edit_picname, 'Enable', 'on')
        set(handles.edit_picname, 'String', handles.picname)
        
        
    end
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function radio_up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radio_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  Checkbox
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

% --- Executes on button press in cb_enabled.
function cb_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to cb_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_enabled


%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%--------------------------------------------------------------------------
%  FUNCTIONS!
%--------------------------------------------------------------------------
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

function [handles] = new(handles)


if isfield(handles, 'roiindex')
    
    handles = rmfield(handles, 'roiindex');
    
end

if isfield(handles, 'plot')
    
    delete(handles.plot);
    handles = rmfield(handles, 'plot');
end

set(handles.edit_name, 'String', '')

set(handles.edit_tag1, 'String', '')
set(handles.edit_tag2, 'String', '')

set(handles.cb_enabled, 'Value', 0)

set(handles.rb_rec, 'Enable', 'on')
set(handles.rb_ellipse, 'Enable', 'on')
set(handles.rb_poly, 'Enable', 'on')

set(handles.rb_rec, 'Value', 0)
set(handles.rb_ellipse, 'Value', 0)
set(handles.rb_poly, 'Value', 0)


set(handles.rb_rec_lowleft, 'Enable', 'off')

set(handles.rb_rec_center, 'Enable', 'off')
set(handles.rb_ell_center, 'Enable', 'off')
set(handles.rb_ell_lowleft, 'Enable', 'off')
set(handles.rb_rec_lowleft, 'Value', 0)

set(handles.rb_rec_center, 'Value', 0)
set(handles.rb_ell_center, 'Value', 0)
set(handles.rb_ell_lowleft, 'Value', 0)


set(handles.edit_x, 'Enable', 'off')
set(handles.edit_y, 'Enable', 'off')
set(handles.edit_width, 'Enable', 'off')
set(handles.edit_height, 'Enable', 'off')

set(handles.txt_x, 'String', '-off-')
set(handles.txt_y, 'String', '-off-')

set(handles.txt_width, 'String', '-off-')
set(handles.txt_height, 'String', '-off-')

set(handles.edit_x, 'String', '')
set(handles.edit_y, 'String', '')

set(handles.edit_width, 'String', '')
set(handles.edit_height, 'String', '')

set(handles.txt_angle, 'String', '-off-')
set(handles.ed_angle, 'Enable', 'off')
set(handles.ed_angle, 'String', '')

%fill roi parameter with values from controls
function [handles] = ROIget(handles)

ROI_Name=get(handles.edit_name, 'String');
if get(handles.rb_all, 'Value')
    validpic = 'all';
else
    validpic = get(handles.edit_picname, 'String');
end;

contentLB = get(handles.lb_rois, 'String');

sizecontentLB = size(contentLB);
if ~isempty(contentLB)
    for k=1:sizecontentLB(1)
        strList= cell2mat(contentLB(k));
        pos = strfind(strList,' -> ');
        rowname= strList(1:pos(1)-1);
        rowvalid= strList(pos(1)+4:pos(2)-1);
        if strcmp(ROI_Name, rowname) && strcmp(validpic, rowvalid)
            roiindex = k;
        end;
    end;
end

if ~isfield(handles, 'ROI')
    handles.ROI = struct('name',{},'valid',{},'enabled',{},'tag1',{},'tag2',{},'x',{},'y',{},'angle',{},'time',{},'type',{},'stop',{});
    handles.ROI
end;

if ~exist('roiindex', 'var')
    roiindex = length(handles.ROI);
    roiindex = roiindex + 1;
end;

if  1 == get(handles.rb_rec, 'Value');
    handles.ROI(1,roiindex).type = 'rectangle';
elseif  1 == get(handles.rb_ellipse, 'Value');
    handles.ROI(1,roiindex).type = 'ellipse';
elseif  1 == get(handles.rb_poly, 'Value');
    handles.ROI(1,roiindex).type = 'polygon';
end;

tp=handles.roi_timepoint;

handles.roiindex = roiindex;
handles.ROI(1,roiindex).name=get(handles.edit_name, 'String');
handles.ROI(1,roiindex).enabled=get(handles.cb_enabled, 'Value');
handles.ROI(1,roiindex).tag1=get(handles.edit_tag1, 'String');
handles.ROI(1,roiindex).tag2=get(handles.edit_tag2, 'String');
if isnan(str2double(get(handles.ed_angle, 'String')))
    handles.ROI(1,roiindex).angle(tp)=0;
else
    handles.ROI(1,roiindex).angle(tp)=str2double(get(handles.ed_angle, 'String'));
end;

if (get(handles.rb_all, 'Value')==1)
    
    handles.ROI(1,roiindex).valid = 'all';
    
elseif (get(handles.rb_selpic, 'Value')==1)
    
    handles.ROI(1,roiindex).valid = (get(handles.edit_picname, 'String'));
    
end

set(handles.lb_rois,'Value',1)

numberROIs = length(handles.ROI);

listboxstring= '';
set(handles.lb_rois, 'String', '');

for k=1:numberROIs
    
    timepoints = max(1,length(handles.ROI(k).time));
    
    listboxstring = [listboxstring; {sprintf( '%s -> %s -> %d points',handles.ROI(k).name , handles.ROI(1,k).valid, timepoints) }];
end;
set(handles.lb_rois, 'String', listboxstring);

set(handles.ed_tp, 'String', max(1,tp));

%fill controls with roi parameter
function [handles] = ROIset(handles)

tp = min(length(handles.ROI(1, handles.roiindex).x), handles.roi_timepoint);
handles.roi_timepoint = tp;

if strcmpi(handles.roimode, 'static')
    handles.ROI(1, handles.roiindex).time=1;
    handles.ROI(1, handles.roiindex).stop=0;
end;

set(handles.ed_tp,'String', tp)

if ~isempty(handles.ROI)
    if isfield(handles, 'plot')
        if ishandle(handles.plot)
            delete(handles.plot);
        end;
    end
    
    set (handles.edit_name, 'String', handles.ROI(1, handles.roiindex).name);
    set (handles.cb_enabled, 'Value', handles.ROI(1,handles.roiindex).enabled);
    set (handles.edit_tag1, 'String', handles.ROI(1, handles.roiindex).tag1);
    set (handles.edit_tag2, 'String', handles.ROI(1, handles.roiindex).tag2);
    
    if strcmp(handles.ROI(1,handles.roiindex).type, 'rectangle')
        
        set(handles.rb_rec, 'Value',1)
        set(handles.rb_rec_lowleft, 'Value',1)
        
        set(handles.rb_ellipse, 'Enable', 'off')
        set(handles.rb_poly, 'Enable', 'off')
        set(handles.rb_rec, 'Enable','on')
        set(handles.rb_rec_lowleft, 'Enable', 'on')
        
        set(handles.rb_rec_center, 'Enable', 'on')
        set(handles.rb_ell_center, 'Enable', 'off')
        set(handles.rb_ell_center, 'Value', 0)
        set(handles.rb_ell_lowleft, 'Enable','off')
        set(handles.rb_ell_lowleft, 'Value', 0)
        
        set(handles.edit_x, 'Enable', 'on')
        set(handles.edit_y, 'Enable', 'on')
        set(handles.edit_width, 'Enable', 'on')
        set(handles.edit_height, 'Enable', 'on')
        
        set(handles.txt_x, 'String', 'x')
        set(handles.txt_y, 'String', 'y')
        
        set(handles.txt_width, 'String', 'width')
        set(handles.txt_height, 'String', 'height')
        
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1));
        
        width = handles.ROI(1,handles.roiindex).x{tp}(2)-handles.ROI(1,handles.roiindex).x{tp}(1);
        set (handles.edit_width, 'String',width );
        
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(2));
        
        height = handles.ROI(1,handles.roiindex).y{tp}(2)-handles.ROI(1,handles.roiindex).y{tp}(1);
        set (handles.edit_height, 'String',height );
        
        set(handles.txt_angle, 'String', 'angle')
        set(handles.ed_angle, 'Enable', 'on')
        set(handles.ed_angle, 'String', handles.ROI(1,handles.roiindex).angle(tp))
        
    elseif strcmp(handles.ROI(1,handles.roiindex).type, 'ellipse')
        
        set(handles.rb_rec, 'Enable','off')
        
        set(handles.rb_rec_lowleft, 'Enable', 'off')
        
        set(handles.rb_rec_center, 'Enable', 'off')
        
        
        set(handles.rb_ellipse, 'Enable', 'on')
        set(handles.rb_ellipse, 'Value', 1)
        
        set(handles.rb_ell_lowleft, 'Enable','on')
        set(handles.rb_ell_lowleft, 'Value', 1)
        set(handles.rb_ell_center, 'Enable', 'on')
        set(handles.rb_ell_center, 'Value', 0)
        
        
        set(handles.rb_poly, 'Enable','off')
        
        set(handles.edit_x, 'Enable', 'on')
        set(handles.edit_y, 'Enable', 'on')
        set(handles.edit_width, 'Enable', 'on')
        set(handles.edit_height, 'Enable', 'on')
        
        set(handles.txt_x, 'String', 'x')
        set(handles.txt_y, 'String', 'y')
        
        set(handles.txt_width, 'String', 'width')
        set(handles.txt_height, 'String', 'height')
        
        set (handles.edit_x, 'String', handles.ROI(1,handles.roiindex).x{tp}(1));
        
        width = handles.ROI(1,handles.roiindex).x{tp}(2) - handles.ROI(1,handles.roiindex).x{tp}(1);
        set (handles.edit_width, 'String',width );
        
        set (handles.edit_y, 'String', handles.ROI(1,handles.roiindex).y{tp}(2));
        
        height = handles.ROI(1,handles.roiindex).y{tp}(2) - handles.ROI(1,handles.roiindex).y{tp}(1);
        set (handles.edit_height, 'String',height );
        
        set(handles.txt_angle, 'String', 'angle')
        set(handles.ed_angle, 'Enable', 'on')
        set(handles.ed_angle, 'String', handles.ROI(1,handles.roiindex).angle(tp))
        
    elseif strcmp(handles.ROI(1,handles.roiindex).type, 'polygon')
        
        set(handles.rb_rec_lowleft, 'Enable', 'off')
        
        set(handles.rb_rec_center, 'Enable', 'off')
        set(handles.rb_ell_center, 'Enable', 'off')
        set(handles.rb_rec_lowleft, 'Value', 0)
        
        set(handles.rb_rec_center, 'Value', 0)
        set(handles.rb_ell_center, 'Value', 0)
        set(handles.rb_ell_lowleft, 'Enable','off')
        set(handles.rb_ell_lowleft, 'Value', 0)
        
        
        set(handles.edit_x, 'Enable', 'off')
        set(handles.edit_y, 'Enable', 'off')
        set(handles.edit_width, 'Enable', 'off')
        set(handles.edit_height, 'Enable', 'off')
        
        set(handles.txt_x, 'String', '-off-')
        set(handles.txt_y, 'String', '-off-')
        
        set(handles.txt_width, 'String', '-off-')
        set(handles.txt_height, 'String', '-off-')
        set(handles.pb_draw, 'Enable', 'on')
        
        set(handles.txt_angle, 'String', '-off-')
        set(handles.ed_angle, 'Enable', 'off')
        set(handles.ed_angle, 'String', '')
        
    end
    
    if     strcmp(handles.ROI(1,handles.roiindex).valid ,'all')
        
        set(handles.edit_picname, 'Enable', 'off');
        set(handles.edit_picname, 'String', 'Picture-Name');
        set(handles.rb_all, 'Value',1);
        
    else
        
        set(handles.edit_picname, 'Enable', 'on');
        set(handles.edit_picname, 'String', handles.ROI(1,handles.roiindex).valid);
        set(handles.rb_selpic, 'Value',1);
    end
    set(handles.lb_rois, 'Value', handles.roiindex);
    handles = plotit(handles);
    set(handles.pb_draw, 'Enable', 'on');
end

function [handles] = plotit(handles)

tp = handles.roi_timepoint;

if isfield(handles, 'roiindex')
    
    if strcmp(handles.ROI(1,handles.roiindex).type, 'rectangle')
        
        xm = handles.ROI(1,handles.roiindex).x{tp}(1) + (handles.ROI(1,handles.roiindex).x{tp}(2)-handles.ROI(1,handles.roiindex).x{tp}(1))/2;
        ym = handles.ROI(1,handles.roiindex).y{tp}(1) + (handles.ROI(1,handles.roiindex).y{tp}(2)-handles.ROI(1,handles.roiindex).y{tp}(1))/2;
        angle = handles.ROI(1,handles.roiindex).angle(tp);
        
        x1= handles.ROI(1,handles.roiindex).x{tp}(1);
        y1= handles.ROI(1,handles.roiindex).y{tp}(1);
        
        vector = [x1-xm, y1-ym ];
        
        vecrotate =[ vector(1)*cosd(angle)-vector(2)*sind(angle), vector(2)*cosd(angle)+vector(1)*sind(angle)];
        
        pfin1 = [xm+vecrotate(1),ym+vecrotate(2)];
        
        x2= handles.ROI(1,handles.roiindex).x{tp}(2);
        y2= handles.ROI(1,handles.roiindex).y{tp}(1);
        
        vector = [x2-xm, y2-ym ];
        
        vecrotate =[ vector(1)*cosd(angle)-vector(2)*sind(angle), vector(2)*cosd(angle)+vector(1)*sind(angle)];
        
        pfin2 = [xm+vecrotate(1),ym+vecrotate(2)];
        
        x3= handles.ROI(1,handles.roiindex).x{tp}(2);
        y3= handles.ROI(1,handles.roiindex).y{tp}(2);
        
        vector = [x3-xm, y3-ym ];
        
        vecrotate =[ vector(1)*cosd(angle)-vector(2)*sind(angle), vector(2)*cosd(angle)+vector(1)*sind(angle)];
        
        pfin3 = [xm+vecrotate(1),ym+vecrotate(2)];
        
        x4= handles.ROI(1,handles.roiindex).x{tp}(1);
        y4= handles.ROI(1,handles.roiindex).y{tp}(2);
        
        vector = [x4-xm, y4-ym ];
        
        vecrotate =[ vector(1)*cosd(angle)-vector(2)*sind(angle), vector(2)*cosd(angle)+vector(1)*sind(angle)];
        
        pfin4 = [xm+vecrotate(1),ym+vecrotate(2)];
        
        x = [pfin1(1),pfin2(1),pfin3(1),pfin4(1)];
        y = [pfin1(2),pfin2(2),pfin3(2),pfin4(2)];
        handles.plot = plot([x, pfin4(1),pfin1(1)],[y,pfin4(2),pfin1(2)],'LineWidth',handles.LWidth,'Color', handles.LColor);
    end
    
    if strcmp(handles.ROI(1,handles.roiindex).type, 'ellipse')
        
        angle = 0.0175*handles.ROI(1,handles.roiindex).angle(tp);
        handles.plot = ...
            ellipse((handles.ROI(1,handles.roiindex).x{tp}(2)-handles.ROI(1,handles.roiindex).x{tp}(1))/2, ...
            (handles.ROI(1,handles.roiindex).y{tp}(2)-handles.ROI(1,handles.roiindex).y{tp}(1))/2, ...
            angle, ...
            handles.ROI(1,handles.roiindex).x{tp}(1) + (handles.ROI(1,handles.roiindex).x{tp}(2)-handles.ROI(1,handles.roiindex).x{tp}(1))/2,...
            handles.ROI(1,handles.roiindex).y{tp}(1) + (handles.ROI(1,handles.roiindex).y{tp}(2)-handles.ROI(1,handles.roiindex).y{tp}(1))/2,'r');
        
    end
    
    if strcmp(handles.ROI(1,handles.roiindex).type, 'polygon')
        
        handles.plot = plot([handles.ROI(1,handles.roiindex).x{tp} handles.ROI(1,handles.roiindex).x{tp}(1)], ...
            [handles.ROI(1,handles.roiindex).y{tp} handles.ROI(1,handles.roiindex).y{tp}(1)],...
            'LineWidth',handles.LWidth,'Color', handles.LColor);
    end
end

% --- Executes on key press with focus on lb_rois and none of its controls.
function lb_rois_KeyPressFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to lb_rois (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pb_clear.
function pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sizex = get(handles.hIm,'XData');
sizey = get(handles.hIm,'YData');


if isfield(handles, 'plot')
    delete(handles.plot);
    handles=rmfield(handles, 'plot');
end
if isfield(handles, 'hSP')
    
    delete(handles.hSP);
    
end

whiteim = ones(sizey(2),sizex(2));

handles.hIm = imshow(whiteim);
% imshow(base_picture, 'XData', [81 720], 'YData', [1 480],  'InitialMagnification', 100);
handles.hSP = imscrollpanel(handles.ROIeditor,handles.hIm);

set(handles.hSP,'Units','normalized',...
    'Position',[0.16756521739130434 0.054409090909090906 0.8295652173913046 0.9070454545454545])

hold on

[handles] = plotit(handles);

guidata(hObject, handles);



function ed_angle_Callback(hObject, eventdata, handles)
% hObject    handle to ed_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_angle as text
%        str2double(get(hObject,'String')) returns contents of ed_angle as a double


% --- Executes during object creation, after setting all properties.
function ed_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function h=ellipse(ra,rb,ang,x0,y0,C,Nb)
% Ellipse adds ellipses to the current plot
%
% ELLIPSE(ra,rb,ang,x0,y0) adds an ellipse with semimajor axis of ra,
% a semimajor axis of radius rb, a semimajor axis of ang, centered at
% the point x0,y0.
%
% The length of ra, rb, and ang should be the same.
% If ra is a vector of length L and x0,y0 scalars, L ellipses
% are added at point x0,y0.
% If ra is a scalar and x0,y0 vectors of length M, M ellipse are with the same
% radii are added at the points x0,y0.
% If ra, x0, y0 are vectors of the same length L=M, M ellipses are added.
% If ra is a vector of length L and x0, y0 are  vectors of length
% M~=L, L*M ellipses are added, at each point x0,y0, L ellipses of radius ra.
%
% ELLIPSE(ra,rb,ang,x0,y0,C)
% adds ellipses of color C. C may be a string ('r','b',...) or the RGB value.
% If no color is specified, it makes automatic use of the colors specified by
% the axes ColorOrder property. For several circles C may be a vector.
%
% ELLIPSE(ra,rb,ang,x0,y0,C,Nb), Nb specifies the number of points
% used to draw the ellipse. The default value is 300. Nb may be used
% for each ellipse individually.
%
% h=ELLIPSE(...) returns the handles to the ellipses.
%
% as a sample of how ellipse works, the following produces a red ellipse
% tipped up at a 45 deg axis from the x axis
% ellipse(1,2,pi/8,1,1,'r')
%
% note that if ra=rb, ELLIPSE plots a circle
%

% written by D.G. Long, Brigham Young University, based on the
% CIRCLES.m original
% written by Peter Blattner, Institute of Microtechnology, University of
% Neuchatel, Switzerland, blattner@imt.unine.ch


% Check the number of input arguments

if nargin<1,
    ra=[];
end;
if nargin<2,
    rb=[];
end;
if nargin<3,
    ang=[];
end;

%if nargin==1,
%  error('Not enough arguments');
%end;

if nargin<5,
    x0=[];
    y0=[];
end;

if nargin<6,
    C=[];
end

if nargin<7,
    Nb=[];
end

% set up the default values

if isempty(ra),ra=1;end;
if isempty(rb),rb=1;end;
if isempty(ang),ang=0;end;
if isempty(x0),x0=0;end;
if isempty(y0),y0=0;end;
if isempty(Nb),Nb=300;end;
if isempty(C),C=get(gca,'colororder');end;

% work on the variable sizes

x0=x0(:);
y0=y0(:);
ra=ra(:);
rb=rb(:);
ang=ang(:);
Nb=Nb(:);

if isstr(C),C=C(:);end; %#ok<FDEPR>

if length(ra)~=length(rb),
    error('length(ra)~=length(rb)');
end;
if length(x0)~=length(y0),
    error('length(x0)~=length(y0)');
end;

% how many inscribed elllipses are plotted

if length(ra)~=length(x0)
    maxk=length(ra)*length(x0);
else
    maxk=length(ra);
end;

% drawing loop

for k=1:maxk
    
    if length(x0)==1
        xpos=x0;
        ypos=y0;
        radm=ra(k);
        radn=rb(k);
        if length(ang)==1
            an=ang;
        else
            an=ang(k);
        end;
    elseif length(ra)==1
        xpos=x0(k);
        ypos=y0(k);
        radm=ra;
        radn=rb;
        an=ang;
    elseif length(x0)==length(ra)
        xpos=x0(k);
        ypos=y0(k);
        radm=ra(k);
        radn=rb(k);
        an=ang(k);
    else
        rada=ra(fix((k-1)/size(x0,1))+1); %#ok<NASGU>
        radb=rb(fix((k-1)/size(x0,1))+1); %#ok<NASGU>
        an=ang(fix((k-1)/size(x0,1))+1);
        xpos=x0(rem(k-1,size(x0,1))+1);
        ypos=y0(rem(k-1,size(y0,1))+1);
    end;
    
    co=cos(an);
    si=sin(an);
    the=linspace(0,2*pi,Nb(rem(k-1,size(Nb,1))+1,:)+1);
    %  x=radm*cos(the)*co-si*radn*sin(the)+xpos;
    %  y=radm*cos(the)*si+co*radn*sin(the)+ypos;
    h(k)=line(radm*cos(the)*co-si*radn*sin(the)+xpos,radm*cos(the)*si+co*radn*sin(the)+ypos);
    set(h(k),'color',C(rem(k-1,size(C,1))+1,:));
    
end;

% --- Executes on button press in tb_Video.
function tb_Video_Callback(hObject, eventdata, handles)
% hObject    handle to tb_Video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of tb_Video
if get(hObject,'Value') == 0
    set(handles.txt_Video,'String', 'Static Picture');
    set(handles.txt_Video,'ForeGroundColor', [0,0,0]);
    set(handles.pb_LoadImage,'String', 'Load Image');
    if ishandle(handles.hIm)
        rp = get(handles.hIm);
        delete(rp.UserData.hpause);
        delete(rp.UserData.hplay);
        delete(rp.UserData.hslide);
        delete(handles.hIm);
    end;
    if isfield(handles, 'roicrtl')
        if isobject(handles.roicrtl)
            delete(handles.roicrtl);
            handles = rmfield( handles, 'roicrtl');
        end;
    end;
    handles.roimode='static';
else
    set(handles.txt_Video,'String', 'Video');
    set(handles.pb_LoadImage,'String', 'Load Video');
    set(handles.txt_Video,'ForeGroundColor', [.7,0,.7]);
    if isfield(handles, 'hIm')
        if ishandle(handles.hIm)
            delete(handles.hIm);
        end;
    end;
    handles.roicrtl=ui_roicontrol;
    set(handles.roicrtl.hdelete, 'Callback', {@roi_delete, handles});
    set(handles.roicrtl.hrecord, 'Callback', {@roi_record, handles});
    set(handles.roicrtl.hback, 'Callback', {@roi_back, handles});
    set(handles.roicrtl.hforward, 'Callback', {@roi_forward, handles});
    set(handles.roicrtl.hend, 'Callback', {@roi_endpoint, handles});
    handles.roimode='dynamic';
end;
guidata(gcf,handles);

% --- Executes on button press in pb_Edit.
function pb_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pb_Edit

% --- Executes on button press in cb_Track.
function cb_Track_Callback(hObject, eventdata, handles)
% hObject    handle to cb_Track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_Track

function roi_record(hObject, eventdata, handles)
handles = guidata(handles.ROIeditor);
notify(handles.roicrtl,'pause');
if isempty(get(handles.edit_name, 'String')) ||  ...
        get(handles.rb_rec, 'Value') == 0 && ...
        get(handles.rb_ellipse, 'Value') == 0 && ...
        get(handles.rb_poly, 'Value') == 0
    msgbox('No ROI-Name given or no type selected!','Error','error')
else
    if ishandle(handles.hIm)
        usdat = get(handles.hIm, 'UserData');
        vtime = usdat.vpos / usdat.vfrate;
    else
        vtime =0;
    end;
    %initiiert von roi_record;
    handles.roi_timepoint=handles.roi_timepoint+1;
    
    %find selected ROI
    handles = ROIget(handles);
    roi=handles.ROI(1,handles.roiindex);
    if ~isempty(roi.time)
        roi.time(end+1) = vtime;
        roi.x(end+1)={[]};
        roi.y(end+1)={[]};
        roi.angle(end+1)=0;
        roi.stop(end+1)=0;
        [roi.time, m, n] = unique(roi.time);
        [roi.time ix]= sort(roi.time);
        roi.x = roi.x(m(ix));
        roi.y = roi.y(m(ix));
        roi.angle =roi.angle(m(ix));
        roi.stop =roi.stop(m(ix));
        tp = find(roi.time == vtime);
    else
        tp=1;
        roi.time(1) = vtime;
        roi.x={[]};
        roi.y={[]};
        roi.angle=0;
        roi.stop=0;
    end;
    handles.ROI(1,handles.roiindex)=roi;
    handles.roi_timepoint = tp;
    set(handles.ed_tp,'String', tp);
    
    if isfield(handles, 'plot')
        delete(handles.plot);
        handles=rmfield(handles, 'plot');
    end
    
    if get(handles.rb_rec_lowleft, 'Value') == 1 ||get(handles.rb_rec_center, 'Value') == 1
        set(handles.rb_rec_lowleft, 'Value', 1)
        handles.draw = imrect();
    end
    
    if get(handles.rb_ell_center, 'Value') == 1 || get(handles.rb_ell_lowleft, 'Value') == 1
        handles.draw = imellipse();
    end
    
    if get(handles.rb_poly, 'Value') == 1
        handles.draw = impoly();
    end
    
    if handles.roi_timepoint==0
        handles.roi_timepoint=1;
    end;
    
    guidata(hObject, handles);
    
end;


function roi_delete(hObject, eventdata, handles)
handles = guidata(handles.ROIeditor);
if isfield(handles, 'plot')
    if ishandle(handles.plot)
        delete(handles.plot);
    end;
    handles=rmfield(handles, 'plot');
end
if isfield(handles,'roiindex')
    if length(handles.ROI(1, handles.roiindex).time)>1
        handles.ROI(1, handles.roiindex).time(handles.roi_timepoint)=[];
        handles.ROI(1, handles.roiindex).x(handles.roi_timepoint)=[];
        handles.ROI(1, handles.roiindex).y(handles.roi_timepoint)=[];
        handles.ROI(1, handles.roiindex).angle(:,handles.roi_timepoint)=[];
        handles.roi_timepoint = min(handles.roi_timepoint, length(handles.ROI(1, handles.roiindex).time));
        set(handles.ed_tp,'String', handles.roi_timepoint)
        handles = plotit(handles);
        handles.roicrtl.pos= handles.ROI(1, handles.roiindex).time(handles.roi_timepoint);
        notify(handles.roicrtl,'newpos');
    else
        pb_deleteRoi_Callback(handles.ROIeditor, eventdata, handles);
    end;
end;
guidata(handles.ROIeditor,handles);

function roi_endpoint(hObject, eventdata, handles)
handles1 = guidata(hObject);
hend_val=get(handles1.roicrtl.hend,'Value');
if hend_val
    iend = uint8(100 .* ones(16, 16, 3));
    iend(3:14,12:13, [1,3]) =  150;
    iend(3:14,12:13, 2) =  0;
    iend(8:9, 6:13, [1,3]) = 150;
    iend(8:9, 6:13, 2) = 0;
    set(handles1.roicrtl.hend,'CData',iend);
else
    iend = uint8(192 .* ones(16, 16, 3));
    iend(3:14,12:13, :) =  0;
    iend(8:9, 6:13, :) = 0;
    set(handles1.roicrtl.hend,'CData',iend);
end;
if isfield(handles1,'roiindex')
    handles1.ROI(1, handles1.roiindex).stop(handles1.roi_timepoint)=hend_val;
end;
guidata(hObject,handles1);

function roi_back(hObject, eventdata, handles)
handles = guidata(handles.ROIeditor);
if isfield(handles, 'plot')
    if ishandle(handles.plot)
        delete(handles.plot);
    end;
    handles=rmfield(handles, 'plot');
end
if isfield(handles,'roiindex')
    handles.roi_timepoint = max(handles.roi_timepoint - 1, 1);
    set(handles.ed_tp,'String', handles.roi_timepoint)
    handles = plotit(handles);
    handles.roicrtl.pos = handles.ROI(1, handles.roiindex).time(handles.roi_timepoint);
    notify(handles.roicrtl,'newpos');
end;

hend_val = handles.ROI(1, handles.roiindex).stop(handles.roi_timepoint);
if hend_val
    iend = uint8(100 .* ones(16, 16, 3));
    iend(3:14,12:13, [1,3]) =  150;
    iend(3:14,12:13, 2) =  0;
    iend(8:9, 6:13, [1,3]) = 150;
    iend(8:9, 6:13, 2) = 0;
    set(handles.roicrtl.hend,'CData',iend);
else
    iend = uint8(192 .* ones(16, 16, 3));
    iend(3:14,12:13, :) =  0;
    iend(8:9, 6:13, :) = 0;
    set(handles.roicrtl.hend,'CData',iend);
end;

guidata(handles.ROIeditor,handles);


function roi_forward(hObject, eventdata, handles)
handles = guidata(handles.ROIeditor);
if isfield(handles, 'plot')
    if ishandle(handles.plot)
        delete(handles.plot);
    end;
    handles=rmfield(handles, 'plot');
end
if isfield(handles,'roiindex')
    handles.roi_timepoint = min(handles.roi_timepoint + 1, length(handles.ROI(1, handles.roiindex).time));
    set(handles.ed_tp,'String', handles.roi_timepoint)
    handles = plotit(handles);
    handles.roicrtl.pos= handles.ROI(1, handles.roiindex).time(handles.roi_timepoint);
    notify(handles.roicrtl,'newpos');
end;
hend_val = handles.ROI(1, handles.roiindex).stop(handles.roi_timepoint);
if hend_val
    iend = uint8(100 .* ones(16, 16, 3));
    iend(3:14,12:13, [1,3]) =  150;
    iend(3:14,12:13, 2) =  0;
    iend(8:9, 6:13, [1,3]) = 150;
    iend(8:9, 6:13, 2) = 0;
    set(handles.roicrtl.hend,'CData',iend);
else
    iend = uint8(192 .* ones(16, 16, 3));
    iend(3:14,12:13, :) =  0;
    iend(8:9, 6:13, :) = 0;
    set(handles.roicrtl.hend,'CData',iend);
end;
guidata(handles.ROIeditor,handles);

function ed_tp_Callback(hObject, eventdata, handles)
% hObject    handle to ed_tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_tp as text
%        str2double(get(hObject,'String')) returns contents of ed_tp as a double


% --- Executes during object creation, after setting all properties.
function ed_tp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
