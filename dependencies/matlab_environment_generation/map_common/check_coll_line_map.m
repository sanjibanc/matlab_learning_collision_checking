%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function connected = check_coll_line_map( p_start, p_end, map  )
%CHECK_COLL_LINE_MAP Checks a line for collision
%   p_start: start coordinates 1x2
%   p_end: end coordinates 1x2
%   map: map struct
%   connected: 1 if free, 0 if not
c = value_line_map( p_start, p_end, map );

if (any(~c))
    connected = 0;
else
    connected = 1;
end

end

