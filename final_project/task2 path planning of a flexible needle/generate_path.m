function [end_tip, end_base,end_A0,end_uw]= generate_path(u_phi,u_w,base_pose,length,width,CB,WS)
% Function Name: generate_path(u_phi,u_w,base_pose,radius,width,CB,WS)
% Generate the path for next node
% inputs:
% -u_phi: Linear speed
% -u_w: End point of line segment
% -base_pose: Cell array obstacles
% -radius: height of triangle
% -width: width of base of triangle
% -CB: obstacles
% -WS: workspace

% Ouputs:
% -end_tip: position of tip
% -end_base: [x y theta] the body frame of current triangle
% -end_A0: three vertices of triangle
% - end_uw: angular speed for next step

end_tip = [];end_base = [];end_A0 = [];end_uw = [];
route = [-u_w u_w 0 ];
for i = 1:size(route,2)
    [tip,base,A0] = needle_pos(u_phi,route(i), base_pose,length,width,CB,WS);
    %% check if needle intersects wtih obs or boundary of WS
        end_tip = [end_tip tip];
        end_base = [end_base base];    
        end_A0 = [end_A0 A0];  
        if isempty(base) == false
        end_uw = [end_uw route(i)];
        end
end
%% end of the function
end
