function blinklist = ilabMkBlinkList(data, index, blink)
% ILABMKBLINKLIST -- Removes blink artifacts particularly from ASL data
%   [blinklist, blinkcount]=ilabMkBlinkList(data, index, blink) attempts to
%   remove blink artifacts based on several criteria.
%   Blinks are identified in the data by 2 methods.
%   1) On some systems pupil size goes to 0 during the blink.
%   2) On some systems the eye location can take on values well outside
%      the range of a normal display.
%   Following a blink, the eye trace will often show a large vertically
%   oriented excursion as the eyes reopen. Thus one often wants to filter
%   both the blink and the abnormal movement locations before and after the blink.
%   The algorithm first identifies a blink based on pupil size or bad location
%   then it examines the vertical pixel rate preceding and
%   following a blink. Data points are excluded if the rate of
%   vertical movement exceeds a specified threshold.
%
%   The algorithm will perform incorrectly if the subject is supposed to
%   be making large vertical saccades and one happens to occur around a
%   blink. The user chooses via preferences in ilabCalcBlinksCB
%   whether to set the blink H,V data to 0 or to set it to the
%   last valid data point preceeding the blink.
%
%   data     datastream
%   index    trial index for data
%   blink    struct:
%
%   The curr(ent) and sub(stitution) arrays are maintained to enable quick
%   switching between filtered/non-filtered states since entire data arrays
%   can be large.
%   ------------------------------------------------------------------------------
%   blink.filter      Blink filter: first value is for pupil method,
%                     second for location
%   blink.limits      Location limits for filtering (Hmin Hmax Vmin Vmax)
%   blink.vertThresh  Threshold for vertical movement (pixels/samplingInterval)
%   blink.replace     Replace (1) or don't replace (0) pre/post blink values
%   blink.window      Number of pre- & post-blink samples to search
%                     for replacement
%   blink.method      Replacement method: Substitute invalid (0) or
%                     last valid point (1) for blinks.

% Authors: Darren Gitelman, Roger Ray
% $Id: ilabMkBlinkList.m 1.12 2004-01-30 12:40:58-06 drg Exp $

nTrials = size(index,1);
blinklist.pupil  = [];
blinklist.loc   = [];
% blinks replaced (non-zero only if replace is true)
blinkcount.pupil = zeros(nTrials,1);
% blinks replaced (non-zero only if replace is true)
blinkcount.loc   = zeros(nTrials,1);

