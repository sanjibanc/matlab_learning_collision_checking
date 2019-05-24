%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef (Abstract) StateLattice < handle
    %STATELATTICE An interface class for state lattice
    %contracts

    properties
    end
    
    methods (Abstract)
        state = nodeToState(self, node);
        % converts node (1xN int vector) to state (1xd)
        % d can be more than N if reduced search space
        
        node = stateToNode(self, state); 
        % converts state (1xd) to node vector
        
        traj = getEdge(self, parent_node, child_node);
        % gets traj (lxd) representing edge connecting two nodes
        % empty if invalid edge
        
        [succ_node_set, succ_edge_set] = getSuccessors(self, parent_node);
        % succ_node_set: Kx3 successor
        % succ_edge_set: K cell array each containing an edge
    end
    
end

