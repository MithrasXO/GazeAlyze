function [] = GA_correction(fname)

global eye;

load(fullfile(eye.dir.conv, fname));

SCANRATE    = ILAB.acqRate;
ONSET = round(SCANRATE * eye.corr.ons / 1000);
nval = round(SCANRATE * eye.corr.dur / 1000);

RES_X       = ILAB.coordSys.screen(1,1);
RES_Y       = ILAB.coordSys.screen(1,2);
FIX_X       = eye.corr.fix.xy(1);
FIX_Y       = eye.corr.fix.xy(2);

%ons rel to separat fix marker
if eye.corr.fix.sepmark
    %find fixation trials...
    %fixation events separat marker
    
    %find datapoints with fix marker
    fixIX = ILAB.fixorder;
    trlIX = ILAB.trialorder;
    %allocating
    fix.x_corr = zeros(length(fixIX),1);
    fix.y_corr = zeros(length(fixIX),1);
    fix.reltrls = zeros(length(fixIX),2);
    
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %collect relevant trials
    %fix bevor trial
    if fixIX(1) == 1;
        for j=1:length(fixIX)-1
            fix.reltrls(j,1) = fixIX(j)+1;
            fix.reltrls(j,2) = fixIX(j+1)-1;
        end;
        fix.reltrls(end,1) = fixIX(end)+1;
        fix.reltrls(end,2) = trlIX(end);
        %fix after trial
    else
        fix.reltrls(1,1) = trlIX(1);
        fix.reltrls(1,2) = fixIX(1)-1;
        for j=2:length(fixIX)
            fix.reltrls(j,1) = fixIX(j-1)+1;
            fix.reltrls(j,2) = fixIX(j)-1;
        end;
    end;
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    % collect x and y fix values
    for j=1:length(fixIX)
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
        % calculate median of scanpath
        if strcmpi(eye.corr.method,'medpath')
            fix.x_corr(j) = median(eyemove.data.display{1,fixIX(j)}(a:b,1));
            fix.y_corr(j) = median(eyemove.data.display{1,fixIX(j)}(a:b,2));
            % calculate fixation center
        else
            id_list = find(fixvar.list(:,1) == fixIX(j) & fixvar.list(:,6) >= a & fixvar.list(:,6) < b);
            if isempty(id_list)
                fix.x_corr(j) = NaN;
                fix.y_corr(j) = NaN;
            elseif strcmpi(eye.corr.method,'maxfix')
                max_id = find(fixvar.list(id_list,7) == max(fixvar.list(id_list,7)));
                fix.x_corr(j) = mean(fixvar.list(id_list(max_id),2));
                fix.y_corr(j) = mean(fixvar.list(id_list(max_id),3));
            elseif strcmpi(eye.corr.method,'meanfix')
                fix.x_corr(j) = mean(fixvar.list(id_list,2));
                fix.y_corr(j) = mean(fixvar.list(id_list,3));
            elseif strcmpi(eye.corr.method,'firstfix')
                fix.x_corr(j) = (fixvar.list(id_list(1),2));
                fix.y_corr(j) = (fixvar.list(id_list(1),3));
            elseif strcmpi(eye.corr.method,'lastfix')
                fix.x_corr(j) = (fixvar.list(id_list(end),2));
                fix.y_corr(j) = (fixvar.list(id_list(end),3));
            end;
        end;
    end;
