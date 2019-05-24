%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
load illustrative_histogram_resource.mat;

region_status = get_region_status( [], region_test, test_bias );
[~,i] = sort(region_status, 'descend');
i(31:end) = [];
region_status_set = region_status(i)';

marginal_gain_trace = [];
selected_test_outcome = [];
while (1)
    [selected_test, selected_gain, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 1 );
    if (isempty(selected_test))
        disp('done');
        break;
    end
    
    outcome = test_outcomes(selected_test);
    selected_test_outcome = [selected_test_outcome; selected_test outcome];
    fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
    
    region_status = get_region_status( selected_test_outcome, region_test, test_bias );
    region_status_set = [region_status_set; region_status(i)'];
    if (any(region_status == 1) || ~any(region_status > 0))
        break;
    end
    
    [~, max_prob_reg_idx] = max(region_status);
    fprintf('Most porbable region %d \n', find(i == max_prob_reg_idx));
end

figure(1);
region_status_set(region_status_set == 0) = 1e-3;
b = bar(region_status_set(:, 1:4)', 'EdgeColor', 'none');
b(1).BaseValue = 0.01;
set(gca, 'YScale', 'log');
colorbar;
xlim([0.5 4.5]);
set(1, 'units', 'inches', 'pos', [1 10 4 1.8]);
set(gca,'FontSize',10,'Fontname','Times')
