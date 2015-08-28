function GA_controler(action, eye_form)

global eye;

eye = eye_form;

do.convert = 0;
do.correction = 0;
do.consistency = 0;
do.plot = 0;
do.blinks = 0;
do.filter = 0;
do.fixations = 0;
do.saccades = 0;
do.pupil = 0;
do.heatmaps = 0;
do.analysis = 0;
do.email = 0;

import= []; %#ok<NASGU>
ILAB=[];
AP =[];
switch action
    case 'import'
        do.convert = 1;
    case 'Batch'
        do.convert = eye.jobs.convert;
        do.correction = eye.jobs.correction;
        do.consistency = eye.jobs.consistency;
        do.plot = eye.jobs.plot;
        do.blinks =eye.jobs.blinks;
        do.filter = eye.jobs.filter;
        do.fixations = eye.jobs.fixations;
        do.saccades = eye.jobs.saccades;
        do.pupil = eye.jobs.pupil;
        do.heatmaps = eye.jobs.heatmaps;
        do.analysis = eye.jobs.analysis;
        do.email = eye.jobs.email;
    case 'preprocessing'
        do.blinks =1;
        do.filter = 1;
        do.fixations = 1;
        do.saccades = 1;
        do.pupil = 1;
    case 'correction'
        do.correction = 1;
    case 'consistency'
        do.consistency = 1;
    case 'plot'
        do.plot = 1;
    case 'blinks'
        do.blinks = 1;
    case 'filter'
        do.filter = 1;
    case 'fixations'
        do.fixations = 1;
    case 'saccades'
        do.saccades = 1;
    case 'pupil'
        do.pupil = 1;
    case 'heatmaps'
        do.heatmaps = 1;
    case 'analysis'
        do.analysis = 1;
end;

if do.convert || do.consistency || do.blinks || do.filter || do.fixations || do.saccades || do.pupil
    switch eye.datatype
        case {'Viewpoint','IVIEW','ISCAN','Tobii','MonkeyLogic'}
            startvalues = regexp(eye.cond.start.values, ';', 'split');
            startvalues = strtrim(startvalues);
            idx_0 = ~strcmp(startvalues,'');
            startvalues=startvalues(idx_0);
            eval(['codes = sort(unique([' eye.cond.start.codes ']));']);
            if size(codes,1)>size(codes,2)
                codes= codes';
            end;
            trialcodes = codes;
            if eye.cond.flag_fixedgaze
                fixcodes =max(codes) + 1;
            else
                fixcodes =[];
            end;
    end;
end
%--------------------------------------------------------------------------
% convert eyetracker files to GazeAlyze struct eye
%--------------------------------------------------------------------------

