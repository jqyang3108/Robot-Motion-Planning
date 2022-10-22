clear;
clc;

%%  p1
%% choose test cases

%% choose test cases
for test = 1:1:6
% test case 1 S is a single point inside polygon
if test == 1
    S = [2 2; 2 2];
    Q = [1 4 4 1; 1 1 4 4];
% test case 2 S is a single point outside polygon
elseif test == 2 
    S = [0 0 ;0 0];
    Q = [1 4 4 1; 1 1 4 4];
% test case 3 distance is 2.12
elseif test == 3
    S = [-1 -2; 1 -2];
    Q = [0 4 4 1; 2 1 4 4];
% test case 4  two polygon intersects
elseif test == 4

    S = [0 4;3 0];
    Q = [1 4 4 1; 1 1 4 4];
% test case 5 distance is 1.414
elseif test == 5
    S = [6 7; 3 5];
    Q = [1 4 4 1; 1 1 4 4];
% test case 5 distance is 1.414
else 
    S  = [3.95 4.84; 1.58 0.08];
    Q = [4 5 5 4;1 1 3 3];
end
%% test Line-Polygon
b = isintersect_linepolygon(S,Q);
if b
    text = 'intersect';
    fprintf('\n',text);
else
    text = 'not intersect';
    fprintf('\n',text);
end

%% draw
subplot(2,3,test)
hold on;
draw_poly(Q,'WS');
plot(S(1,1),S(2,1),'bo')
plot(S(1,2),S(2,2),'bx')
plot([S(1,1) S(1,2)],[S(2,1) S(2,2)],'blue')
hold off;
title(text)
grid on;
axis([-3 8 -3 8]);
axis equal;
end