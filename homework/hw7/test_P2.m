clear all; close all; clc;
%%  p2
%% choose test cases
test =4;
% test case 1 distance is 1.2649
if test == 1
    A = [1 4 4 1; 1 1 4 4];
    B = [-2 0 -1  ;0 0 3];
% test case 2 distance is 2
elseif test == 2
    A = [2 5 5 2; 3 3 6 6];
    B = [0 2 2 0 ;0 0 3 3 ];
% test case 3 distance is 2.12
elseif test == 3
    A = [ 5 8 10 6 3 3;  0 1 2 4 2 1];
 	B = [-2 2 -1 ;-1 -1 2 ];
% test case 4  two polygon intersects
elseif test == 4
    A = [-1 1 4 6 2 -1; 1 0 1 2 4 2];
 	B = [-2 -1 2  ;0 3 0 ];
% test case 5 distance is 1.414
else 
    A = [ 5 8 10 6 3 3;  0 1 2 4 2 1];
 	B = [-2 2 -1  ;0 0 3];
end


%% figure 1   (two original convex polygons and their mink sum)

%% draw polygons

figure(1);
hold on;
draw_poly(A','A');
draw_poly(B','B');

S = convex_hull(A',-B');
draw_poly(S,'mink_sum')
%distance = GJKalg_2D(A,B);
%while true
    fprintf('\n===================================\n')

 distance = GJKalg_2D(A,B)

%if distance > a 
%break
%end
    fprintf('\n===================================\n')


%% draw Minkowski sum


hold off;
title('[Red: Polygon A] [Blue: Polygon B] [Greed: Minkowski Diff of A and B]')
grid on;
axis([-5 5 -5 5]);
axis equal;


%% GJK find distance and draw figure 2  (simplex,  mink diff , point p and the origin)



