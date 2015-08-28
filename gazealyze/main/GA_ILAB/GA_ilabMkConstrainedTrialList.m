function  idx = GA_ilabMkConstrainedTrialList(AP, Iin)

% ILABMKCONSTRAINEDTRIALLILIST -- restricts data based on a time index.
%   IDX = ILABMKCONSTRAINEDTRIALLILIST(Iin) sets up a timing index to the
%   data for calculations. The timing index itself comes from other calculations.
%   Timing constraints can be created through fixation, ROI, saccade and gaze calculations.
%   For example if only the first 500 msec of a 1000 msec trial is analyzed for fixations
%   then just that 500 msec can be displayed by clicking the time checkbox
%   in the main window.
global eye
% Authors: Darren Gitelman, Roger Ray
% $Id: ilabMkConstrainedTrialList.m 1.3 2002-10-02 20:30:38-05 drg Exp $

tDlg = 'TRIAL CONSTRAINT ERROR';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  VALIDATE PARAMETER SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nTrials cols] = size(Iin);



% exit if expt type does not use targets and user has requested a
% calculation which depends on targets
  
  hErr=[];
  if AP.targets && (AP.start.marker == 3 || AP.end.marker == 3)
	msg = {'Cannot perform the requested calculation.';...
	       'No target information available for calculation.'};
	hErr = errordlg(msg, tDlg, 'modal');
  end

%  Check if validation fails and return empty index.
%  =============================================================================

if (isnumeric(hErr) & hErr > 0 )| strcmpi(hErr,'yes')
   idx = [];
   AP.index = idx;
   ilabSetAnalysisParms(AP);
   return
end


% Convert the analysis offset intervals (ms) into index displacements.
% ____________________________________________________________________

acqIntvl = eye.ILAB.acqIntvl;

dIS = round(AP.start.intvl/acqIntvl);
dIE = round(AP.end.intvl/acqIntvl);

idx = zeros(nTrials, cols);

% constrained trial start
% -------------------------------
switch AP.start.marker

  case 1, idx(:,1) = Iin(:,1) + dIS;
  case 2, idx(:,1) = Iin(:,2) - dIS;	                  
  case 3, idx(:,1) = Iin(:,3) + dIS;	                  

end;

% calculate constrained trial end
% --------------------------------
switch AP.end.marker

  case 1, idx(:,2) = Iin(:,2) - dIE;
  case 2, idx(:,2) = Iin(:,1) + dIE;	                  
  case 3, idx(:,2) = Iin(:,3) + dIE;
  	                  	
end

%  Copy the remainder of the cols in the input index array

   idx(:,3:cols) = Iin(:,3:cols);
   
% ______________________________________________________________
%
%  VALIDATE RESULTS
%
%  Don't wind past beginning or end of input trial indices
%  Make sure that all beginning indices are <= ending indices.
% ______________________________________________________________

begErr = find((idx(:,1) < Iin(:,1)) | (idx(:,2) < Iin(:,1)));
endErr = find((idx(:,2) > Iin(:,2)) | (idx(:,1) > Iin(:,2)));
seqErr = find( idx(:,1) > idx(:,2));

if ~isempty(begErr) || ~isempty(endErr) || ~isempty(seqErr)
   msg = {'Error(s) in constraining trials'};
   if ~isempty(begErr)
     msg = [msg; {sprintf('  %d trials have limits which precede trial start', length(begErr))}];
   end;
   if ~isempty(endErr)
     msg = [msg; {sprintf('  %d trials have limits which extend beyond trial end', length(endErr))}];
   end;
   if ~isempty(seqErr)
     msg = [msg; {sprintf('  %d trials with start limit beyond end limit', length(seqErr))}];
   end;
   
   errordlg(msg, tDlg, 'modal');
   
   idx = [];   % Return an empty index array
end;

AP.index = idx;


return;
