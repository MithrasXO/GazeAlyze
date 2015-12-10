function varargout = GA_analysis(fid, varlist, action, fname)

global eye;

load(fullfile(eye.dir.conv,fname), 'ILAB');

%***************************************
%filtering selected trials
%***************************************
if strcmpi(eye.include.trials,'all')
    trlIX = ILAB.trialorder;
else
    eval(['trlIX = sort(unique([' eye.include.trials ']));']);
    trlIX = trlIX(ismember(trlIX, ILAB.trialorder)); %#ok<NODEF>
end;

switch action
    
    case 'header'
        
        %++++++++++++++++++++++++++
        %build components of header
        %++++++++++++++++++++++++++
        header = 'vp';
        %1. stage - times - componente ready
        
        %2. stage - trials
        trials = num2str(1:length(trlIX));
        trials = regexp(trials, ' ','split');
        trials(ismember(trials, '')==1)=[];
        trials = strcat('t',trials);
        
        %3. stage - normalize rois: yes, no
        norm{1}='';
        if eye.stats.roi.norm
            norm{2}='N';
        end;
        %4. stage - rois..
        %roi selection to export, indices of rois with selected name
        roiIX=[];
        for j=1:length(eye.stats.roi_exp)
            for i=1:length(eye.ROI)
                if length(eye.stats.roi_exp{j}) > 4
                    if strcmp('tag_', eye.stats.roi_exp{j}(1:4)) && (strcmpi(eye.ROI(i).tag1, eye.stats.roi_exp{j}(5:end)) || strcmpi(eye.ROI(i).tag2,eye.stats.roi_exp{j}(5:end)))
                        roiIX(end+1)=i;
                    end;
                end;
                if strcmpi(eye.ROI(i).name,eye.stats.roi_exp{j})
                    roiIX(end+1)=i;
                end;
            end;
        end;
        roi = cell2struct(eye.stats.roi_exp,{'name'},1);
        for i=1:length(roi)
            k=0;
            for j=1:length(eye.stats.fix.relrois)
                if ~strcmpi(roi(i).name,eye.stats.fix.relrois(j)) && ~strcmpi(roi(i).name, 'screen')
                    k = k+1;
                    roi(i).rel{k} = eye.stats.fix.relrois(j);
                end;
            end;
        end;
        %5. stage - variables:
        
        %roi related
        varabs = {'daMN','daCM','na'};
        varabs = varabs(logical([eye.stats.fix.da_mean, eye.stats.fix.da_cum, eye.stats.fix.na]));
        varrel = {'drMN','drCM','nr'};
        varrel = varrel(logical([eye.stats.fix.dr_mean, eye.stats.fix.dr_cum, eye.stats.fix.nr]));
        % trial related, roi independend
        vartrl = {'fsac','path','saclat','sacdir'};
        vartrl = vartrl(logical([eye.stats.fix.sacrat, eye.stats.scanspat,eye.stats.sac.firstlat,eye.stats.sac.firstdir]));
        %roi_related, no norming to roi size
        varroi = {'ford', 'first', 'firstons', 'firstdur'};
        varroi = varroi(logical([eye.stats.fix.order, eye.stats.fix.first, eye.stats.fix.firstons, eye.stats.fix.firstdur]));
        %++++++++++++++++++++++++++++++++++
        %header montage
        %0. global report related to file
        if eye.stats.qual
            header = [header ';blinks;points;snr' ];
            varlist(end+1).var = 'blinks';
            varlist(end+1).var = 'points';
            varlist(end+1).var = 'snr';
        end;
        
        fprintf(fid,'%s',header);
        header=[];
        
        %1. stage - trials
        if eye.stats.separatrows
            header = [header ';trl' ];
        end;
        for c = 1 : length(trials)
            [header varlist]= head_montage(header, varlist, norm, roi, varabs, varrel, vartrl, varroi, trials{c}, c);
        end;
        
        fprintf(fid,'%s\n',header);
    case 'analysis'
        TRIAL_COUNT = length(trlIX);
        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        % loading proband data
        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        %1.0 read fix data
        %load preprocessed data
        load(fullfile(eye.dir.conv, fname),'eyemove','fixvar','saccvar','quality');
        
        %sort for condition number
        if eye.stats.sort
            codes = ILAB.data(ILAB.index(trlIX,1),3);
            [codes_sorted, IX] = sort(codes);
            trlIX= trlIX(IX);
        else
            IX= 1:TRIAL_COUNT;
        end;
        
        %1.1 read scanpath drift correction data
        if eye.stats.valid || eye.stats.corr
            %load correction parameter
            if isempty(who('-file', fullfile(eye.dir.conv, fname),'corr_par'))
                disp('miss correction parameter -> analyze uncorrected data');
                corr_par = zeros(TRIAL_COUNT,4);
                corr_par(:,1) = trlIX;
                corr_par(:,2) = trlIX;
            else
                load(fullfile(eye.dir.conv, fname),'corr_par');
            end;
        end;
        %1.2 read stim sequence
        %open stim sequence file
        % sequence file only needed if covariates should be reported or if analyzing single pic rois
        if eye.stats.roi.all_stim_only || eye.stats.covar
            proband = fname(1:end-7);
            seqfile = dir(fullfile(eye.dir.stimseq, ['*' proband '*']));
            seqname = seqfile(1).name;
            fid = fopen(fullfile(eye.dir.stimseq,seqname),'r');
            raw = textscan(fid, '%s', 'delimiter' ,'\n');
            fclose(fid);
            raw{1}(1:eye.stim.row-1)=[];
            %covariate to report
            if eye.stats.covar
                if ischar(eye.stim.covar)
                    eye.stim.covar = eval(eye.stim.covar);
                end;
                covar=cell(TRIAL_COUNT,length(eye.stim.covar));
                for j= 1:TRIAL_COUNT
                    line =raw{1}{IX(j)};
                    pos = regexp(line,'\t');
                    for i=1:length(eye.stim.covar)
                        %tabstop as delimiter;
                        if eye.stim.covar(i) > 1
                            pos1 = pos(eye.stim.covar(i)-1)+1;
                        elseif eye.stim.covar(i) == 1
                            pos1 = 1;
                        end;
                        if eye.stim.covar(i) == length(pos)+1
                            pos2 = length(line);
                        elseif eye.stim.covar(i) < length(pos)+1
                            pos2 = pos(eye.stim.covar(i))-1;
                        end;
                        covar(j,i) = {line(pos1:pos2)};
                    end;
                end;
                %stim sequence for roi selection
                pic=cell(TRIAL_COUNT,1);
            end;
            %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            % calculating analysis var..
            %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            for j = 1:length(varlist)
                varlist(j).val = '';
                trlNr = varlist(j).trl;
                %report covariate
                if strfind(varlist(j).var,'cov')
                    co = str2double(varlist(j).var(4:end));
                    varlist(j).val = covar{trlNr,co};
                    %report duration
                elseif strcmp(varlist(j).var,'dur')
                    ilabNr = trlIX(trlNr);
                    varlist(j).val = num2str(round(length(eyemove.data.display{ilabNr}) * ILAB.acqIntvl));
                elseif strcmp(varlist(j).var,'error')
                    ilabNr = trlIX(trlNr);
                    k = find(corr_par(:,1)<=ilabNr & corr_par(:,2)>=ilabNr);
                    if isnan(corr_par(k,3))
                        varlist(j).val = '1';
                    else
                        varlist(j).val = '0';
                    end;
                elseif strcmp(varlist(j).var,'blinks')
                    varlist(j).val = num2str(quality.blinkpoints);
                elseif strcmp(varlist(j).var,'points')
                    varlist(j).val = num2str(quality.datapoints);
                elseif strcmp(varlist(j).var,'snr')
                    varlist(j).val = num2str(quality.snr);
                    %calculate variables
                else
                    ilabNr = trlIX(trlNr);
                    %stim pic file name building
                    if eye.stats.roi.all_stim_only
                        pic = '';
                    else
                        %actual stim pic
                        %tabstop as delimiter;
                        line =raw{1}{IX(trlNr)};
                        pos = regexp(line,'\t');
                        %tabstop as delimiter;
                        if eye.stim.col > 1
                            pos1 = pos(eye.stim.col-1)+1;
                        elseif eye.stim.col == 1
                            pos1 = 1;
                        end;
                        if eye.stim.col == length(pos)+1
                            pos2 = length(line);
                        elseif eye.stim.col < length(pos)+1
                            pos2 = pos(eye.stim.col)-1;
                        end;
                        pic = line(pos1:pos2);
                        pic = strrep(eye.stim.pic,'$pic',pic);
                    end;
                    %time period extraction
                    [startT, remain] = strtok(varlist(j).time,'_');
                    ons_end = 0;
                    off_end = 0;
                    if strfind(startT,'end-')
                        ons_end = 1;
                        startT = strrep(startT,'end-','');
                    end;
                    if strfind(remain,'end-')
                        off_end = 1;
                        remain = strrep(remain,'end-','');
                    end;
                    idx = regexp(remain,'[0-9]');
                    endT = remain(idx);
                    %percent recalc in msec
                    if strcmp(varlist(j).time(end),'%')
                        trldur = round(length(eyemove.data.display{ilabNr}) * ILAB.acqIntvl);
                        startT = round(str2double(startT) * trldur / 100);
                        endT = round(str2double(endT) * trldur / 100);
                    else
                        if ons_end
                            startT = length(eyemove.data.display{ilabNr}) * ILAB.acqIntvl - str2double(startT);
                        else
                            startT = str2double(startT);
                        end;
                        if off_end
                            endT = length(eyemove.data.display{ilabNr}) * ILAB.acqIntvl - str2double(endT);
                        else
                            endT = str2double(endT);
                        end;
                    end;
                    %data from the fix_list
                    fixidx = find(fixvar.list(:,1) == ilabNr & ...
                        fixvar.list(:,6) >= round(ILAB.acqRate * startT / 1000) & ...
                        fixvar.list(:,6) <= round(ILAB.acqRate * endT / 1000));
                    %fixons in datapoints
                    fix_ons = fixvar.list(fixidx,6);
                    %recalc in msec
                    fix_ons = round(fix_ons .* ILAB.acqIntvl);
                    %fixdur in datapoints
                    fix_dur = fixvar.list(fixidx,7);
                    %recalc in msec
                    fix_dur = round(fix_dur .* ILAB.acqIntvl);
                    fix_xy = fixvar.list(fixidx,2:3);
                    %data from the scanpath_list
                    a = round(ILAB.acqRate * startT / 1000);
                    if a <= 0
                        a=1;
                    elseif a > length(eyemove.data.display{ilabNr}(:,1))
                        a=length(eyemove.data.display{ilabNr}(:,1));
                    end;
                    b = round(ILAB.acqRate * endT / 1000);
                    if b <= 0
                        b=1;
                    elseif b > length(eyemove.data.display{ilabNr}(:,1))
                        b=length(eyemove.data.display{ilabNr}(:,1));
                    end;
                    pathdat = eyemove.data.display{ilabNr}(a:b,:);
                    
                    %data from the sacc_list, saccade start time inside trial
                    if ~isempty(saccvar.list)
                        %time
                        saccidx = find(saccvar.list(:,1) == ilabNr & ...
                            saccvar.list(:,3) >= round(ILAB.acqRate * startT / 1000) & ...
                            saccvar.list(:,3) <= round(ILAB.acqRate * endT / 1000));
                    else
                        saccidx = [];
                    end;
                    if ~isempty(saccidx)
                        first_saccade_latency = round(saccvar.list(saccidx(1),3) * ILAB.acqIntvl) - startT;
                        %sacc_start
                        a = saccvar.list(saccidx(1),3);
                        %sacc_end
                        b = saccvar.list(saccidx(1),4);
                        saccstartxy = eyemove.data.display{ilabNr}(a,:);
                        saccendxy = eyemove.data.display{ilabNr}(b,:);
                        %tan alpha
                        if saccendxy(2) < saccstartxy(2)
                            if saccendxy(1) == saccstartxy(1)
                                first_saccade_direction = 0; % N
                            elseif saccendxy(1) > saccstartxy(1) %0-90° , N-O
                                first_saccade_direction = - atand(saccendxy(2)-saccstartxy(2))/(saccendxy(1)-saccstartxy(1));
                            elseif saccendxy(1) < saccstartxy(1) %270-360°, W-N
                                first_saccade_direction = 270 + atand(saccendxy(2)-saccstartxy(2))/(saccendxy(1)-saccstartxy(1));
                            end;
                        elseif saccendxy(2) > saccstartxy(2)
                            if saccendxy(1) == saccstartxy(1)
                                first_saccade_direction = 180; % S
                            elseif saccendxy(1) > saccstartxy(1) %90-180° , O-S
                                first_saccade_direction = 90 + atand(saccendxy(2)-saccstartxy(2))/(saccendxy(1)-saccstartxy(1));
                            elseif saccendxy(1) < saccstartxy(1) %180-270°, S-W
                                first_saccade_direction = 270 + atand(saccendxy(2)-saccstartxy(2))/(saccendxy(1)-saccstartxy(1));
                            end;
                        elseif saccendxy(2) == saccstartxy(2)
                            if saccendxy(1) == saccstartxy(1)
                                first_saccade_direction = 0;
                            elseif saccendxy(1) > saccstartxy(1) % 0
                                first_saccade_direction = 90;
                            elseif saccendxy(1) < saccstartxy(1) % W
                                first_saccade_direction = 270;
                            end;
                        end;
                    else
                        first_saccade_latency = [];
                        first_saccade_direction = [];
                    end;
                    
                    if eye.stats.corr
                        %find related fix period
                        k = find(corr_par(:,1)<=ilabNr & corr_par(:,2)>=ilabNr);
                        pathdat(:,1) = pathdat(:,1) - corr_par(k,3);
                        pathdat(:,2) = pathdat(:,2) - corr_par(k,4);
                        fix_xy(:,1) = fix_xy(:,1) - corr_par(k,3);
                        fix_xy(:,2) = fix_xy(:,2) - corr_par(k,4);
                    end;
                    
                    %calculating variables
                    switch varlist(j).var
                        
                        case {'daMN', 'daCM', 'na','drMN', 'drCM', 'nr','ford','first', 'firstons', 'firstdur'}
                            [area, inside] = roi_search(ILAB.coordSys.screen, varlist(j).roi, eye.ROI, fix_xy, fix_ons, fix_dur, pic);
                            if ~isempty(varlist(j).roirel)
                                [area_rel, inside_rel] = roi_search(ILAB.coordSys.screen, varlist(j).roirel, eye.ROI, fix_xy, fix_ons, fix_dur, pic);
                            end;
                    end;
                    
                    switch varlist(j).var
                        case {'daMN', 'daCM', 'na'}
                            %norming on roi area
                            if isempty(varlist(j).norm)
                                normfac = 1;
                            else
                                normfac = 1 - area / (ILAB.coordSys.screen(1,1) * ILAB.coordSys.screen(1,2));
                            end;
                        case {'drMN','drCM','nr'}
                            %norming on roi area
                            if isempty(varlist(j).norm)
                                normfac = 1;
                            else
                                normfac = 1 - area / area_rel;
                            end;
                    end;
                    switch varlist(j).var
                        case 'daMN'
                            varlist(j).val = num2str(mean(fix_dur(inside)) * normfac,'%10.2f');
                        case 'daCM'
                            varlist(j).val = num2str(sum(fix_dur(inside)) * normfac,'%10.2f');
                        case 'na'
                            varlist(j).val = num2str(numel(fix_dur(inside)) * normfac,'%10.2f');
                        case 'ford'
                            if isempty(find(inside,1,'first'))
                                varlist(j).val = '0';
                            else
                                varlist(j).val = int2str(find(inside,1,'first'));
                            end;
                        case 'first'
                            if isempty(find(inside,1,'first'))
                                varlist(j).val = '0';
                            else
                                varlist(j).val = int2str(find(inside,1,'first')==1);
                            end;
                        case 'firstons'
                            if isempty(find(inside,1,'first'))
                                varlist(j).val = '0';
                            else
                                varlist(j).val = num2str(fix_ons(find(inside,1,'first')));
                            end;
                        case 'firstdur'
                            if isempty(find(inside,1,'first'))
                                varlist(j).val = '0';
                            else
                                varlist(j).val = num2str(fix_dur(find(inside,1,'first')));
                            end;
                        case 'drMN'
                            varlist(j).val = num2str((mean(fix_dur(inside))/mean(fix_dur(inside_rel))) * normfac,'%10.2f');
                        case 'drCM'
                            varlist(j).val = num2str((sum(fix_dur(inside))/sum(fix_dur(inside_rel))) * normfac,'%10.2f');
                        case 'nr'
                            varlist(j).val = num2str((numel(fix_dur(inside))/numel(fix_dur(inside_rel))) * normfac,'%10.2f');
                        case 'fsac'
                            varlist(j).val = num2str(sum(fix_dur)/(endT-startT-sum(fix_dur)) ,'%10.2f');
                        case 'path'
                            varlist(j).val = num2str(sum(sqrt(sum(diff(pathdat).^2,2))),'%10.2f');
                        case 'saclat'
                            varlist(j).val = num2str(first_saccade_latency,'%10.2f');
                        case 'sacdir'
                            varlist(j).val = num2str(first_saccade_direction,'%10.2f');
                    end;
                    if ~strcmpi(varlist(j).var,'fsac') && ~strcmpi(varlist(j).var,'path') && ~strcmpi(varlist(j).var,'sacdir') && ~strcmpi(varlist(j).var,'saclat')
                        if isempty(find(inside,1,'first'))
                            varlist(j).val = '0';
                        end;
                    end;
                end;
                if strcmp(varlist(j).val,'NaN')
                    varlist(j).val = '0';
                end;
                
                if isempty(varlist(j).val)
                    %error(['error during analysis: var: ' varlist(j).var ' pic: ' pic]);
                end;
                varlist(j).val = strrep(varlist(j).val,'.',',');
            end;
        end;
