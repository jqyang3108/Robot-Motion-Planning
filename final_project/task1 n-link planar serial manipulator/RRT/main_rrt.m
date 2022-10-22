clear;
clc;
close

%% test case
root = [0;0];
CB={[-5 5 0;-12 -12 -4],[-10  -5 -5 -10; 5 5 10 10] ,[4 10 10 4;6 6 12 12]};

xmax = 20;xmin = -20;ymax= 20;ymin = -20; WS = [xmin xmax xmax xmin;ymin ymin ymax ymax];
qI = [ 0 0 0 0];
qG = [ 2.1 -0.3 6.18 -0.8 ];
length = [4 4 4 4]; 
NumNodes = 1500;
      

%% Video config
myVideo = VideoWriter('RRT'); %open video file
myVideo.FrameRate = 4;  %can adjust this
open(myVideo)
%% plot WS and OBS
hold on
grid on;
title('5-Link Serial Manipulator RRT Path Planning ')
axis([xmin xmax ymin ymax+0.5]);
axis equal;
draw_poly(WS,'WS')
qI_pos= draw_link(root,qI,length,'red','red.');
qG_pos = draw_link(root,qG,length,'blue','blue.');
for i = 1:1: size(CB,2)
    obs = CB{i};
    ps = polyshape(obs(1,:),obs(2,:));
    pobs = plot(ps);
    pobs.FaceAlpha = 1;
end

%% Find path
 [path , V, E] =build_RRT(qI , qG, NumNodes, CB,WS,length,root);
 while isempty(path) == true
      [path V, E]  =build_RRT(qI , qG, NumNodes, CB,WS,length,root);
      fprintf('\nNo path found, try again!\n')
 end
 
 %% plot
 p_arm1 = plot(0,0);
 p_arm2 = p_arm1;p_arm3 = p_arm1;p_arm4=p_arm1;p_arm5=p_arm1;pjoint = p_arm1;
for i = 1:size(path,1)    
    base_angle = joint_base_angle_convert(path(i,:));
    a = [];
    link = [];
    n = size(length,2);
    for j = 1:n
        if j == 1
            start_p = root;
            end_p = [start_p(1,1)+cos(base_angle(j))*length(j);start_p(2,1)+sin(base_angle(j))*length(j)];
        else
            start_p = end_p;
            end_p = [start_p(1,1)+cos(base_angle(j))*length(j);start_p(2,1)+sin(base_angle(j))*length(j)];
        end
        delete(pjoint);
        pjoint = plot(end_p(1,1),end_p(2,1),'blacko','MarkerSize',5); % mark end effector
        link = [link [start_p ;end_p]];  
        a = [a end_p];
    end   
    delete(p_arm1)
    delete(p_arm2)
    delete(p_arm3)
    delete(p_arm4)
    S = link;
    p_arm1=plot([S(1,1),S(3,1)],[S(2,1),S(4,1)],'black');
    p_arm2=plot([S(1,2),S(3,2)],[S(2,2),S(4,2)],'black');
    p_arm3=plot([S(1,3),S(3,3)],[S(2,3),S(4,3)],'black');
    p_arm4=plot([S(1,4),S(3,4)],[S(2,4),S(4,4)],'black');
    S = S(:,4);
    if i>1
        ppath = plot([S_old(3,1) S(3,1)],[S_old(4,1) S(4,1)],'green','LineWidth',1,'DisplayName','Path');
        if is_intersect_obs(CB, S_old(3:4,1), S(3:4,1)) == true
           text(10,25,'Warning: Path hits obstacles, please run again!')
           fprintf('\nWarning: Path may hit obstacles, please run again!\nWarning: Path may hit obstacles, please run again!\nWarning: Path may hit obstacles, please run again!\n') 
           close(myVideo)
           return
        end
    end  
     S_old = S;
    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame); 
end

%%
hold off;
close(myVideo)
fprintf('\nPath found!\n')

function base_angle = joint_base_angle_convert(joint_angle)
    n = size(joint_angle,2);
    if n == 4
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)];
    elseif n==5
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)+joint_angle(5)];   
    end
    
end
