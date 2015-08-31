function varargout = ilabHannWindow(varargin)
% ILABHANNWINDOW - returns a Hanning window suitable for filtering
%   varargin{1} = size of window in data points
%   varargin{2} = standard is an asymmetric window
%                 symmetric is a symmetric window
% 
% If called with no arguments the function returns its default parameters.
% These are used to set up the filter dialog. If called with 1 or 2
% arguments it returns a window that can be used for filtering using the
% filter function.
%
% See formulas in Harris F. On the Use of Windows for Harmonic Analysis with
% the Discrete Fourier Transform, IEEE Proceedings. 66(1):51-83.
%
% Standard versus periodic windows based on hanning.m from the Matlab
% signal processing toolbox.

% Authors: Darren Gitelman
% $Id: ilabHannWindow.m 1.7 2004-09-12 19:10:04-05 drg Exp drg $

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
                   'label',         'Hanning',...
                   'uicontrols',    [],...
                   'tooltipstring', [],...
                   'params',        []);
    tmp.uicontrols{1}    = 'Width';
    tmp.uicontrols{2}    = 'Type';
    tmp.params{1}        = 5;
    tmp.params{2}        = {'standard','symmetric'}';
    tmp.tooltipstring{1} = 'Width in data points.';
    tmp.tooltipstring{2} = 'Standard is a periodic window.';
    varargout = {tmp};
    return    
elseif nargin == 2
    N    = varargin{1};
    type = varargin{2};
else
    % do nothing
    varargout = {[]};
    return
end

% --------------------------------------------------------------
% CHECK ARGUMENTS VALIDITY
% --------------------------------------------------------------
if N < 1 | ~(strcmpi(type,'standard') | strcmpi(type,'symmetric'))
    errordlg('Illegal argumments for Hanning Window.','ILAB ERROR','modal');
end

% --------------------------------------------------------------
% ALGORITHM
% --------------------------------------------------------------
switch lower(type)
    case 'standard'
        % Includes the first zero sample
        N = N-1;
        if ~rem(N,2)
            % Even length window
            n2 = N/2;
            w = hanning(n2,N);
            w = [w; w(end:-1:1)];
        else
            % Odd length window
            n2 = (N+1)/2;
            w = hanning(n2,N);
            w = [w; w(end-1:-1:1)];
        end
        w = [0; w];
                
    case 'symmetric'
        % Does not include the first and last zero sample
        if ~rem(N,2)
            % Even length window
            n2 = N/2;
            w = hanning(n2,N);
            w = [w; w(end:-1:1)];
        else
            % Odd length window
            n2 = (N+1)/2;
            w = hanning(n2,N);
            w = [w; w(end-1:-1:1)];
        end        
end

varargout = {w};
return

% --------------------------------------------------------------
% INTERNAL FUNCTIONS
% --------------------------------------------------------------
function w = hanning(M,N)
%   HANNING Calculates and returns the first M points of an N point
%   Hanning window. This is then reflected by the calling code above.

w = 0.5*(1 - cos(2*pi*(1:M)'/(N+1))); 