end;
varargout(1)= {varlist};
return;

function [area, inside] = roi_search(screen, varroi, roilist, fix_xy, fix_ons, fix_dur, pic)

%roi area
flag_found=0;
area = 0;
area_act = 0;
inside = false(size(fix_xy,1),1);
inside_act = [];


%++++++++++++++++
%screen check
%++++++++++++++++
if strcmpi('screen', varroi)
    area = (screen(1,1) * screen(1,2));
    inside = (0 < fix_xy(:,1) & screen(1,1) > fix_xy(:,1) & 0 < fix_xy(:,2) & screen(1,2) > fix_xy(:,2));
    %++++++++++++++++
    %roi tag check
    %++++++++++++++++
elseif length(varroi)>4
    if length(pic)
        %searching for roi dimensions of valid = special pic
        if ~isempty(pic)
            for i=1:length(roilist)
                if strcmpi(roilist(i).tag1, varroi(5:end)) ||strcmp(roilist(i).tag2, varroi(5:end))
                    if strfind(pic, roilist(i).valid)
                        flag_found=1;
                        [area_act, inside_act] = checkROI(roilist(i),fix_xy, fix_ons, fix_dur);
                        area = area + area_act;
                        inside = inside | inside_act;
                    end;
                end;
            end;
        end;
        
        %searching for roi dimensions of valid = all
        if ~flag_found
            for i=1:length(roilist)
                if strcmpi(roilist(i).tag1, varroi(5:end)) ||strcmp(roilist(i).tag2, varroi(5:end))
                    if strcmpi(roilist(i).valid, 'all')
                        flag_found=1;
                        [area_act, inside_act] = checkROI(roilist(i),fix_xy,fix_ons, fix_dur);
                        area = area + area_act;
                        inside = inside | inside_act;
                    end;
                end;
            end;
        end;
    end;
    
