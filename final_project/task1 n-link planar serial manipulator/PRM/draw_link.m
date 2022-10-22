function out = draw_link(root,joint_angle,length,color,endcolor)
% Function Name:  draw_link(root,joint_angle,length,color,endcolor)
% Find the convex hull C of two given polygons A and B
% inputs:
% -root: 2x1 postion of proximal end
% -joint_angle: nx1 joints angles in radian
% -length: nx1 length of each link
% -color: color of link
% -endcolor: color of end effector

% Ouputs:
% -out: position of end effector
%%
a = [];
link = [];
n = size(length,2);
%% transfer from joint angle to angle with x axis
base_angle = joint_base_angle_convert(joint_angle);
%% find pos of each joint
for i = 1:n
    if i == 1
        start_p = root;
        end_p = [start_p(1,1)+cos(base_angle(i))*length(i);start_p(2,1)+sin(base_angle(i))*length(i)];
    else
        start_p = end_p;
        end_p = [start_p(1,1)+cos(base_angle(i))*length(i);start_p(2,1)+sin(base_angle(i))*length(i)];
    end
    link = [link [start_p ;end_p]];  
    a = [a end_p];
end
%% plot links
for i  =1:size(link,2)
    S = link(:,i);
    p1=plot([S(1,1),S(3,1)],[S(2,1),S(4,1)],color);
    
end
plot(end_p(1,1),end_p(2,1),endcolor,'MarkerSize',10); % mark end effector
out = end_p;


end
function base_angle = joint_base_angle_convert(joint_angle)
    n = size(joint_angle,2);
    if n == 4
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)];
    elseif n==5
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)+joint_angle(5)];   
    end
    
end