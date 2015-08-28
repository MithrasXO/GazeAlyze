%--------------------------------------------------------------------------
% rename.m v1.05 >>> Christoph Berger / Martin Winkels 10.09.09
%--------------------------------------------------------------------------

%Das Programm sucht und vergleicht Header und Datenfiles der Viewpoint Eyetracker-Software
%Werden übereinstimmungen im Timestamp gefunden wird das Datenfile
%umbenannt (Dateiname des Headerfiles) und in den renamed Ordner verschoben.

% Von Christoph Berger und Martin Winkels 

% Klinik und Poliklinik für Psychiatrie und Psychotherapie der Universität Rostock
% AG Emotion & Kognition

%--------------------------------------------------------------------------
% rename.m v1.05 >>> Christoph Berger / Martin Winkels 10.09.09 
%--------------------------------------------------------------------------


%Aufräumen
clear;

%Pfad wählen wo die Daten- und Headerfiles liegen
pathraw = '\\Sr198056\share\Martin Winkels\Projekte\ProjektIlab\Daten\Marlies_ExpB\Viewpoint\raw\';

%Pfad wählen in den die fertigen Dateien verschoben werden sollen
pathrenamed ='\\Sr198056\share\Martin Winkels\Projekte\ProjektIlab\Daten\Marlies_ExpB\Viewpoint\renamed\';


%Einlesen der Daten in 2 Listen

%Liste für die Files die umbenannt werden müssen (Daten ohne Probandennamen)
list_file_data = dir(fullfile(pathraw,'200*-*'));
%Liste der Files deren Namen gelesen werden müssen (Header mit Probandennamen)
list_file_header = dir(fullfile(pathraw,'expB*'));

%Falls der Ordner nicht existiert, erstelle ihn
if ~(exist ([pathraw 'finished\'], 'dir'))

    mkdir ([pathraw 'finished\']);
end;

%Schleife über die Datenfiles
for idx_Data=1:length(list_file_data)

    %Lese/Importiere jeweils 1 File abhängig von idx_Data
    file_data = importdata(fullfile(pathraw,list_file_data(idx_Data,1).name));

    %Sicherheitsabfrage ob überhaupt Daten vorhanden sind im File
    if length(file_data.textdata)>7

        %Ziehe die Timestamp-Informationen aus dem Datenfile
        TimeStampA=file_data.textdata{8,1};

        if findstr(TimeStampA, 'TimeValues') > 0

            %Gegenstück des Datenfiles wird in der Liste der Headerfiles
            %gesucht (Schleife über die Headerfiles)
            for idx_Header=1:length(list_file_header)

                %%Lese/Importiere jeweils 1 File abhängig von idx_Header
                file_Header = importdata(fullfile(pathraw,list_file_header(idx_Header,1).name));


                %Sicherheitsabfrage ob überhaupt Daten vorhanden sind im File
                if length(file_Header.textdata)>7

                    %Ziehe die Timestamp-Informationen aus dem Headerfile
                    TimeStampB=file_Header.textdata{8,1};

                    %Vergleichen ob die beiden Timestamps gleich sind
                    TimeStampEqual = strcmp(TimeStampA, TimeStampB);

                    %Falls gleich...
                    if(TimeStampEqual == 1)

                        %Lese den Filenamen ein
                        selected_file=list_file_data(idx_Data,1).name;

                        %Kopiere das File in den neuen Ordner
                        copyfile(fullfile(pathraw,selected_file),pathrenamed);

                        %Abfrage ob File eine TXT endung aufweist
                        if (strfind('.txt',list_file_header(idx_Header,1).name ))

                            %Falls ja benenne das kopierte Datenfile um mit
                            %dem Dateinamen des Headerfiles
                            movefile(fullfile(pathrenamed,selected_file),(fullfile(pathrenamed,list_file_header(idx_Header,1).name)));
                        else
                            %Falls ja benenne das kopierte Datenfile um mit
                            %dem Dateinamen des Headerfiles und hänge ein
                            %.txt an
                            movefile(fullfile(pathrenamed,selected_file),(fullfile(pathrenamed,[list_file_header(idx_Header,1).name '.txt'])));
                        end

                        %Verschiebe die bearbeiteten Header- und Datenfiles
                        %in den Ordner finished
                        movefile(fullfile(pathraw, list_file_header(idx_Header,1).name),[pathraw 'finished\' list_file_header(idx_Header,1).name ]);
                        movefile(fullfile(pathraw, selected_file),[pathraw 'finished\' selected_file]);

                        %Anzeigen das Files gefunden und bearbeitet wurden
                        disp (['Match between ', list_file_data(idx_Data,1).name,' and ',list_file_header(idx_Header,1).name, ' found! File has been moved and renamed!']);
                        disp (' ');

                        %Liste neu einlesen
                        list_file_header = dir(fullfile(pathraw,'expB*'));

                        %Schleife abbrechen da Files gefunden wurden
                        break;
                    end;
                end;
            end;
        end;
    end;
end;
%Anzeigen das fertig
disp ('All done!!!');
%aufräumen
clear;
