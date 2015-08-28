%Programm sucht und sortiert gleiche Files in gleiche Unterordner


path = 'C:\Documents and Settings\fmri\My Documents\Eyetracker\Projekte\FORUN\ILAB\rawmat\';
pathfaces = fullfile(path, 'FACES');
pathiaps = fullfile(path, 'IAPS');
pathrmie1 = fullfile(path, 'RMIE1');
pathrmie2 = fullfile(path, 'RMIE2');

mkdir(pathfaces);
mkdir(pathiaps);
mkdir(pathrmie1);
mkdir(pathrmie2);

filestoren = dir(fullfile(path, '*.mat'));

for i=1:size(filestoren)
    
    file = filestoren(i,1).name;
    if (strncmp(file, 'Faces', 5))
        copyfile(fullfile(path,file),pathfaces);
    end;
    
    if (strncmp(file, 'IAPS', 4))
        copyfile(fullfile(path,file),pathiaps);
    end;
    
    if (strncmp(file, 'RMIE1', 5))
        copyfile(fullfile(path,file),pathrmie1);
    end;
    
    if (strncmp(file, 'RMIE2', 5))
    copyfile(fullfile(path,file),pathrmie2);
    end;
    
    
end;