else
    if  ~eye.corr.blocked
        %fixation events rel to trial marker
        fix.x_corr = zeros(length(ILAB.trialorder),1);
        fix.y_corr = zeros(length(ILAB.trialorder),1);
        % onset of fixation phase
        
        % collect x and y fix values
        for j=1:length(ILAB.trialorder)
            a = ONSET;
            if a <= 0
                a=1;
            elseif a > length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1))
                a=length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1));
            end;
            b = a + nval;
            if b <= 0
                b=1;
            elseif b > length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1))
                b=length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1));
            end;
            % calculate median of scanpath
            if strcmpi(eye.corr.method,'medpath')
                fix.x_corr(j) = median(eyemove.data.display{1,ILAB.trialorder(j)}(a:b,1));
                fix.y_corr(j) = median(eyemove.data.display{1,ILAB.trialorder(j)}(a:b,2));
                fix.reltrls(j,1) = j;
                fix.reltrls(j,2) = j;
            else
                id_list = find(fixvar.list(:,1) == ILAB.trialorder(j) & fixvar.list(:,6) >= a & fixvar.list(:,6) < b);
                if isempty(id_list)
                    fix.x_corr(j) = NaN;
                    fix.y_corr(j) = NaN;
                elseif strcmpi(eye.corr.method,'maxfix')
                    max_id = find(fixvar.list(id_list,7) == max(fixvar.list(id_list,7)));
                    fix.x_corr(j) = mean(fixvar.list(id_list(max_id),2));
                    fix.y_corr(j) = mean(fixvar.list(id_list(max_id),3));
                elseif strcmpi(eye.corr.method,'meanfix')
                    fix.x_corr(j) = mean(fixvar.list(id_list,2));
                    fix.y_corr(j) = mean(fixvar.list(id_list,3));
                elseif strcmpi(eye.corr.method,'firstfix')
                    fix.x_corr(j) = (fixvar.list(id_list(1),2));
                    fix.y_corr(j) = (fixvar.list(id_list(1),3));
                elseif strcmpi(eye.corr.method,'lastfix')
                    fix.x_corr(j) = (fixvar.list(id_list(end),2));
                    fix.y_corr(j) = (fixvar.list(id_list(end),3));
                end;
            end;
        end;
        %blocked
    else
        k=1;
        act_trl=[];
        % collect x and y fix values
        for j=1:length(ILAB.trialorder)
            ix = ILAB.index(ILAB.trialorder(j),1);
            %if another block of trial starts...
            if ILAB.data(ix,3) ~=act_trl && ILAB.data(ix,3) ~=255
                act_trl = ILAB.data(ix,3);
                a = ONSET;
                if a <= 0
                    a=1;
                elseif a > length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1))
                    a=length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1));
                end;
                b = a + nval;
                if b <= 0
                    b=1;
                elseif b > length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1))
                    b=length(eyemove.data.display{1,ILAB.trialorder(j)}(:,1));
                end;
                % calculate median of scanpath
                fix.reltrls(k,1) = j;
                % calculate median of scanpath
                if strcmpi(eye.corr.method,'medpath')
                    fix.x_corr(k) = median(eyemove.data.display{1,ILAB.trialorder(j)}(a:b,1));
                    fix.y_corr(k) = median(eyemove.data.display{1,ILAB.trialorder(j)}(a:b,2));
                else
                    id_list = find(fixvar.list(:,1) == ILAB.trialorder(j) & fixvar.list(:,6) >= a & fixvar.list(:,6) < b);
                    if isempty(id_list)
                        fix.x_corr(k) = NaN;
                        fix.y_corr(k) = NaN;
                    elseif strcmpi(eye.corr.method,'maxfix')
                        max_id = find(fixvar.list(id_list,7) == max(fixvar.list(id_list,7)));
                        fix.x_corr(k) = mean(fixvar.list(id_list(max_id),2));
                        fix.y_corr(k) = mean(fixvar.list(id_list(max_id),3));
                    elseif strcmpi(eye.corr.method,'meanfix')
                        fix.x_corr(k) = mean(fixvar.list(id_list,2));
                        fix.y_corr(k) = mean(fixvar.list(id_list,3));
                    elseif strcmpi(eye.corr.method,'firstfix')
                        fix.x_corr(k) = (fixvar.list(id_list(1),2));
                        fix.y_corr(k) = (fixvar.list(id_list(1),3));
                    elseif strcmpi(eye.corr.method,'lastfix')
                        fix.x_corr(k) = (fixvar.list(id_list(end),2));
                        fix.y_corr(k) = (fixvar.list(id_list(end),3));
                    end;
                end;
                k = k+1;
            else
                fix.reltrls(k,2) = j;
            end;
        end;
    end;
end;
% calculate drift as shift in pixel
fix.x_drift = fix.x_corr - FIX_X - RES_X/2;
fix.y_drift = fix.y_corr - FIX_Y - RES_Y/2;

% export to GA matlab variable struct
corr_par = [fix.reltrls fix.x_drift fix.y_drift];
save(fullfile(eye.dir.conv, fname), 'corr_par', '-append');
% export to text file
dlmwrite(fullfile(eye.dir.results, 'corr', [fname(1:end-7) '_cor.txt'] ), [fix.reltrls fix.x_drift fix.y_drift]);
%search for separate fixation marker .. actual only at viewpoint files
%available
