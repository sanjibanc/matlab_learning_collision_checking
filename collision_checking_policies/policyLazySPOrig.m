%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyLazySPOrig < CollisionCheckPolicy
    %POLICYDRD Vanilla DRD method to decide which policy to collision check
    % If test world is not from train world, this policy will not guarantee
    % that it will find a path should it exist. Refer to other extended
    % policies in such case
    properties
        G
        Gplan
        start_idx
        goal_idx
        current_path_edgeids
        counter 
        checked_edgeids
    end
    
    methods
        function self = policyLazySPOrig(G, start_idx, goal_idx)
            self.G = G;
            self.Gplan = G;
            self.start_idx = start_idx;
            self.goal_idx = goal_idx;
            self.counter = 1;
            self.checked_edgeids = [];
            [~, path] = graphshortestpath(self.Gplan, self.start_idx, self.goal_idx);
            self.current_path_edgeids = get_edgeids_from_path(path, self.G);
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            self.counter = self.counter + 1;
            if (~isempty(self.current_path_edgeids) && self.counter <= 1e3)
                idx = 1;%randi(length(self.current_path_edgeids));
                edgeid = self.current_path_edgeids(idx);
                self.current_path_edgeids(idx) = [];
            else
                edgeid = []; %solved or unsolvable
            end
        end
        
        function setOutcome(self, selected_edgeid, outcome) %Interface function
            self.checked_edgeids = union(self.checked_edgeids, selected_edgeid);
            if (outcome == 0)
                selected_edge = get_edge_from_edgeid(selected_edgeid, self.G);
                self.Gplan = delete_edge(selected_edge, self.Gplan);
                [~, path] = graphshortestpath(self.Gplan, self.start_idx, self.goal_idx);
                self.current_path_edgeids = get_edgeids_from_path(path, self.G);
                self.current_path_edgeids = setdiff(self.current_path_edgeids, self.checked_edgeids);
            end
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            % plot stuff
            for edgeid = self.current_path_edgeids
             plot_edgeid( edgeid, graph, coord_set, 'y', 2 );
            end
        end
        
        function printDebug(self)
            % Print anything for debugging
        end
    end
end

