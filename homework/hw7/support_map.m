function point = support_map(p, C)
% Function Name:  support_map(C, p, num_C)
% Find the extreme point
% inputs:
% -C: n × 2 array of the coordinates of the vertices of convex hull
% -p: the coordinate of point P
% -num_C: number of vertices of the convex hull
%
% Ouputs:
% -C: n × 2 array of the coordinates of the vertices of convex hull


%% Define variables
extreme_p = [];

%% calculate the v.x for every simplex
for i = 1:size(C,2)
    extreme_p = [extreme_p dot(-p,C(:,i))];
end
%% find the max v.x
[mins, index] = max(extreme_p);
point = C(:,index);
end