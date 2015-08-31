function dataNaN = ilabZeros2NaN(datain)
% ILABZEROS -- Converts invalid points in data file to NaNs
%   dataNaN = ILABZEROS2NAN(datain) finds (0,0) coord in datain and converts them to (NaN,NaN)
%
%    (0,0) coords signify invalid non-meaningful values in the data stream.
%    Changing (0,0) to (NaN, NaN) causes them to be skipped in "plot" commands.

% Authors: Darren Gitelman
% $Id: ilabZeros2NaN.m 1.1 2002-05-05 14:15:06-05 drg Exp $

	dataNaN = datain;
	NaNidx = find(dataNaN(:,1) == 0 & dataNaN(:,2) == 0);
	dataNaN(NaNidx,1:2) = NaN*zeros(length(NaNidx),2);
