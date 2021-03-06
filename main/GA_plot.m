function [] = GA_plot(fname)

global eye;

%load converted and preprocessed data
load(fullfile(eye.dir.conv, fname),'ILAB','eyemove','fixvar');

%var for all probands
SCANRATE    = ILAB.acqRate;
nval = round(SCANRATE * eye.plot.dur / 1000);
ONSET = round(SCANRATE * eye.plot.ons / 1000);

RES_X       = ILAB.coordSys.screen(1,1);
RES_Y       = ILAB.coordSys.screen(1,2);
FIX_X       = eye.plot.xy(1);
FIX_Y       = eye.plot.xy(2);

resultfolder= fullfile(eye.dir.results,'plot');

%***************************************
%filtering selected trials
%***************************************
if strcmpi(eye.include.trials,'all')
    fixIX = ILAB.fixorder;
    trlIX = ILAB.trialorder;
else
    eval(['fixIX = sort(unique([' eye.include.trials ']));']);
    fixIX = fixIX(ismember(fixIX, ILAB.fixorder)); %#ok<NODEF>
    eval(['trlIX = sort(unique([' eye.include.trials ']));']);
    trlIX = trlIX(ismember(trlIX, ILAB.trialorder)); %#ok<NODEF>
end;
TRIAL_COUNT = length(trlIX);

if eye.plot.trl.path || eye.plot.trl.fix
    trlOrdNr = find(ismember(ILAB.trialorder, trlIX)); %#ok<NODEF>
    %open stim sequence file
    if eye.plot.white
        pic=cell(TRIAL_COUNT,1);        
        for j= 1:TRIAL_COUNT
            pic{j} = 'white';
        end;
    else        
        proband = fname(1:end-7);
        seqfile = dir(fullfile(eye.dir.stimseq, ['*' proband '*']));
        seqname = seqfile(1).name;
        fid = fopen(fullfile(eye.dir.stimseq,seqname),'r');
        raw = textscan(fid, '%s', 'delimiter' ,'\n');
        fclose(fid);
        raw{1}(1:eye.stim.row-1)=[];
        pic=cell(TRIAL_COUNT,1);
        for j= 1:TRIAL_COUNT
            act_pic = textscan(raw{1}{trlOrdNr(j)},[repmat('%*s',1,eye.stim.col-1) '%s%[...]']);
            pic{j} = act_pic{1}{1};
        end;
    end;
end;