end;
%++++++++++++++++
%roi name check
%++++++++++++++++
if flag_found==0
    %searching for roi dimensions of valid = special pic
    if ~isempty(pic)
        for i=1:length(roilist)
            if strcmpi(roilist(i).name, varroi)
                if strfind(pic, roilist(i).valid)
                    flag_found=1;
                    [area, inside] = checkROI(roilist(i), fix_xy, fix_ons, fix_dur);
                    break;
                end;
            end;
        end;
    end;
    %searching for roi dimensions of valid = all
    if ~flag_found
        for i=1:length(roilist)
            if strcmpi(roilist(i).name, varroi)
                if strcmpi(roilist(i).valid, 'all')
                    flag_found=1;
                    [area, inside] = checkROI(roilist(i),fix_xy, fix_ons, fix_dur);
                    break;
                end;
            end;
        end;
    end;
end;

return;
%fixation check whether it belongs to roi:
%criteria for dynamic rois: fixation duration is touched by roi duration
function [area, inside] = checkROI(roi, fix_xy_ref, fix_ons, fix_dur)
inside = false(size(fix_xy_ref,1),1);
if length(fix_ons)~=length(fix_dur) || length(fix_dur) ~= size(fix_xy_ref,1)
    error('error in filtering of fixation list');
end;

