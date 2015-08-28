function ilabProgressBar(action,pct,str)
% ILABPROGRESSBAR -- Draws a progress bar in figure window 4.
%   ILAB_PROGRESS(action,pct,string) will set up, update, and 
%   clear a progress bar to inform the user what is happening.
%
%   Valid actions are setup, update, and clear.
%   If update is selected then pct refers to the length of the
%   bar. Valid numbers are 0-100. String is a text label.

% Authors: Darren Gitelman, Roger Ray
% $Id: ilabProgressBar.m 1.4 2003-08-19 00:20:53-05 drg Exp $

switch lower(action)
case 'setup'
    try
      delete(findobj('Tag','progress'))
  catch
  end
    figure('Color',[.5 .5 .5],'Name','PROGRESS',...
        'menubar','none','NumberTitle','off',...
        'Position',[20 400 320 120],...
        'Units','pixels','Resize','off','Tag','progress');
    
    axes('Position',[.02 .5 .96 .22],'Units','normalized',...
        'XTick',[],'Xlim',[-1 101],'YTick',[],...
        'YColor',[0 0 0],'XColor',[0 0 0],'DrawMode','fast',...
        'Box','on','Tag','progressax');
    
    h = line('Xdata',[0 0], 'Ydata',[0 0],...
        'LineWidth',11, 'Color', [1 0 0],'EraseMode','background','tag','progline');
    set(gca,'UserData',h);
   h = xlabel(' ','FontSize',10,'FontWeight','demi','Tag','proglabel',...
        'horizontalalignment','center');
    set(gca,'XColor',[0 0 0]);
    
case 'update'
    if nargin == 2
        str = [];
    end
    hf = findobj('Tag','progress');
    br = findobj(hf,'Tag','progline');
    set(br,'Xdata',[0 pct]);
    if ~isempty(str)
        % findobj(findobj('Tag','progress'),'Tag','proglabel') doesn't seem to work on UNIX R11
        hca = get(hf, 'CurrentAxes');
        hxlabel = get(hca, 'XLabel');
        set(hxlabel,'String',str);
    end
    
case 'clear'
    if ~isempty(findobj('Tag','progress'))
        delete(findobj('Tag','progress'));
    end
end

drawnow;