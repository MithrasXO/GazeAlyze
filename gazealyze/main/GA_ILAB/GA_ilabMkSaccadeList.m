function saccadeList = GA_ilabMkSaccadeList(data, index)

global eye
% ILABMKSACCADELIST -- creates the saccade list
%   SACCADELIST = ILABMKSACCADELIST(saccadeList, layoutType) -- creates a list of
%   saccades and their parameters.
%   The saccade identification algorithm is based on
%   Fischer, B., Biscaldi, M., and Otto, P.1993.  Saccadic eye movements of
%   dyslexic adults.  Neuropsychologia, Vol. 31, No 9, pp. 887-906.
%
%   This algorithm will be fooled if there is a lot of variability
%   to the data. It does not check that all points in the saccade
%   have a velocity greater than the critical velocity
%
%   saccadeList col value
%              1   trial number
%              2   saccade count
%              3   saccade start (ms) from trial start
%              4   saccade end   (ms)
%              5   peak saccade velocity  (deg/s)
%              6   mean saccade velocity  (deg/s)
%              7   saccadic reaction time (time from target(or start) to vCutoff vel) 
%              8   time-to-peak velocity  (time from target(or start) to vPeak vel)
%              9   saccade amplitude (deg) ( vMean * saccade duration)
%              10  percentage of invalid pts in the saccade


% Authors: Roger Ray, Darren Gitelman
% $Id: ilabMkSaccadeList.m 1.8 2004-02-17 23:32:56-06 drg Exp $

saccadeList = [];

ILAB = eye.ILAB;
AP = eye.AP;
% -----------------------------------------
% Get acquisition interval
% -----------------------------------------
acqIntvl = eye.ILAB.acqIntvl;

% --------------------------------------------------------------------
%  Find threshold (critical) velocity in ILAB pixels/acq_interval: vCrit
%  Find search window width in samples: wSamples
% --------------------------------------------------------------------

[pixPerDegH, pixPerDegV] = GA_ilabPixelsPerDegree(AP);

% assumes the horizontal and vertical pixels per degree are equal
% needs to be updated.
vCrit = pixPerDegH * AP.saccade.velThresh / ILAB.acqRate;

wSamples = round(AP.saccade.window/acqIntvl);
if wSamples < 1; wSamples = 1; end;

trials = size(index,1);

% -----------------------------------------
%  Is there a fixation ROI supplied?
% -----------------------------------------
isFixROI = ~isempty(AP.saccade.ROI.name);
    
% -----------------------------------------
%  min duration of ROI fixation (in samples)
% -----------------------------------------

fLen = round(AP.saccade.minFixDuration/acqIntvl);

% -----------------------------------------
%  Initialize the Progress Bar
% -----------------------------------------

GA_ilabProgressBar('clear')
GA_ilabProgressBar('setup')
GA_ilabProgressBar('update',0,'Calculating Trial 1');

% -----------------------------------------
%  Loop over the trials
% -----------------------------------------

