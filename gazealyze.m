% -------------------------------------------------------------------------
% GazeAlyze 
% (C) 2010-2011 Christoph Berger and Martin Winkels (University of Rostock)
% -------------------------------------------------------------------------
clc;
% determining the GazeAylze search path and 
% add GA function folders to search path

% check Matlab version
v=version;verr=0;
if str2num(v(1:3))<7.1
    verr=1;
    errmsg=sprintf('You are running GazeAlyze on a Matlab version (%s) under which it has not been tested.\nIf you encounter any other error, please contact the developers.', v);
    warning(errmsg);
end;

% check toolbox functions
image = license('checkout','image_toolbox');
if ~image
    errmsg='Image processing toolbox not installed. visualisation functions like plots and heatmaps will not be implemented. all other functions might work properly.';
    warning(errmsg);
end;

% check whether GazeAlyze is on the path
[pth]=fileparts(which('gazealyze'));
if isempty(strfind(path, fullfile(pth,'gui')))   
    addpath(genpath(pth));
end;
% starting the GUI
GA_gui_main();