if do.convert
    flag_error=0;
    wb = waitbar(0,'', 'Name',[eye.datatype ' File Conversion...']);
    err_cnt=0;
    if strcmpi(eye.include.files,'all')
        path = eye.dir.raw;
        rawdat = dir(path);
        rawdat = rawdat([rawdat.isdir]==0);
        pathcontent = {rawdat.name}';
        fID = pathcontent;
        %filter path content
        if ~strcmp(eye.dir.fileid,'')
            strPos = strfind(eye.dir.fileid,'$id');
            %placeholder '$id' exists
            if ~isempty(strPos)
                if strPos>1
                    Prefix = eye.dir.fileid(1:strPos-1);
                    included = strncmpi(pathcontent, Prefix, length(Prefix));
                    pathcontent = pathcontent(included);
                    fID = fID(included);
                    fID = cellfun(@(x) strrep(x,Prefix,''),fID, 'UniformOutput', false);
                end;
                if length(eye.dir.fileid) - strPos + 3  > 0
                    Suffix = eye.dir.fileid((strPos + 3):end);
                    included = cellfun(@(x) strcmp(x(end-length(Suffix)+1:end),Suffix),pathcontent);
                    pathcontent = pathcontent(included);
                    fID = fID(included);
                    fID = cellfun(@(x) strrep(x,Suffix,''),fID, 'UniformOutput', false);
                end;
                %placeholder '$id' exists not
            else
                strPos = strfind(eye.dir.fileid,'.');
                Suffix = eye.dir.fileid(strPos(end):end);
                fID = cellfun(@(x) strrep(x,Suffix,''),fID, 'UniformOutput', false);
            end;
        end;
        steps = length(pathcontent);
    else
        steps = length(eye.include.files);
    end;
    
    for i=1:steps
        
        import= []; %#ok<NASGU>
        ILAB=[];
        AP =[];
        IX=[];
        
        if strcmpi(eye.include.files,'all')
            fname = pathcontent{i};
            ident = fID{i};
        else
            fname = strrep(eye.dir.fileid,'$id',eye.include.files{i});
            ident = eye.include.files{i};
        end;
        waitbar(i / steps, wb, ['Working on file ' fname])
        disp (['import: ', fname, '...']);
        %--------------------------------------------------------------------------
        % DataType Viewpoint
        %--------------------------------------------------------------------------
        
        if strcmp(eye.datatype, 'Viewpoint')
            
            [import, ILAB, flag_error] = GA_ilabConvertViewpoint(eye.dir.raw, fname); %#ok<ASGLU>
            
            %--------------------------------------------------------------------------
            % DataType ASL
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'ASL')
            GA_ilabAnalysisParms();
            
            [ILAB, eye.AP] = GA_ilabConvertASL(eye.dir.raw, fname, eye.datatype_custval, eye.AP);
            
            %--------------------------------------------------------------------------
            % DataType CORTEX
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'CORTEX')
            
            [eye.ILAB, eye.AP] = GA_ilabConvertCORTEX(eye.dir.raw, fname, eye.AP);
            
            %--------------------------------------------------------------------------
            % DataType ISCAN
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'ISCAN')
            
            [import, ILAB, flag_error] = GA_ilabConvertISCAN_ascii_v400(eye.dir.raw, fname); %#ok<ASGLU>
            
            %--------------------------------------------------------------------------
            % DataType IVIEW
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'IVIEW')
            [import, ILAB, flag_error]= GA_ilabConvertIVIEW_IDF_201(eye.dir.raw, fname); %#ok<ASGLU>
            
            %--------------------------------------------------------------------------
            % DataType Tobii (EPRIME Extension)
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'Tobii')
            [import, ILAB, flag_error]= GA_ilabConvertTobii_TX300(eye.dir.raw, fname); %#ok<ASGLU>
            
            %--------------------------------------------------------------------------
            % DataType MonkeyLogic
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'MonkeyLogic')
            [import, ILAB, flag_error]= GA_ilabConvertMonkeyLogic_mat(eye.dir.raw, fname); %#ok<ASGLU>
            
            %--------------------------------------------------------------------------
            % DataType CB
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'CB')
            %automatische Auswahlfunktion für den Datentyp
            % eye.ILAB = GA_ilabConvertCB;
            
            %--------------------------------------------------------------------------
            % DataType TextFileCB
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'TextFileCB')
            %automatische Textfunktion für den Datentyp
            %eye.ILAB = GA_ilabConvertTextFileCB;
            
            %--------------------------------------------------------------------------
            % DataType Custom
            %--------------------------------------------------------------------------
            
        elseif strcmp(eye.datatype, 'Custom')
            
            %selbsterstelltes template abrufen
            %@eye.datatype_custval(eye.dir.conv, fname, eye.AP);
        end
        if ~flag_error
            ILAB.fixorder= [];
            ILAB.trialorder= [];
            % fixation/trial order information
            %find datapoints with fix marker
            if ~isempty(fixcodes)
                IX = find(ILAB.data(:,3)== fixcodes);
                %find fix numbers
                for j=1:length(IX)
                    ILAB.fixorder(end+1) = find(ILAB.index(:,1)==IX(j));
                end;
            end;
            %find datapoints with trial marker
            if isempty(fixcodes)
                IX = find(ILAB.data(:,3)~= 255 & ILAB.data(:,3)~= 0);
            else
                IX = find(ILAB.data(:,3)~= fixcodes & ILAB.data(:,3)~= 255 & ILAB.data(:,3)~= 0);
            end;
            %if nothing is marked as trial, the whole dataset is marked as one single trial
            if isempty(IX)
                ILAB.data(1,3)= 1;
                ILAB.data(end,3)= 255;
                ILAB.index =[1,length(ILAB.data(:,1)),NaN];
                IX=1;
            end;
            %find trial numbers
            for j=1:length(IX)
                ILAB.trialorder(end+1) = find(ILAB.index(:,1)==IX(j));
            end;
            ILAB.fID=ident;
            ILAB.condtrial = trialcodes;
            ILAB.condfix = fixcodes;
            save(fullfile(eye.dir.conv, [ident, '_GA.mat']), 'import', 'ILAB');
            disp ('... done');
        else
            err_cnt = err_cnt + flag_error;
        end;
    end;
    if err_cnt>0
        error([num2str(err_cnt) ' Errors were found while importing files. check ' fullfile(eye.dir.raw, 'error') ])
    end;
    close(wb);
