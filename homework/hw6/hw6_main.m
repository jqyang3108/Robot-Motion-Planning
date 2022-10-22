clear all; close all; 
clc;
%% Test set 1: 
%obs_vertices = [-1 -1;1 0;0 1];
%A0_vertices = [-1 -1;1 0;0 1];

%% Test set 2: 
%obs_vertices = [8 -1; 10 -1; 10 1; 8 1];
%A0_vertices = [-1 -1;1 -1; 0 1];

%% Test set 3: two triangles 
%obs_vertices = [0 -1;1 0;0 1];
%A0_vertices = [1 -1;1 1;0 0];
%% Test set 4:  Triangle O and square A(0)
     O = {[0,2,1;0,0,sqrt(3)],[3,5,5,3,2;3,3,5,5,4],[-3 -2 -2.5 -4;3 3 5 5]};
    A0 = 0.5.*[-1.5 1 3 -1;-1 -1 1 1];q = [1,1,0]';

%% C_obs
 %C_obs = fn_c_obstacles(obs_vertices,A0_vertices,4);
%% Plot
i = 1;
axis equal
hold on
   draw_poly(A0 ,'A0');

for i = 1:size(O,2)
   
   draw_poly(O{i} ,'O');

end



%%
   C_obs = fn_c_obstacles(O, A0, q);

        

xlabel('x'); ylabel('y');
title('Test Case 1 Solution')
axis([-1 6 -1 6])
grid on
hold off
