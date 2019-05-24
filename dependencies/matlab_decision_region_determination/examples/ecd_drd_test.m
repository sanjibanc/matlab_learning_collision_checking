%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(3); 
%% Create data
num_hyp = 1000;
num_region = 10;
num_test = 100;

% Assign regions
coord_hyp = 2*rand(num_hyp, 2) - repmat([1 1], num_hyp, 1);
coord_reg = 2*rand(num_region, 2) - repmat([1 1], num_region, 1);
[~, idx] = min(pdist2(coord_hyp, coord_reg), [], 2);
hyp_region = zeros(num_hyp, num_region);
hyp_region(sub2ind([num_hyp num_region], transpose(1:num_hyp), idx)) = 1;
col_region = hsv(num_region);

% Create tests
A = rand(num_test, 2);
A = normr(A);
b = (2*rand(num_test, 1)-1)*0.9;
hyp_test = (coord_hyp*A' - repmat(b', num_hyp, 1)) <= 0;
test_cost = ones(1, num_test);

% figure;
% axis([-1 1 -1 1]);
% hold on;
% scatter(coord_hyp(:,1), coord_hyp(:,2),10,col_region(idx));
% line([-ones(1, num_test); ones(1, num_test)], [(b + A(:,1))./A(:,2) (b - A(:,1))./A(:,2)]');

%% Lets test ECD
true_hyp = 300; % The true hypothesis known only to us

active_hyp = 1:num_hyp;

figure(2);
axis([-1 1 -1 1]);
hold on;
scatter(coord_hyp(active_hyp,1), coord_hyp(active_hyp,2),10,col_region(idx(active_hyp),:));
plot(coord_hyp(true_hyp,1), coord_hyp(true_hyp,2), 'k*');
pause;

marginal_gain_trace = [];
while (1)
    [selected_test, selected_gain, marginal_gain] = ecd_drd( active_hyp, hyp_region, hyp_test, test_cost );
    if (isempty(selected_test))
        disp('done');
        break;
    end
    
    outcome = hyp_test(true_hyp, selected_test);
    marginal_gain_trace = [marginal_gain_trace; marginal_gain];
    fprintf('Selected test: %d Gain: %f Outcome: %d\n', selected_test, selected_gain, outcome);

    active_hyp = prune_hyp( active_hyp, hyp_test, selected_test, outcome );
    
    % disp
    figure(2);
    cla;
    axis([-1 1 -1 1]);
    hold on;
    scatter(coord_hyp(active_hyp,1), coord_hyp(active_hyp,2),10,col_region(idx(active_hyp),:));
    plot(coord_hyp(true_hyp,1), coord_hyp(true_hyp,2), 'k*');
    line([-1; 1], [(b(selected_test) + A(selected_test,1))./A(selected_test,2) (b(selected_test) - A(selected_test,1))./A(selected_test,2)]','Color', 'k');
    pause;
end

