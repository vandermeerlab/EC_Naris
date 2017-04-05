%% Naris Paper Sandbox
%setup basic analyses paths
restoredefaultpath
% to vandermeerlab codebase shared functions and AMPX loading functions
addpath(genpath('D:\Users\mvdmlab\My_Documents\GitHub\vandermeerlab\code-matlab\shared'))
addpath('D:\Users\mvdmlab\My_Documents\GitHub\vandermeerlab\code-matlab\shared\io\amplipex') % give the loading AMPX functions
% add the Naris paper functions "Naris_paper" on github
addpath(genpath('D:\Users\mvdmlab\My_Documents\GitHub\EC_Naris\Naris_Paper\Naris'))
% add basic functions and circ_stats toolbox
addpath(genpath('D:\Users\mvdmlab\My_Documents\GitHub\EC_Naris\Naris_Paper\Basic_functions'))

% set up global parameters for directories to be used during analyses.  
global PARAMS
PARAMS.ft_dir ='D:\Users\mvdmlab\My_Documents\GitHub\fieldtrip';  %fieldtrip toolbox building using 
PARAMS.data_dir = 'D:\DATA\';      % where the raw data has been stored. 
PARAMS.stats_dir = 'D:\DATA\temp'; % where you would like the stats output to be saved as a .txt
PARAMS.CSD_dir = 'D:\Users\mvdmlab\My_Documents\GitHub\EC_Naris\Naris_Paper\BuzCSD';  % keep this separate until generating CSDs later on.  
PARAMS.figure_dir = 'D:\DATA\temp'; % where you would like the figures to be saved
PARAMS.intermediate_dir  = 'D:\DATA\temp'; %where to put intermediate files. 
%% list of sessions to analyze
% Session_list = {'R054-2014-10-11', 'R054-2014-10-12', 'R054-2014-10-13', 'R054-2014-10-14'};
Session_list = {'R054-2014-10-10', 'R054-2014-10-13', ...
    'R049-2014-02-07', 'R049-2014-02-08', 'R049-2014-02-10',... % 'R049-2014-02-09',...
    'R061-2014-09-26', 'R061-2014-09-27', 'R061-2014-09-28',...
    'R045-2014-04-15','R045-2014-04-16', 'R045-2014-04-17'};

type = 'pre';

%% list of sessions to analyze
% Session_list = {'R054-2014-10-11', 'R054-2014-10-12', 'R054-2014-10-13', 'R054-2014-10-14'};
Session_list = {'R049-2014-02-07', 'R049-2014-02-08', 'R049-2014-02-10',... % 'R049-2014-02-09',...
    'R045-2014-04-15','R045-2014-04-16', 'R045-2014-04-17'};

type = 'post';

%% get the task sessions
Session_list = {'R049-2014-02-07', 'R049-2014-02-08', 'R049-2014-02-10',...
    'R045-2014-04-15','R045-2014-04-16', 'R045-2014-04-17'};
type = 'task';
%% loop over each session to get: events, power, event_phase, middle cycles, cycle_phase

for iSess =1:length(Session_list)
    disp(['Running Session: ' (strrep(Session_list{iSess},'-', '_'))])
    if strcmp(type, 'pre') == 1
        all_data.(strrep(Session_list{iSess},'-', '_')) = AMPX_Naris_pipeline([Session_list{iSess}], 'session_type', type, 'plane_plot', 'yes');
    elseif strcmp(type, 'post') == 1
        all_data_post.(strrep(Session_list{iSess},'-', '_')) = AMPX_Naris_pipeline([Session_list{iSess}], 'session_type', type, 'plane_plot', 'yes');
    elseif strcmp(type, 'task') ==1
        all_data_task.(strrep(Session_list{iSess},'-', '_')) = AMPX_Naris_pipeline([Session_list{iSess}], 'session_type', type, 'plane_plot', 'yes');
    end
end

%% save the all_data struct
if strcmp(type, 'pre') == 1
    save([PARAMS.intermediate_dir '\Naris_all_data_pre.mat'], 'all_data', '-v7.3')
elseif strcmp(type, 'task') ==1
    save([PARAMS.intermediate_dir '\Naris_all_data_task.mat'], 'all_data_task', '-v7.3')
elseif strcmp(type, 'post') ==1
    save([PARAMS.intermediate_dir '\Naris_all_data_post.mat'], 'all_data_post', '-v7.3')
end


