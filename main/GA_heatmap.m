function GA_heatmap(testeye)

%Generates heatmaps from fixations and prints them to images

%Copyright (C) Martin Winkels, Christoph Berger 2010

warning off all;

global eye;


if nargin==1
    
    eye = testeye;
    eye.testeye = 1;
else
        eye.testeye = 0;
end

tic;

%--------------------------------------------------------------------------
% allocation of variables
%--------------------------------------------------------------------------

heat.heatmap_path = fullfile(eye.dir.results, 'heatmaps');
if ~isdir(heat.heatmap_path)
    mkdir(heat.heatmap_path);
end;

heat.trial = eye.include.trials;

%Eyetracker-ScreenSize
heat.screensize.x = eye.heatmap.screen(2);
heat.screensize.y = eye.heatmap.screen(4);

%List of images to apply heatmaps later-on (note: this script is
%image-triggerd)
heat.pictures_path = eye.dir.stim;
heat.picname = strrep(eye.stim.pic , '$pic','*');
if strcmpi(eye.include.pics,'all')
    fnames = dir(fullfile(heat.pictures_path, heat.picname));
    fnames = fnames(~[fnames.isdir]);
    heat.pictures = {fnames.name};
else
    heat.pictures = eye.include.pics;
end;

heat.size_pictures= length(heat.pictures);

%List of data files
heat.data_path = eye.dir.conv;

if strcmpi(eye.include.files,'all')
    fnames = dir(fullfile(heat.data_path, '*_GA.mat'));
    heat.data_results = {fnames.name};
else
    heat.data_results = strcat(eye.include.files,'_GA.mat');
end;

heat.size_data= length(heat.data_results);

%Dir of the picture sequence files
heat.dir_pic_seq = eye.dir.stimseq;
heat.pic_seq = dir(fullfile(heat.dir_pic_seq, '*.txt'));
heat.size_seq= length(heat.pic_seq);

%--------------------------------------------------------------------------
% Included file all/excelfile/groups
%--------------------------------------------------------------------------

switch eye.heatmap.group.type
    
    % all subjects means the sucjects that will be committed by GA
    case  'all'
        
        for i=1:heat.size_data
            heat.subjects{i,1}= heat.data_results{i}(1:end-7);
        end
        if ~isempty(heat.subjects)
            heat.size_subjects = length(heat.subjects);
        end
        
        generate_heatmaps(heat,eye);
        
        % file means that you can select different groups based on an
        % external excel file.
    case  'file'
        
        [xls_num, xls_char] = xlsread(eye.heatmap.dir.datafile); %#ok<ASGLU>
        
        size_xls = size(xls_char); %zeilen/spalten
        
        for h=1:size_xls(2)
            counter =1;
            for i=1:size_xls(1)
                
                if ~strcmp(xls_char{i,h},'')
                    
                    for j=1:length(heat.data_results)
                        
                        if strfind(heat.data_results{j}, xls_char{i,h})
                            heat.subjects{counter,1} = heat.data_results{j}(1:end-7);
                            counter = counter+1;
                        end
                        
                    end
                end
            end
            if ~isempty(heat.subjects)
                heat.size_subjects = length(heat.subjects);
            end
            heat.groupnr = h;
            
            generate_heatmaps(heat,eye);
        end
        
end

if  eye.testeye == 0
    tElapsed=toc;
    msgbox(['Finished in ' num2str(tElapsed) ' seconds!'],'Done...','help');
end
%--------------------------------------------------------------------------
% Main function, generates heatmaps with various subfunctions
%--------------------------------------------------------------------------
function generate_heatmaps(heat,eye)

%waitbar setup
% wbh = waitbar(0,'Working on picture ','Name','Generating heatmaps');
% steps = heat.size_pictures;

