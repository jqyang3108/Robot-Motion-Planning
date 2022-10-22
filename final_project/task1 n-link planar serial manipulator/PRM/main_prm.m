clear;
clc;
close;

%% choose test cases
    CB={[ 20 40 40 20; 34 34 45 45],[17 22 22 17 12 12; 12 14 22 28 22 14 ],[30 45 37; 14 14 25]};
    xmax = 50; xmin = 0;ymax = 50;ymin = 0;WS = [xmin xmax xmax xmin;ymin ymin ymax ymax];      
    qI = [0.1 0 0 0 0.4];
    qG = [2.7 0 0 0.4 0];    
    root = [25;25];
    length = [4 4 4 4 4];
    n= 5;
    NumNodes = 3500;
    K = 5;


%% Video config
myVideo = VideoWriter('PRM'); %open video file
myVideo.FrameRate = 8;  %can adjust this
open(myVideo)
%% plot WS and OBS
hold on
grid on;
title('5-Link Serial Manipulator PRM Path Planning ')
axis([0 xmax -0.5 ymax+0.5]);
axis equal;
draw_poly(WS,'WS')
delta_q = 1;
qI_pos= draw_link(root,qI,length,'red','red.');
qG_pos = draw_link(root,qG,length,'blue','blue.');
for i = 1:1: size(CB,2)
    obs = CB{i};
    ps = polyshape(obs(1,:),obs(2,:));
    pobs = plot(ps);
    pobs.FaceAlpha = 1;
end

[path,V,G] = build_PRM(qI,qG,NumNodes,K,CB,WS,root,length);
while isempty(path)
    [path,V,G] = build_PRM(qI,qG,NumNodes,K,CB,WS,root,length);
    fprintf('\n No path found, try again!\n');
end


 %% plot
 p_arm1 = plot(0,0);
 p_arm2 = p_arm1;p_arm3 = p_arm1;p_arm4=p_arm1;p_arm5=p_arm1;pjoint = p_arm1;
for i = 1:size(path,1)    
    base_angle = path(i,:);
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

    S = link;
    
    delete(p_arm1)
    delete(p_arm2)
    delete(p_arm3)
    delete(p_arm4)
    delete(p_arm5)
    p_arm1=plot([S(1,1),S(3,1)],[S(2,1),S(4,1)],'black');
    p_arm2=plot([S(1,2),S(3,2)],[S(2,2),S(4,2)],'black');
    p_arm3=plot([S(1,3),S(3,3)],[S(2,3),S(4,3)],'black');
    p_arm4=plot([S(1,4),S(3,4)],[S(2,4),S(4,4)],'black');
    p_arm5=plot([S(1,5),S(3,5)],[S(2,5),S(4,5)],'black');
    S = S(:,5);
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
    pause(0.005) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame); 
end

%%
hold off;
close(myVideo)
fprintf('\nPath found!\n')


