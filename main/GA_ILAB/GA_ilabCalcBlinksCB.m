function GA_ilabCalcBlinksCB()

global eye;
% ILABCALCBLINKSCB -- Callback for Blinks Maint Calculation Menu Item
%   ILABCALCBLINKSCB(action) sets up a dialog for blink calculations.
%   The "global" BLINKSUI_AP should be used only within this function.
%
%   BLINKSUI_AP holds the values of the analysisParms while the Blinks UI window
%   is open.  Choosing OK, causes their values to be saved; choosing Cancel
%   causes them to be discarded.
%   ------------------------------------------------------------------------------
%   blink.filter      Blink filter method: (1) by pupil size, (2) by bad locations
%   blink.flag        Turn blink filter on or off (1/0)
%   blink.limits      Limits for location filtering (Hmin Hmax Vmin Vmax)
%   blink.list        List of replacements for blink periods [i1 i2 x y]
%   blink.method      Replacement method: Substitute invalid (0) or last valid point (1) for blinks.
%   blink.replace     Replace (1) or don't replace (0) pre/post blink values
%   blink.vertThresh  Threshold for vertical movement (pixels/samplingInterval)
%   blink.window      Number of pre- & post-blink samples to search for replacement

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabCalcBlinksCB.m 1.17 2003-08-06 14:20:14-05 drg Exp $

ILAB = eye.ILAB;

plotParms = eye.PP;

% do a coordinate transformation
%-------------------------------
if isstruct(ILAB.coordSys)
    datain = GA_ilabCoord(ILAB,'normal',1);
    datain = GA_ilabZeros2NaN(datain);
else
    datain = ILAB.data;
end

if any(eye.AP.blink.filter)
    %--------------------------------------------------------------------------
    %   %%Make list of blinks and filter them!
    %--------------------------------------------------------------------------
    
    eye.AP.blink.list  = GA_ilabMkBlinkList(datain, ILAB.index, eye.AP.blink);

    % fid2 = fopen('blinks.txt','a');
    % fprintf(fid2,'%s\n',[  ILAB.subject(1:end-1) ',' num2str(length(datain)) ',' num2str(length(eye.AP.blink.list.loc))]);
    % fclose(fid2);
    eye.ILAB.quality.datapoints = length(datain);
    eye.ILAB.quality.blinkpoints = length(eye.AP.blink.list.loc);
    
    plotParms.data = GA_ilabFilterBlinks(datain, eye.AP.blink.list);
else
    plotParms.data = datain;
end;


% Blinks are always calculated on raw data. So
% clear plotParms.filtercache
plotParms.filtercache = repmat(struct('type','','params',[],'colidx', 0, 'data', []),1,3);

eye.PP = plotParms;

return;
