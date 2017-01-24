%% Naris occlusion paper sandbox

rat_list = {'R102', 'R104', 'R053'};
%
for iRat = 1:length(rat_list)
    if isunix
        cfg.data_path = '/Users/jericcarmichael/Documents/Nairs_data';
        cd([cfg.data_path '/' rat_list{iRat}])
    else
        if strcmp(rat_list{iRat}, 'R053')
            cfg.data_path = 'G:\Naris';
        else
            cfg.data_path = 'G:\JK_recordings\Naris';
        end
        cd([cfg.data_path '/' rat_list{iRat}])
    end
    % find all the folders in the dir and then list only the data folders.
    files = dir();
    files = files([files.isdir]);
    sess_list = {};
    for ifiles = 3:length(files)
        if strcmp(files(ifiles,:).name(1:4), rat_list{iRat})
            sess_list{end+1} = files(ifiles,:).name;
        end
    end
    %%
    for iSess = 1:length(sess_list)
        if isunix
            cd([cfg.data_path '/' rat_list{iRat} '/' sess_list{iSess}])
        else
            cd([cfg.data_path '\' rat_list{iRat} '\' sess_list{iSess}])
        end
        LoadExpKeys;
        cfg.ExpKeys = ExpKeys;
        cfg.fname = sess_list{iSess};
        %%
        if strcmp(cfg.fname(1:4), 'R053') || strcmp(cfg.fname(1:4), 'R060')
            phases = {'pre', 'right', 'left', 'post'};
            proper_phases = {'pre', 'ipsi', 'contra', 'post'}; % names them properly. 

        else
            phases = {'pre', 'ipsi', 'contra', 'post'};
        end
        
        for iPhase = 1:length(phases)
            if isunix
                cd([cfg.data_path '/' rat_list{iRat} '/' sess_list{iSess} '/' sess_list{iSess} '_' phases{iPhase}])
            else
                cd([cfg.data_path '\' rat_list{iRat} '\' sess_list{iSess} '\' sess_list{iSess} '_' phases{iPhase}])
            end
            % load the data
            if strcmp(rat_list{iRat}, 'R102') || strcmp(rat_list{iRat}, 'R104')
                cell_idx = strfind(ExpKeys.Chan_to_use_labels, 'NAc');
                chan_idx = find(not(cellfun('isempty', cell_idx)));
                cfg_data.fc = ExpKeys.Chan_to_use(chan_idx);
                data = LoadCSC(cfg_data);
                evt = LoadEvents([]);
                % this section is to restrict to only the pot sections.
                idx = strfind(evt.label, 'Starting Recording');
                start_idx = find(not(cellfun('isempty', idx)));
                idx = strfind(evt.label, 'Stopping Recording');
                stop_idx = find(not(cellfun('isempty', idx)));
                
                % check to make sure NLX didn't mess up the start stop events (this happened for R104-2016-09-26_ipsi. It has 19 start times for some reason)
                if length(evt.t{start_idx}) >= 3 % should only have 2
                    [~, trk_idx]  = max(diff(evt.t{start_idx}(2:end))); % find the largest gap
                    trk_idx = trk_idx +1; % offset by one to compensate for the "diff"
                else
                    trk_idx = [];
                end
                data_r = restrict(data,evt.t{start_idx}(1),evt.t{stop_idx}(1));
                data_ampx = tsd2AMPX(data_r);
                disp(['Sampling Frequency: ' num2str(data_ampx.hdr.Fs)])
            elseif strcmp(rat_list{iRat}, 'R053')
                
                if strcmp(phases{iPhase}, 'pre') % for the pre session determine which channel to use for analyses
                    cfg_ampx.ch = 1:64;
                    ch_idx = cfg_ampx.ch(ExpKeys.BadChannels);
                    cfg_ampx.ch(ch_idx) = [];
                    cfg_ampx.df = 10;
                    if exist([cfg.fname '-pre_data.mat'], 'file')
                        load([cfg.fname '-pre_data.mat']);
                    else
                        data_temp = AMPX_loadData([strrep(cfg.fname,'_', '-') '-pre.dat'],(1:64), cfg_ampx.df);
                        save([cfg.fname '-pre_data.mat'], 'data_temp'); % save this to be loaded for speed.
                    end
                    cfg_detect = cfg_ampx;
                    cfg_detect.psd = 'normal'; % uses the standard PSD instead of the white filter option.
                    cfg_ampx.chan_to_load = AMPX_detect_best_chan(cfg_detect, data_temp, ExpKeys);
                    data_ampx = AMPX_loadData([strrep(cfg.fname,'_', '-') '-' phases{iPhase} '.dat'], cfg_ampx.chan_to_load,cfg_ampx.df);
                    cfg.chan_to_load = cfg_ampx.chan_to_load;
                else
                    % use the same channel as the other phases. 
                    data_ampx = AMPX_loadData([strrep(cfg.fname,'_', '-') '-' phases{iPhase} '.dat'], cfg_ampx.chan_to_load,cfg_ampx.df);
                end
                
            end
            % run the PSD script
            if strcmp(cfg.fname(1:4), 'R053')
                cfg.Naris_exp = proper_phases{iPhase};
            else
                cfg.Naris_exp = phases{iPhase};
            end
            cfg.gamma = [45 65; 70 90];
            naris.(cfg.Naris_exp) = Naris_fast_mod(cfg, data_ampx);
            %% collect the data in one file.
            all_naris.(rat_list{iRat}).(strrep(sess_list{iSess}, '-', '_')) = naris;
            
            naris.(cfg.Naris_exp).data_ampx = data_ampx;
            cfg = naris.(cfg.Naris_exp).cfg;

        end
        
        if isunix
            cd([cfg.data_path '/' rat_list{iRat} '/' sess_list{iSess}])
        else
            cd([cfg.data_path '\' rat_list{iRat} '\' sess_list{iSess}])
        end
        %% count the events
        cfg_count = cfg;
        cfg_count.low_gamma= [45 65];
        cfg_count.high_gamma= [70 90];

        [cfg.count_cfg, Naris_stats] = Naris_gamma_count_mod(cfg_count);
        all_stats_labels = Naris_stats.labels; 
        all_stats.(strrep(sess_list{iSess}, '-', '_')).low = Naris_stats.low;
        all_stats.(strrep(sess_list{iSess}, '-', '_')).high = Naris_stats.high;

        %%
        % make a plot of the PSD
        cfg.subnum = iPhase;
        Naris_fig = Naris_plot_mod(cfg, naris);
        close all
        %% make a spectrogram across phases
        cfg_spec = [];
%         Naris_spec_fig(cfg, naris)
        close all
        %% save the plots. and the data.
        if isfield(cfg, 'whitefilter');
            save(['White_Naris_data_' num2str(cfg.hann_win_fac) '_new'], 'naris', '-v7.3')
        else
            save(['Naris_data_' num2str(cfg.hann_win_fac)], 'naris', '-v7.3')
        end
        clear Naris_data
        clear naris
    end
end

%% get the count stats
if isfield(all_stats, 'labels')
all_stats = rmfield(all_stats, 'labels')
end
stats.count = Naris_count_stats([], all_stats);

%% get the power stats
% low gamma 40-55Hz
cfg_in = [];
cfg_in.gamma_freq = [45 65]; 
stats.power.low = Naris_power_stats(cfg_in, all_naris);
close all
% high gamma 70 -85 Hz
cfg_in = [];
cfg_in.gamma_freq = [70 90]; 
stats.power.high = Naris_power_stats(cfg_in, all_naris);