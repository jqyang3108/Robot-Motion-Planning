function xnew =  find_xnew(xnear,xrand,length,root,WS,CB)
% Function Name: rad_to_deg
% generate xnew for the next node
%======================================
% inputs:
% -xnear: joint angle of xnear
% -xrand: joint angle of xrand
% -length: length of links
% -root: proximal end
% -WS: workspace
% -CB: Obstacles
%=======================================
% Ouputs:
% -xnew: joint angle of xnew

%% generate n random joint angles around xnear
xnew_cand = [];
for i = 1:10
    a = random_xnew(xnear);
    [valid,end_pos_xrand] = link_Cfree_check(a,length,root,WS,CB);
    while valid == false
        a = random_xnew(xnear);
        [valid,end_pos_xrand] = link_Cfree_check(a,length,root,WS,CB);  
    end
    %draw_link(root,a,length,'black','black.'); % plot xnew
    xnew_cand = [xnew_cand ;a];
end
%% find the nearest to xnear
xnew = Nearest_Vertex(xrand,xnew_cand);
%draw_link(root,xnew,length,'black','black.'); % plot xnew

end

%% Add 1
function rand_angle = random_xnew(xnear_deg)
        d = [15 15 15 20];     
        change_1 = randi([-d(1),d(1)]);
        change_2 = randi([-d(2),d(2)]);
        change_3 = randi([-d(3),d(3)]);
        change_4 = randi([-d(4),d(4)]);
        x_new_cand = xnear_deg+[change_1 change_2 change_3 change_4]; 
        dista = dist_angle(xnear_deg,x_new_cand);    
        while dista>45||dista<10
            change_1 = randi([-d(1),d(1)]);
            change_2 = randi([-d(2),d(2)]);
            change_3 = randi([-d(3),d(3)]);
            change_4 = randi([-d(4),d(4)]); 
            change = [change_1 change_2 change_3 change_4];
            x_new_cand = xnear_deg+change; 
            dista = dist_angle(xnear_deg,x_new_cand);
        end       
        a = x_new_cand;
        rand_angle = deg_to_rad(a);   
end
%% Add 2
function rad = deg_to_rad(deg)
% Function Name: rad_to_deg
% convert degree to radian
%======================================
% inputs:
% -deg: angle in deg
%=======================================
% Ouputs:
% -rad: angle in rad
    rad = deg*pi/180;
end
