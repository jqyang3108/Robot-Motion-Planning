function qrand = rand_conf(O,WS)
% Function Name: 
% Generate random configurations
%=======================================
% inputs:
% -O: Cell array obstacles
% -WS: Workspace
%=======================================
% Ouputs:
% -qramd: The random configuration
%=======================================
%% Generate random configuration
pt = [ rand(1)*(max(abs(WS(1,:))));rand(1)*(max(abs(WS(2,:))))];
%% if qrand is not in the Cfree, generate again
while is_Cfree(O, pt,WS) ~= 1
	pt = [ rand(1)*(max(abs(WS(1,:))));rand(1)*(max(abs(WS(2,:))))];
end
qrand = pt;
end