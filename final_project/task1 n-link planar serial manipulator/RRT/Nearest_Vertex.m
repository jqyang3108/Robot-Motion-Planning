function [xnear,near_id] = Nearest_Vertex(xrand,V,Vid)
xnear = 0;
a = [];
n = size(V,2);
for i  =1:size(V,1)
    x = V(i,:);
    a = [a dist_angle(xrand,x)];
end
[minc,index] = min(a);
xnear = V(index,:);
near_id = index;
end

%% addtional functions 1 rad_to_deg
function deg = rad_to_deg(rad)
    deg = [];
    for i = 1:size(rad,2)
        a = rad(i)*180/pi;
        if a<0
            a = 360+a;
        end
        deg = [deg a];
        
    end
end
%% addtional functions 2 deg_to_rad
function rad = deg_to_rad(deg)
    rad = deg*pi/180;
end

