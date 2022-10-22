function out = draw_link(root,joint_angle,length,color,endcolor)
% Function Name:  draw_link(root,joint_angle,length,color,endcolor)
% draw serial manipulator
% inputs:
% -S: 2 × nA array of the coordinates of the vertices of polygon
% -type: indicates the type of graph tp be drawn (1 means polygon A, 2 means polygon B, C means simplex, and the last one means convex hull)
%
% Ouputs:
% -polygon: object polygon
a = [];
link = [];
n = size(joint_angle,2);
base_angle = joint_base_angle_convert(joint_angle);
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

for i  =1:size(link,2)
    S = link(:,i);
    p1=plot([S(1,1),S(3,1)],[S(2,1),S(4,1)],color);
    
end
plot(end_p(1,1),end_p(2,1),endcolor,'MarkerSize',15); % mark end effector

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