end

%--------------------------------------------------------------------------
%  check data of consistency esp. time vector
%--------------------------------------------------------------------------

if do.consistency
    wbhandle = waitbar(0,'', 'Name','Consistency check ...');
    inconsist = 0;
    if strcmpi(eye.include.files,'all')
        %Import of directory holding files to analyse
        files = dir(fullfile(eye.dir.conv, '*.mat'));
        for i=1: length(files)
            disp (['consistency check: ', files(i,1).name, '...']);
            waitbar(i / length(files), wbhandle,['Consistency check: ' files(i,1).name] )
            
            pos=strfind(files(i,1).name,'FORUN');

            movefile(fullfile(eye.dir.conv, files(i,1).name),fullfile(eye.dir.conv, [files(i,1).name(pos:end-8) '_GA.mat']));
            
%             flag_err = GA_consistency(files(i,1).name);
%             inconsist = inconsist + flag_err;
%             if flag_err
%                 disp (['consistency error: ', files(i,1).name]);
%             else
%                 disp ('... done');
%             end;
        end;
    else
        for i=1: length(eye.include.files)
            fname = [eye.include.files{i} '_GA.mat'];
            disp (['consistency check: ', fname, '...']);
            waitbar(i / length(eye.include.files), wbhandle,['Consistency check: ' fname] )
            flag_err = GA_consistency(fname);
            inconsist = inconsist + flag_err;
            if flag_err
                disp (['consistency error: ', fname]);
            else
                disp ('... done');
            end;
        end;
    end;
    if inconsist > 0
        disp (['There were inconsistencies found at ', num2str(inconsist), ' files... check folder: ', fullfile(eye.dir.conv, 'error')]);
    else
        disp ('no inconsistencies found ');
        %         data=imread('ok.png');
        %         msgbox('No inconsistencies found.','Inconsistencies','custom',data);
    end;
    close(wbhandle);
end;
%--------------------------------------------------------------------------
% Eye-Tracker files processing with ILAB
%--------------------------------------------------------------------------

if do.blinks || do.filter || do.fixations || do.saccades || do.pupil
    
    wbhandle = waitbar(0,'', 'Name','ILAB analysis ...');
    
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    fJFrame = get(wbhandle,'JavaFrame');
    v=version;
    if strcmpi(v(4),'.')
        v = [v(1) '0' v(3)];
    else
        v = [v(1) v(3:4)];
    end;
    if str2num(v) < 710
        fJFrame.fFigureClient.getWindow.setAlwaysOnTop(true);
    else
        fJFrame.fHG1Client.getWindow.setAlwaysOnTop(true);
    end;
    warning on MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    
    if strcmpi(eye.include.files,'all')
        %Import of directory holding files to analyse
        files = dir(fullfile(eye.dir.conv, '*_GA.mat'));
        for i=1: length(files)
            disp (['ILAB analysis of ', files(i,1).name, '...']);
            waitbar(i / length(files), wbhandle,['ILAB analysis of ' files(i,1).name] )
            load(fullfile(eye.dir.conv,files(i,1).name),'ILAB');
            ILAB.conv_file_name = files(i,1).name;
            eye.ILAB=ILAB;
            clear ILAB;
            %try
            GA_ILAB_batch(wbhandle);
            %             catch exept_screen
            %                 error('screen size not properly defined!');
            %                 break;
            %             end;
            disp ('..done!');
        end;
    else
        for i=1: length(eye.include.files)
            fname = [eye.include.files{i} '_GA.mat'];
            disp (['ILAB analysis of ', fname, '...']);
            waitbar(i / length(eye.include.files), wbhandle,['ILAB analysis of ' fname] )
            load(fullfile(eye.dir.conv,fname), 'ILAB');
            eye.ILAB=ILAB;
            clear ILAB;
            %try
            GA_ILAB_batch(wbhandle);
            %catch exept_screen
            %    error(['error during ILAB processing: ' exept_screen.message]);
            %    break;
            %end;
            disp ('..done!');
        end;
    end;
    close(wbhandle);
