function GA_ilabAnalysisParms()

global eye;

% ILABGETANALYSISNPARMS -- Returns the ANALYSISPARMS data structure.
%   ANALYSISPARMS = ILABGETANALYSISNPARMS creates a new ANALYSISPARMS data struct
%   if it does not exist.
%
%   ANALYSISPARMS contains parameters about current analysis but is also
%   used to store start up parameters of various sorts.
%
%   ANALYSISPARMS Fields (more downunder)
%   -------------------------------
%
%
%     basis:    coordinate (0) or fixation (1) based analysis
%
%     targets:  {0,1} depending if no targets/targets present in data set.
%               This is a convenience field which is often used in processing
%               analysis parameters and in performing analyses.
%               It is set each time a new data set is loaded
%               (ilabLoadDataCB)
%
%   minReactTime  Minimum reaction time (ms)
%


% Authors: Roger Ray, Darren Gitelman
% $Id: ilabGetAnalysisParms.m 1.31 2004-09-05 00:31:18-05 drg Exp drg $


%Pfade übertragen

% path.vp_path = eye.dir.vp_path;
% % path.vp_files = eye.dir.vp_files;
% path.vp_results = eye.dir.vp_results;

vers = GA_ilabVersion;

%   ROI statistics parameters
%   -------------------------------
%   ROI statistics calculations use the basis & gap parameters
%   ROIstats.list   List of ROI statistics results
%   ROIstats.table  Formatted table of ROI statistics results

%ROI wird im Steuerskript definiert.
ROI = '';
ROIStats.list  = [];
ROIStats.table = [];


%   -------------------------------
%   start.marker: Start analysis at trial start [+ intvl], trial end [- intvl], target [+/- intvl]
%   start.intvl   Optional interval (ms) used relative to start,marker
%   start.ROI     Optional ROI code. When specified, the first starting data coords
%                 must lie within the ROI.
%   end.marker    End analysis at trial end [- intvl], trial [+ intvl], target [+/- intvl]
%   end.intvl     Optional interval (ms) used with end.marker
%
%   index         Array of beg/end indices for each trial that corresponds to
%                 the constraints specified in start and end parms above.
%   -----------------------------------------------------------------------
%Marker
Start.marker = 1;
Start.intvl  = 0;
Start.ROI    = 7;

End.marker   = 1;
End.intvl    = 0;


%   ----------------------------------------------------------------------------
%   Data gap handling parameters
%   Data gaps occur when the coordinate values are invalid.
%   The eye scanning equipment places (0,0) coords at these sampling points.
%   The value pair (NaN, NaN) could also be used to mark invalid coords.
%   ----------------------------------------------------------------------------
%   gap.min     Minimum number of consecutive invalid  samples that define a "gap"
%   gap.maxPct  Maximum percent of invalid samples/trial allowed.
%   gap.method  Gap-handling method when # of consecutive invalid samples <= gap.min
%               (0 => count only time for gaps. 1=> count time & interpolate coords)
%               The methods should probably be expanded to include
%               No handling (Ignore? reject?),
%               count gap times, interpolate (linearly) coords, or both.
%    gap.calc   Flag to calculate or not calculate trials with %zero exceeding maxPct.
%               0 = don't calc, 1 = calc.

gap.min    = 10;
gap.maxPct = 20;
gap.method = 0;
gap.calc   = 1;



%   Fixation parameters
%   -------------------------------
%   fix.params                  parameters for various fixation calcs
%   fix.params.vel              parameters for velocity/distance based calculations
%   fix.params.vel.hMax         hMax, vMax maximum horizontal and vertical excursion allowed
%   fix.params.vel.vMax           between samples during a fixation period(ILAB pixels)
%                                 since the acquisition time is constant between samples
%                                 distance measures are equivalent to velocity measures.
%   fix.params.vel.minDuration  Minimum duration of a fixation period
%
%   fix.params.disp.Disp        Dispersion
%   fix.params.disp.minDuration Minimum duration of a fixation period
%   fix.params.disp.NaNDur      Maximum data loss per fixation
%   fix.type                    currently chosen calculation type. Vel = velocity and
%                                 disp = dispersion
%
%   fix.list         List of fixation calculation results.
%   fix.table        Formatted table of calculation results.

