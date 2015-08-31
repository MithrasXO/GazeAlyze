function [pixPerDegH, pixPerDegV] = GA_ilabPixelsPerDegree(AP)
% ILABPIXELSPERDEGREE Returns the number of pixels per degree on the screen
%     The pixels per degree calculation is based on 1/50 of the screen
%     width or height. This is because the arctan calculation for degrees
%     of visual angle assymptotically approaches the true value for
%     smaller angles. 1/50 was picked after empirically examining a graph
%     of the calculation. Using this factor the number differs from the true
%     pixels per degree in the 4th decimal place.

% Authors: D. Gitelman
% $Id: ilabPixelsPerDegree.m 1.1 2003-08-08 21:28:17-05 drg Exp $

factor = 50;

[wILAB, hILAB] = GA_ilabGetILABCoord;

pixPerDegH = (wILAB/factor)/(atan((AP.screen.width/factor)/AP.screen.distance) * 180/pi);
pixPerDegV = (hILAB/factor)/(atan((AP.screen.height/factor)/AP.screen.distance) * 180/pi);