end;

%--------------------------------------------------------------------------
% calculate  x,y drift to shift scanpath prior to analysis
%--------------------------------------------------------------------------
if do.correction
    wbhandle = waitbar(0,'', 'Name','calc drift of...');
    
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    fJFrame = get(wbhandle,'JavaFrame');
    v=version;
    if strcmpi(v(4),'.')
        v = [v(1) '0' v(3)];
    else
        v = [v(1) v(3:4)];
    end;
    if str2num(v) < 710
        fJFrame.fFigureClient.getWindow.setAlwaysOnTop(true);
    else
        fJFrame.fHG1Client.getWindow.setAlwaysOnTop(true);
    end;
    warning on MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    
    resultfolder = fullfile(eye.dir.results, 'corr');
    if ~isdir(resultfolder)
        mkdir(resultfolder);
    end;
    
    if strcmpi(eye.include.files,'all')
        %Import of directory holding files to plot
        files = dir(fullfile(eye.dir.conv, '*_GA.mat'));
        for i=1: length(files)
            disp (['calc drift of ', files(i,1).name, '...']);
            waitbar(i / length(files), wbhandle,['calc drift of ' files(i,1).name] )
            GA_correction(files(i,1).name);
            disp ('..done!');
        end;
    else
        for i=1: length(eye.include.files)
            fname = [eye.include.files{i} '_GA.mat'];
            disp (['calc drift of ', fname, '...']);
            waitbar(i / length(eye.include.files), wbhandle,['calc drift of ' fname] )
            GA_correction(fname);
            disp ('..done!');
        end;
    end;
    close(wbhandle);
end;

%--------------------------------------------------------------------------
% plot scanpath and fixations for inspection
%--------------------------------------------------------------------------

if do.plot
    
    wbhandle = waitbar(0,'', 'Name','plot of...');
    
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    fJFrame = get(wbhandle,'JavaFrame');
    v=version;
    if strcmpi(v(4),'.')
        v = [v(1) '0' v(3)];
    else
        v = [v(1) v(3:4)];
    end;
    if str2num(v) < 710
        fJFrame.fFigureClient.getWindow.setAlwaysOnTop(true);
    else
        fJFrame.fHG1Client.getWindow.setAlwaysOnTop(true);
    end;
    warning on MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    
    resultfolder = fullfile(eye.dir.results, 'plot');
    if ~isdir(resultfolder)
        mkdir(resultfolder);
    end;
    
    if  eye.plot.trl.path
        if ~isdir(fullfile(resultfolder, 'trialpath'))
            mkdir(fullfile(resultfolder, 'trialpath'));
        end
    end
    
    if  eye.plot.trl.fix
        if ~isdir(fullfile(resultfolder, 'trialfix'))
            mkdir(fullfile(resultfolder, 'trialfix'));
        end
    end
    
    if  eye.plot.fix.path
        if ~isdir(fullfile(resultfolder, 'fixpath'))
            mkdir(fullfile(resultfolder, 'fixpath'));
        end
    end
    
    if  eye.plot.fix.med
        if ~isdir(fullfile(resultfolder, 'fixmed'))
            mkdir(fullfile(resultfolder, 'fixmed'));
        end
    end
    
    if strcmpi(eye.include.files,'all')
        %Import of directory holding files to plot
        files = dir(fullfile(eye.dir.conv, '*_GA.mat'));
        for i=1: length(files)
            disp (['inspection plot of ', files(i,1).name, '...']);
            waitbar(i / length(files), wbhandle,['inspection plot of ' files(i,1).name] )
            GA_plot(files(i,1).name);
            disp ('..done!');
        end;
    else
        for i=1: length(eye.include.files)
            fname = [eye.include.files{i} '_GA.mat'];
            disp (['inspection plot of ', fname, '...']);
            waitbar(i / length(eye.include.files), wbhandle,['inspection plot of ' fname] )
            GA_plot(fname);
            disp ('..done!');
        end;
    end;
    close(wbhandle);
    
end;