%loop over all images in folder
for z=1:heat.size_pictures
    
    
    %waitbar step waitbar(z / steps, wbh, ['Working on picture '
    %heat.pictures(z,1).name])
    
    %allocate picture // picture so work with
    selected_picture = heat.pictures{z};
    
    %create an empty matrix where the fixations will be entered
    fixationfield = zeros(heat.screensize.y,heat.screensize.x,1);
    
    
    %%loop over all subjects
    for u=1:heat.size_subjects
        
        %%%%% SELECTING NEEDED FILES
        
        %selected subject + conversion if the data is in the wrong format
        sel_subject = heat.subjects(u,1);
        
        if isnumeric(sel_subject)
            sel_subject = num2str(sel_subject);
        end;
        
        if iscell(sel_subject)
            sel_subject = cell2mat(sel_subject);
        end;
                
        
        %selected seq-file
        seqfile = dir(fullfile(eye.dir.stimseq, ['*' sel_subject '*']));
        
        if ~isempty(seqfile)
            
              sel_seqfile = seqfile(1).name;
            
%             for s=1:heat.size_seq
%                 
%                 if(~isempty(strfind(heat.pic_seq(s,1).name, sel_seqfileraw)) || ~isempty(strfind(sel_seqfileraw, heat.pic_seq(s,1).name)))
%                     sel_seqfile =heat.pic_seq(s,1).name;
%                     break;
%                 end
%                 
%             end
            
            %selected data-file
            for d=1:heat.size_data
                
                if(strfind(heat.data_results{d}, sel_subject))
                    sel_datafile =heat.data_results{d};
                    break;
                end
                
            end
            
            %%%%%
            
            %%%%% LOADING NEEDED DATA FROM FILES + SEARCH PICTRIAL
            
            %opening and reading of the selected sequence file
            fid = fopen(fullfile(heat.dir_pic_seq, sel_seqfile), 'r');
            series = textscan(fid, '%s', 'delimiter' ,'\n');
            series{1}(1:eye.stim.row-1)=[];
            fclose(fid);
            
            %opening and reading of the fixationlist and ILAB-struct
            load(fullfile(heat.data_path, sel_datafile),'fixvar','ILAB');
                        
            %get the selected trial
            if strcmpi(eye.include.trials,'all')
                trlIX = ILAB.trialorder;
            else
                eval(['trlIX = sort(unique([' eye.include.trials ']));']);
                trlIX = trlIX(ismember(trlIX, ILAB.trialorder));
            end;
            
            trial_count = length(trlIX);
            selected_ILABtrial='';
            
            
            for j= 1:trial_count

                act_pic = textscan(series{1}{j},[repmat('%*s',1,eye.stim.col-1) '%s%[...]']);
                
                if strcmpi( selected_picture ,strrep(eye.stim.pic,'$pic',act_pic{1}))
                    selected_ILABtrial = trlIX(j);
                    break;
                end;
            end;
            
            if ~isempty(selected_ILABtrial)
                
                %%%%%
                
                %%%%% CORRECTION SETTINGS
                
                %If correction is needed,  correction factors will be
                %loaded otherwise they will be set to zero
                if eye.heatmap.dir.usecorrection == 1
                    %load correction parameter
                    load(fullfile(eye.dir.conv, [sel_subject '_GA.mat']),'corr_par');
                    k = find(corr_par(:,1)<=selected_ILABtrial & corr_par(:,2)>=selected_ILABtrial);
                    subx = round(corr_par(k,3));
                    suby = round(corr_par(k,4));                    
                else
                    subx = 0;
                    suby = 0;
                    
                end
                
                %%%%%
                
                %%%%% GENERATING FIXATION FIELD
                
                %Provide entry of the fixations into the FixationField-Matrix
                indextrial = find(fixvar.list(:,1) == selected_ILABtrial);
                
                for i=1:length(indextrial)
                    
                    x = round(fixvar.list(indextrial(i),2)-subx);
                    y = round(fixvar.list(indextrial(i),3)-suby);
                    
                    if (x > 0 && y > 0 && y <= heat.screensize.y && x <=heat.screensize.x)
                        
                        %Count fixations
                        if strcmp(eye.heatmap.color.fixtype, 'countfix')
                            
                            fixationfield(y,x,1) = fixationfield(y,x,1)+1;
                            
                            %Count fixation-times
                        elseif strcmp(eye.heatmap.color.fixtype, 'fixtime')
                            
                            fixationfield(y,x,1) = fixationfield(y,x,1)+fixvar.list(indextrial(i),7)*(ILAB.acqIntvl);
                            
                        end
                    end
                end
            end
        else 
            
        disp(['ERROR no sequencefile for: ', sel_subject]);
        end
        %%%%%
    end
    
    %%%%%
    
    %%%%% BUILDING HEATMAP IMAGE
    
    %reading of the stim-picture
    base_picture = imread(fullfile(heat.pictures_path, selected_picture));
    
    %CIRCLEFIELD
    %create circles around fixations
    circlefield = circle(fixationfield, eye, heat.screensize);
    
    %%transparency or with surrounding colormap?
    if strcmp(eye.heatmap.creation.bocolor, 'none')
        
        heat_map = ones(heat.screensize.y,heat.screensize.x,3);
        %to see what belongs to the heatmap and what don't
        heat_map = heat_map*2;
        
    else
        heat_map = ones(heat.screensize.y,heat.screensize.x,3);
        heat_map(:,:,1) = heat_map(:,:,1)*eye.heatmap.creation.bocolor(1);
        heat_map(:,:,2) = heat_map(:,:,2)*eye.heatmap.creation.bocolor(2);
        heat_map(:,:,3) = heat_map(:,:,3)*eye.heatmap.creation.bocolor(3);
    end
    
    %HEATMAP
    %generates the heatmap
    heatmap = gen_heatoverlay(circlefield, eye, heat.screensize, heat_map);
    
    %ALPHAMAP
    %Generating of the alpha_map this is responsable for the transparency
    %of the heatmap
    if strcmp(eye.heatmap.creation.bocolor, 'none')
        
        alpha_map = zeros(heat.screensize.y,heat.screensize.x);
        
        for xsec=1:heat.screensize.x
            
            for ysec=1:heat.screensize.y
                
                if ~(heatmap(ysec,xsec,1) < 3 && heatmap(ysec,xsec,1)> 1.5)
                    
                    alpha_map(ysec,xsec) = eye.heatmap.creation.transparency;
                else
                    
                    heatmap(ysec,xsec,1)= eye.heatmap.color.color1(1);
                    heatmap(ysec,xsec,2)= eye.heatmap.color.color1(2);
                    heatmap(ysec,xsec,3)= eye.heatmap.color.color1(3);
                end
            end
        end
        
        %smooth transparency in edges
        h = fspecial('disk',eye.heatmap.creation.filteratt);
        alpha_map = imfilter(alpha_map,h,'replicate');
        alpha_map = round(alpha_map*100)/100;
        
    else
        
        alpha_map = ones(heat.screensize.y,heat.screensize.x)*eye.heatmap.creation.transparency;
    end
    
    %FILTER
    %filter to smooth the rois / make them look good
    %more filters to implement in future here
    h = fspecial('disk',eye.heatmap.creation.filteratt);
    heatmap = imfilter(heatmap,h,'replicate');
    
    %     h = fspecial('gaussian', [5 5], 0.8); X8 =
    %     imfilter(X8,h,'circular', 1);
    
    %light up the picture if needed
    % him = imshow(ones(screensize.y,screensize.x,1),'XData', [0
    % screensize.x], 'YData', [0 screensize.y]); set(him,'AlphaData', 0.1)
    
    %%%%%
    
    %%%%% BRING HEATMAP IMAGE TO SCREEN
    
    
    %creating of the figure & first picture
    figure;
    %    axis image;
    %first picture background-image
    colorIm = ones(heat.screensize.y-1,heat.screensize.x-1,3);
    colorIm(:,:,1) = colorIm(:,:,1)*eye.heatmap.creation.bcolor(1);
    colorIm(:,:,2) = colorIm(:,:,2)*eye.heatmap.creation.bcolor(2);
    colorIm(:,:,3) = colorIm(:,:,3)*eye.heatmap.creation.bcolor(3);
    
    %showing of the first picture
    imshow( colorIm,'XData', [1 heat.screensize.x], 'YData', [1 heat.screensize.y]);
    %   reset( gcf );
    %   reset( gca );
    %visible or invisble, good for testing set( spfFig , 'Visible', 'off');
    
    %hold on to create some more pictures
    hold on;
    
    
    %second picture showing and centering the stim-picture
    Xdatx = (eye.heatmap.screen(2)-size(base_picture,2))/2 + eye.heatmap.creation.shiftpic(1)+1;
    Xdaty = size(base_picture,2) + (eye.heatmap.screen(2)-size(base_picture,2))/2 + eye.heatmap.creation.shiftpic(2);
    Ydatx = (eye.heatmap.screen(4)-size(base_picture,1))/2 + eye.heatmap.creation.shiftpic(1)+1;
    Ydaty = size(base_picture,1) + (eye.heatmap.screen(4)-size(base_picture,1))/2 + eye.heatmap.creation.shiftpic(2);
    imshow(base_picture, 'XData', [Xdatx Xdaty], 'YData', [Ydatx Ydaty],  'InitialMagnification', 100);
    
    
    %third picture place heatmap over the complete scene
    spfFig = imshow(heatmap);
    set(spfFig,'AlphaData', alpha_map)
    %set(gcf, 'color', 'none')
    
    %%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%
    cmap = 0;
    
    if cmap == 1
        
        colormap(jet(250));
        scale = 250/eye.heatmap.color.stage14;
        hcb = colorbar('location', 'East', 'Color', 'white' ,...
            'YTickLabel',...
            {eye.heatmap.color.stage0,eye.heatmap.color.stage1,eye.heatmap.color.stage2,...
            eye.heatmap.color.stage3,eye.heatmap.color.stage4,eye.heatmap.color.stage5...
            ,eye.heatmap.color.stage6,eye.heatmap.color.stage7,eye.heatmap.color.stage8,...
            eye.heatmap.color.stage9,eye.heatmap.color.stage10,eye.heatmap.color.stage11,...
            eye.heatmap.color.stage12,eye.heatmap.color.stage13,eye.heatmap.color.stage14},...
            'YTick',...
            [scale*eye.heatmap.color.stage0,scale*eye.heatmap.color.stage1,scale*eye.heatmap.color.stage2,...
            scale*eye.heatmap.color.stage3,scale*eye.heatmap.color.stage4,scale*eye.heatmap.color.stage5...
            ,scale*eye.heatmap.color.stage6,scale*eye.heatmap.color.stage7,scale*eye.heatmap.color.stage8,...
            scale*eye.heatmap.color.stage9,scale*eye.heatmap.color.stage10,scale*eye.heatmap.color.stage11,...
            scale*eye.heatmap.color.stage12,scale*eye.heatmap.color.stage13,scale*eye.heatmap.color.stage14]);
        set(hcb,'YTickMode','manual');
        
    end
    %%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%TEST%%%%%
    
    %Some transformations to enable a good scaled output when saving the
    %figure...
    %set( spfFig, 'Units', 'pixels', 'position', [100 100 imCols imRows] );
    %set( gca, 'Units', 'pixels', 'position', [1 1 imCols imRows ]);
    %set( spfFig, 'paperunits', 'points', 'papersize', [fix((imCols-1)*(3/4))+1 fix((imRows-1)*(3/4))+1]);
    %set( spfFig, 'paperunits', 'normalized', 'paperposition', [0 0 1 1]);
    
    
    %Save of the generated heatmap
    if  eye.testeye == 0
        
        savefig(heat,selected_picture,eye.heatmap.group.type);
        
         close (gcf);
         
    else
        
        % Construct a questdlg with three options
        choice = questdlg('Would you like to create another Testheatmap?', ...
            'Testheatmap', ...
            'Yes','No','No');
        % Handle response
        switch choice
            case 'Yes'
                close (gcf);
            case 'No'
                close (gcf);
                break
                
        end
        
    end

    
