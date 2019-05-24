%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef XYHAnalyticLattice < StateLattice
    %STATELATTICE An interface class for state lattice
    %contracts
    
    properties
        lattice_type % int
        radius
        path_resolution
        origin %1x2
        children_set %cell array
        children_traj_set %array of traj error
        xy_resolution
        num_heading
    end
    
    methods
        function self = XYHAnalyticLattice(lattice_type, radius, path_resolution, origin)
            self.lattice_type = lattice_type;
            self.radius = radius; %dubins issue
            self.path_resolution = path_resolution;
            self.origin = origin;
            
            switch self.lattice_type
                case 1
                    self.xy_resolution = self.radius;
                    self.num_heading = 4;
                    self.children_set{1} = [1 0 0;
                        1 1 1;
                        1 -1 3];
                    self.children_set{2} = [0 1 1;
                        -1 1 2;
                        1 1 0];
                    self.children_set{3} = [-1 0 2;
                        -1 -1 3;
                        -1  1 1];
                    self.children_set{4} = [0 -1 3;
                        1 -1 0;
                        -1 -1 2];
                case 2
                    self.xy_resolution = self.radius*0.5;
                    self.num_heading = 8;
                    self.children_set{1} = [1 0 0;
                        2 1 1;
                        2 -1 7];
                    self.children_set{2} = [1 1 1;
                        1 2 2;
                        2 1 0];
                    self.children_set{3} = [0 1 2;
                        -1 2 3;
                        1 2 1];
                    self.children_set{4} = [-1 1 3;
                        -2 1 4;
                        -1 2 2];
                    self.children_set{5} = [-1 0 4;
                        -2 -1 5;
                        -2 1 3];
                    self.children_set{6} = [-1 -1 5;
                        -1 -2 6;
                        -2 -1 4];
                    self.children_set{7} = [0 -1 6;
                        1 -2 7;
                        -1 -2 5];
                    self.children_set{8} = [1 -1 7;
                        2 -1 0;
                        1 -2 6];
                case 3
                    self.xy_resolution = self.radius*0.5;
                    self.num_heading = 8;
                    self.children_set{1} = [1 0 0;
                        2 1 1;
                        2 -1 7;
                        3 1 0;
                        3 -1 0];
                    self.children_set{2} = [1 1 1;
                        1 2 2;
                        2 1 0];
                    self.children_set{3} = [0 1 2;
                        -1 2 3;
                        1 2 1;
                        -1 3 2;
                        1 3 2];
                    self.children_set{4} = [-1 1 3;
                        -2 1 4;
                        -1 2 2];
                    self.children_set{5} = [-1 0 4;
                        -2 -1 5;
                        -2 1 3;
                        -3 -1 4;
                        -3 1 4];
                    self.children_set{6} = [-1 -1 5;
                        -1 -2 6;
                        -2 -1 4];
                    self.children_set{7} = [0 -1 6;
                        1 -2 7;
                        -1 -2 5;
                        1 -3 6;
                        -1 -3 6];
                    self.children_set{8} = [1 -1 7;
                        2 -1 0;
                        1 -2 6];
                case 4
                    self.xy_resolution = self.radius*0.5;
                    self.num_heading = 8;
                    self.children_set{1} = [1 0 0;
                        3 1 0;
                        3 -1 0;
                        2 2 2;
                        2 -2 6];
                    self.children_set{2} = [];
                    self.children_set{3} = [0 1 2;
                        3 3 0];
                    self.children_set{4} = [];
                    self.children_set{5} = [];
                    self.children_set{6} = [];
                    self.children_set{7} = [0 -1 6;
                        3 -3 0];
                    self.children_set{8} = [];
            end
            
            for i = 1:length(self.children_set)
                start = self.nodeToState([0 0 i-1]);
                children = self.children_set{i};
                for j = 1:size(children, 1)
                    goal = self.nodeToState(children(j,:));
                    path = get_dubins_path( start, goal, 0.99*self.radius, self.path_resolution );
                    children_traj{j} = path;
                end
                self.children_traj_set{i} = children_traj;
            end
        end
        
        function state = nodeToState(self, node)
            % converts node (int 1x3) to state (1x3)
            state = zeros(1,3);
            state(1:2) = self.origin + self.xy_resolution * node(1:2);
            state(3) = wrapToPi(node(3)*2*pi/self.num_heading);
        end
        
        function node = stateToNode(self, state)
            % converts state (1x3) to node vector (int 1x3)
            node = zeros(1,3);
            node(1:2) = round((state(1:2) - self.origin)/self.xy_resolution);
            node(3) = mod(round( self.num_heading * wrapTo2Pi(state(3)) /(2*pi)), self.num_heading) ;
        end
        
        function traj = getEdge(self, parent_node, child_node)
            % gets state_array representing edge connecting two nodes
            % empty if invalid edge
            [succ_node, succ_edges] = self.getSuccessors(parent_node);
            membership = ismember(succ_node, child_node, 'rows');
            if (any(membership))
                traj = succ_edges{membership};
            else
                traj = [];
            end
        end
        
        function [succ_node, succ_edges] = getSuccessors(self, parent_node)
            succ_node = self.children_set{parent_node(3)+1};
            succ_node(:,1:2) = succ_node(:,1:2) + repmat(parent_node(1:2), size(succ_node,1), 1);
            succ_edges = self.children_traj_set{parent_node(3)+1};
            offset = [self.xy_resolution * parent_node(1:2) 0];
            for i = 1:length(succ_edges)
                succ_edges{i} = succ_edges{i} + repmat(offset, size(succ_edges{i},1), 1);
            end
        end
        
        function visualize(self)
            hold on;
            cc = hsv(length(self.children_traj_set));
            for i = 1:length(self.children_traj_set)
                children_traj = self.children_traj_set{i};
                for j = 1:length(children_traj)
                    traj = children_traj{j};
                    plot(traj(:,1), traj(:,2), 'Color', cc(i,:));
                end
            end
        end
    end
    
end

