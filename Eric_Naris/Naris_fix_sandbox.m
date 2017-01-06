%% Naris occlusion paper sandbox

rat_list = {'R102', 'R104', 'R053'};
phases = {'pre', 'ipsi', 'contra', 'post'};

for iRat = 1:length(rat_list)
    if isunix
        cfg.data_path = '/Users/jericcarmichael/Documents/Nairs_data';
        cd([cfg.data_path '/' rat_list{iRat}])
    else
        cfg.data_path = '';
        cd([cfg.data_path '/' rat_list{iRat}])
    end
    sess_list = dir();
    sess_list = {sess_list(3,:).name};
    for iSess = 1:sess_list
        if isunix
            cd([cfg.data_path '/' rat_list{iRat} '/' sess_list{iSess}])
        else
            cd([cfg.data_path '/' rat_list{iRat}])
        end
        LoadExpKeys;
        cfg.fname = strrep(sess_list{iSess},'-','_');
        %%
        for iPhase = 1:length(phases)
            if isunix
                cd([cfg.data_path '/' rat_list{iRat} '/' sess_list{iSess} '/' sess_list{iSess} '_' phases{iPhase}])
            else
                cd([cfg.data_path '/' rat_list{iRat}])
            end
            % load the data
            if strcmp(rat_list{iRat}, 'R102') || strcmp(rat_list{iRat}, 'R104')
                cell_idx = strfind(ExpKeys.Chan_to_use_labels, 'NAc');
                chan_idx = find(not(cellfun('isempty', cell_idx)));
                cfg_data.fc = ExpKeys.Chan_to_use(chan_idx);
                data = LoadCSC(cfg_data);
                data_ampx = tsd2AMPX(data)
                disp(['Sampling Frequency: ' num2str(data_ampx.hdr.Fs)])
            elseif strcmp(rat_list{iRat}, 'R053')
                
            end
            % run the PSD script
            cfg.Naris_exp = phases{iPhase};
            naris.(cfg.Naris_exp) = Naris_fast_mod(cfg, data_ampx); 
             % count the events
             Naris_stats = Naris_gamma_count(

        end
        %%
            % make a plot of the PSD
            cfg = naris.(phases{iPhase}).cfg;
            cfg.subnum = iPhase;
            Naris_fig = Naris_plot_mod(cfg, naris)
            
            %% save the plots. and the data.
            if isfield(cfg, 'whitefilter');
                save(['White_Naris_data_' num2str(cfg.hann_win_fac) '_new'], 'naris', '-v7.3')
            else
                save(['Naris_data_' num2str(cfg.hann_win_fac)], 'naris', '-v7.3')
            end
    end
end