if eye.plot.fix.med || eye.plot.fix.path
    
    if eye.corr.fix.sepmark && ~isempty(fixIX)
        
        %allocating
        fix.x_median = zeros(length(fixIX),1);
        fix.y_median = zeros(length(fixIX),1);
        fix.x = cell(length(fixIX),1);
        fix.y = cell(length(fixIX),1);
        % collect x and y fix values
        for j=1:length(fixIX)
            
            if eye.plot.all
                a=1;
                b= length(eyemove.data.display{1,fixIX(j)}(:,1));
            else
                
                a = ONSET;
                if a <= 0
                    a=1;
                elseif a > length(eyemove.data.display{1,fixIX(j)}(:,1))
                    a=length(eyemove.data.display{1,fixIX(j)}(:,1));
                end;
                b = a + nval;
                if b <= 0
                    b=1;
                elseif b > length(eyemove.data.display{1,fixIX(j)}(:,1))
                    b=length(eyemove.data.display{1,fixIX(j)}(:,1));
                end;
            end;
            % calculate median of scanpath
            if eye.plot.fix.med
                fix.x_median(j) = median(eyemove.data.display{1,fixIX(j)}(a:b,1));
                fix.y_median(j) = median(eyemove.data.display{1,fixIX(j)}(a:b,2));
            end;
            if eye.plot.fix.path
                fix.x{j} = eyemove.data.display{1,fixIX(j)}(a:b,1);
                fix.y{j} = eyemove.data.display{1,fixIX(j)}(a:b,2);
            end;
        end;
    elseif ~eye.corr.fix.sepmark && ~isempty(trlIX)
        if  ~eye.corr.blocked
            %fixation events rel to trial marker
            fix.x_median = zeros(length(trlIX),1);
            fix.y_median = zeros(length(trlIX),1);
            fix.x= cell(length(trlIX),1);
            fix.y= cell(length(trlIX),1);
            % onset of fixation phase
            % collect x and y fix values
            for j=1:length(trlIX)
                
                if eye.plot.all
                    a=1;
                    b=length(eyemove.data.display{1,trlIX(j)}(:,1));
                else
                    
                    a = ONSET;
                    if a <= 0
                        a=1;
                    elseif a > length(eyemove.data.display{1,trlIX(j)}(:,1))
                        a=length(eyemove.data.display{1,trlIX(j)}(:,1));
                    end;
                    b = a + nval;
                    if b <= 0
                        b=1;
                    elseif b > length(eyemove.data.display{1,trlIX(j)}(:,1))
                        b=length(eyemove.data.display{1,trlIX(j)}(:,1));
                    end;
                end;
                % calculate median of scanpath
                if eye.plot.fix.med
                    fix.x_median(j) = median(eyemove.data.display{1,trlIX(j)}(a:b,1));
                    fix.y_median(j) = median(eyemove.data.display{1,trlIX(j)}(a:b,2));
                end;
                if eye.plot.fix.path
                    fix.x{j} = eyemove.data.display{1,trlIX(j)}(a:b,1);
                    fix.y{j} = eyemove.data.display{1,trlIX(j)}(a:b,2);
                end;
            end;
            %blocked
        else
            k=1;
            act_trl=[];
            % collect x and y fix values
            for j=1:length(trlIX)
                ix = ILAB.index(trlIX(j),1);
                %if another block of trial starts...
                if ILAB.data(ix,3) ~=act_trl && ILAB.data(ix,3) ~=255
                    act_trl = ILAB.data(ix,3);
                    a = ONSET;
                    if a <= 0
                        a=1;
                    elseif a > length(eyemove.data.display{1,trlIX(j)}(:,1))
                        a=length(eyemove.data.display{1,trlIX(j)}(:,1));
                    end;
                    b = a + nval;
                    if b <= 0
                        b=1;
                    elseif b > length(eyemove.data.display{1,trlIX(j)}(:,1))
                        b=length(eyemove.data.display{1,trlIX(j)}(:,1));
                    end;
                    % calculate median of scanpath
                    if eye.plot.fix.med
                        fix.x_median(k) = median(eyemove.data.display{1,trlIX(j)}(a:b,1));
                        fix.y_median(k) = median(eyemove.data.display{1,trlIX(j)}(a:b,2));
                    end;
                    if eye.plot.fix.path
                        fix.x{k} = eyemove.data.display{1,trlIX(j)}(a:b,1);
                        fix.y{k} = eyemove.data.display{1,trlIX(j)}(a:b,2);
                    end;
                    k = k+1;
                end;
            end;
        end;
    end;
end;

if eye.plot.corr
    %load correction parameter
    if isempty(who('-file', fullfile(eye.dir.conv, fname),'corr_par'))
        disp('miss correction parameter -> analyze uncorrected data');
        corr_par = zeros(TRIAL_COUNT,4);
        corr_par(:,1) = trlIX;
        corr_par(:,2) = trlIX;
    else
        load(fullfile(eye.dir.conv, fname),'corr_par');
    end;
    strcorr = '_cor';
else
    strcorr = '';
end;

screen =ones(RES_Y,RES_X,3);