% -------------------------------------------------------------------------------
GA_ilabProgressBar('setup')
GA_ilabProgressBar('update',0,'Filtering Blinks')
for i = 1:nTrials
    GA_ilabProgressBar('update',100*(i/nTrials))
    
    t1 = index(i,1);    % index of start of i-th trial
    t2 = index(i,2);    % index of   end of i-th trial
    
    % filter by pupil size
    if blink.filter(1) & size(data,2) >= 4
        
        pupilSize = data(t1:t2,4);
        
        %  Check if one or more blinks (zero values) are present
        if ~all(data(t1:t2,4))
            
            % --------------------------------------------------------
            %  Set the non-zero pupil sizes to 1
            %  Then find difference vector to locate blink transitions
            %  1 -> 0  = -1  : Start of blink
            %  0 -> 1  = +1  : End of blink
            % --------------------------------------------------------
            nz = find(pupilSize >0);
            pupilSize(nz) = ones(length(nz),1);
            
            transitions = diff(pupilSize);
            if pupilSize(1) == 0
                transitions = [-1;transitions];
            else
                transitions = [0;transitions];
            end
            
            % Indices of blink starts.  -1 => start
            %   (relative to start of trial)
            % Subtract 1 because indices are not 0 based
            % --------------------------------------
            if blink.replace
                iBS = find(transitions == -1) - 1;
                if transitions(1) == -1
                    iBS(1) = 1;
                end
            else
                iBS = [];
            end
            
            % Indices of blink ends.   +1 => end
            %   (relative to start of trial)
            % Subtract 2 because indices are not 0 based and
            % method shifts end by 1
            % --------------------------------------
            iBE = find(transitions == 1) - 2;
            if transitions(2) == 1
                iBE(1) = 1;
            end
            % assume that if length(iBE) is < length(iBS) then the
            % length should only differ by 1
            if length(iBE) < length(iBS)
                iBE = [iBE; length(pupilSize)];
            end
            
            % --------------------------------------------------------
            % Loop over blink starts to see if preblink points
            %   show excessive vertical movement
            % Set up substitution indices depending on whether
            %   (NaN, NaN) or pre-/post-blink points get substituted
            % --------------------------------------------------------
            for j = 1:length(iBS)
                
                % get starting and ending indices of preblink period
                %   (relative to start of data)
                % -----------------------------------------------------
                i1 = t1 + iBS(j) + 1 - blink.window;
                i2 = t1 + iBS(j);
                
                if i1 < t1, i1 = t1; end;
                if i2 > t2, i2 = t2; end;
                
                % --------------------------------------------------------------
                % Indices of vertical excursions >  blink.vertThresh
                %    (relative to start of preblink period)
                % --------------------------------------------------------------
                iV = find(abs(diff(data(i1:i2,2))) > blink.vertThresh);
                
                % --------------------------------------------------------------
                % Get indices of first vert movement that exceeds blink.vertThresh
                %    in the preblink period.
                %
                % --------------------------------------------------------------
                if isempty(iV)
                    iVS1 = t1 + iBS(j) - 1;
                else
                    iVS1 = i1 + min(iV)-1;
                end;
                iVE1 = iBS(j);
                
                
                % These flags will be used to tell us to substitute
                % a valid pre- or post-blink location for the pre-/post-blink values
                % Basically this means we've looked backward and
                % ended up at the start of the trial with no valid locations,
                % or similarly we've looked forward and found no
                % valid locations.
                % A very rare scenario is that there will be no valid
                % locations throughout an entire trial. In that case
                % the whole trial will be marked as a NaN
                preBadFlag  = 0;
                postBadFlag = 0;
                
                %                 datatmp = data(t1:iVS1,4);
                %                 iVStmp = max(find(datatmp > 0));
                %                 if ~isempty(iVStmp)
                %                     if (iVS1 > iVStmp + t1 -1)
                %                         iVS1 = iVStmp + t1 -1;
                %                     end
                %                 else
                %                     iVS1 = t1;
                %                     preBadFlag = 1;
                %                 end
                
                % If the user has checked off a search by location
                % check that valid values are actually valid
                % and filter by location if needed
                %                 if blink.filter(2)
                %                     datatmp = data(t1:iVS1,1:2);
                %                     % This should == iVS1 if all locations are valid
                %                     iVStmp  = max(find(datatmp(:,1) > blink.limits(1) & ...
                %                         datatmp(:,1) < blink.limits(2) & ...
                %                         datatmp(:,2) > blink.limits(3) & ...
                %                         datatmp(:,2) < blink.limits(4)));
                %
                %                     if ~isempty(iVStmp)
                %                         % modify the start point only if location
                %                         % info says that that the point is bad
                %                         if iVS1 > (iVStmp + t1 -1)
                %                             iVS1 = iVStmp + t1 -1;
                %                         end
                %                     else
                %                         iVS1 = t1;
                %                         preBadFlag = 1;
                %                     end
                %                 end
                
                % Get index of end of pre-blink period
                %    (relative to start of data)
                % ------------------------------------------------------
                iVS2 = t1 + round(((iBS(j)+iBE(j))/2));
                
                % Now look at post-blink period for large movements
                %---------------------------------------------------
                i1 = t1 + iBE(j);
                i2 = i1 + blink.window -1;
                
                if i1 > t2, i1 = t2; end;
                if i2 > t2, i2 = t2; end;
                
                iV = find(abs(diff(data(i1:i2,2))) > blink.vertThresh);
                
                if isempty(iV)
                    iVE1 = iVS2 + 1;
                    iVE2 = i1;
                else
                    iVE1 = iVS2 + 1;
                    iVE2 = i1 + max(iV)+1;
                end;
                
                if iVE2 > t2, iVE2 = t2;  end;
                
                datatmp = data(iVE2:t2,4);
                iVStmp = min(find(datatmp > 0));
                if ~isempty(iVStmp)
                    if iVE2 < (iVStmp + iVE2 -1)
                        iVE2 = iVStmp + iVE2 -1;
                    end
                else
                    iVE2 = t2;
                    postBadFlag = 1;
                end
                
                % if user has checked to filter by location
                % check that post-valid values are actually valid locations
                %                 if blink.filter(2)
                %                     datatmp = data(iVE2:t2,1:2);
                %                     iVStmp  = min(find(datatmp(:,1) > blink.limits(1) & ...
                %                         datatmp(:,1) < blink.limits(2) & ...
                %                         datatmp(:,2) > blink.limits(3) & ...
                %                         datatmp(:,2) < blink.limits(4)));
                %                     if ~isempty(iVStmp)
                %                         if iVE2 < (iVStmp + iVE2 -1)
                %                             iVE2 = iVStmp + iVE2 -1;
                %                         end
                %                     else
                %                         iVE2 = t2;
                %                         postBadFlag = 1;
                %                     end
                %                 end
                
                % Filter pupil size column as well if it exists.
                %-----------------------------------------------
                if size(data,2) >= 4
                    colidx = [1:2,4];
                else
                    colidx = 1:2;
                end
                
                switch blink.method
                    case 0 % substitute invalid points
                        subPt = NaN * ones(length(iVS1:iVE2),size(colidx,2));
                        idx   = iVS1:iVE2;
                    case 1 % nearest neighbor-type substitution
                        if preBadFlag & postBadFlag
                            subPt = NaN * ones(length(iVS1:iVE2),size(colidx,2));
                            idx = iVS1:iVE2;
                        elseif preBadFlag
                            subPt1 = data(iVE2,colidx);
                            subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                            subPt2 = data(iVE2,colidx);
                            subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                            subPt  = [subPt1; subPt2];
                            idx    = [iVS1:iVS2, iVE1:iVE2];
                        elseif postBadFlag
                            subPt1 = data(iVS1,colidx);
                            subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                            subPt2 = data(iVS1,colidx);
                            subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                            subPt  =  [subPt1; subPt2];
                            idx    = [iVS1:iVS2, iVE1:iVE2];
                        else
                            subPt1 = data(iVS1,colidx);
                            subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                            subPt2 = data(iVE2,colidx);
                            subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                            subPt  =  [subPt1; subPt2];
                            idx    = [iVS1:iVS2, iVE1:iVE2];
                        end
                        
                    case 2 % linearly interpolated substitution
                        if preBadFlag & postBadFlag
                            subPt = NaN * ones(length(iVS1:iVE2),size(colidx,2));
                            idx = iVS1:iVE2;
                        elseif preBadFlag
                            subPt = repmat(data(iVE2,colidx),length(iVS1:iVE2),1);
                            idx = iVS1:iVE2;
                        elseif postBadFlag
                            subPt = repmat(data(iVS1,colidx),length(iVS1:iVE2),1);
                            idx = iVS1:iVE2;
                        else
                            subPt1 = data(iVS1,colidx);
                            subPt2 = data(iVE2,colidx);
                            subPt  = interp1([iVS1;iVE2],[subPt1;subPt2],[iVS1:iVE2]);
                            idx = iVS1:iVE2;
                        end
                end
                
                blinklist.pupil  = [blinklist.pupil; [idx' subPt]];
            end
            
        end   % endif ~all(pupilSize)
    end % if pupil method
    % filter by location
    if blink.filter(2)
        t1  = index(i,1);    % index of start of i-th trial
        t2  = index(i,2);    % index of   end of i-th trial
        LBS = [];
        LBE = [];
        
        % as above set the bad points to 0 and the good ones to 1
        locs = data(index(i,1):index(i,2),1:2);
        
        locsidx = find(((locs(:,1) > blink.limits(1)) & (locs(:,1) < blink.limits(2))) & ...
            ((locs(:,2) > blink.limits(3)) & (locs(:,2) < blink.limits(4))));
        
        
        if length(locsidx) ~= length(locs)
            locslog = zeros(length(locs),1);
            locslog(locsidx,1) = ones(length(locsidx),1);
            
            % We want just the transition points. +1 are starts
            % of bad points and -1 are ends
            loctransitions = diff(locslog);
            
            if locslog(1) == 0
                loctransitions = [-1;loctransitions];
            else
                loctransitions = [0;loctransitions];
            end
            
            % Indices of blink starts.  -1 => start
            %   (relative to start of trial)
            % --------------------------------------
            if blink.replace
                LBS = find(loctransitions == -1);
            else
                LBS = [];
            end
            
            % Indices of blink ends.   +1 => end
            %   (relative to start of trial)
            % --------------------------------------
            LBE = find(loctransitions == 1) - 1;
            if length(LBE) < length(LBS)
                LBE = [LBE; length(locslog)];
            end
        end % ~isempty(locsidx)
        
        % --------------------------------------------------------
        % Loop over blink starts to see if preblink points
        %   show excessive vertical movement
        % Set up substitution indices depending on whether
        %   (NaN, NaN) or pre-/post-blink points get substituted
        % --------------------------------------------------------
        for j = 1:length(LBS)
            
            % get starting and ending indices of preblink period
            %   (relative to start of data)
            % -----------------------------------------------------
            i1 = t1 + LBS(j) + 1 - blink.window;
            i2 = t1 + LBS(j);
            
            if i1 < t1, i1 = t1; end;
            if i2 > t2, i2 = t2; end;
            
            % --------------------------------------------------------------
            % Indices of vertical excursions >  blink.vertThresh
            %    (relative to start of preblink period)
            % --------------------------------------------------------------
            iV = find(abs(diff(data(i1:i2,2))) > blink.vertThresh);
            
            % --------------------------------------------------------------
            % Get index of first vert movement that exceeds blink.vertThresh
            %    (relative to start of data)
            % --------------------------------------------------------------
            if isempty(iV)
                iVS1 = t1 + LBS(j) - 1;
            else
                iVS1 = i1 + min(iV)-1;
            end;
            
            preBadFlag  = 0;
            postBadFlag = 0;
            
            
            
            datatmp = data(t1:iVS1,1:2);
            % This should = iVS1 if the location is valid
            iVStmp  = max(find(datatmp(:,1) > blink.limits(1) & ...
                datatmp(:,1) < blink.limits(2) & ...
                datatmp(:,2) > blink.limits(3) & ...
                datatmp(:,2) < blink.limits(4)));
            
            if ~isempty(iVStmp)
                if iVS1 > (iVStmp + t1 -1)
                    iVS1 = iVStmp + t1 -1;
                end
            else
                iVS1 = t1;
                preBadFlag = 1;
            end
            
            if blink.filter(1)
                datatmp = data(t1:iVS1,4);
                iVStmp = max(find(datatmp > 0));
                if ~isempty(iVStmp)
                    if iVS1 > (iVStmp + t1 -1)
                        iVS1 = iVStmp + t1 -1;
                    end
                else
                    iVS1 = t1;
                    preBadFlag = 1;
                end
            end
            
            % Get index of end of pre-blink period
            %    (relative to start of data)
            % ------------------------------------------------------
            iVS2 = t1 + round(((LBS(j)+LBE(j))/2));
            
            % Now look at post-blink period for large movements
            %---------------------------------------------------
            i1 = t1 + LBE(j);
            i2 = i1 + blink.window -1;
            
            if i1 > t2, i1 = t2; end;
            if i2 > t2, i2 = t2; end;
            
            iV = find(abs(diff(data(i1:i2,2))) > blink.vertThresh);
            
            if isempty(iV)
                iVE1 = iVS2 + 1;
                iVE2 = i1;
            else
                iVE1 = iVS2 + 1;
                iVE2 = i1 + max(iV)+1;
            end;
            
            if iVE2 > t2, iVE2 = t2;  end;
            
            %if user has checked to filter by location
            %check that post-valid values are actually valid locations
            datatmp = data(iVE2:t2,1:2);
            iVStmp  = min(find(datatmp(:,1) > blink.limits(1) & ...
                datatmp(:,1) < blink.limits(2) & ...
                datatmp(:,2) > blink.limits(3) & ...
                datatmp(:,2) < blink.limits(4)));
            if ~isempty(iVStmp)
                if iVE2 < (iVStmp + iVE2 -1)
                    iVE2 = iVStmp + iVE2 -1;
                end
            else
                iVE2 = t2;
                postBadFlag = 1;
            end
            
            if blink.filter(1)
                datatmp = data(iVE2:t2,4);
                iVStmp = min(find(datatmp > 0));
                if ~isempty(iVStmp)
                    if iVE2 < (iVStmp + iVE2 -1)
                        iVE2 = iVStmp + iVE2 -1;
                    end
                else
                    iVE2 = t2;
                    postBadFlag = 1;
                end
            end
            
            % Filter pupil size column as well if it exists.
            %-----------------------------------------------
            if size(data,2) >= 4
                colidx = [1:2,4];
            else
                colidx = 1:2;
            end
            %hilfscode
            %if iVS1==iVE2, iVE2 = iVE2+1; end;
            
            
            switch blink.method
                case 0 % substitute invalid points
                    subPt = NaN * ones(length(iVS1:iVE2),size(colidx,2));
                    
                case 1 % nearest neighbor-type substitution
                    if preBadFlag & postBadFlag
                        subPt = NaN * ones(length(iVS1:iVE2),1);
                    elseif preBadFlag
                        subPt1 = data(iVE2,colidx);
                        subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                        subPt2 = data(iVE2,colidx);
                        subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                        subPt  =  [subPt1; subPt2];
                    elseif postBadFlag
                        subPt1 = data(iVS1,colidx);
                        subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                        subPt2 = data(iVS1,colidx);
                        subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                        subPt  =  [subPt1; subPt2];
                    else
                        subPt1 = data(iVS1,colidx);
                        subPt1 = repmat(subPt1,length(iVS1:iVS2),1);
                        subPt2 = data(iVE2,colidx);
                        subPt2 = repmat(subPt2,length(iVE1:iVE2),1);
                        subPt  =  [subPt1; subPt2];
                    end
                    
                case 2 % linearly interpolated substitution
                    if preBadFlag & postBadFlag
                        subPt = NaN * ones(length(iVS1:iVE2),3);
                    elseif preBadFlag
                        subPt = repmat(data(iVE2,colidx),length(iVS1:iVE2),1);
                    elseif postBadFlag
                        subPt = repmat(data(iVS1,colidx),length(iVS1:iVE2),1);
                    else
                        subPt1 = data(iVS1,colidx);
                        subPt2 = data(iVE2,colidx);
                        subPt  = interp1([iVS1;iVE2],[subPt1;subPt2],[iVS1:iVE2]);
                    end
            end
            idx = iVS1:iVE2;
            while size(subPt,1)>size(idx,2)
                iVE2=iVE2+1;
                idx = iVS1:iVE2;
            end;
            blinklist.loc  = [blinklist.loc; [idx' subPt]];
        end
    end   % endif ~all(pupilSize)
end % if pupil method
% end       % endfor nTrials
GA_ilabProgressBar('clear')
return;
