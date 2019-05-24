%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function write_edge_traj_list_tofile( filename, edge_traj_list )
%WRITE_EDGE_TRAJ_LIST_TOFILE Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen(filename, 'w');
fprintf(fileID, '%d\n', length(edge_traj_list));

if ( size(edge_traj_list(1).traj,2) == 3)
    formatSpec = '%4.2f %4.2f %4.2f \n';
elseif( size(edge_traj_list(1).traj,2) == 4)
    formatSpec = '%4.2f %4.2f %4.2f %4.2f \n';
end

for i = 1:length(edge_traj_list)
    %fprintf(fileID, 'Path %d\n', i);
    fprintf(fileID, '%d\n', size(edge_traj_list(i).traj,1));
    fprintf(fileID, formatSpec, edge_traj_list(i).traj(:,1:end)');
end

