%% Naris Oclusion sandbox
Naris.R053.sessions = {'R053-2014-12-27', 'R053-2014-12-28', 'R053-2014-12-30', 'R053-2014-12-31'};
Naris.R054.sessions = {'R054-2014-12-06', 'R054-2014-12-07', 'R054-2014-12-09', 'R054-2014-12-10'};
% Naris.R060.session_list = {'R053-2014-12-27', 'R053-2014-12-28', 'R053-2014-12-30', 'R053-2014-12-31'};

ids = fieldnames(Naris)

%%
for id = 3:length(ids)
    for iSess = 1%:length(Naris.(ids{id}).sessions)
        cd(['/Users/jericcarmichael/Documents/Nairs_data/' Naris.(ids{id}).sessions{iSess}])
        if iSess ==1
            cfg = [];
            [Naris.(ids{id}).data.(strrep(Naris.(ids{id}).sessions{iSess}, '-', '_')) , cfg] = Naris_fast([]);
            chan_to_use = cfg.tetrodes;
            cfg = [];
%             close all
        else
            cfg = [];
            cfg.tetrode = chan_to_use;
            [Naris.(ids{id}).data.(strrep(Naris.(ids{id}).sessions{iSess}, '-', '_')) , cfg] = Naris_fast([]);
            cfg = [];
%             close all
        end
    end
end