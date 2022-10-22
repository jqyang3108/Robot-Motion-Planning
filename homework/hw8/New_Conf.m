function qnew = New_Conf(qnear,qrand,delta_q,O, WS)
% Function Name: New_Conf
% Select a new configuration qnew by moving from qnear by the step size ∆q.
%=======================================
% inputs:
% -qnear: Point qneat
% -qrand: Random configuration
% -delta_q: Step size
% -O: Cell array obstacles
% -WS: Workspace
%=======================================
% Ouputs:
% -qnew: node qnew
%=======================================

%%
num_obs = size(O);
angle = atan2((qrand(2,1)-qnear(2,1)),(qrand(1,1)-qnear(1,1)));
qnew = [qnear(1,1)+ delta_q*cos(angle);qnear(2,1)+delta_q*sin(angle)];
a = is_Cfree(O, qnew,WS);
%b = is_intersect_obs(O,qnear,qnew);
%while (a == 0)%||(b==1)
  %  angle = atan2((qrand(2,1)-qnear(2,1)),(qrand(1,1)-qnear(1,1)));
  %  qnew = [qnear(1,1)+ delta_q*cos(angle);qnear(2,1)+delta_q*sin(angle)]
  %  a = is_Cfree(O, qnew,WS)
    %b = is_intersect_obs(O,qnear,qnew)
end

