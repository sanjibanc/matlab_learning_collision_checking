%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyDecisionTreeOnly < CollisionCheckPolicy
    %POLICYDRD Vanilla DRD method to decide which policy to collision check
    % If test world is not from train world, this policy will not guarantee
    % that it will find a path should it exist. Refer to other extended
    % policies in such case
    properties
        decision_tree
        current_node
        active_hyp
        hyp_region
        hyp_test
        test_cost
        selected_test_outcome
        region_test
        test_bias
        mixing %0 means use only prior ... 1 means use 0.5
        update_posterior
        switch_flag
        test_gain
        path_edgeid_map
    end
    
    methods
        function self = policyDecisionTreeOnly(decision_tree_data, path_edgeid_map, test_cost, mixing, update_posterior)
            self.decision_tree = decision_tree_data.decision_tree;
            self.current_node = 1;
            
            self.hyp_region = decision_tree_data.hyp_region;
            self.hyp_test = decision_tree_data.hyp_test;
            self.test_cost = test_cost;
            self.selected_test_outcome = [];
            
            self.mixing = mixing;
            self.update_posterior = update_posterior;
            self.switch_flag = false;
            self.region_test = false(length(path_edgeid_map), length(test_cost));
            for i = 1:length(path_edgeid_map)
                for e = path_edgeid_map{i}
                    self.region_test(i, e) = true;
                end
            end
            self.path_edgeid_map = path_edgeid_map;
            self.test_gain = zeros(1, size(self.hyp_test,2));
            
            current_data = get_data_from_decision_tree(self.current_node, self.decision_tree);
            self.active_hyp = current_data.active_hyp;
            
            test_count = (1/size(self.hyp_test,1))*sum(self.hyp_test(self.active_hyp,:), 1);
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, length(self.test_cost));
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            % update bias
            if (length(self.active_hyp) >= 1)
                test_count = (1/length(self.active_hyp))*sum(self.hyp_test(self.active_hyp,:), 1);
            else
                test_count = 0.5*ones(1, length(self.test_cost));
            end
            
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, length(self.test_cost));
            edgeid = [];
            if (~self.switch_flag)
                current_data = get_data_from_decision_tree(self.current_node, self.decision_tree);
                edgeid = current_data.selected_edge;
                self.test_gain = zeros(1, size(self.hyp_test,2));
            end
            if (isempty(edgeid) && ~isempty(self.active_hyp))
                self.switch_flag = true;
                %reg_idx = find(any(self.hyp_region(self.active_hyp, :), 1), 1);
                [max_mem, reg_idx] = max(sum(self.hyp_region(self.active_hyp, :), 1));
                if (max_mem == 0)
                    reg_idx = [];
                end
                if(~isempty(reg_idx))
                    candidate_edges = self.path_edgeid_map{reg_idx};
                    candidate_edges = setdiff(candidate_edges, self.selected_test_outcome(:,1)');
                    if (~isempty(candidate_edges))
                        edgeid = candidate_edges(randi(length(candidate_edges)));
                    end
                end                
            end
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            if (~self.switch_flag)
                current_data = get_data_from_decision_tree(self.current_node, self.decision_tree);
                if (selected_edge ~= current_data.selected_edge)
                    error('Went off decision tree when not expected');
                end
                if (~outcome)
                    outcome_id = 1;
                else
                    outcome_id = 2;
                end
                [child_node, child_data] = get_decision( self.decision_tree, self.current_node, outcome_id );
                self.current_node = child_node;
                if (child_node == 0)
                    self.switch_flag = true;
                end
                if (~isempty(child_data))
                    self.active_hyp = child_data.active_hyp;
                else
                    self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
                end
            elseif (self.update_posterior)
                self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            end
            self.selected_test_outcome = [self.selected_test_outcome; selected_edge outcome];
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            % plot stuff
            if (1 || ~self.switch_flag)
                edge_likelihood = self.getEdgeLikelihood();
                plot_edge_likelihood(edge_likelihood, graph, coord_set);
            else
                plot_edge_utility(self.test_gain, graph, coord_set);
            end
        end
        
        function printDebug(self)
            % Print anything for debugging
            %self.active_prob()
            self.switch_flag
        end
        
        function prob = active_prob(self)
            prob = length(self.active_hyp)/size(self.hyp_region,1);
        end
        
        function edge_likelihood = getEdgeLikelihood(self)
            edge_likelihood = (1/length(self.active_hyp))*sum(self.hyp_test(self.active_hyp, :),1);
        end
        
    end
    
end
