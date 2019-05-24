%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Plot dubin
clc;
clear;
close all;

%% Path
start = [1 1 0];
goal = [2 1 0];
radius = 2*0.99;
res = 0.1;

path = get_dubins_path( start, goal, radius, res );
plot(path(:,1), path(:,2));