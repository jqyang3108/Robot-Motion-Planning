function [point1 ,point2] = find_points(tip,base,width)
% Function Name: find_points(tip,base,width)
% Check if line segment intersects with obstacles
% inputs:
% -tip: tip pos
% -base: base pos
% -width: width of base of triangle
% Ouputs:
% -point1: left point 
% -point2: right point
    A = tip(1:2,1);
    a_m = base(1:2,1);
    a_mA = (A-a_m)/norm(A-a_m);
    a_mA_prime = [-a_mA(2,1);a_mA(1,1)];
    
    point1 = (width/2)*a_mA_prime+a_m;
    point2 = -(width/2)*a_mA_prime+a_m;
%% end of the function
end

