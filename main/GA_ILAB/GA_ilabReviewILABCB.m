function GA_ilabReviewILABCB()

global eye;
% ILABREVIEWILABCB -- Review ILAB data
%   ILABREVIEWILABCB(action, ILAB) displays information about the specified ILAB data
%   is presented in a dialog figure with opportunities to Save, Edit and Load the values
%
%   The "globals" REVUI_ILAB REVUI_SAVE_NEEDED should be used only within this function.
%
%   REVUI_ILAB holds the values of the ILAB struct while the ILAB Review UI window is open.
%   REVUI_SAVE_NEEDED When ILAB is supplied as an argument to this function,
%   assume that ILAB comes from a file conversion that has not been saved.
%   Changing the comment and entering the "Edit Trials" dialog also sets
%   REVUI_SAVE_NEEDED.

% Authors: John Bernero, Darren Gitelman, Roger Ray
% $Id: ilabReviewILABCB.m 1.21 2004-05-25 12:25:31-05 drg Exp drg $



% ------------------------------------------------------------------

% ------------------------------------------------------------
% Validate that # start codes == # stop codes
% ------------------------------------------------------------

[startStopTargOK, index] = ckStartStopCnt(eye.ILAB.data(:,3), eye.AP.trialCodes);
coordSysOK = ckCoordSys(eye.ILAB);

if startStopTargOK && coordSysOK
    
    % set the trialCodes
    eye.ILAB.trialCodes.start = eye.AP.trialCodes.start;
    eye.ILAB.trialCodes.target = eye.AP.trialCodes.target;
    eye.ILAB.trialCodes.end = eye.AP.trialCodes.end;
    
    % Set the index elements
    %---------------------------------------------
    eye.ILAB.index = index;
    

    
    %  Initialize some fields in the PlotParms data structure & store them.    
    
    % update the plot parms with the appropriately transformed data.
    
    datain         = GA_ilabCoord(eye.ILAB,'normal',1);
    datain         = GA_ilabZeros2NaN(datain);
    eye.PP.data = datain;    
    eye.PP.index = eye.ILAB.index;    
    % Reset the selected trialList
    eye.PP.trialList = 1;   
    
    %  Set targets/no targets field in AnalysisParms structure.
    eye.AP.targets = isfinite(eye.ILAB.index(1,3));  % Col 3 is NaN when no targets
    
        
elseif  ~startStopTargOK
    errStr = {'Number of start, stop or target codes are not equal.';
        'Edit trials before saving.'};
    errordlg(errStr, 'ILAB Save Error', 'modal');
    return
elseif ~coordSysOK
    errStr = {'Select a coordinate system to continue or click Cancel.'};
    errordlg(errStr, 'ILAB ERROR', 'modal');
    return
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ckStartStopCnt returns 1 or 0 depending on whether or not
%                 the number of start and end codes are equal or not
%                 also returns the index to the codes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [startStopTargOK, index] = ckStartStopCnt(serialCodes, trialCodes)

iStart  = find(ismember(serialCodes, trialCodes.start));
iStop   = find(ismember(serialCodes, trialCodes.end));
iTarget = find(ismember(serialCodes, trialCodes.target));

nStartCodes   = length(iStart);
nStopCodes    = length(iStop);
nTargetCodes  = length(iTarget);

startStopTargOK = 0;
index         = [];

if nStartCodes == nStopCodes
    index = [iStart, iStop];
    if ~isempty(iTarget)
        if nTargetCodes == nStartCodes
            index = [index, iTarget];
            startStopTargOK = 1;
        else
            index = [];
            startStopTargOK = 0;
        end
    else
        index(:,3) = NaN;
        startStopTargOK = 1;
    end
end


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ckCoordsys returns a 1 or a 0 depending on whether a coordinate system
%           has been selected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coordSysOK = ckCoordSys(ILAB)
coordSysOK = 1;

if isempty(ILAB)
    coordSysOK = 0;
    return
elseif isstruct(ILAB.coordSys)
    if isempty(ILAB.coordSys.name)
        coordSysOK = 0;
    end
    return
else
    if isempty(ILAB.coordSys)
        coordSysOK = 0;
    end
    return
end
return
