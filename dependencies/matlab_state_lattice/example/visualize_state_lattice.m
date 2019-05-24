%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Visualize cells
clc;
clear;
close all;

%% Select lattice
type = 4;

switch type
    case 1
        state_lattice = XYHAnalyticLattice(1, 2.0, 0.1, [0 0]);
    case 2
        state_lattice = XYHAnalyticLattice(2, 2.0, 0.1, [0 0]);
    case 3
        state_lattice = XYHAnalyticLattice(3, 0.075, 0.01, [0 0]);
    case 4
        state_lattice = XYHZAnalyticLattice(5, 1.0, 0.1, 0.01, [0 0 0]);
end

%% Plot
figure(1);
state_lattice.visualize();
axis equal

% %%  Scratch
% state_lattice.stateToNode([10 10 -0.6*pi])