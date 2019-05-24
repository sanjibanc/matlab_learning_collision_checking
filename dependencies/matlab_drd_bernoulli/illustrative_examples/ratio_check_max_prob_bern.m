%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
data = 1;

switch data
    case 1
        load illustrative_histogram_resource.mat;
    case 2
        region_test = logical([1 0;
                        repmat([0 1], 200, 1)]);
        test_cost = [1 1];
        test_bias = [0.01 0.00999];
        test_outcomes = logical([1 0]);
    case 3
        A =[1 0;
            repmat([0 1], 10, 1)];
        B = [zeros(1, 10); eye(10)];
        region_test = logical([A B]);
        test_cost = ones(1, size(region_test,2));
        test_bias = [0.01 0.5 0.01*ones(1,10)];
        test_outcomes = logical([1 0 zeros(1,10)]);
    case 4
        A = [ones(100, 1); 0];
        B = zeros(size(A,1), 100);
        B(end,:) = 1;
        region_test = logical([A B]);
        test_cost = ones(1, size(region_test,2));
        test_bias = [0.09 0.9772*ones(1, size(B,2))];
        test_outcomes = logical([0 ones(1, size(B,2))]);
end

ratio_set = [];
selected_test_outcome = [];
while (1)
    [selected_test_orig, ~, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 );
    [selected_test] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 1 );

    if (isempty(selected_test))
        disp('done');
        break;
    end
    
    outcome = test_outcomes(selected_test);
    
    test_bias_init = test_bias;
    if (~isempty(selected_test_outcome))
        test_bias_init(selected_test_outcome(:,1)) = selected_test_outcome(:,2)';
    end
    val1 = 1;
    for i = 1:size(region_test,1)
        reg_val = (1 - prod(test_bias_init(region_test(i,:))));
        val1 = val1*reg_val;
    end
    
    selected_test_outcome = [selected_test_outcome; selected_test outcome];
    fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
    
    ratio = marginal_gain(selected_test_orig) / marginal_gain(selected_test)
    ratio2 = val1 / marginal_gain(selected_test)
    pause
    
    region_status = get_region_status( selected_test_outcome, region_test, test_bias );
    if (any(region_status == 1) || ~any(region_status > 0))
        break;
    end
end
