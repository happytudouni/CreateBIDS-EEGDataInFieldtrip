cd '/Users/wanzexie/Downloads/EEGData/';
load 'subjectsmatrix.mat';
participantnumbers = sort(subjectsmatrix.participantnumbers);
nsubj = length(participantnumbers);

ft_defaults;

for i = 1:nsubj
    participantnumber = participantnumbers(i);
    if participantnumber < 2000 
        age = 36
    elseif participantnumber>2000 & participantnumber < 4000
        age = 6
    end
    
    cfg = [];
    cfg.method    = 'copy';
    cfg.datatype  = 'eeg';

    % specify the input file name;
    dataname = [num2str(participantnumber) '.s.1hzHighpass.set'];
    EEG = pop_loadset('filename',dataname);
    % Change the first event to onset;
    EEG.event(1).type = 'onset';
    EEG.event(1).urevent = 'onset';
    pop_saveset(EEG, 'filename',dataname);
    
    cfg.dataset   = dataname;

    % specify the output directory
    cfg.bidsroot  = 'bids';
    cfg.sub       = num2str(participantnumber);
    
    % specify the .json dataset description
    cfg.dataset_description.BIDSVersion  = "1.2";
    cfg.dataset_description.Name         = "CRYPTO and PROVIDE EEG Baseline Data";
    cfg.dataset_description.License      = "CC-BY";
    cfg.dataset_description.ReferencesAndLinks = [];

    % specify the information for the participants.tsv file
    % this is optional, you can also pass other pieces of info
    cfg.participants.age = age;
    cfg.participants.sex = [];

    % specify the information for the scans.tsv file
    % this is optional, you can also pass other pieces of info
    cfg.scans.acq_time = datestr(now, 'yyyy-mm-ddThh:MM:SS'); % according to RFC3339

    % specify some general information that will be added to the eeg.json file
    cfg.InstitutionName             = 'BCH, Harvard Medical School';
    cfg.InstitutionalDepartmentName = 'Nelson Lab';
    cfg.InstitutionAddress          = '1 Autumn Street, Boston, MA 02215, USA';

    % provide the mnemonic and long description of the task
    cfg.TaskName        = 'Baseline';
    cfg.TaskDescription = 'Subjects were watching computer screen savers. Data were filtered with [1 50] band-pass filter';

    % these are EEG specific
    cfg.eeg.PowerLineFrequency = 50;   % since recorded in Bangladesh
    cfg.eeg.EEGReference       = 'Center(Cz)'; % HGSN Net
    cfg.eeg.SoftwareFilters    = 'n/a';

    data2bids(cfg);
end