function polygon = draw_poly(S,type)
% Function Name:  draw_poly(S,type)
% Find the convex hull C of two given polygons A and B
% inputs:
% -S: 2 × nA array of the coordinates of the vertices of polygon
% -type: indicates the type of graph tp be drawn (1 means polygon A, 2 means polygon B, C means simplex, and the last one means convex hull)
%
% Ouputs:
% -polygon: object polygon

[S_num_vertices,r] = size(S);
j = 1;

if type == 'A'
    dot = 'ro';
    line = 'red';
elseif type == 'B'
    dot = 'bo';
    line = 'blue';
elseif type == 'C'  %% draw simplex
    dot = 'bo';
    line = 'cyan';
else
    dot = 'g*';
    line = 'green';
end
    
while j <=S_num_vertices
   plot(S(j,1),S(j,2),dot) 
   j = j+1; 
end
[k,av] = convhull(S);
plot(S(k,1),S(k,2),line)

end
