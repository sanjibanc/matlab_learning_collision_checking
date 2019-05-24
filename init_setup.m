%% Set up the workspace with relevant paths 
addpath(genpath(strcat(pwd,'/utils')));
addpath(genpath(strcat(pwd,'/collision_checking_policies')));
setenv('collision_checking_dataset_folder','/Users/sanjiban/graph_collision_checking_dataset');
fprintf('\nSet collision_checking_dataset_folder to %s\n',getenv('collision_checking_dataset_folder'));

