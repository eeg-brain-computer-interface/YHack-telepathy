function dataimport_forruth(basename)

global eegdata;

filepath = '';

pfiles = dir([filepath basename '*.mat']);

data = load([filepath pfiles(1).name]);
% hd_data  = load([filepath pfiles(2).name]);
fprintf('Loading %s\n',pfiles.name);

%% sampling rate
thesrate = round(1 / (data.ans.Time(2,1) - data.ans.Time(1,1)));
fprintf('Sampling rate of %sHz detected...\n',num2str(thesrate));
data = data.ans.Data';

%% put it into workspace
eegdata = data;
evalin('base','global eegdata');

%% put into EEGLAB
EEG = pop_importdata('dataformat','array','nbchan',size(data,1),'data','eegdata','srate',thesrate,'pnts',0,'xmin',0);

%% import events from first channel
EEG = pop_chanevent(EEG, 1 ,'edge','leading','edgelen',0);
EEG = eeg_checkset(EEG);

% %% filter data
% % do high pass filter FIRST (bandpass in EEG lab is buggy)
 EEG = pop_eegfilt(EEG, 0.5, 0, [], [0], 0, 0, 'fir1',0); % does a 0.5 Hz high
% % pass filter
 EEG = pop_eegfilt(EEG, 0, 30, [], [0], 0, 0, 'fir1',0); % does a 30 Hz
% % low pass filter
 EEG = pop_iirfilt( EEG, 55, 65, 0, 1); % does a 60 Hz notch filter

% often we filter our data from 0.1-1 to 30-40 Hz and add a 60 Hz notch filter
% (for line noise)

%% add channel info
% eeglab includes some standard electrode location files
% (eeglab\sample_locs\)
EEG = pop_chanedit(EEG, 'load',{'Standard-10-10-Cap16.locs' 'filetype' 'autodetect'});
EEG = eeg_checkset(EEG);

%% epoch around events
EEG = pop_epoch( EEG, {  }, [-0.2 0.8], 'epochinfo', 'yes'); 
%chop data into pack of 1 s (200 ms before event, 800 ms after event) (good
%for P300, but may want longer for imagery, e.g., 200 ms before to 3-5 s
%after)

%% detrend
EEG = eeg_detrend(EEG);

%% baseline correct (takes out eeg from pre-stimulus period)
EEG = pop_rmbase(EEG,[-200 0]);

%% rename the events

% 1 - standard (attend R trials)
% 2 - left implicit target
% 3 - right explicit target
% 4 - standard (attend L trials)

eventnames = {
    'rSTD'
    'lIMP'
    'rEXP'
    'lSTD'
    };

%% rename the events
% 
% for i = 1:length(EEG.event);
%     EEG.event(i).type = char(eventnames(EEG.event(i).type));    
% end


%% save it
EEG = eeg_checkset(EEG);
EEG.filepath = filepath;
EEG.setname = sprintf('%s',basename);
EEG.filename = sprintf('%s_norej.set',basename);

fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
pop_saveset(EEG,'filename', EEG.filename, 'filepath', EEG.filepath);

%% select events you care about
EEGsil = pop_selectevent( EEG, 'event',2,'deleteevents','on'); % grab only events named '2'
EEGsil.setname = [basename '_event2'];
EEGsil = eeg_checkset( EEGsil );

%% save events you care about as a separate file
EEGsil.filename = [EEGsil.setname '.set'];
pop_saveset(EEGsil,'filename', EEGsil.filename, 'filepath', EEG.filepath);

%% plot channel ERPs
figure; pop_timtopo(EEG, [-199.2188       796.875], [NaN], 'ERP data'); %all electrodes on one plot
figure; pop_plottopo(EEG, [1:12] , 'setname', 0, 'ydir',1); %across head at different axes (change 1:12 to your number of channels)
clear global eegdata; 