fix.params.vel.hMax         = 14;
fix.params.vel.vMax         = 14;
fix.params.vel.minDuration  = 100;
fix.params.disp.Disp        = 20;
fix.params.disp.minDuration = 100;
fix.params.disp.NaNDur      = inf;
fix.type                    = 'disp'; %'vel' or 'disp'
fix.list                    = [];
fix.table                   = [];


%   Gaze maintenance parameters
%   -------------------------------
%   gaze.ROI   The ROI which defines the gaze boundary
%   gaze.list  List of gaze calculation results. {0,1}=>gaze {not maintained,maintained}
%   gaze.table Formatted table of calculation results.
%   gaze.DataOutpts List of horiz, vert coords and whether they are in
%   selected ROI.

% for k=1:length(eye.ROI)
%     
%     if strcmp(eye.ROI(1,k).name, eye.gazeROI)
%         
%         gaze.ROI = eye.ROI(1,k);
%         break
%     end;
%     
% end;


gaze.list       = [];
gaze.table      = [];
gaze.DataOutpts = {};

%   Video Screen parameters (Used in specifing ROI's by angle and perhaps elsewhere)
%   -------------------------------
%   screen.distance    Subject distance to screen (cm)
%   screen.width       Screen width (cm)
%   screen.height      Screen height(cm)
%
screen.distance = 60 ;
screen.width    =  51;
screen.height   =  29;

%   Saccade analysis parameters
%   -------------------------------
%   saccade.method           Method used to calculate saccades
%   saccade.velThresh        Minimum velocity ( ILAB pixels/samplingInterval )
%   saccade.window           Maximum width of search window (in ms) from onset of velThresh
%   saccade.pctPeak          Percent of peak velocity for final saccade cut
%   saccade.minDuration      Minimum duration of saccade (ms)
%   saccade.onset            Calculation of saccadic RT and ttpeak w.r.t.
%                            trial=1 or target=2.
%   saccade.ROI              optional ROI used to establish min fixation response
%   saccade.minFixDuration   optional  min fixation duration in ROI
%   saccade.list             List of saccade results.
%   saccade.table            Formatted table of calculation results.
%
saccade.method         = 1;
saccade.velThresh      = 30;
saccade.window         = 100;
saccade.pctPeak        = 15;
saccade.minDuration    = 35;
saccade.onset          = 1;
saccade.ROI            = struct(...
    'name',   [],...
    'x',      [],...
    'y',      [],...
    'enabled',1);

saccade.minFixDuration = 100;
saccade.list           = [];
saccade.table          = [];



%   Blink filtering parameters (This could be independent of any other analysis)
%
%   A list of replacements is maintained to enable quick
%     switching between filtered/non-filtered states since entire data arrays
%     can be large.
%   -------------------------------
%   blink.filter      Blink filter method: (1) by pupil size, (2) by bad locations
%   blink.limits      Limits for location filtering (Hmin Hmax Vmin Vmax)
%   blink.list        List of replacements for blink periods [i1 i2 x y]
%   blink.method      Replacement method: Substitute invalid (0) or last
%   valid point (1) for blinks. (2) linear interpolation
%   blink.replace     Replace (1) or don't replace (0) pre/post blink values
%   blink.vertThresh  Threshold for vertical movement (pixels/samplingInterval)
%   blink.window      Number of pre- & post-blink samples to search for replacement

%This means filter by location
blink.filter = [0,1];
blink.limits = eye.blink.limits;%haupt
blink.list = [];
blink.method = 2;
blink.replace = 1;
blink.vertThresh = 20;
blink.window = 5;


%   Filtering parameters (This could be independent of any other analysis)

%   filter.rawcur      Filter current Data (1) or Filter raw Data (2)
%   filter.param1      Is used for the 3 different filter methods that are
%   filter.param2      implemented right now.    
%   filter.param2str       

            % Moving_Average uses only param1 and the parameter "width" is implemented
            % in param1  (normal value = 4)

            % Gaussian uses param1 and param2 the parameter "width" is implemented
            % in param1  (normal value = 4) the parameter 1/Std dev is implemented in param2 (normal value = 1)

            % Hanning uses param1 and param2str the parameter "width" is implemented
            % in param1  (normal value = 5) the parameter Type is implemented in
            % param2str (normal value = standard) (you can only choose standard or symmetric)
            
%   filter.datacol      set up an index of the columns to smooth. Generally this will be 1 = horiz, 2 = vert, 4 = pupil
%   filter.dataChoice   choose what to be filterd (horz. eye, vert. eye, pupil data)
%   filter.method       %Choose Filter Method "Gaussian", "Hanning", "Moving_Average"
                        
filter.rawcur = 1;
filter.param1 = '4'; 
filter.param2    = [];
filter.param2str = [];
filter.datacol = [1 2 4];
filter.dataChoice = [1 1 1];


filter.method = 'Moving_Average'; 

switch (filter.method)

    case ('Gaussian')
        filter.Gaussian = ilabGaussWindow;

    case ('Hanning')
        filter.Hanning = ilabHannWindow;

    case ('Moving_Average')
        filter.Moving_Average = ilabMovingAvgWindow;

end



%   File extension parameters
%   ---------------------------------
%   file.Ext        Permits filtering of different file types in the file
%                   selection box
%	-------------------------------------------------------------------------

file.Ext = {'*.bin; *.eyd; *.dat','ASL, ISCAN, or IVIEW files (*.bin, *.eyd, *.dat)';...
    '*.eyd', 'ASL binary files (*.eyd)';...
    '*.bin', 'ISCAN binary files (*.bin)';...
    '*.dat', 'IVIEW ascii files (*.dat)';...
    '*.*',   'All other file types (*.*)'};




%   trialCodes Parameters
%   Values in the data file that mark trial start, end and target appearance
%     (The individual markers can be multi-valued.)
%   To designate a value as empty use NaN. Do not simply leave a value empty.
%   CORRECT -> trialCodes.target = NaN;      INCORRECT -> trialCodes.target = [];
%   Default and current parameters deal with situations in which trialCodes
%   for a particular dataset may differ from the default.
%
%  (But can a trial start with a target??) This has not been tested.
%  ---------------------------------
%  trialCodes.start  = current start codes
%  trialCodes.target = current target codes
%  trialCodes.end    = current end codes
%
%  trialCodes.default.start  = default start codes
%  trialCodes.default.target = default target codes
%  trialCodes.default.end    = default end codes


trialCodes.default.start  = [eye.ILAB.condtrial,eye.ILAB.condfix];
trialCodes.default.target = [eye.ILAB.condtrial,eye.ILAB.condfix];
trialCodes.default.end    = 255;

trialCodes.start  = trialCodes.default.start;
trialCodes.target = trialCodes.default.target;
trialCodes.end    = trialCodes.default.end;


% PLOTPARMS parameters
%-------------------------------------
% PP.plotSpeedConst   Multiplier for how long to delay between each point
%                     plotted. This is calculated by the formula
%                     PP.plotSpeedConst*(10-speed)^2)

