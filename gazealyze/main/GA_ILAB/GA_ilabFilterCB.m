function GA_ilabFilterCB()

global eye;
% ILABFILTERCB - filter eye or pupil data.
%  ilabFilter(varargin) the order of the first 2 elements are
%    action    - call gui or callback to different routines
%    PlotParms - use only to clear the filter cache.
%
% The routine is now object oriented. To plug in a new filter all a user
% must do is write a filtering function that returns its definition and
% a digital filtering window. See ilabGaussWindow or ilabHannWindow.
% The function is placed in the filters directory. Restarting ILAB will
% read in the function. As long as the function is setup according to
% the examples this routine will accept parameters and perform filtering
% correctly without knowing the details of the function.

% Authors: Darren Gitelman
% $Id: ilabFilterCB.m 1.10 2004-09-12 19:25:23-05 drg Exp drg $
GA_ilabGetPlotParms;

% trap no data or filter selected.
choiceIdx = find(eye.AP.filter.dataChoice);

% first check if there is filtered data and unfilter it. We
% don't merely resort to using raw data since the user may have
% performed other operations, such as blink filtering,
% which we want to preserve.

% check if we want to use unfiltered data, and there is data to be
% unfiltered and we didn't choose to selectively unfilter part of
% the data.

% process the chosen filter or unfilter the data.
if eye.AP.filter.rawcur == 2  % Unfilter
    % if no data to unfilter then return
    if any(~ismember(eye.AP.filter.datacol(choiceIdx),[eye.PP.filtercache.colidx]))
        warndlg('Only data that has been filtered can be unfiltered.',...
            'ILAB FILTER WARNING','modal');
        return
    end
    % unfilter the chosen data
    for i = 1:length(choiceIdx)
        eye.PP.data(:,eye.PP.filtercache(choiceIdx(i)).colidx) = ...
            eye.PP.filtercache(choiceIdx(i)).data;
        eye.PP.filtercache(choiceIdx(i)) = struct('type','','params',[],...
            'colidx', 0, 'data', []);
    end    
    return
end
% check if there is previously filtered data and if the user is
% re-filtering it.
if ~chkForFilteredData(eye.PP,eye.AP.filter.datacol,choiceIdx)
    return
end
% proceed with filtering
% get the parameters

windw = eval([eye.AP.filter.(eye.AP.filter.method).mfilename,'(',eye.AP.filter.param1,eye.AP.filter.param2str,')']);

% apply to the data
data  = eye.PP.data;
for i = 1:size(eye.PP.index,1)
    for j = 1:length(choiceIdx)
        filtered = GA_ilabFilter(windw,1,data(eye.PP.index(i,1):eye.PP.index(i,2),eye.AP.filter.datacol(choiceIdx(j))));
        if ~isempty(filtered)
        data(eye.PP.index(i,1):eye.PP.index(i,2),eye.AP.filter.datacol(choiceIdx(j))) = filtered;                   
        end;
    end
end

for i = 1:length(choiceIdx)
    eye.PP.filtercache(choiceIdx(i)).colidx = eye.AP.filter.datacol(choiceIdx(i));
    eye.PP.filtercache(choiceIdx(i)).data   = eye.PP.data(:,eye.AP.filter.datacol(choiceIdx(i)));
    eye.PP.filtercache(choiceIdx(i)).type   = eye.AP.filter.method;
    eye.PP.filtercache(choiceIdx(i)).params{1} = eye.AP.filter.param1;
    if ~isempty(eye.AP.filter.param2)
        eye.PP.filtercache(choiceIdx(i)).params{2} = eye.AP.filter.param2;
    end
    eye.PP.data(:,eye.AP.filter.datacol(choiceIdx(i))) = data(:,eye.AP.filter.datacol(choiceIdx(i)));
end

%------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function flag = chkForFilteredData(PP, datacol ,choiceIdx)

flag = 1;
% if data has been filtered check if user is trying to filter it again. If
% so warn them of the consequences and check whether to proceed.
if (any([PP.filtercache.colidx] ~= 0)) & ...
        any(ismember([PP.filtercache.colidx],datacol(choiceIdx)))
    fq = questdlg(['Filtering previously filtered data cannot be undone. ',...
        'Do you want to proceed?'],'ILAB Filter Warning','Yes','No','Yes');
    if strcmp(fq,'No')
        flag = 0;
    end
end
