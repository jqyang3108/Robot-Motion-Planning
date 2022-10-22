function [V,C] = rand_vertex(a, b)
% Function Name:  rand_vertex(a, b)
% Randomly choose three vertices to form a simplex
% inputs:
% -A: 2 × nA array of the coordinates of the vertices of polygon A
% -B: 2 × nB array of the coordinates of the vertices of polygon B
%
% Ouputs:
% -V: 2 × 3 array of the coordinates of the vertices of simplex
% -C: n × 2 array of the coordinates of the vertices of convex hull
% -num_C: number of vertices of the convex hull

%% Define variables
V = [];
k = 1;
%% get C
%C = convex_hull(a',-b')         % get C from mink sum of a and -b
C = fn_c_obstacles(a,b,[0;0;0]);
num_C = size(C);    
%% randomly pick 3 unique indices of V
V_index = sort(randi([1,num_C(1)],1,3));         % randomly pick 3 indices of V
while size(unique(V_index)) ~= 3                 % make every element in V unique
    V_index = sort(randi([1,num_C(1)],1,3));

end
%% get V contains 3 vertices of the simplex
while k <= 3
    V = [V [C(V_index(k),1);C(V_index(k),2)]];       
    k=k+1;
end
%% draw
draw_poly(C,'mink_sum')

end
