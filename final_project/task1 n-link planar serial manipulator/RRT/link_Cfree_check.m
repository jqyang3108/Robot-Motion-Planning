function [valid, end_point] = link_Cfree_check(joint_angle,length,root,WS,CB)
    valid = false;
    n = size(joint_angle,2);
    
    line_seg = [];
    base_angle = joint_base_angle_convert(joint_angle);
    for i  = 1:n       
        l = length(i);
        if i == 1           
            p0 = root;
            p1 = [p0(1,1)+l*cos(base_angle(i));p0(2,1)+l*sin(base_angle(i))];
            line_seg = [line_seg [p0;p1]];
            % in Cfree && line no intersect
            a = (is_Cfree(CB, p1,WS)==1)&& (is_intersect_obs(CB, p0, p1)==0);
        else
            p0 = p1;
            p1 = [p0(1,1)+l*cos(base_angle(i));p0(2,1)+l*sin(base_angle(i))];
            line_seg = [line_seg [p0;p1]];  
            a = a&& (is_Cfree(CB, p1,WS)==1)&& (is_intersect_obs(CB, p0, p1)==0);
        end    
    end  
    valid = a;
    end_point = p1;
end

function base_angle = joint_base_angle_convert(joint_angle)
    n = size(joint_angle,2);
    if n == 4
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)];
    elseif n==5
        base_angle = [joint_angle(1) joint_angle(1)+joint_angle(2) joint_angle(1)+joint_angle(2)+joint_angle(3) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4) joint_angle(1)+joint_angle(2)+joint_angle(3)+joint_angle(4)+joint_angle(5)];   
    end
    
end