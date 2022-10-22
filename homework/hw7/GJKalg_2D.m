function distance = GJKalg_2D(A, B)
% Function Name:  GJKalg_2D(a, b)
% The GJK algorithm
% inputs:
% -A: 2 × nA array of the coordinates of the vertices of polygon A
% -B: 2 × nB array of the coordinates of the vertices of polygon B
%
% Ouputs:
% -distance: the distance between A and B

%% Define variables
dist = 0;
%% check if two polygon intersects
for i = 1:size(A,2)
    [in,on]=inpolygon(A(1,1),A(2,1),B(1,:),B(2,:));
    if in==1 && on ==0
        fprintf('\n Two polygon intersects \n');
        break
    end
end
for i = 1:size(B,2)
    [in,on]=inpolygon(B(1,1),B(2,1),A(1,:),A(2,:));
    if in==1 && on ==0
        fprintf('\n Two polygon intersects \n');
        break
    end
end
%% randomly pick three vertices of C  
[V,C] = rand_vertex(A, B);

%% calculate the distance from p to the origin
while true
   %% Compute point P of minimum norm 
   [p, line_pair] = ClosestPointOnTriangleToPoint(V, [0;0]); % find point p   
    %% check if p on the origin
    if ((norm(p - [0;0])) ==0 )||(inpolygon(A(1,1),A(2,1),B(1,:),B(2,:)))   % if p is the origin, return      
        dist = 0;
        break;
    end
    %% find the extreme point q
    extreme_p=support_map(p, C');
    
    %% return if no more extreme point than p itself, extreme point is on the line where p locates
    if dot((line_pair(:,1)-extreme_p),(line_pair(:,2)-extreme_p)) ==0 %% if no more extreme point than p itself, vector of p and vector of q is parallel 
       dist = norm(p-[0;0]);
       break 
    end
    %% Add q and update V 
    V = [line_pair(:,1) line_pair(:,2) extreme_p];
end

%% draw
s = V';
draw_poly(s,'C')                 %% draw simplex
plot(0,0,'ro')                     % red O origin
plot(p(1,1),p(2,1),'bx')           % point P
%plot(extreme_p(1,1),extreme_p(2,1),'rx')           % red X extreme point 
plot([0 p(1,1)],[0 p(2,1)],'red') 
hold off;
title('[Red: Origin to P] [Cyan: Simplex] [Greed: Minkowski Diff of A and B]')

grid on;
axis([-5 5 -5 5]);
axis equal;
%% output
distance = dist;
end