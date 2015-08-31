function [out_data, out_lbstring] = GA_gui_get(in_lbstring, newstr, in_data, in_cntrl, strType)
%[mainGUIdata.data.eye.cond.duration, lbstring ] =  gui_get(lbstring, 'Trials limited: ', handles.pm_type, 'String');

value = get(in_cntrl,strType);

if strcmp(get(in_cntrl,'Style'),'popupmenu')
    str = get(in_cntrl,'String');
    value= str{value};
    strType = 'String';
end;

if strcmp(get(in_cntrl,'Style'),'listbox')
    value = value';
end;

if isempty(value) && isempty(in_data);
    value = '';
    out_data = '';
end;

flag_change = 0;

if strcmp(strType,'String')
    
    if iscell(value)
        for i=1:length(value)
            if ~any(strcmp(in_data,value(i)))
                flag_change = 1;
            end;
        end;
        for i=1:length(in_data)
            if ~any(strcmp(in_data(i),value))
                flag_change = 1;
            end;
        end;
    else
        if strcmp(value, 'choose file...') || strcmp(value, 'choose directory...')
            value = '';
        end;
        if isnumeric(in_data) && ~isempty(in_data)
            if length(str2num(value))~= length(in_data)
                flag_change = 1;
            elseif any(str2num(value)~=in_data)
                flag_change = 1;
            end;
        else
            value=strrep(value,char(39) , '');
            if ~strcmp(value,in_data)
                flag_change = 1;
            end;
        end;
    end;
elseif strcmp(strType,'Value')
    if value~=in_data
        flag_change = 1;
    end;
end;

if flag_change
    %data update
    if ~isnumeric(value) && isnumeric(in_data) && ~isempty(in_data)
        out_data = str2num(value);
    else
        out_data = value;
    end;
    if isnumeric(value)
        value = num2str(value);
    end;
    if strcmp(value, 'NaN')
        value = '-none-';
    end;
    if iscell(value)
        value = 'changed';
    end;
    %log update
    out_lbstring = [in_lbstring; [newstr value]];
else
    out_data=in_data;
    out_lbstring = in_lbstring;
end;