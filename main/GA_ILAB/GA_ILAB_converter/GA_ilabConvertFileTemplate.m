function GA_ilabConvertFileTemplate()
% ILABCONVERTFILETEMPLATE - Template for setting up a file convertor.
%  Change the function's name to suit your purpose.
%
%  This convertor should be setup as a toolbox for easy integration with
%  ILAB. To do this put the function inside a directory of the same name
%  (minus the .m extension) and place in the ILAB/Toolbox directory. Then
%  restart ILAB. Now a toolbox with the name of your convertor will be
%  visible in the toolbox menu under the File menu. Choosing your convertor
%  will execute this file.
%
%  The function should handle its own file selection, opening and
%  conversion. It should not produce the ILAB structure as an output, nor
%  should it try to set that structure using ilabSetILAB. Instead, the ILAB
%  stucture should be sent to ilabReviewILABCB to properly fill in 
%  the remaining fields and check its format.
%
% Template Author: Darren Gitelman
% $Id: ilabConvertFileTemplate.m 1.2 2004-10-03 13:53:45-05 drg Exp drg $

%=====================================================================
% SETUP ILAB VARIABLE SECTION
%=====================================================================
ILAB          = ilabGetILAB('reset');

% This will return the following structure. The data type is in parentheses
% ILAB =    path: []            Path to selected data file (string)
%          fname: []            Name of selected data file (string)
%           type: []            Type of eye data file, e.g. ASL or ISCAN (string)
%           vers: []            Version of the eye data file (double, scalar)
%        subject: []            Subject ID (string)
%           date: []            Date of run (string)
%           time: []            Time of run (string)
%        comment: []            Comments (string)
%       coordSys: [1x1 struct]  Leave alone.
%        acqRate: []            Data acquisition speed, e.g., 60 or 120 (double, scalar)
%       acqIntvl: []            Acquisition interval in msecs (i.e., 1000/acqRate (double, scalar)
%           data: []            Actual data. (double, matrix) Must be organized as n x 3 or
%                               n x 4 matrix. Column order is horizontal eye data,
%                               vertical eye data, trial start/end markers, and 
%                               pupil data. Pupil data is optional. Trial start/end
%                               markers are numbers that ILAB interprets as the start
%                               and end of trials based on the trial codes. For example,
%                               if the start code is 1, end code is 255, there is 1 trial, 
%                               there are n data points, then ILAB.data(1,3) = 1, 
%                               and ILAB.data(n,3) = 255, and the rest of ILAB.data(:,3)
%                               would be 0.
%         trials: 0             Number of trials (double, scalar)
%          index: []            Index to start and end of each trial. (n x 3)
%                               Column 1 is for trial starts, Column 2 for ends
%                               and column 3 for targets or just NaN. Using
%                               the previous example if there was one trial
%                               and no targets then ILAB.index = [1 n NaN];
%                               Where n is replaced by the actual last line
%                               number of the data.
%          image: [1x1 struct]  Leave alone
%     trialCodes: []            Leave alone
%
% ********************************************************************
% The code must fill in fields acqRate, acqIntvl, data, index, and
% trials. All other fields can be left empty.
% ********************************************************************

%=====================================================================
% FILE SELECTION SECTION
%=====================================================================
% Code to select a file and return the name and path
% e.g., [fname, pth] = uigetfile('*.eyd', 'Pick an XXXX file');


%=====================================================================
% FILE OPEN SECTION
%=====================================================================
% Code to open the file for reading
% e.g., fid = fopen(fullfile(pth,fname),'r');


%=====================================================================
% CODE FOR READING SPECIFIC FILE TYPE
%=====================================================================
% This section contains code specific to reading the particular file type.
% This may involve a combination of reading an ascii header and binary data
% 
% Once all variables are read in the relevant fields of the ILAB structure
% can be filled in. Remember at a mimimum the code must fill in the fields
% acqRate, acqIntvl, data, index, and trials. It would also be useful to
% fill in type to identify the platform on which the data was acquired,
% vers to provide some form of version control, and subject and date to
% identify the data.


%=====================================================================
% FILE CLOSE
%=====================================================================
% close the handle to the data file
% e.g., fclose(fid); where fid = file handle obtained from fopen


%=====================================================================
% CODE FOR REVIEWING DATA TO SET THE COORDINATE SYSTEM
%=====================================================================
% Data must be displayed in the data properties dialog and a coordinate
% system chosen. This allows the user to make sure the trial designations
% and other file properties are correctly filled in.
ilabReviewILABCB('init', ILAB);

% All done.
