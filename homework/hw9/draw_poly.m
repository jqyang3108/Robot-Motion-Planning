function polygon = draw_poly(S,type)
% Function Name:  draw_poly(S,type)
% Find the convex hull C of two given polygons A and B
% inputs:
% -S: 2 × nA array of the coordinates of the vertices of polygon
% -type: indicates the type of graph tp be drawn (1 means polygon A, 2 means polygon B, C means simplex, and the last one means convex hull)
%
% Ouputs:
% -polygon: object polygon
%%
[r,S_num_vertices] = size(S);
j = 1;
if type == 'P'
    dot = 'ro';
    line = 'red';
elseif type == 'WS'
    dot = 'black.';
    line = 'black';
    width = 3;
elseif type == 'O'
    dot = 'b.';
    line = 'blue';
    width = 0.2;
else
    dot = 'g*';
    line = 'green';
end
    
while j <=S_num_vertices
   plot(S(1,j),S(2,j),dot) 
   j = j+1; 
end
[k,av] = convhull(S');
plot(S(1,k),S(2,k),line,'LineWidth',width)

end
