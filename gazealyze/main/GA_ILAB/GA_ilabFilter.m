function out = GA_ilabFilter(b,a,x)
%ILABFILTER filter a vector with zero phase distortion
%  OUT = ILABFILTER(B, A, X) filters the data in vector X with the filter described
%  by A and B.  The filter is described by the difference equation:
%
%    y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                     - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%
%  Signals are filtered in the forward and then reverse direction. The output 
%  has zero phase distortion. The technique of Gustafsson is used to match
%  initial conditions in order to minimize the starting and ending transients.
%
%  The length of the input x must be more than three times
%  the filter order, defined as max(length(b)-1,length(a)-1).
%
%  References: 
%    [1] Sanjit K. Mitra, Digital Signal Processing, 2nd ed., McGraw-Hill, 2001
%    [2] Fredrik Gustafsson, Determining the initial states in forward-backward 
%        filtering, IEEE Transactions on Signal Processing, pp. 988--992, April 1996, 
%        Volume 44, Issue 4
%
%  This function is based on Matlab's filtfilt function, but it is not as
%  generalized, and only operates on vectors.

% Authors: Darren Gitelman
% $Id: ilabFilter.m 1.3 2004-10-22 17:34:29-05 drg Exp drg $


if length(x) <= length(b)-1
    out = [];
    return
end

if min(size(x)) > 1
    errordlg('ilabFilter only operates on vectors.','ILAB FILTER ERROR','modal');
    return
end

b = b(:)';
a = a(:)';
nb = length(b);
na = length(a);
szfilt = max(nb,na);
szedge = 3*(szfilt-1);

% equalize coefficient sizes
if nb < na
    b(na) = 0;
elseif na < nb
    a(nb) = 0;
end

% use equation from Gustafsson
zi = ( eye(szfilt-1) - [-a(2:szfilt)' [eye(szfilt-2); zeros(1,szfilt-2)]] ) \ ...
     ( b(2:szfilt)' - a(2:szfilt)'*b(1) );
 
 % find NaNs
 xNANidx = find(isnan(x));
 if ~isempty(xNANidx)
     x(xNANidx) = 0;
 end

%  The length of the input x must be more than three times
%  the filter order, defined as max(length(b)-1,length(a)-1).
x_length = length(x);
if length(x) < 3 * max(length(b)-1,length(a)-1)
    x(end+1: 1 + 3 * max(length(b)-1,length(a)-1)) =  0;
end;
 
% flip beginning and end of data sequence and tack on.
y = [2*x(1)-flipud(x(2:szedge+1,:));  x; 2*x(end) - flipud(x(end-szedge:end-1))];

% filter, reverse data, filter again, and reverse data again
% b is normalized by sum(b) so that output has same magnitude as the input.
y = filter(b/sum(b),a,y,[zi*y(1)]);
y = flipud(y);
y = filter(b/sum(b),a,y,[zi*y(1)]);
y = flipud(y);

% remove extra pieces of y
out = y(szedge+1:end-szedge);
out(x_length+1:end) = [];

% put back NaNs
if ~isempty(xNANidx)
    out(xNANidx) = NaN;
end
