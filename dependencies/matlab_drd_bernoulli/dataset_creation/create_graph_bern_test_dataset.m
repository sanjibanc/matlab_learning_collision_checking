%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Dataset
foldername = strcat(getenv('collision_checking_dataset_folder'), '/dataset_graph_bern_test_1/');
region_type = 1;
path_type = 1;
save_data = true;
num_datapoints = 100;

%% Each scenario varies the number of regions
switch region_type
    case 1
        num_paths = 100;
    case 2
        num_paths = 500;
    case 3
        num_paths = 1000;
end

%% Create graph
rng(1);
bbox = [0 1 0 1];
N = 100;

[ G, coord_set ] = rgg( bbox, N);
figure;
axis(bbox);
view_graph( G, coord_set );

%% Start and goal
[~, start_idx] = min(pdist2([0 0], coord_set), [], 2);
[~, goal_idx] = min(pdist2([1 1], coord_set), [], 2);

%% Path
path_library = [];

switch path_type
    case 1
        while (length(path_library) < num_paths)
            outcome = binornd(1, 0.5, size(G,1), size(G,2));
            Gnew = sparse(G.*outcome);
            [~, path] = graphshortestpath(Gnew, start_idx, goal_idx);
            if (~isempty(path))
                is_path_new = 1;
                for i = 1:length(path_library)
                    if (isequal(path_library{i}, path))
                        is_path_new = 0;
                        break;
                    end
                end
                if (is_path_new)
                    path_library{length(path_library)+1} = path;
                end
            end
        end
    case 2
        [~, path_library] = graphkshortestpaths(G, start_idx, goal_idx, num_paths);
end

plot_path_set( path_library, coord_set );
% %% Save stuff
% save(filename, 'G', 'bbox', 'coord_set', 'path_library');

%% Create region test
edges = find(G);
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));


region_test = false(length(path_library), length(edges));

for i = 1:length(path_library)
    path = path_library{i};
    path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
    cidx = full(edge_id_lookup(path_edges));
    region_test(i, cidx) = true;
end

%% Create outcome sets
for problem_type = 1:3
    switch problem_type
        case 1
            test_bias = 0.5*ones(1, length(edges));
            test_cost = ones(1, length(edges));
        case 2
            test_bias = 0.1 + 0.8*rand(1, length(edges));
            test_cost = ones(1, length(edges));
        case 3
            test_bias = 0.1 + 0.8*rand(1, length(edges));
            test_cost = max(0.0, transpose(full(G(edges))));
    end
    test_outcome_set = zeros(num_datapoints, length(edges));
    alive_status = zeros(num_datapoints, 1);
    count = 1;
    while (count <= num_datapoints)
        outcome = logical(binornd(1, test_bias));
        region_status = get_region_status( [], region_test, outcome );
        if (sum(region_status) == 0)
            continue;
        end
        test_outcome_set(count, :) = outcome;
        alive_status(count) = sum(region_status);
        count = count +1;
    end
    fprintf('Average alive regions %f \n', mean(alive_status));
    if (save_data)
        save(strcat(foldername, 'test_set', num2str(problem_type),'.mat'), 'test_outcome_set', 'test_bias', 'test_cost', 'region_test', 'G', 'bbox', 'coord_set', 'path_library');
        saveas(gcf, strcat(foldername, 'thumbnail.png'));
    end
end