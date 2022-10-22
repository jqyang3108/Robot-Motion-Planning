function a = is_intersect_obs(O, q0, q1)
% Function Name: 
% Check if line segment intersects with obstacles
% inputs:
% -q0: Initial point of line segment
% -q1: End point of line segment
% -O: Cell array obstacles
% Ouputs:
% -b: Binary value, true for line intersects with any obstacles and false for not

num_obs = size(O);
for i = 1:1:num_obs(2)
    obs = O{i};
    if i == 1
       a=isintersect_linepolygon([q0 q1],obs); % check for the first polygon
    end
    b = isintersect_linepolygon([q0 q1],obs);   % check for the rest of polygons
    a = a|| b;                                % intersect if intersect1||intersect2||intersect3 .... is true
end
%% 