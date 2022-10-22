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