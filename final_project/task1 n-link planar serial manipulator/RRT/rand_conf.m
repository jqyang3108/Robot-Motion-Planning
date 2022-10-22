function out = rand_conf(input,length,root,WS,CB)
% Function Name:  rand_conf(S,type)
% Generate random configuration 
% inputs:
% -S: 2 × nA array of the coordinates of the vertices of polygon
% -type: indicates the type of graph tp be drawn (1 means polygon A, 2 means polygon B, C means simplex, and the last one means convex hull)
%
% Ouputs:
% -polygon: object polygon
    out = [];
    a_deg = rad_to_deg(input);
    random_angle = get_xrand(a_deg);
    [valid,end_pos_xrand] = link_Cfree_check(random_angle,length,root,WS,CB);
    while valid==false
        random_angle = get_xrand(a_deg);
        [valid,end_pos_xrand] = link_Cfree_check(random_angle,length,root,WS,CB);
    end
   
   out = random_angle;
end



%% addtional functions 1 get_qrand
function rand_angle = get_xrand(a_deg)
    n = size(a_deg,2);
    a = [];
    if n==4
        d = [360 360 360 360];     
        b = [0 0 0 0];
        for i = 1:4
            x = b(i)+(-d(i)+(2*d(i))*rand(1));
            if x<0
                x = 360+x;      
            end
            x = mod(x,360);
            a = [a x];
        end           
    elseif n==5
        d = [15 12 10 5 5];
        a = [a_deg(1)+(-d(1)+(2*d(1))*rand(1)) a_deg(2)+(-d(2)+(2*d(2))*rand(1)) a_deg(3)+(-d+(2*d(3))*rand(1)) a_deg(4)+(-d(4)+(2*d(4))*rand(1)) a_deg(5)+(-d(5)+(2*d(5))*rand(1))];
    end
    rand_angle = a; 
end
%% addtional functions 2 rad_to_deg
function deg = rad_to_deg(rad)
    deg = [];
    for i = 1:size(rad,2)
        a = rad(i)*180/pi;
        if a<0
            a = 360+a;
        end
        deg = [deg a];
        if a>360
           a= a-360; 
        end
    end
end
%% addtional functions 3 deg_to_rad
function rad = deg_to_rad(deg)
    rad = deg*pi/180;
end

