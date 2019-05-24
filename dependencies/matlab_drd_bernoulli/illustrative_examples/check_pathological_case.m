%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Problem parameters
theta_1 = 0.7;
eps_theta = 0.01;


%% Objective
obj1_set = [];
obj2_set = [];
N_set = 2:20;
for N = N_set
theta_2 = (theta_1 + eps_theta)^(1/N);
obj1 = ((1-theta_1)^3)*(1 - theta_2^N);
obj2 = (1-theta_1)*( (theta_2^3)*(1 - theta_2^(N-1)) + (1-theta_2)^3 );
obj1_set = [obj1_set obj1];
obj2_set = [obj2_set obj2];
end

figure;
hold on;
plot(N_set, obj1_set);
plot(N_set, obj2_set);
