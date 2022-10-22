function uatt = U_attractive(q, qG)
% Function Name:    U_attractive(q, qG)
% Attractive gradient of given point
% inputs:
% -q: current point
% -qG; target point
%
% Ouputs:
% -uatt: Attractive gradient of given point

%%
PG_star = 6; %% distance Q* that Cobs attracts 
n = 3;      %% positive sacling factor
rho_qG = norm(qG-q);
a = [n*(q(1,1)-qG(1,1)); n*(q(2,1)-qG(2,1))];
if rho_qG > PG_star
    uatt = a;
else
    uatt = PG_star*a/rho_qG;
end
   uatt =rescale_q(uatt); 

end