end

%close(wbh)


%Done!


%tells you when finished...
warning on all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% CIRCLE FUNCTION %%%

function [circ_field]= circle(fixation_field, eye, screensize)

%cirlce radius
radius = eye.heatmap.creation.fixradius;

%empty cirlce field
circ_field = zeros(screensize.y,screensize.x);

%drawing circles into circle field based on fixation field
for xsec=1:screensize.x
    
    for ysec=1:screensize.y
        
        if (fixation_field(ysec,xsec,1)>0)
            
            
            t = 0:.1:2*pi;
            x = round(radius*cos(t)+round(xsec));
            y = round(radius*sin(t)+round(ysec));
            mask = poly2mask(x,y,screensize.y,screensize.x);
            
            for a=1:screensize.x
                
                for b=1:screensize.y
                    
                    if (mask(b,a)==1)
                        
                        circ_field(b,a,1) =circ_field(b,a,1) + fixation_field(ysec,xsec,1);
                        
                    end
                end
            end
        end
    end
    
    
end

%%% HM OVERLAY %%%

function [heat_map]= gen_heatoverlay(circlefield, eye, screensize, heat_map)

%for the whole pixel array, apply some color
for xsec=1:screensize.x
    
    for ysec=1:screensize.y
        
        %if the circlefield value fits into value-borders - apply some
        %color
        if circlefield(ysec,xsec) >= (eye.heatmap.color.stage0)
            
            if circlefield(ysec,xsec)>=(eye.heatmap.color.stage0) && circlefield(ysec,xsec) < (eye.heatmap.color.stage1)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color1(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color1(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color1(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage1) && circlefield(ysec,xsec) < (eye.heatmap.color.stage2)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color2(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color2(2);
                heat_map(ysec,xsec,3)=eye.heatmap.color.color2(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage2) && circlefield(ysec,xsec) < (eye.heatmap.color.stage3)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color3(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color3(2);
                heat_map(ysec,xsec,3)=eye.heatmap.color.color3(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage3) && circlefield(ysec,xsec) < (eye.heatmap.color.stage4)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color4(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color4(2);
                heat_map(ysec,xsec,3)=eye.heatmap.color.color4(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage4) && circlefield(ysec,xsec) < (eye.heatmap.color.stage5)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color5(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color5(2);
                heat_map(ysec,xsec,3)=eye.heatmap.color.color5(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage5) && circlefield(ysec,xsec) < (eye.heatmap.color.stage6)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color6(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color6(2);
                heat_map(ysec,xsec,3)=eye.heatmap.color.color6(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage6) && circlefield(ysec,xsec) < (eye.heatmap.color.stage7)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color7(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color7(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color7(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage7) && circlefield(ysec,xsec) < (eye.heatmap.color.stage8)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color8(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color8(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color8(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage8) && circlefield(ysec,xsec) < (eye.heatmap.color.stage9)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color9(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color9(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color9(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage9) && circlefield(ysec,xsec) < (eye.heatmap.color.stage10)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color10(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color10(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color10(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage10) && circlefield(ysec,xsec) < (eye.heatmap.color.stage11)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color11(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color11(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color11(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage11) && circlefield(ysec,xsec) < (eye.heatmap.color.stage12)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color12(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color12(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color12(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage12) && circlefield(ysec,xsec) < (eye.heatmap.color.stage13)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color13(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color13(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color13(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage13) && circlefield(ysec,xsec) < (eye.heatmap.color.stage14)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color14(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color14(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color14(3);
                
            elseif circlefield(ysec,xsec)>= (eye.heatmap.color.stage14) && circlefield(ysec,xsec) < (eye.heatmap.color.stage15)
                
                heat_map(ysec,xsec,1)= eye.heatmap.color.color15(1);
                heat_map(ysec,xsec,2)= eye.heatmap.color.color15(2);
                heat_map(ysec,xsec,3)= eye.heatmap.color.color15(3);
                
            end
        end
    end
end

%%% HEATMAP EXPORT %%%

function savefig(heat,selected_picture,grouptype)


if strcmp(grouptype, 'all')
    
    %external script produced and Copyright (C) by OliverWoodford 2008-2009
    %saves the figure very nicely
    export_fig(fullfile(heat.heatmap_path, selected_picture),'-jpg', '-native');
    
    %file
elseif strcmp(grouptype, 'file')
    
    grouppath = fullfile(heat.heatmap_path, num2str(heat.groupnr));
    mkdir(grouppath);
    %external script produced and Copyright (C) by OliverWoodford 2008-2009
    %saves the figure very nicely
    export_fig(fullfile(grouppath, selected_picture),'-jpg', '-native');
    
end

