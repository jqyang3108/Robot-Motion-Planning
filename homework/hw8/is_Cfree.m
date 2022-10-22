function is_Cfree = is_Cfree(O, pt,WS)
% Function Name: 
% Check if point is in the C free space.
% inputs:
% -O: Cell array obstacles
% -pt; Point to check
% -WS: Workspace
% Ouputs:
% -b: Binary value, true for point in Cfree and false for not


%% test if qrand in any obs : 0 for not in all obs
num_obs = size(O);
for i = 1:1:num_obs(2)
    obs = O{i};
    if i == 1
        inobs = inpolygon(pt(1,1),pt(2,1),obs(1,:),obs(2,:));
    end
    inobs = inobs||inpolygon(pt(1,1),pt(2,1),obs(1,:),obs(2,:));
end
%% test if qrand in the workspace: 1 for in the WS
in_ws = inpolygon(pt(1,1),pt(2,1),WS(1,:),WS(2,:));
%% valid if qrand in WS and qrand not in obs
is_Cfree = (inobs==0)&& (in_ws == 1); 
end