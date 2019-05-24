%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef (Abstract) CollisionCheckPolicy < handle & matlab.mixin.Copyable
    %COLLISIONCHECKPOLICY An interface class for collision checking
    %contracts

    properties
    end
    
    methods (Abstract)
        edgeid = getEdgeToCheck(self); 
        % chooses the next action
        
        setOutcome(self, selected_edge, outcome); 
        % update after new observation
        
        plotDebug2D(self, graph, coord_set, path_library);
        % plot stuff
        
        printDebug(self);
        % Print anything for debugging
    end
    
end