%+++++++++++++++++++++++++++++++++++++++++++++
%ploting data
%+++++++++++++++++++++++++++++++++++++++++++++
%plot trial path
if eye.plot.trl.path || eye.plot.trl.fix
    
    for j= 1:length(trlIX)
        
        trldatNr = trlIX(j);
        if ~eye.plot.white
            picname = strrep(eye.stim.pic,'$pic',pic{j});
        end;
        
        %***************************************
        %filter selected pictures
        %***************************************
        flag_plot=0;
        if eye.plot.white
                rgb = screen;
                flag_plot=1;
         elseif ismember(picname, eye.include.pics) | strcmpi(eye.include.pics,'all')
            flag_plot=1;
            rgb = imread(fullfile(eye.dir.stim,picname));
            pic{j} = strrep(pic{j},'.JPG','');
            pic{j} = strrep(pic{j},'.jpg','');
            pic{j} = strrep(pic{j},'.mpeg','');
            pic{j} = strrep(pic{j},'.avi','');
         end;    
         if flag_plot
            %shift with correction parameter?
            if eye.plot.corr
                %find related fix period
                k = find(corr_par(:,1)<=trldatNr & corr_par(:,2)>=trldatNr);
                corr_x = corr_par(k,3);
                corr_y = corr_par(k,4);
            else
                corr_x = 0;
                corr_y = 0;
            end;
            
            if eye.plot.trl.path
                %not the entire trial?
                if ~eye.plot.all
                    if length(eyemove.data.display{1,trldatNr}(:,1))<eye.plot.ons
                        ons = length(eyemove.data.display{1,trldatNr}(:,1)); %#ok<NASGU>
                    end;
                    if eye.plot.ons < 1
                        ons = 1;
                    else
                        ons = round(SCANRATE) * eye.plot.ons / 1000;
                    end;
                    
                    if length(eyemove.data.display{1,trldatNr}(:,1))<(nval+ons)
                        nval = length(eyemove.data.display{1,trldatNr}(:,1))-ons;
                    else
                        nval = round(SCANRATE) * eye.plot.dur / 1000;
                    end;
                    plot_x = eyemove.data.display{1,trldatNr}(ons:ons + nval,1);
                    plot_y = eyemove.data.display{1,trldatNr}(ons:ons + nval,2);
                    
                else
                    plot_x = eyemove.data.display{1,trldatNr}(:,1);
                    plot_y = eyemove.data.display{1,trldatNr}(:,2);
                end;
                
                spfFig = figure;
                %display the first picture
                imshow( screen );
                figure(spfFig);
                reset( gcf );
                reset( gca );
                hold on;
                axis image;
                
                Xdatx = (RES_X-size(rgb,2))/2 + FIX_X;
                Xdaty = size(rgb,2) + (RES_X-size(rgb,2))/2 + FIX_Y;
                Ydatx = (RES_Y-size(rgb,1))/2 + FIX_X;
                Ydaty = size(rgb,1) + (RES_Y-size(rgb,1))/2 + FIX_Y;
                imshow(rgb, 'XData', [Xdatx Xdaty], 'YData', [Ydatx Ydaty],  'InitialMagnification', 100);
                
                disp(['plot path: ' pic{j} ' trialnr:' num2str(trldatNr)]);
                plot(plot_x - corr_x, plot_y - corr_y,'Color','black','LineWidth',1,'Parent',gca);
                %start and end point
                scatter(plot_x(1) - corr_x, plot_y(1) - corr_y,'Parent',gca,'MarkerEdgeColor','none','MarkerFaceColor','green','LineWidth', 2);
                scatter(plot_x(end) - corr_x, plot_y(end)  - corr_y,'Parent',gca,'MarkerEdgeColor','none','MarkerFaceColor','red','LineWidth',2);
                %5. export
                export_fig(fullfile(resultfolder,'trialpath', [fname(1:end-7) '_' pic{j} strcorr '_trl' num2str(trldatNr) '_path.jpg']),'-jpg',spfFig,'-native');
                close(spfFig);
            end;
            if eye.plot.trl.fix
                %not the entire trial?
                if ~eye.plot.all
                    index = find(fixvar.list(:,1) == trldatNr & ...
                        fixvar.list(:,6) >= round(SCANRATE * eye.plot.ons / 1000) & ...
                        fixvar.list(:,6) <= round(SCANRATE * (eye.plot.dur+eye.plot.ons) / 1000));
                else
                    index = find(fixvar.list(:,1) == trldatNr);
                end;
                
                spfFig = figure;
                %showing of the first picture
                imshow( screen );
                figure(spfFig);
                reset( gcf );
                reset( gca );
                hold on;
                axis image;
                
                Xdatx = (RES_X-size(rgb,2))/2 + FIX_X;
                Xdaty = size(rgb,2) + (RES_X-size(rgb,2))/2 + FIX_Y;
                Ydatx = (RES_Y-size(rgb,1))/2 + FIX_X;
                Ydaty = size(rgb,1) + (RES_Y-size(rgb,1))/2 + FIX_Y;
                imshow(rgb, 'XData', [Xdatx Xdaty], 'YData', [Ydatx Ydaty],  'InitialMagnification', 100);
                
                disp(['plot Fixations: ' pic{j} ' trialnr:' num2str(trldatNr)]);
                if ~isempty(index)
                    plot(fixvar.list(index,2) - corr_x, fixvar.list(index,3)  - corr_y, ...
                        'Color','black','LineWidth',1,'Marker','o', 'MarkerEdgeColor','b','MarkerFaceColor','none',...
                        'MarkerSize',2,'Parent',gca);
                    for k= 1:length(index)
                        width=fixvar.list(index(k),7)/2;
                        posx=fixvar.list(index(k),2)-width/2 - corr_x;
                        posy=fixvar.list(index(k),3)-width/2 - corr_y;
                        rectangle('Position',[posx,posy,width,width],'Curvature',[1,1],'FaceColor','none', 'EdgeColor', 'b','Parent',gca);
                    end;
                    %start und endpunkt
                    scatter(fixvar.list(index(1),2) - corr_x, fixvar.list(index(1),3) - corr_y,'MarkerEdgeColor','none','MarkerFaceColor','green','LineWidth', 2,'Parent',gca);
                    scatter(fixvar.list(index(end),2) - corr_x, fixvar.list(index(end),3) - corr_y,'MarkerEdgeColor','none','MarkerFaceColor','red','LineWidth',2,'Parent',gca);
                end;
                %5. exportieren
                export_fig(fullfile(resultfolder,'trialfix', [fname(1:end-7) '_' pic{j} strcorr '_trl' num2str(trldatNr) '_fix.jpg']),'-jpg',spfFig,'-native');
                close(spfFig);
            end;
        end;
    end;
