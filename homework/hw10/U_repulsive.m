function urep = U_repulsive(q, CB)
% Function Name:   U_repulsive(q, CB)
% Repulsive gradient of given point
% inputs:
% -q: current point
% -CB; obstacles
%
% Ouputs:
% -urep: repulsive gradient of given point

%%
Q_star = 15; %% distance Q* that Cobs repluses 
n = 10;      %% positive sacling factor
urep = 0;

%%
for i  = 1:size(CB,2)
    obs = CB{i};    
    c_pt = ClosestPointOnPolygon(obs,q)
    rho_q = norm(c_pt-q)  
    grad_rho_q = [(q(1,1)-c_pt(1,1))/rho_q ; (q(2,1)-c_pt(2,1))/rho_q ];
     
    if rho_q > Q_star      
       grad_ui =  [0;0];
    else
       a = n*(1/Q_star - 1/rho_q)*((1/rho_q)^2);
       grad_ui = [grad_rho_q(1,1)*a ;grad_rho_q(2,1)*a];
    end      
    grad_ui = rescale_q(grad_ui);
    urep = urep+grad_ui;    
end

end