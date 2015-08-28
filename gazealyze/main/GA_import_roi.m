function roi = GA_import_roi(roilist, roiall)

%open roi data file
fid = fopen(roiall.file,'r');
roidat= textscan(fid, '%s', 'delimiter' ,'\n');
fclose(fid);
roi = struct('name', {}, 'angle', {}, 'x', {}, 'y', {}, 'stop', {}, 'type', {}, 'valid', {}, 'tag1', {}, 'tag2', {}, 'enabled', {});
name = regexp(roidat{1}{roiall.row_head},'\t','split');

h = waitbar(0,'Importing ROIs');
steps = length(roilist);

%over all roi names
for k=1:length(roilist)
    
    waitbar(k / steps, h, ['Working on roi ' roilist(k).col_roi_name])
    %over all stim pics
    for j=0:length(roidat{1})-roiall.row_data
        data = regexp(roidat{1}{roiall.row_data + j},'\t','split');
        %does stim pic name contain filterstring?
        if ~isempty(strfind(data{roiall.col_pics},roiall.picfilter)) || isempty(deblank(roiall.picfilter))
            %is this roi for this stim pic defined?
            if length(data) >= roilist(k).col_roi_data
                if ~isempty(data{roilist(k).col_roi_data})
                    roi(end+1).valid = strrep(data{roiall.col_pics},roiall.picfilter,'');
                    roi(end).name = name{roilist(k).col_roi_name};
                    roi(end).tag1 = name{roilist(k).col_roi_tag};
                    for i=0:5
                        dat(i+1) = round(str2double(data{roilist(k).col_roi_data + i}));
                    end;
                    if dat(1)==1
                        roi(end).type = 'ellipse';
                    else roi(end).type = 'rectangle';
                    end;
                    roi(end).enabled = 1;
                    if roilist(k).flag_BH
                        roi(end).x = {[dat(2)-dat(4)/2 + 1 ; dat(2) + dat(4)/2]};
                        roi(end).y = {[dat(3)-dat(5)/2 + 1 ; dat(3) + dat(5)/2]};
                    else
                        roi(end).x = {[dat(2); dat(4)]};
                        roi(end).y = {[dat(3); dat(5)]};
                    end;
                    if ~isempty(dat(6))
                        roi(end).angle = dat(6);
                    else roi(end).angle = 0;
                    end;
                    roi(end).stop = 0;
                end;
            end;
        end;
    end;
end;
close (h);