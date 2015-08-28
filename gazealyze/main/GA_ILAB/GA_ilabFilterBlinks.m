function dataout = GA_ilabFilterBlinks(data, blinklist)
% ILABFILTERBLINKS -- applies the blinklist to the datastream
%   DATAOUT = ILABFILTERBLINKS - filters the datastream to remove blink artifacts
%   Each entry in the blink list is of the form [i1 i2 x y]
%   The values in data(i1:i2, 1:2) are set to [x y]

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabFilterBlinks.m 1.4 2003-07-07 00:33:12-05 drg Exp $

dataout = data;

blinks = [blinklist.pupil; blinklist.loc];

if ~isempty(blinks)
    
    % Filter pupil size column as well if it exists.
    %-----------------------------------------------
    if size(data,2) >= 4
        dataout(blinks(:,1),[1:2,4]) = blinks(:,2:4);
    else
        dataout(blinks(:,1),[1:2]) = blinks(:,2:3);
    end
end

return;
