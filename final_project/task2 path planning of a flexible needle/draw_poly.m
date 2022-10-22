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
    line = 'red';
    width = 0.2;
elseif type == 'L'
    dot = 'black.';   
    line = 'black';
    width = 0.5;  
    plot([S(1,1),S(1,2)],[S(2,1),S(2,2)],line,'LineWidth',width)
    
    while j <=S_num_vertices
        plot(S(1,j),S(2,j),dot) 
        j = j+1; 
    end
    
    return
 elseif type == 's'
    dot = 'blacko';   
    line = 'red';
    width = 1;  
    plot([S(1,1),S(1,2)],[S(2,1),S(2,2)],line,'LineWidth',width)
    
    while j <=S_num_vertices
        plot(S(1,j),S(2,j),dot) 
        j = j+1; 
    end
    
    return   
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
function C=convex_hull(A,B)
% Function Name:  convex_hull(A,B)
% Find the convex hull C of two given polygons A and B
% inputs:
% -A: 2 × nA array of the coordinates of the vertices of polygon A
% -B: 2 × nB array of the coordinates of the vertices of polygon B
%
% Ouputs:
% -C: n × 2 array of the coordinates of the vertices of convex hull

%% define variables
j = 1;
i = 1;
C = [];
%% create empty matrix sum for the mink sum
num_A=size(A); 
num_B=size(B);
sum=zeros(num_A(1)*num_B(1),num_A(2));
%% Get the sum of every element of A and every element of B
while i<=num_A(2)
   temp=bsxfun(@plus,A(:,i),B(:,i)');
   sum(:,i)=temp(:);
   i = i+1;
end
%% Elimite redudant points
sum=unique(sum,'rows');                     % remove dulicated points
K = unique(convhull(sum,'Simplify',true));  % remove point on the line, K is the index of vertices of the convex hull
num_K = size(K);
while j <=num_K(1)                        % Get the coordinate of vertices of the convex hull
   C = [C; sum(K(j),1) sum(K(j),2)] ;
   j = j+1; 
end
end
