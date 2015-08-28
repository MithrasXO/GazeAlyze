function flag_error = GA_consistency(fname)

global eye;

load(fullfile(eye.dir.conv, fname),'ILAB');



strError='';

flag_error = 0;
if isempty(ILAB.data)
    strError = {'no data or confusion in data stream'};
    flag_error = 1;
elseif strcmp(eye.datatype,'Viewpoint')
    load(fullfile(eye.dir.conv, fname),'import');
    if any(import.marker.times(3:end)==0)        
        ix=find(import.marker.times(3:end)==0);
        mark=import.marker.values(ix+2);
        strmark = '';
        for i=1:length(mark)
            strmark = strcat(strmark, ',', mark{i});
        end;        
        inconsist = [ 'time info error at marker nr: ' mat2str(ix)  ' marker string: ' strmark];
        strError{end+1} = inconsist;
        flag_error = 1;
    end;
    if length(import.marker.values)< 2                
        inconsist = ['only one marker'];
        strError{end+1} = inconsist;
        flag_error = 1;
    end;
    
end;

if flag_error
    
    if ~isdir(fullfile(eye.dir.conv, 'error'))
        mkdir(fullfile(eye.dir.conv, 'error'));
    end
    movefile(fullfile(eye.dir.conv, fname), fullfile(eye.dir.conv, 'error', fname));
    
    if ~isdir(fullfile(eye.dir.raw, 'error'))
        mkdir(fullfile(eye.dir.raw, 'error'));
    end
    movefile(fullfile(eye.dir.raw, strrep(eye.dir.fileid, '$id', fname(1:end-7))), fullfile(eye.dir.raw, 'error', strrep(eye.dir.fileid, '$id', fname(1:end-7))));
    
    fid = fopen(fullfile(eye.dir.conv, 'error', [fname(1:end-6) 'err.txt']),'w');
    for i=1:length(strError)
        fprintf(fid, '%s\n', strError{i} );
    end;
    fclose(fid);
    
end;