end;
%plotting fixation period path
if eye.plot.fix.med ||eye.plot.fix.path
    
    spfFig = figure;
    
    for j=1:length(fix.x)
        if eye.plot.corr
            corr_x = corr_par(j,3);
            corr_y = corr_par(j,4);
        else
            corr_x = 0;
            corr_y = 0;
        end;
        
        if eye.plot.fix.path
            
            figure(spfFig);
            imshow( screen );
            reset( gcf );
            reset( gca );
            hold on;
            axis image;
            text(RES_X/2+FIX_X,RES_Y/2+FIX_Y,'+');
            
            disp(['plot fix path: trialnr:' num2str(fixIX(j))]);
            %ploting the fix data
            plot(fix.x{j}(:) - corr_x,fix.y{j}(:) - corr_y,'Color','black','LineWidth',1);
            %start and endpoint
            scatter(fix.x{j}(1) - corr_x,fix.y{j}(1) - corr_y,'MarkerEdgeColor','none','MarkerFaceColor','green','LineWidth', 2);
            scatter(fix.x{j}(end) - corr_x,fix.y{j}(end) - corr_y,'MarkerEdgeColor','none','MarkerFaceColor','red','LineWidth',2);
            %5. exportieren
            export_fig(fullfile(resultfolder,'fixpath', [fname(1:end-7) strcorr '_fix' num2str(fixIX(j)) '_path.jpg']),'-jpg',spfFig,'-native');
            close(spfFig);
        end;
        if eye.plot.fix.med
            
            figure(spfFig);
            imshow( screen );
            reset( gcf );
            reset( gca );
            hold on;
            axis image;
            text(RES_X/2+FIX_X,RES_Y/2+FIX_Y,'+');
            
            disp(['plot fix median: trialnr:' num2str(fixIX(j))]);
            %plot median
            scatter(fix.x_median(j) - corr_x,fix.y_median(j) - corr_y,'MarkerEdgeColor','none','MarkerFaceColor','green','LineWidth', 2);
            %export
            export_fig(fullfile(resultfolder,'fixmed', [fname(1:end-7) strcorr '_fix' num2str(fixIX(j)) '_med.jpg']),'-jpg',spfFig,'-native');
            close(spfFig);
        end;
    end;
end;

