clear;
clc;
%%  test p2 PRM algorithm
%% choose test cases
for test = 1:1:4
% test case 1 
if test == 1
    NumNodes = 50;
    qI = [3.5;0.5];
    qG = [1;4];
    delta_q = 0.3;
    Obs = {[0 2 2 0;1 1 2 2],[4 5 5 4;1 1 3 3]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    K = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
  
% test case 2 
elseif test == 2
    NumNodes = 100;
    qI = [1;0.5];
    qG = [4.9;4.5];
    delta_q = 0.5;
    Obs = {[1 2 2.5 1.5 0 ;1 1 2 3 2],[3.71 4.17 4.81 3.93 3.78; 4.14 3.97 4.83 4.91 4.67],[4 5 5 4;1 1 3 3]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    K = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
% test case 3 
elseif test == 3
    NumNodes = 100;
    qI = [3.5;0.5];
    qG = [1;4];
    delta_q = 0.3;
    Obs = {[0 2 2 0;1 1 2 2],[4 5 5 4;1 1 3 3],[1.5 2 2 1.5 1 1;3 3.2 3.7 4.1 3.7 3.2 ]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    K = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
% test case 4  
else 
    NumNodes = 100;
    qI = [1;0.5];
    qG = [1.5;4.7];
    delta_q = 0.3;
    Obs = {[0 2 2 0;1 1 2 2],[4 5 5 4;1 1 3 3],[1 3 3 1; 3 3 4 4]};
    num_obs = size(Obs);
    xmax = 5;
    ymax = 5;
    K = 5;
    workspace = [0 xmax xmax 0;0 0 ymax ymax];
end

%% Draw
subplot(2,2,test)
hold on;
plot(qI(1,1),qI(2,1),'b.','MarkerSize',20);
plot(qG(1,1),qG(2,1),'b.','MarkerSize',20);
draw_poly(workspace,'WS');
for i = 1:1: num_obs(2)
    draw_poly(Obs{i},'O');
end
[path,V,G] = build_PRM(qI,qG,NumNodes,K,Obs,xmax,ymax);



%% draw vertices
num_V = size(V);
for i = 1:num_V(2)
    plot(V(1,i),V(2,i),'blacko','MarkerSize',4);
end
%% draw edges
num_G = size(G);
map = [];
for i  = 1:num_G(2)
    for j = 1:num_G(2)
        if G(i,j)~=0
            map = [map [i;j]];
        end
    end
end
num_map = size(map);
for i = 1:num_map(2)
    q0 = V(:,map(1,i));
    q1 = V(:,map(2,i));
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
a = G;
%%
hold off;
title('Test',test)
grid on;
axis([0 xmax -0.5 ymax+0.5]);
axis equal;


end

