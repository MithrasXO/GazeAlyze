function [w, h] = GA_ilabGetILABCoord()
global eye
% ILABGETILABCOORD -- returns the size in pixels of the ILAB coordinate system
%   [W, H] = ILABGETILABCOORD - Returns width & height of ILAB Coord System.
%   First checks if a coordinate system has been loaded. If not then returns
%   default values of 640 x 480, which were based on the size
%   of a typical Macintosh screen at the time of original development.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabGetILABCoord.m 1.3 2002-09-29 18:54:05-05 drg Exp $

if isfield(eye.ILAB.coordSys,'screen')
    w = eye.ILAB.coordSys.screen(1);
    h = eye.ILAB.coordSys.screen(2);
else
    w = 640;
    h = 480;    
end;
return;
