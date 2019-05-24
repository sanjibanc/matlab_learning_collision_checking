%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ DIST, PATH ] = graphkshortestpaths( G, S, T, K )
%
% [ DIST, PATH ] = graphkshortestpaths( G, S, T, K ) determines the K shortest paths from node S
% to node T. weights of the edges are all positive entries in the n-by-n adjacency matrix
% represented by the sparse matrix G. DIST are the K distances from S to T; PATH is a cell array
% with the K shortest paths themselves.
%
% the shortest path algorithm used is Dijkstra's algorithm (graphshortestpath).
%
% **Please note that the algorithm implemented here is an undirected version of Yen's algorithm**
%
% - Yen, JY. Finding the k shortest loopless paths in a network; Management Science 17(11):712-6.
%
% 03/01/2013: I would like to thank Oskar Blom Göransson for helping me find a bug in the previous version.

% find A^1
[ DIST( 1 ), PATH{1} ] = graphshortestpath( G, S, T );

candidate_paths = { }; % list of candidate paths
candidate_dists = [ ]; % distance of each candidate path

% find A^2 ... A^K
for k = 2:K
	k_G = G; % version of G used in this iteration (some edges will be removed)

	% for each node travelled in A^{k-1}
	for i = 1:( length( PATH{k-1} ) - 1 )
		i_node = PATH{k-1}( i );

		% iterate over all previous paths and examine if 1..i overlaps with A^{k-1}
		for j = 1:k-1
			if( length( PATH{j} ) >= i & ( all( PATH{j}( 1:i ) == PATH{k-1}( 1:i ) ) ) )
				% it does; remove the following edge that appears in A^j
				j_next_node = PATH{j}( i+1 );
				k_G( i_node, j_next_node ) = 0; k_G( j_next_node, i_node ) = 0;
			end
		end

		% calculate shortest path from i to T
		[ dist_i_t, path_i_t ] = graphshortestpath( k_G, i_node, T );
		% if path exists, concatenate with 1..i-1 and add to candidates list
		if( dist_i_t < Inf )
			path_1_i_t = [ PATH{k-1}( 1:i-1 ) path_i_t ];
			dist_1_i_t = graphpathdistance( G, path_1_i_t ); % we can safely use G- removed
									 % edges will not appear
			% add resulting path to candidates list
			candidate_paths{end+1} = path_1_i_t;
			candidate_dists( end+1 ) = dist_1_i_t;
		end
	end

	% no candidates; all shortest paths found
	if( isempty( candidate_dists ) )
		return
	end

	% take shortest path from candidates list as kth path
	[ y, i ] = sort( candidate_dists );
	DIST( k ) = candidate_dists( i( 1 ) );
	PATH{k} = candidate_paths{i( 1 )};
	% remove shortest path (and all of its copies) from the candidates list
	remove_indices = [];
	for idx = 1:length( candidate_paths )
		if( length( PATH{k} ) == length( candidate_paths{idx} ) & all( PATH{k} == candidate_paths{idx} ) )
			remove_indices( end+1 ) = idx;
		end
	end
	candidate_dists( remove_indices ) = [];
	candidate_paths( remove_indices ) = [];
end


	function DIST = graphpathdistance( G, PATH )
	%
	% DIST = graphpathdistance( PATH ) calculates the distance travelled by PATH in graph G.

	% convert PATH into edges
	edges = sub2ind( size( G ), PATH( 1:end-1 ), PATH( 2:end ) );
	% sum weights over edges
	DIST = full( sum( G( edges ) ) );


