clc;
clear;
close all;

%% World
rng(2);
num_worlds = 1000;
dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_7/');
env_dataset = strcat(dataset,'environments/');


%% Create world
idx = randperm(num_worlds, 4);
for i = 1:4
    subplot(2,2,i)
    filename = strcat(env_dataset, 'world_',num2str(idx(i)),'.mat');
    load(filename, 'map');
    visualize_map(map);
end
saveas(gcf, strcat(dataset,'/thumbnail.png'));