if ~isfield(roi, 'time')
    roi.time=0;
end;

for tp=1:length(roi.time)
    if roi.stop(tp)==0
        fix_xy = fix_xy_ref;
        
        %filtering relevant fixations
        %only valid for dynamic rois
        if length(roi.time) > 1
            roi_ons = roi.time(tp);
            if tp < length(roi.time)
                roi_dur = roi.time(tp+1) - roi_ons;
            else
                roi_dur = fix_ons(end)+ fix_dur(end) - roi_ons;
            end;
            %filtering all fixation with overlap between roi timepoint and fixation
            inside_time = min(repmat(roi_ons + roi_dur, length(fix_dur),1),fix_ons + fix_dur) - max(repmat(roi_ons,length(fix_ons),1),fix_ons)>=0;
        else
            inside_time = true(size(fix_xy,1),1);
        end;
        
        %coord trans of xy - rotation with angle around M_roi
        %calc the center of the roi - the rotation is in GA limited rel. to the center
        if ~strcmpi(roi.type,'polygon')
            if ~isempty(roi.angle(tp))
                if roi.angle(tp) ~= 0
                    MX_roi = (roi.x{tp}(2)-roi.x{tp}(1))/2;
                    MY_roi = (roi.y{tp}(2)-roi.y{tp}(1))/2;
                    %transform the coord of fix
                    %1. calc vec M_roi->fix (coord basis)
                    vec = fix_xy .* 0;
                    vec(:,1) =  MX_roi - fix_xy(:,1);
                    vec(:,2) =  MY_roi - fix_xy(:,2);
                    %2. rotate vec
                    rotvec = vec .* 0;
                    rotvec(:,1) = vec(:,1) .* cosd(roi.angle(tp)) - vec(:,2) .* sind(roi.angle(tp));
                    rotvec(:,2) = vec(:,2) .* cosd(roi.angle(tp)) + vec(:,1) .* sind(roi.angle(tp));
                    %3. add vec M_roi
                    fix_xy(:,1)= rotvec(:,1) + MX_roi;
                    fix_xy(:,2)= rotvec(:,2) + MY_roi;
                end;
            end;
        end;
        switch roi.type
            case 'rectangle'
                inside_area = (roi.x{tp}(1) < fix_xy(:,1) & roi.x{tp}(2) > fix_xy(:,1) & roi.y{tp}(1)< fix_xy(:,2) & roi.y{tp}(2) > fix_xy(:,2));
                area = (roi.x{tp}(2) - roi.x{tp}(1)) * (roi.y{tp}(2) - roi.y{tp}(1));
            case 'ellipse'
                %calc of foci coordinates (linear exzentricity)
                if (roi.x{tp}(2)-roi.x{tp}(1)) > (roi.y{tp}(2)-roi.y{tp}(1))
                    a = (roi.x{tp}(2)-roi.x{tp}(1))/2;
                    b = (roi.y{tp}(2)-roi.y{tp}(1))/2;
                    %x
                    F1(1) = roi.x{tp}(1) + a - sqrt(a^2 - b^2);
                    F2(1) = roi.x{tp}(2) - a + sqrt(a^2 - b^2);
                    %y
                    F1(2) = roi.y{tp}(1) + b;
                    F2(2) = F1(2);
                else
                    b = (roi.x{tp}(2)-roi.x{tp}(1))/2;
                    a = (roi.y{tp}(2)-roi.y{tp}(1))/2;
                    %x
                    F1(1) = roi.x{tp}(1) + b;
                    F2(1) = F1(1);
                    %y
                    F1(2) = roi.y{tp}(1) + a - sqrt(a^2 - b^2);
                    F2(2) = roi.y{tp}(2) - a + sqrt(a^2 - b^2);
                end;
                %calc distances (euklid) of P to foci
                PF1 = round(sqrt((fix_xy(:,1) - F1(1)).^2 + (fix_xy(:,2) - F1(2)).^2 ));
                PF2 = round(sqrt((fix_xy(:,1) - F2(1)).^2 + (fix_xy(:,2) - F2(2)).^2 ));
                %decision: fix_xy inside roi?
                inside_area = (PF1 + PF2 <= 2 * a);
                area = pi * a * b;
            case 'polygon'
                inside_area = inpoly(fix_xy,[roi.x{tp}(:)', roi.y{tp}(:)']);
                area = polyarea(roi.x{tp}(:), roi.y{tp}(:));
        end;
    end;
    inside = inside | (inside_area & inside_time);
