function GA_ilabCalcFixCB()
global eye;
% ILABCALCFIXCB -- Callback for Fixation Calculation Menu Item
%   ILABCALCFIXCB(action) sets up a dialog for fixation calculations
%
%   The "global" FIXUI_AP should be used only within this function.
%   It is cleared when the dialog exits.
%
%   FIXUI_AP holds the values of the analysisParms while the Fixation
%   UI window is open.  Choosing OK, causes their values to be saved;
%   choosing Cancel causes them to be discarded.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabCalcFixCB.m 1.16 2004-08-16 10:11:52-05 drg Exp drg $

% enable time display checkbox if used in calculation
%ilabShowConstrainedTrialsCB('status')

mkFixationList;
% Clear the filtercache
GA_ilabGetPlotParms;
% clear plotParms.filtercache
eye.PP.filtercache = repmat(struct('type','','params',[],'colidx', 0, 'data', []),1,3);

%showFixRelMvmtChkBoxes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nur Visualisierung...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%GA_ilabShowFixationTblCB('init');

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mkFixationList()
global eye
%  Make the Fixation List
%  -------------------------------------------------

GA_ilabGetPlotParms;

constrainedIndex = GA_ilabMkConstrainedTrialList(eye.AP, eye.PP.index);

if isempty(constrainedIndex),   return;  end;

GA_ilabMkFixationList(constrainedIndex);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showFixRelMvmtChkBoxes()

%  Enable the Fixations and Rel. Movement Checkboxes.
% ---------------------------------------------------

f = ilabGetMainWinHdl;

h = findobj(f, 'Tag', 'ShowFixBox');
if ~isempty(h)  set(h, 'Enable', 'on');  end;

h = findobj(f, 'Tag', 'RelMovePlotBox');
if ~isempty(h)  set(h, 'Enable', 'on');  end;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
