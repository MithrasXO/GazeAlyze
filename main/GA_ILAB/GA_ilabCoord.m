function [dataout] = ilabCoord(ILAB,type,zeroflag)
% ILABCOORD -- Converts eye tracker coordinates to standard screen coordinates
%              or vice versa
%   [dataout] = ilabCoord(datain, type, zeroflag)
%   ________________________________________________________
%	datain	input ISCAN data matrix (n x 3)
%   type    normal    eye tracker coordinates     -> computer screen coordinates
%           inverse   computer screen coordinates -> eye tracker coordinates
%
%   zeroflag: if zeroflag == 1 then maintain (0,0) coord in datain
%
%   ilabCoord takes a data matrix of eye positions in
%   ISCAN coordinates and converts them to computer screen
%   coordinates based on a data specific coordinate system
%   Mapping was determined empirically by measuring both the
%   Eye tracker screen and computer screen simultaneously. The
%   ISCAN/ ASL screen DOES NOT map to the mac screen starting at 0,0.

% Authors: Darren Gitelman
% $Id: ilabCoord.m 1.2 2002-08-28 08:57:46-05 drg Exp $

% Get the coordinate system for the current dataset
%-----------------------------------------------------------------------
datain = ILAB.data;

switch type
    
case 'normal'
    dataout = [((datain(:,1) * ILAB.coordSys.params.h(1)) + ILAB.coordSys.params.h(2)),...
            ((datain(:,2) * ILAB.coordSys.params.v(1)) + ILAB.coordSys.params.v(2))];
    
case 'inverse'
    dataout = [((datain(:,1) + ILAB.coordSys.params.h(2)) / ILAB.coordSys.params.h(1)),...
            ((datain(:,2) + ILAB.coordSys.params.v(2)) / ILAB.coordSys.params.v(1))];
    
end

% Force (0,0) coords in datain to map to (0,0) in dataout
%-----------------------------------------------------------------------
if zeroflag & ~isempty(dataout)
   q = find(datain(:,1) ==0 & datain(:,2) == 0);
   dataout(q,1:2) = zeros(size(q,1),2);
end

%  Copy any remaining columns
%-----------------------------------------------------------------------
cols = size(datain,2);

if cols > 2
	dataout(:,3:cols) = datain(:,3:cols);
end
