%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
region_test = logical([1 1 0 0 0;
    0 0 1 0 1;
    0 0 0 1 1]);
test_bias = [0.8 0.7 0.8 0.8 0.6];
%test_bias = [0.8 0.7 0.8 0.8 0.3];

test_cost = ones(1, 5);
test_outcomes = logical([1 0 1 1 1]);

marginal_gain_trace = [];
selected_test_outcome = [];
while (1)
    [selected_test, selected_gain, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 );
    if (isempty(selected_test))
        disp('done');
        break;
    end
    marginal_gain
    outcome = test_outcomes(selected_test);
    selected_test_outcome = [selected_test_outcome; selected_test outcome];
    fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
end