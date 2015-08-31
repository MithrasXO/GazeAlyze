%record button oop style
classdef ui_roicontrol < handle
    properties
        hrecord;
        hdelete;
        hback;
        hforward;
        hend;
        pos;
    end
    events
        newpos;
        pause;
    end
    methods
        function set.pos(obj,value)
            obj.pos= value;
        end
        function value = get.pos(obj)
            value = obj.pos;
        end
        function obj = ui_roicontrol
            %----------------------------------
            %record button
            %----------------------------------
            irecord = uint8(192 .* ones(16, 16, 3));
            a=5;b=5;
            for st = -a:a
                x = st;
                y = sqrt(b^2 * (1-(x^2/a^2)));
                irecord(round(8-y):round(8+y),round(8+x),:) = 0;
            end;
            irecord([7,9],3:13,:) = 0;
            obj.hrecord = uicontrol( ...
                'Style', 'pushbutton', ...
                'CData', irecord, ...
                'tooltipString','record new ROI-timepoint',...
                'Position', [702, 8, 20, 20]);
            %----------------------------------
            %delete button
            %----------------------------------
            idelete = uint8(192 .* ones(16, 16, 3));
            for ic = 1:11
                idelete(2+ic, 2+ic, :) = [150,0,150];
                idelete(2+ic, 3+ic, :) = [150,0,150];
                idelete(2+ic, 4+ic, :) = [150,0,150];
                idelete(14-ic, 4+ic, :) = [150,0,150];
                idelete(14-ic, 3+ic, :) = [150,0,150];
                idelete(14-ic, 2+ic, :) = [150,0,150];
            end
            obj.hdelete = uicontrol( ...
                'Style', 'pushbutton', ...
                'CData', idelete, ...
                'tooltipString','delete ROI-timepoint',...
                'Position', [728, 8, 20, 20]);
            
            %----------------------------------
            %start/restart/end button
            %----------------------------------
            iend = uint8(192 .* ones(16, 16, 3));            
            iend(3:14,12:13, :) =  0;    
            iend(8:9, 6:13, :) = 0;  
            obj.hend = uicontrol( ...
                'Style', 'togglebutton', ...
                'CData', iend, ...
                'tooltipString','end of ROI-timeline',...
                'Position', [754, 8, 20, 20]);
            
            %----------------------------------
            %backward button
            %----------------------------------
            
            iback = uint8(192 .* ones(16, 16, 3));
            iback(3:14, 4:5, :) = 0;
            for ic = 1:6
                iback(2+ic, 13-ic:12, :) = 0;
                iback(15-ic,13-ic:12, :) = 0;
            end
            obj.hback = uicontrol( ...
                'Style', 'pushbutton', ...
                'CData', iback, ...
                'tooltipString','last ROI-timepoint',...
                'Position', [652, 8, 20, 20]);
            %----------------------------------
            %forward button
            %----------------------------------
            iforward = uint8(192 .* ones(16, 16, 3));
            iforward(3:14, 12:13, :) = 0;
            for ic = 1:6
                iforward(2+ic, 5:4+ic, :) = 0;
                iforward(15-ic, 5:4+ic, :) = 0;
            end
            obj.hforward = uicontrol( ...
                'Style', 'pushbutton', ...
                'CData', iforward, ...
                'tooltipString','next ROI-timepoint',...
                'Position', [678, 8, 20, 20]);
        end
        function delete(obj)
            if ishandle(obj.hrecord)
                delete(obj.hrecord);
            end;
            if ishandle(obj.hend)
                delete(obj.hend);
            end;
            if ishandle(obj.hdelete)
                delete(obj.hdelete);
            end;
            if ishandle(obj.hback)
                delete(obj.hback);
            end;
            if ishandle(obj.hforward)
                delete(obj.hforward);
            end;
        end
    end
end