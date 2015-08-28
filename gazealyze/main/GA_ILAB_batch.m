function GA_ILAB_batch(wbhandle)

global eye;

%  try
fclose all;

%1. %Vordefinierte externe Parameter laden -> in eye.PP
GA_ilabGetPlotParms;

%2. %Vordefinierte externe Parameter laden -> in eye.AP
if strcmp(eye.jobs.ILAB, 'default file')
    GA_ilabAnalysisParms();
elseif exist(eye.jobs.ILAB) == 2
    run(eye.jobs.ILAB);
else 
    error([eye.jobs.ILAB ' is no valid ILAB-parameter file.' ]);
end;

%3a. alle importierten trialcodes werden auf die in eye.cond.values beschränkt nur trialcodes verwenden, welche aus  
GA_ilabReviewILABCB();

if eye.blink.limits(2)-eye.blink.limits(1) == 0 || eye.blink.limits(4)-eye.blink.limits(3) == 0
    throw(except_screen)
end;

if eye.jobs.blinks
    %4. Blinks
    GA_ilabCalcBlinksCB();
end

if eye.jobs.filter
    %5. Glättung
    GA_ilabFilterCB();
end

if eye.jobs.fixations
    %6. Fiaxtionen
    GA_ilabCalcFixCB();
end

if eye.jobs.saccades
    %9. Saccades
    GA_ilabCalcSaccadeCB();
end

%10. data + results into workspace
[eyemove, pupil, eye.ILAB.quality.snr] = GA_ilabData2WSCB();

fixvar = eye.AP.fix; %#ok<*NASGU>
saccvar = eye.AP.saccade;

quality = eye.ILAB.quality;

save(fullfile(eye.dir.conv, eye.ILAB.conv_file_name), 'eyemove', 'pupil', 'fixvar', 'saccvar', 'quality', '-append');

%11.    export single files...
GA_ilabSaveTblAsExcelCB();

%Aufräumen, Cache leeren, Ausgangszustand wiederherstellen

h = figure(GA_gui_main);
closeFig(h, wbhandle)
fclose all;
clearvars -except eye filelist filepath steps wb
eye = rmfield(eye, {'ILAB' 'AP' 'PP'});


function closeFig(varargin)

% This function closes all figures currently open EXCEPT for
% those listed as arguments.

if nargin==0,
    close all;
    return
end


all_figs = findobj(0, 'type', 'figure');

if iscellstr(varargin)
    figs2keep=cellfun(@str2double,varargin);
else
    figs2keep=[varargin{:}];
end
figs2keep(figs2keep==0)=gcf;
delete(setdiff(all_figs, figs2keep))


