function varargout = ilabMovingAvgWindow(varargin)
% ILABGAUSSWINDOW - returns a Gaussian window suitable for filtering
%   varargin{1} = (N): size of window in data points.
%   varargin{2} = (alpha): reciprocal of the standard deviation.
%
% If called with no arguments the function returns its default parameters.
% These are used to set up the filter dialog. If called with 1 or 2
% arguments it returns a window that can be used for filtering using the
% filter function.
%
% See formulas in Harris F. On the Use of Windows for Harmonic Analysis with
% the Discrete Fourier Transform, IEEE Proceedings. 66(1):51-83. Based on
% matlab's gausswin.m function.

% Authors: Darren Gitelman
% $Id: ilabMovingAvgWindow.m 1.2 2004-09-12 19:20:27-05 drg Exp drg $

% mfilename      returns the name of this file
% version        This is the version number assigned by the author. It should
%                change whenever the default parameters including label, 
%                uicontrols or params change. This alerts ilabRegisterFilters 
%                that the current parameters are different than what are stored
%                in analysisparms. It is not necessary to change this version
%                number when altering the internal algorithms. This parameter
%                should be a number.
% label          Used in the filters popup selection menu. Cannot have spaces. (string)
% uicontrols     Labels for the uicontrols where users enter parameters.
%                (strings)
% tooltipstring  String instructing users on what to enter.
% params         Default values for the inputs. Note if the second parameter
%                is a cell array of strings then there is no default but
%                the elements are setup as a popup menu.
% All fields must be present, but can be empty.
% At the present time a maximum of 2 parameters/uicontrols/tooltipstrings
% are used.

% --------------------------------------------------------------
% DEFAULT PARAMETERS
% --------------------------------------------------------------
if nargin < 1
    tmp = struct('mfilename',       mfilename,...
                   'version',       1,...
                   'label',        'Moving_Average',...
                   'uicontrols',    [],...
                   'tooltipstring', [],...
                   'params',        []);
    tmp.uicontrols{1}    = 'Width';
    tmp.params{1}        = 4;
    tmp.tooltipstring{1} = 'Width in data points.';
    varargout = {tmp};
    return    
elseif nargin == 1
    N = varargin{1};
else
    varargout = {[]};
    return
end

% --------------------------------------------------------------
% CHECK ARGUMENTS VALIDITY
% --------------------------------------------------------------
if N < 1
    errordlg('Illegal argumments for Moving Average Window.','ILAB ERROR','modal');
end

% --------------------------------------------------------------
% ALGORITHM
% --------------------------------------------------------------
w = ones(1,N);

varargout = {w};
return

% --------------------------------------------------------------
% INTERNAL FUNCTIONS
% --------------------------------------------------------------