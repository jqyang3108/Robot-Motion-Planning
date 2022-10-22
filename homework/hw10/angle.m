function angle = angle(u)
%%
%Find angle between edge and x_axis
%inputs:
%-u:    The vector of edge

%Ouputs:
%-angle: The angle in degrees
%%
x1 = u(1,1);
x2 = 0;
y1 = u(2,1);
y2 = 0;   
angle = atan2d(y1,x1) - atan2d(y2,x2); %% become negative if angle is greater that 180 degrees
if (angle) < 0          %% Change negetive angles to positive within 0 to 2 pi
    angle = 360+angle;
end

%%
angle;
end


