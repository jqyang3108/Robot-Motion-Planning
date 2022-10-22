function dist = dist_angle(angle1,angle2)
% Function Name:  dist_angle(angle1,angle2)
% Angular distance between two group of joint angles
% inputs:
% -angle1: Joint angle 1
% -angle2: Joint angle 2
% Ouputs:
% -dist: oAngular distance between two group of joint angles
for i = 1:4
   w(i) = (5-i)/10; 
end

weight = 0;
for i = 1:4
   weight = weight + w(i)*(angle1(i)-angle2(i))^2; 
end
dist = sqrt(weight);

end