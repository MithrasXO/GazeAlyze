function GA_ilabCalcSaccadeCB

global eye;
% ILABCALCSACCADECB -- Callback for Saccade Analysis Menu Item
%   ILABCALCSACCADECB(action) -- sets up a dialog for analyzing saccades
%   and setting appropriate parameters for the analysis.
%   The "global" SACCADEUI_AP should be used only within this function.
%
%   SACCADEUI_AP holds the values of the analysisParms while the Saccade
%   UI window is open.  Choosing OK, causes their values to be saved
%   and analysis performed; choosing Cancel causes them to be discarded.

% Authors: Roger Ray, Darren Gitelman
% $Id: ilabCalcSaccadeCB.m 1.13 2004-02-17 23:24:19-06 drg Exp $


global SACCADEUI_AP;

SACCADEUI_AP = eye.AP;

% enable time display checkbox if used in calculation
% ilabShowConstrainedTrialsCB('status')

mkSaccadeResults(SACCADEUI_AP);




return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mkSaccadeResults(AP)

global eye;
%  Make the Saccade List & Table and Save Them
%  ----------------------------------------------------

% Use the plotParms data so that the saccade caculation reflects
% any currently implemented preprocessing, such as blink filtering.
PP = eye.PP;
IL = eye.ILAB;

% Time constraints are always calculated relative to the original index
% and not to a processed index. This avoids constraining a
% constraint with its attendant problems of keeping track
% of where we are. However, the constraint is always applied
% to the plotParms or processed data.
constrainedIndex = GA_ilabMkConstrainedTrialList(eye.AP, IL.index);

if isempty(constrainedIndex),   return;  end;

%  Make a list of saccade results (list & table) and save them
%  -------------------------------------------------------
eye.AP.saccade.list = GA_ilabMkSaccadeList(PP.data, constrainedIndex);

eye.AP.saccade.table = GA_ilabMkSaccadeTbl(eye.AP.saccade.list, 'listbox');



return