%--------------------------------------------------------------------------
% analysis and export to further statistics
%--------------------------------------------------------------------------
if do.analysis
    wbhandle = waitbar(0,'', 'Name','Analysing of...');
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    fJFrame = get(wbhandle,'JavaFrame');
    v=version;
    if strcmpi(v(4),'.')
        v = [v(1) '0' v(3)];
    else
        v = [v(1) v(3:4)];
    end;
    if str2num(v) < 710
        fJFrame.fFigureClient.getWindow.setAlwaysOnTop(true);
    else
        fJFrame.fHG1Client.getWindow.setAlwaysOnTop(true);
    end;
    warning on MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    
    resultfolder = fullfile(eye.dir.results, 'stats');
    if ~isdir(resultfolder)
        mkdir(resultfolder);
    end;
    
    fid = fopen(fullfile(resultfolder, eye.stats.fname),'wt');
    varlist = struct('val', {}, 'var', {}, 'trl', {}, 'roi', {}, 'roirel', {}, 'norm', {}, 'time', {} );
    
    if strcmpi(eye.include.files,'all')
        %Import of directory holding files to analyse
        files = dir(fullfile(eye.dir.conv, '*_GA.mat'));
        
        varlist = GA_analysis(fid, varlist,'header',files(1,1).name);
        for i=1: length(files)
            disp (['stats analysis of ', files(i,1).name, '...']);
            waitbar(i / length(files), wbhandle,['stats analysis of ' files(i,1).name] )
            varlist = GA_analysis(fid,varlist, 'analysis', files(i,1).name);
            proband = files(i,1).name(1:end-7);
            fprintf(fid,'%s;',proband);
            trlNr=0;
            glob_val_cnt = 0;
            for i= 1:length(varlist) %#ok<FXSET>
                if eye.stats.separatrows && isempty(varlist(i).trl)
                    glob_val_cnt = glob_val_cnt + 1;
                end;
                if eye.stats.separatrows && ~isempty(varlist(i).trl) && varlist(i).trl > trlNr
                    if trlNr > 0
                        fprintf(fid,'\n');
                        fprintf(fid,'%s;',proband);
                        for j=1:glob_val_cnt
                            fprintf(fid,'%s;',varlist(j).val);
                        end;
                    end;
                    fprintf(fid,'%s;',varlist(i).trllabel(2:end));
                    fprintf(fid,'%s;',varlist(i).val);
                    trlNr = varlist(i).trl;
                else
                    fprintf(fid,'%s;',varlist(i).val);
                end;
            end;
            fprintf(fid,'\n');
            disp ('..done!');
        end;
    else
        varlist = GA_analysis(fid,varlist,'header',[eye.include.files{1} '_GA.mat']);
        for i=1: length(eye.include.files)
            fname = [eye.include.files{i} '_GA.mat'];
            disp (['stats analysis of ', fname, '...']);
            waitbar(i / length(eye.include.files), wbhandle,['stats analysis of ' fname] )
            varlist = GA_analysis(fid,varlist,'analysis', fname);
            fprintf(fid,'%s;',eye.include.files{i});
            for i= 1:length(varlist) %#ok<FXSET>
                if eye.stats.separatrows && isempty(varlist(i).trl)
                    glob_val_cnt = glob_val_cnt + 1;
                end;
                if eye.stats.separatrows && ~isempty(varlist(i).trl) && varlist(i).trl > trlNr
                    if trlNr > 0
                        fprintf(fid,'\n');
                        fprintf(fid,'%s;',proband);
                        for j=1:glob_val_cnt
                            fprintf(fid,'%s;',varlist(j).val);
                        end;
                    end;
                    fprintf(fid,'%s;',varlist(i).trllabel(2:end));
                    fprintf(fid,'%s;',varlist(i).val);
                    trlNr = varlist(i).trl;
                else
                    fprintf(fid,'%s;',varlist(i).val);
                end;
            end;
            fprintf(fid,'\n');
            disp ('..done!');
        end;
    end;
    close(wbhandle);
    fclose(fid);
end;

%--------------------------------------------------------------------------
% Create Heatmaps
%--------------------------------------------------------------------------

if do.heatmaps
    GA_heatmap();
end


%--------------------------------------------------------------------------
% Send Email when fnished
%--------------------------------------------------------------------------

if do.email
    %%Welchen Mailserver nehmen?
    setpref('Internet','SMTP_Server',eye.email_smtp);
    
    setpref('Internet','E_mail','noreply@gazealyze.sourceforge.net');
    
    sendmail(eye.email_adress,'GazeAlyze BatchMode finished', ...
        ['This is an automatically generated message' 10 '' 10 ...
        'GazeAlyze has finished the batchmode']);
end