for i = 1:trials
    
    GA_ilabProgressBar('update',100*i/trials,['Calculating Trial ' num2str(i)]);
    drawnow
    
    t1 = index(i,1);
    t2 = index(i,2);
    
    trialx = data(t1:t2,1);
    trialy = data(t1:t2,2);
    
    if AP.saccade.onset == 1
        % calculate w.r.t. trial start
        tT = 1;
    else
        % calculate w.r.t. target start
        tT = index(i,3) - t1 +1;    % target index (rel. to trial start)
    end;
    
    % ------------------------------------------------------------------
    % Determine if gaze maintained in specified ROI (if any) for the
    %  minimum specified duration.
    % ------------------------------------------------------------------
    
    if isFixROI
        
        %  Find search range g1:g2 for gaze maintenance.
        %  Start at target, if there is one.  Otherwise start at beginning of trial
        
        g1 = tT;
        g2 = tT + fLen-1;         % minus 1 time point to make sure fixation
                                  % is within fLen time points of the actual
                                  % trial start at t=0
        if g2 > t2;  g2 = t2; end;
        
        % Search only valid sample pts (finite values, exclude (NaN, NaN))
        
        g = find(isfinite(trialx(g1:g2)));  
        
        
        % Test if all finite elements in ROI	  
        if ~all(inpolygon(trialx(g), trialy(g), AP.saccade.ROI.x, AP.saccade.ROI.y));
            inROI = 0;
        else
            inROI = 1;
        end;
        
    else
        inROI = 1;
    end;
    
    
    
    %  ---------------------------------------------------------------------
    %  Continue to process if fixation maintained in designated ROI, if any.
    %  ---------------------------------------------------------------------
    if inROI
        
        %  --------------------------------------------------------         
        %  Find the absolute velocity vector (ILAB pixels/sample)
        %  --------------------------------------------------------         
        vx = [0; diff(trialx)];
        vy = [0; diff(trialy)];
        
        vabs = sqrt(vx.^2 + vy.^2);
        
        % ------------------- plotting during debugging ---------------------
        %       figure;
        %       vRange = acqIntvl*(1:length(vabs));        % range of vabs in ms.
        %       plot(vRange/1000, vabs, 'k');
        %       hold on;
        %       plot(acqIntvl*[1 length(vabs)]./1000, [ vCrit vCrit], 'b--');
        %       drawnow;
        % ------------------- plotting during debugging ---------------------
        
        iCrit = find(vabs >= vCrit);
        
        %  Search for saccades by looking through list of pts where vabs exceeds the
        %  specified critical velocity.
        
        %  Find the next available pt in the critcal velocity list
        %  Limit the search to the specified window width (saccade.window <-> wSamples) (i1:i2)
        %  Find first occurence of vPeak (whose index is iPeak)
        %  Find the cutoff velocity from vPeak * saccade.pctPeak/100
        %  Find extent of saccade working back & fwd from vPeak to vCutoff (s1:s2)
        %  Verify that duration of saccade satifies saccade.minDuration
        %  Calculate remainder of saccade parameters.
        %  Calculate the distance from mean vel * duration to avoid
        %   possible invalid points at begin and/or end of saccade.
        %   (Trajectory is assumed to be straight line during saccade.)
        %  Add saccade info to list
        %  Advance the ptr in iCrit beyond identified saccade.
        %  __________________________________________________________________
        
        if ~isempty(iCrit)
            
            k    = 1;  % index for iCrit
            scnt = 0;  % counter for saccades
            s2   = 1;  % initialize end of last saccade to beginning of trial
            
            while k <= length(iCrit)
                
                % First bound for peak search
                i1 = iCrit(k);
                
                % Second bound for peak search
                % Wsamples provides the maximum window for finding the peak. If
                % too wide then saccades will be merged.
                i2 = i1 + wSamples;
                % Set the second bound to the smaller of the
                % window or the end of the saccade index, so
                % we don't go beyond the end of the trial
                i2 = min(i2, length(vabs)); 
                
                % The peak is the maximum in the bounds
                vPeak = max(vabs(i1:i2));
                
                % and get the peaks index
                iPeak = i1 + min(find(vabs(i1:i2) == vPeak)) - 1;  % first maximum
                
                % the saccade limits are defined as a percent of the peak
                vCutoff = vPeak * AP.saccade.pctPeak/100;
                
                s1 = min(find(vabs(iPeak:-1:s2) <= vCutoff)); % search back
                s1 = iPeak - s1 + 1;
                
                s2 = min(find(vabs(iPeak:end) <= vCutoff));    % search fwd
                if isempty(s2)
                    s2 = length(vabs);
                else
                    s2 = iPeak + s2 - 1;
                end;
                
                ts1 = s1 * acqIntvl;  %  saccade start time (ms) from trial start
                ts2 = s2 * acqIntvl;  %  saccade   end time
                
                if ( (ts2-ts1) > AP.saccade.minDuration)
                    
                    
                    % pct of invalid vabs pts in saccade
                    % There are more invalid pts in the vabs vector than in trialx
                    
                    iNaN = find(~isfinite(vabs(s1:s2)));
                    pctInvalid=(length(iNaN)/(s2-s1+1))*100; 
                    
                    iV = find(isfinite(vabs(s1:s2)));
                    iV = s1 + iV - 1;	       
                    if ~isempty(iV)
                        vMean = mean(vabs(iV));            % mean velocity (valid pts only)
                    else
                        vMean = NaN;
                    end;
                    sRT = (s1-tT+1)* acqIntvl;        % saccadic reaction time (ms)
                    ttP = (iPeak-tT+1)* acqIntvl;     % time to peak  (ms)
                    
                    % --------------- plotting during debugging ------------------
                    %                     
                    %      disp(sprintf('Trial %d  Saccade st: %.2f end: %.2f dur: %.1f ms vPk = %.1f vAvg = %.1f Inv = %.0f',...
                    %      i, ts1/1000, ts2/1000, ts2-ts1, vPeak, vMean, pctInvalid));
                    %                                                  
                    %      sRange = (s1:s2) * acqIntvl;
                    %      plot(sRange/1000, vabs(s1:s2), 'r');
                    %      plot(iPeak*acqIntvl/1000, vabs(iPeak), 'ro');  % vPeak where search started
                    %                                   
                    %      plot([s1 s2]*acqIntvl/1000, [vCutoff vCutoff], 'r:');
                    %      plot(ts1/1000, vCutoff, 'r^');
                    %      plot(ts2/1000, vCutoff, 'r^');
                    %      drawnow
                    % --------------- plotting during debugging ----------------
                    
                    vPeak = vPeak*ILAB.acqRate/pixPerDegH; %  convert to deg/s
                    vMean = vMean*ILAB.acqRate/pixPerDegH; %  convert to deg/s
                    
                    dSac = vMean * (ts2 - ts1) / 1000; % distance travelled (deg)
                    %     x1 = trialx(s1);  x2 = trialx(s2);
                    %     y1 = trialy(s1);  y2 = trialy(s2);
                    %     dist = sqrt((x2-x1)^2 + (y2-y1)^2)/pixPerDeg;
                    %     disp(sprintf('Trial %d dist %.1f %.1f\n', i, dSac, dist));
                    
                    % advance saccade count
                    scnt = scnt + 1;
                    
                    % The values in saccadeList are
                    % trial# saccade# start_of_saccade end_of_saccade peak_velocity mean_velocity saccade_RT time_to_peak distance_travelled pct_invalid_points
                    % NOTE: start_of_saccade and end_of_saccade are indices
                    % into the data list. These indices must be converted
                    % to times in the saccade table.
                    saccadeList = [saccadeList; i scnt s1 s2 vPeak vMean sRT ttP dSac pctInvalid]; 
                    
                    k = min(find(iCrit > s2));
                else
                    k = k + 1;    % minDuration not achieved.           
                end;          % endif minDuration
                
            end;  % endwhile
            
            
        end;  % endif ~isempty(iCrit)
        
    end;  % endif inROI
    
end;   % end loop over trials

AP.saccade.list = saccadeList;
eye.AP = AP;
GA_ilabProgressBar('clear')
return
