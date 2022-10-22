% Test Cases
% Robot Motion Planning HW6 Problem 6
% Attention! cell O contains multiple obstacles!
%% Case 1
% Inputs
clear all; close all; 
% cell O contains multiple obstacles, each of which is encoded in one 
% element of the cell O!
test = 1;
for test = 1:4
 if test == 1
O = {[0,2,1;0,0,sqrt(3)],[3,5,5,3;3,3,5,5]};
A0 = 0.5.*O{1,1};
% please investigate how entries of q contribute to the C-obstacles!
% (hint: now all entries are useful)
q = [1,1,.5]';
 elseif test ==2
     O = {[0,2,1;0,0,sqrt(3)],[3,5,5,3,2;3,3,5,5,4],[-3 -2 -2.5 -4;3 3 5 5]};
    A0 = 0.5.*[-1.5 1 3 -1;-1 -1 1 1];q = [1,1,0]';
 elseif test ==3 
    O = {[0,2,1;0,0,sqrt(3)],[3,5,5,3,2;3,3,5,5,4],[-3 -2 -2.5 -4;3 3 5 5]};
    A0 = 0.5.*[-1.5 1 3 -1;-1 -1 1 1];q = [1,1,0.2]';
    
 else
    O = {[0,2,1;0,0,sqrt(3)],[3,5,5,3,2;3,3,5,5,4],[-3 -2 -2.5 -4;3 3 5 5]};
    A0 = 0.5.*[-1.5 1 3 -1;-1 -1 1 1];q = [1,2,1.7]';
 end

%%%%%%%%%%%TODO%%%%%%%%%%%%%%
% Write your own fn_c_obstacles(O,A0,q)
% Notice: do not change the function name!
[Co]= fn_c_obstacles(O,A0,q);

% Display answer and plot
disp('Cobs Solution:');
figure(1)
subplot(2,2,test)
hold on 
[row,column] = size(O);
for i = 1:row
    for j = 1:column
        o = O{i,j};
        plot([o(1,:),o(1,1)],[o(2,:),o(2,1)])
        co = Co{i,j};
        plot([co(1,:),co(1,1)],[co(2,:),co(2,1)])
        disp(co);
    end
end
axis([-1 5 -1 6]);
axis equal;
legend('Obstacle1','CObstacle1','Obstacle2','CObstacle2')
legend('location','northwest')
xlabel('x'); ylabel('y');
title('Test Case Solution ',test)
hold off
end