end;
return;

function [header, varlist]= head_montage(header, varlist, norm, roi, varabs, varrel, vartrl, varroi, trlID, c )

global eye;

if eye.stats.separatrows
    trllabel = '';
    headshort = header;
else
    trllabel = [trlID  '_'];
end;

if eye.stats.covar
    covar_cols= eval(eye.stim.covar);
    for co =1:length(covar_cols)
        cov = ['cov' num2str(co)];
        header = [header ';' trllabel cov];
        varlist(end+1).var = cov;
        varlist(end).trl = c;
        varlist(end).trllabel = trlID;
    end;
end;
if eye.stats.trldur
    header = [header ';' trllabel  'dur' ];
    varlist(end+1).var = 'dur';
    varlist(end).trl = c;
    varlist(end).trllabel = trlID;
end;
if eye.stats.valid
    header = [header ';' trllabel  'err' ];
    varlist(end+1).var = 'error';
    varlist(end).trl = c;
    varlist(end).trllabel = trlID;
end;
%2. stage times
for tim = 1:length(eye.stats.times)
    time = strrep(eye.stats.times{tim},'%','P');
    time = strrep(time,'-','_');
    % trial related, roi independend
    for trl =1:length(vartrl)
        header = [header ';' trllabel vartrl{trl} '_' time];
        varlist(end+1).var = vartrl{trl};
        varlist(end).trl = c;
        varlist(end).trllabel = trlID;
        varlist(end).time = eye.stats.times{tim};
    end;
    %roidependent
    %3. stage - rois: tag1, tag2, single
    for r = 1:length(roi)
        %diverse roi variables:
        for j=1:length(varroi)
            header= [header ';' trllabel roi(r).name '_' varroi{j} '_' time ];
            varlist(end+1).var = varroi{j};
            varlist(end).trl = c;
            varlist(end).trllabel = trlID;
            varlist(end).roi = roi(r).name;
            varlist(end).time = eye.stats.times{tim};
        end;
        %exception:no area norming for screen
        if strcmp(roi(r).name,'screen')
            %absolute variables
            for j=1:length(varabs)
                header= [header ';' trllabel roi(r).name '_' varabs{j} '_' time ];
                varlist(end+1).var = varabs{j};
                varlist(end).trl = c;
                varlist(end).trllabel = trlID;
                varlist(end).roi = roi(r).name;
                varlist(end).norm = norm{1};
                varlist(end).time = eye.stats.times{tim};
            end;
        else
            %4. stage - normalize rois: yes, no
            for n = 1:length(norm)
                %5. stage - variables:
                %absolute variables
                for j=1:length(varabs)
                    header= [header ';' trllabel roi(r).name norm{n} '_' varabs{j} '_' time ];
                    varlist(end+1).var = varabs{j};
                    varlist(end).trl = c;
                    varlist(end).trllabel = trlID;
                    varlist(end).roi = roi(r).name;
                    varlist(end).norm = norm{n};
                    varlist(end).time = eye.stats.times{tim};
                end;
                %relative variables
                for j=1:length(varrel)
                    for k=1:length(roi(r).rel)
                        header= [header ';' trllabel roi(r).name '_' cell2mat(roi(r).rel{k}) norm{n} '_' varrel{j} '_' time ];
                        varlist(end+1).var = varrel{j};
                        varlist(end).trl = c;
                        varlist(end).trllabel = trlID;
                        varlist(end).roi = roi(r).name;
                        varlist(end).roirel = cell2mat(roi(r).rel{k});
                        varlist(end).norm = norm{n};
                        varlist(end).time = eye.stats.times{tim};
                    end;
                end;
            end;
        end;
    end;
end;
if c > 1 &&  eye.stats.separatrows
    header = headshort;
end;
return;
