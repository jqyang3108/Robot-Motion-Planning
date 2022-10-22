function scaled_q = rescale_q(q)
% Function Name:    rescale_q(q)
% Rescale given vector
% inputs:
% -q: current point
%
% Ouputs:
% -scaled_q: rescaled  vector
%%
scaled_q = [0;0];
x = max(abs(q(1,1)),abs(q(2,1)));
tx = 0;
while x > 1
  x = x / 10;
  tx = tx + 1;
end
%%
if (tx==2)
    scaled_q =q/100;
elseif (tx==3)
    scaled_q =q/1000;    
elseif (tx==4)
    scaled_q =q/10000;    
elseif (tx==5)
    scaled_q =q/100000;    
elseif (tx==1)
    scaled_q =q/10;        
else
    scaled_q =  q/1;
end
end