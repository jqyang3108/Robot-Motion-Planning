 clear;
clc;
%%  test p1 RRT algorithm
%% choose test cases
for test = 1:1:4
% test case 1
if test ==1
    NumNodes = 400;
    qI = [0.5;0.5];
    qG = [2.5;4];
    delta_q = 0.2;
    Obs = {[0 2 2 0;1 1 2 2],[4 5 5 4;1 1 3 3]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
   
% test case 2 distance is 2
elseif test == 2
    NumNodes = 400;
    qI = [4.5;0.5];
    qG = [0.9;4.1];
    delta_q = 0.2;
    Obs = {[1 2 2.5 1.5 1 ;1 1 2 3 2],[1.71 3.17 2.81 1.93 1.78; 4.14 3.97 4.83 4.91 4.67],[4 5 5 4;1 1 3 3]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
% test case 3 distance is 2.12
elseif test == 3
    NumNodes = 400;
    qI = [0.5;0.5];
    qG = [2.5;4];
    delta_q = 0.2;
    Obs = {[1 2 2.5 1.5 1 ;1 1 2 3 2],[3.71 3.8 4.81 3.93 3.78; 4.14 3.97 4.83 4.91 4.67],[4 5 5 4;1 1 3 3]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
% test case 4  two polygon intersects
else 
    NumNodes = 400;
    qI = [0.5;0.5];
    qG = [4;4.8];
    delta_q = 0.2;
    Obs = {[0 2 2 0;1 1 2 2],[4 5 5 4;1 1 3 3],[1 3 3 1; 3 3 4 4]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
end

%% test RRT

%% Draw
subplot(2,2,test)
hold on;
draw_poly(workspace,'WS');
for i = 1:1: num_obs(2)
    draw_poly(Obs{i},'O');
end
plot(qI(1,1),qI(2,1),'red.','MarkerSize',20); % mark qG
plot(qG(1,1),qG(2,1),'red.','MarkerSize',20); % mark qG
[path,V,E] = build_RRT(qI , qG, NumNodes, delta_q, Obs, xmax, ymax);


%% draw vertices
num_V = size(V);
for i = 1:num_V(2)
    plot(V(1,i),V(2,i),'blacko','MarkerSize',4);
end

%% draw edges
num_E = size(E);
for i = 1:num_E(2)
    q0 = E{i}(:,1);
    q1 = E{i}(:,2);
    plot([q0(1,1) q1(1,1)],[q0(2,1) q1(2,1)],'black','LineWidth',1)
end
%% draw path
num_path = size(path);
for i = 1:num_path(2)
    plot(path(1,i),path(2,i),'g.','MarkerSize',10)
    if i~=1
        plot([path(1,i-1) path(1,i)],[path(2,i-1) path(2,i)],'red','LineWidth',3)
    end
end

hold off;
if isempty(path)
    title('out of node Test',test)
else
    title('Test',test)
end
grid on;
axis([0 xmax -0.5 ymax+0.5]);
axis equal;
end
 