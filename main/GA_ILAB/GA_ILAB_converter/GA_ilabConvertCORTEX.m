function  [ILAB, AP] = GA_ilabConvertCORTEX(pname, fname, AP)
% ILABCONVERTCORTEX - Extracts relevant variables from a Cortex data file
%   [datamat, serialidx, hz, subject, filedate, filetime, description, ver] =
%   ilabConvertCORTEX(pname, fname)

% Authors: Darren Gitelman
% $Id: ilabConvertCORTEX.m 1.9 2004-10-08 18:48:28-05 drg Exp drg $

% initialize output variables.
ILAB          = GA_ilabcreateILABstruct();
ILAB.path     = pname;
ILAB.fname    = fname;
ILAB.type     = 'cortex';
[p, f, e]     = fileparts(fname);
ILAB.subject  = f;

% Setup cortex data structure
cortex = struct(...
    'length',            [],...
    'cond_no',           [],...
    'repeat_no',         [],...
    'block_no',          [],...
    'trial_no',          [],...
    'isi_size',          [],...
    'code_size',         [],...
    'eog_size',          [],...
    'epp_size',          [],...
    'eye_storage_rate',  [],...
    'kHz_resolution',    [],...
    'expected_response', [],...
    'response',          [],...
    'response_error',    [],...
    'time',              [],...
    'codes',             [],...
    'epp',               [],...
    'eog',               []);

% open file
fid = fopen(fullfile(pname,fname));
if fid < 0
    ILAB = [];
    ILAB.error = 'CORTEX: Could not open data file.';
    return
end

% get file size
fseek(fid,0,1);
eof = ftell(fid);
n = 0;
fseek(fid,0,-1);

% get the data
% exit criteria is if we're less than 26 bytes
% from the end of the file because the header needs at
% least this number of bytes
while ftell(fid) < eof-26
    % have to break out of loop since there is no way to know how many
    % trials there are from the headers themselves
    n = n + 1;
    cortex(n).length             = fread(fid,1,'ushort');
    cortex(n).cond_no            = fread(fid,1,'ushort');
    cortex(n).repeat_no          = fread(fid,1,'ushort');
    cortex(n).block_no           = fread(fid,1,'ushort');
    cortex(n).trial_no           = fread(fid,1,'ushort');
    cortex(n).isi_size           = fread(fid,1,'ushort');
    cortex(n).code_size          = fread(fid,1,'ushort');
    cortex(n).eog_size           = fread(fid,1,'ushort');
    cortex(n).epp_size           = fread(fid,1,'ushort');
    cortex(n).eye_storage_rate   = fread(fid,1,'uchar');
    cortex(n).kHz_resolution     = fread(fid,1,'uchar');
    cortex(n).expected_response  = fread(fid,1,'short');
    cortex(n).response           = fread(fid,1,'short');
    cortex(n).response_error     = fread(fid,1,'short');
    cortex(n).time               = fread(fid,cortex(n).isi_size/4,'long');
    cortex(n).codes              = fread(fid,cortex(n).code_size/2,'short');
    cortex(n).epp                = fread(fid,cortex(n).epp_size/2,'short');
    cortex(n).eog                = fread(fid,cortex(n).eog_size/2,'short');
    
    cortex(n).epp = reshape(cortex(n).epp,2,length(cortex(n).epp)/2)';
    cortex(n).eog = reshape(cortex(n).eog,2,length(cortex(n).eog)/2)';
end

% close the file
fclose(fid);

% assign data to ILAB output variables.
% The variables subject, filedate, filetime, and description remain empty
ILAB.vers = 1.0;

% Assign hz
% Cortex has a nominal eye data collection rate but does not
% maintain this rate of collection in the face of doing other things.
% At least in the sample file I was provided, the collection rate was 
% ever so slightly slowed (about 1% slower) than the nominal rate.
% Determining the actual rate depends on cortex recording
% eye movements during an entire trial. If the eye recording is actually
% turned on and off then the nominal rate must be used.
% Not sure which codes turn the eye data on and off
% Could be  44 START_EYE1, 45 END_EYE1, 46 START_EYE2, 47 END_EYE2
%
% Currently ILAB has no facility for dealing with different data acquisition
% rates on a trial by trial basis. This variable is hooked into many
% ILAB functions so changing it is not trivial.
%
% For now set the reported rate to the nominal rate recorded in cortex
% However, for sorting out the timing in each trial figure the actual
% rate. Otherwise, the number of points will not correspond to the trial
% timing
hz = 1000/cortex(1).eye_storage_rate;
ILAB.acqRate  = hz;
ILAB.acqIntvl = cortex(1).eye_storage_rate;

% allocate datamat, serialidx
totalBytes = sum([cortex.eog_size])/4;
datamat    = zeros(totalBytes,3);

% index for datamat
idx        = 1;

% Use CORTEX's codes for EOG start and stop

startCode = 100;
endCode   = 101;

AP.trialCodes.start  = startCode;
AP.trialCodes.end    = endCode;
AP.trialCodes.target = NaN;


% put data into datamat
% Times are relative to the start and end of the eye data and NOT absolute
% trial times. Thus the start of the eye data (eog) is time 0, always.
for i = 1:size(cortex,2)
    idx2 = idx + size(cortex(i).eog,1)-1;
    datamat(idx:idx2,1:2) = cortex(i).eog;
    datamat(idx,3)        = startCode;
    datamat(idx2,3)       = endCode;
    dataidx(i,1:2)        = [idx, idx2];
    idx = idx2 + 1;
end

ILAB.data       = datamat;
ILAB.index      = dataidx;
ILAB.index(:,3) = NaN;
ILAB.trials     = size(ILAB.index,1);
