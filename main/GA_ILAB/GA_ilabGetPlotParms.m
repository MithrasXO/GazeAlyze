function GA_ilabGetPlotParms()
% ILABGETPLOTPARMS -- creates and returns the PLOTPARM variable
%   PLOTPARMS = ILABGETPLOTPARMS creates a new PLOTPARM data struct if it does not exist.
%   The plotparms data structure contains all the information needed to plot the
%   data. At this point the data has been converted to proper computer screen
%   coordinates based on the ILAB.coordSys structure.
%
%   A circle is drawn for each fixation. The radius of the circle is proportional
%   to the length of the fixation.  The size is scaled to the maximum length
%   fixation, i.e.  circleSz = fix.maxCircleSz * (fixationLength/fix.maxDuration)
%
%   fix.maxDuration  Maximum fixation duration (ms) (Corresponds to maxCircleSz)
%   fix.maxCircleSz  Maximum circle size (radius size in pixels)

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabGetPlotParms.m 1.23 2004-09-06 01:30:41-05 drg Exp drg $

global eye

if ~isfield(eye,'PP')
    
    % The plot parameters should be based on the loaded dataset.
    % However, when ILAB starts there is no loaded dataset, so
    % this defaults to 640 x 480 through ilabGetILABCoord
    %---------------------------------------------------------
    [wILAB, hILAB] = GA_ilabGetILABCoord;      
    
    img = 1; img = repmat(img,[1, 1, 3]);
    
    % 'XTimePlotAxis';'YTimePlotAxis'
    PLOTPARMS = struct (...
        'IMG_TAG',       'BkgndImgAxes',...
        'PCA_TAG',       'PlotCtlAxes',...
        'CPA_TAG',       'CoordPlotAxes',...
        'APA_TAG',       'AuxiliaryPlotAxes',...
        'XYPLOT_TAG',    ' ',...
        'PUPILPLOT_TAG', ' ',...
        'data',          [],...
        'index',         [],...
        'coordGrid',     struct('axis',      1,...
        'axisUnits', 'coord',...
        'degOrigin', [wILAB/2 hILAB/2],...
        'show',      'off',...
        'visible',   'off'),...
        'fix',           struct('maxDuration', 2000, 'maxCircleSz', 240, 'show', 0),...
        'image',         struct('files', struct('fname',   '',...
        'sfname',  '',...
        'trial',   '',...
        'start',   '',...
        'duration',''),...
        'pathpref', 1,...
        'version', '',...
        'loaded',   0,...
        'handle',  [],...
        'show',    0),...
        'filtercache',   repmat(struct('type','','params',[],'colidx', 0, 'data', []),1,3),...
        'pupil',         0,...
        'relMovmnt',     0,...
        'scanPath',      1,...
        'showROI',       0,...
        'segPlot',       struct('colors', 'rgbcmykw', 'tMinMax', zeros(8,2), 'pctMinMax', zeros(8,2), 'method', 1, 'show', 0),...
        'showTime',      0,...
        'showVel',       0,...
        'speed',         10,...
        'trialList',     []);
    
    % for some reason matlab will not set up a cell string when assembling the
    % structure so this is done here
    PLOTPARMS.XYPLOT_TAG = {' '};
    
    eye.PP = PLOTPARMS;
end;