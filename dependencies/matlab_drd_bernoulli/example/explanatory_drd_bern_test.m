%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);

if(0)
    %% Create data
    num_region = 1000;
    num_test = 100;
    num_test_in_region = 5;
    
    % Assign ground truth
    test_bias = 0.5*ones(1, num_test);
    test_cost = ones(1, num_test);
    
    region_test = false(num_region, num_test);
    for i = 1:num_region
        region_test(i, randperm(num_test, num_test_in_region)) = true;
    end
    
    test_outcomes = logical(binornd(1, test_bias));
    %region_status = get_region_status( [1:num_test; test_outcomes]', region_test, ones(1, num_test) );
end
if(0)
    region_test = logical([1 1 1 0 0 0;
        0 0 0 1 1 1]);
    test_bias = [0.8 0.8 0.8 0.8 0.8 0.8];
    test_cost = ones(1, 6);
    test_outcomes = logical([1 1 1 1 1 1]);
end
if(0)
    region_test = logical([1 1 0 0 0;
        0 0 1 0 1;
        0 0 0 1 1]);
    test_bias = [0.3 0.3 0.8 0.8 0.8];
    test_cost = ones(1, 5);
    test_outcomes = logical([1 1 1 1 1]);
end
if(0)
    region_test = logical([ 1 1 1 0 0 0;
                            0 1 1 1 0 0;
                            0 0 1 0 1 1]);
    test_bias = [0.8 0.8 0.8 0.8 0.8 0.9];
    test_cost = ones(1, 6);
    test_outcomes = logical([0 1 1 0 1 1]);
end
if(1)
    theta_1 = 0.5;
    eps_theta = 0.01;
    N = 10;
    theta_2 = (theta_1 + eps_theta)^(1/N);
    region_test = logical([1 zeros(1, N);
        0 ones(1, N)]);
    test_bias = [theta_1 theta_2*ones(1,N)];
    test_cost = ones(1, N+1);
    test_outcomes = logical(binornd(1, test_bias));
end

marginal_gain_trace = [];
selected_test_outcome = [];
val_trace = [];
while (1)
    [selected_test, selected_gain, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 );
    if (isempty(selected_test))
        disp('done');
        break;
    end
    
    outcome = test_outcomes(selected_test);
    selected_test_outcome = [selected_test_outcome; selected_test outcome];
    fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
    
%     figure(1);
%     region_status = get_region_status( selected_test_outcome, region_test, test_bias );
%     bar(region_status);
%     ylim([0 1]);
%     pause;
    
%     marginal_gain_trace = [marginal_gain_trace; marginal_gain];
%     
%     val = f_drd_bern(  selected_test_outcome, region_test, test_bias);
%     val_trace = [val_trace; val];
end

%%
% any(any(marginal_gain_trace < 0))
% any(any(diff(marginal_gain_trace) > 0))

%% 