PP.plotSpeedConst = 0.002;


% Coordinate Transformation Parameters
%------------------------------------
%  coordSys     coordinate systems parameters
%     name           name of coordinate system
%     data           Raw data for linear transformation between computer
%                    screen and eye tracker coordinates
%     params         parameters for linear transformation between
%                    computer screen and eye tracker coordinates
%     screen         Width and Height of computer screen in pixels
%     eyetracker     Width and Height of eye tracker screen in pixels


coordSys =  struct('name',     '',...
    'data',     [],...
    'params',   struct('h', [], 'v', []),...
    'screen',   [],...
    'eyetrack', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AP = struct (...
    'basis',        0,...
    'coordSys',     coordSys,...
    'file',         file,...
    'gap',          gap,...
    'minReactTime', 100,...
    'PP',           PP,...
    'start',        Start,...
    'targets',      0,...
    'end',          End,...
    'index',        [],...
    'blink',        blink,...
    'filter',       filter,...
    'fix',          fix,...
    'gaze',         gaze,...
    'ROIStats',     ROIStats,...
    'screen',       screen,...
    'saccade',      saccade,...
    'trialCodes',   trialCodes,...
    'path',         path,...
    'ROI',          ROI,...
    'vers',         vers.ap);

eye.AP = AP;

return;

