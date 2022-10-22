clear;
clc;
close

%% test case
test =1;

%% test case 1  world with 2 obscales 
if test == 1
    d = 1;
    % workspace & obstacles
	CB={[10 19 20 15 10 6;9 15 20  25  25 19 ],[30 40 40 30 25 28; 25 30 35 35 32 27]};
    xmax = 50;xmin = 0;ymax = 50;ymin = 0; WS = [0 xmax xmax 0;0 0 ymax ymax];
     
    % speed      
    radius =0.8;
    u_phi = 1;
    u_w = 30*pi/180;
    
    height  = 1.6;
    width = 1.0;
    robot_config=[height,width];
    
    % number of maximum nodes
    NumNodes = 500;

    % select targe node
    qI = [0;0;0];
    qI = [0;0;0];           
    qG1 = [35;40] ;qG2 = [10;35]; qG3 = [45;35];
    qG = qG1;
%% test case 2 world with 3 obscales 

elseif test == 2
    % workspace & obstacles
    d = 1;
	CB={[10 15  20 15 10 5;15 15 20 25 25 20] ,[25 35 35 25 20 ;30 30 35 35 32] ,[25 30 40 45 40 30 ;20 15 15 20 25 25] } ;
    xmax = 50;xmin = 0;ymax = 50;ymin = 0; WS = [0 xmax xmax 0;0 0 ymax ymax];
  
    % speed 
    radius = 0.8; 
    u_phi = 1;
    u_w = 30*pi/180;
     
    % robot configuration
    height  = 1.6;
    width = 1.0;
    robot_config=[height,width];
     
    % number of maximum nodes
    NumNodes = 500; 
     
    % select targe node
    qI = [0;0;0];           
    qG1 = [35;40]; qG2 = [30;27] ;qG3 = [48;25];
    qG = qG1;

end
%% Initialize video
myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 8;  %can adjust this, 5 - 10 works well for me
open(myVideo)

%% RRT find path 
[path, V, E,triangle_pos,u_w_out] = build_RRT(qI,qG,NumNodes, CB,WS,u_phi,u_w,radius,robot_config);
while isempty(path)==true
    [path, V, E,triangle_pos,u_w_out] = build_RRT(qI,qG,NumNodes, CB,WS,u_phi,u_w,radius,robot_config);
end
%% plot result
hold on
title('Path Planning of a Flexible Needle')
grid on;
axis([xmin xmax ymin ymax]*d );
axis equal;

draw_poly(WS,'WS');
pG = plot(qG(1,1),qG(2,1),'blue.','MarkerSize',40,'DisplayName','qG'); % mark qG
for i = 1:1: size(CB,2)
    obs = CB{i};
    ps = polyshape(obs(1,:),obs(2,:));
    pobs = plot(ps);
    pobs.FaceAlpha = 1;
end
%% draw vertices
for i = 1:size(V,2)
    %plot(V(1,i),V(2,i),'black.','MarkerSize',4,'DisplayName','vertices');
end
%% draw edges
for i = 1:size(E,2)
    q0 = E{i}(:,1);
    q1 = E{i}(:,2);
    %plot([q0(1,1) q1(1,1)],[q0(2,1) q1(2,1)],'black','LineWidth',0.2,'DisplayName','Edges');
end
%% draw path & needle trajectory
% mark needle at qI
A0_new = triangle_pos{1};
ps = polyshape(A0_new(1,:),A0_new(2,:));
pg = plot(ps);
pg.FaceAlpha = 0.9;

for i = 1:size(path,2)
    path_plot = plot(0,0);
    if i~=size(path,2)&&mod(i,5)==0
        %delete(pg);
        A0_new = triangle_pos{i};
        ps = polyshape(A0_new(1,:),A0_new(2,:));
        pg = plot(ps);
        pg.FaceAlpha = 0.1;
    end
    if i~=size(path,2)   
        if i+1>size(u_w_out,2)
           a =  size(u_w_out,2);
        else
            a = i+1;
            traj=draw_traj(u_phi*radius, u_w_out(a),path(:,i),robot_config(1));
        end
        for j = 2:size(traj,2)
            point0 = traj(:,j-1);
            point1 = traj(:,j);
            ptraj = plot([point0(1,1) point1(1,1)],[point0(2,1) point1(2,1)],'blue','LineWidth',1,'DisplayName','D');
        end
    end   
    if i~=1&&i<=size(path,2)
        path_plot = plot([path(1,i-1) path(1,i)],[path(2,i-1) path(2,i)],'red','LineWidth',0.3,'DisplayName','Path');     
    end
    
    legend('Location','southeast')
    legend([pG ptraj  path_plot pg],{'qG','Needle Trajectory','Path','Needle'})

    pause(0.005) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
  

hold off;
%% end of recording
close(myVideo)

%% draw trajectory
function [tip_pose_out]=draw_traj(linear_speed, u_w,base_pose,robot_config)
step = 10;
delta_t = 1/step;
tip_post = [];
length = robot_config(1);
tip_pos = [tip_post base_pose(1,1)+length*cos(base_pose(3,1));base_pose(2,1)+length*sin(base_pose(3,1));base_pose(3,1)]; %% postive of tip when starts
%%
for i = 1:step
        ang = base_pose(3,1);
        update_angle =  ang+u_w*delta_t;
        base_pose = [base_pose(1,1)+cos(ang)*linear_speed*delta_t;base_pose(2,1)+sin(ang)*linear_speed*delta_t;update_angle ]; %% update base pose
        tip_pos = [tip_pos [base_pose(1,1)+length*cos(base_pose(3,1));base_pose(2,1)+length*sin(base_pose(3,1));update_angle]];              
end
tip_pose_out = tip_pos(1:2,:);
end