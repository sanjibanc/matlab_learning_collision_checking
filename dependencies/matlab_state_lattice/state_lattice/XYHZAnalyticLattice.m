%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef XYHZAnalyticLattice < StateLattice
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
        z_resolution
        num_heading
        z_set
    end
    
    methods
        function self = XYHZAnalyticLattice(lattice_type, radius, glide_slope, path_resolution, z_set, origin)
            self.lattice_type = lattice_type;
            self.radius = radius; %dubins issue
            self.path_resolution = path_resolution;
            self.origin = origin;
            self.z_set = z_set;
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
                case 5
                    self.xy_resolution = self.radius*0.5;
                    self.num_heading = 8;
                    self.children_set{1} = [1 0 0;
                        3 1 0;
                        3 -1 0;
                        2 1 1;
                        2 -1 7];
                    self.children_set{2} = [1 1 1;
                        2 1 0];
                    self.children_set{3} = [];
                    self.children_set{4} = [];
                    self.children_set{5} = [];
                    self.children_set{6} = [];
                    self.children_set{7} = [];
                    self.children_set{8} = [1 -1 7;
                        2 -1 0];
            end
            
            self.z_resolution = self.xy_resolution * glide_slope;
            
            for i = 1:length(self.children_set)
                start = self.nodeToState([0 0 i-1 0]);
                start(4) = [];
                children = self.children_set{i};
                for j = 1:size(children, 1)
                    goal = self.nodeToState([children(j,:) 0]);
                    goal(4) = [];
                    path = get_dubins_path( start, goal, 0.99*self.radius, self.path_resolution );
                    children_traj{j} = path;
                end
                self.children_traj_set{i} = children_traj;
            end
        end
        
        function state = nodeToState(self, node)
            % converts node (int 1x4) to state (1x4)
            state = zeros(1,4);
            state(1:2) = self.origin(1:2) + self.xy_resolution * node(1:2);
            state(3) = wrapToPi(node(3)*2*pi/self.num_heading);
            state(4) = self.origin(3) + self.z_resolution * node(4);
        end
        
        function node = stateToNode(self, state)
            % converts state (1x4) to node vector (int 1x4)
            node = zeros(1,4);
            node(1:2) = round((state(1:2) - self.origin(1:2))/self.xy_resolution);
            node(3) = mod(round( self.num_heading * wrapTo2Pi(state(3)) /(2*pi)), self.num_heading) ;
            node(4) = round((state(4) - self.origin(3))/self.z_resolution);
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
            parent_node_xyz = parent_node(1:3);
            
            succ_node_xyz = self.children_set{parent_node_xyz(3)+1};
            
            if (isempty(succ_node_xyz))
                succ_node = [];
                succ_edges = [];
                return
            end
            
            succ_node_xyz(:,1:2) = succ_node_xyz(:,1:2) + repmat(parent_node_xyz(1:2), size(succ_node_xyz,1), 1);
            succ_edges_xyz = self.children_traj_set{parent_node_xyz(3)+1};
            offset = [self.xy_resolution * parent_node_xyz(1:2) 0];
            for i = 1:length(succ_edges_xyz)
                succ_edges_xyz{i} = succ_edges_xyz{i} + repmat(offset, size(succ_edges_xyz{i},1), 1);
            end
            
            succ_node = [];
            count = 1;
            for i = 1:size(succ_node_xyz,1)
                for j = self.z_set
                    succ_node = [succ_node; succ_node_xyz(i,:) parent_node(4)+j];
                    traj_xyz = succ_edges_xyz{i};
                    traj_z = self.origin(3) + self.z_resolution*transpose(linspace(parent_node(4), parent_node(4)+j, size(traj_xyz,1)));
                    succ_edges{count} = [traj_xyz traj_z];
                    count = count + 1;
                end
            end
        end
        
        function visualize(self)
            hold on;
            cc = hsv(length(self.children_traj_set));
            for i = 1:length(self.children_traj_set)
                parent_node = [0 0 i-1 0];
                [~, succ_edges] = self.getSuccessors(parent_node);
                for j = 1:length(succ_edges)
                    traj = succ_edges{j};
                    plot3(traj(:,1), traj(:,2), traj(:,4),'Color', cc(i,:));
                end
            end
        end
    end
    
end

