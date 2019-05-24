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


option_set = [0 1];
f_val_set = [];
epsilon_val_set = [];
for option = option_set
    marginal_gain_trace = [];
    selected_test_outcome = [];
    epsilon = f_drd_bern(  selected_test_outcome, region_test, test_bias);
    epsilon_val = [];
    f_val = epsilon^(1/100);
    while (1)
        [selected_test, selected_gain, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, option );
        if (isempty(selected_test))
            disp('done');
            break;
        end
        
        outcome = test_outcomes(selected_test);
        selected_test_outcome = [selected_test_outcome; selected_test outcome];
        fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
        
        region_status = get_region_status( selected_test_outcome, region_test, test_bias );
        epsilon = f_drd_bern(  selected_test_outcome, region_test, test_bias);
        epsilon_val =[epsilon_val; epsilon];
        f_val = [f_val epsilon^(1/100)];
        if (any(region_status == 1) || ~any(region_status > 0))
            break;
        end
    end
    epsilon_val_set{length(epsilon_val_set) + 1} = epsilon_val;
    f_val_set{length(f_val_set) + 1} = f_val;
end
figure(1);
hold on;
plot(f_val_set{1}, 'LineWidth', 2);
plot(f_val_set{2}, 'LineWidth', 2);
%plot([0; 20], [1; 1], 'm--', 'LineWidth', 2);
set(1, 'units', 'inches', 'pos', [1 10 2 1.8]);
set(gca,'FontSize',10,'Fontname','Times');
ylim([0 1])