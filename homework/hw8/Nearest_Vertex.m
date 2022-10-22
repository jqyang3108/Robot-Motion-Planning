function [qnew,index] =  Nearest_Vertex(qrand, G)
% Function Name: 
% Find a nearest node qnear in G to qrand. Initially, the nearest node is qinit.
%=======================================
% inputs:
% -qrand: Random configuration
% -G: Array of all nodes q
%=======================================
% Ouputs:
% -qnew: qnew node
% -index: Index of the qnear in G
%=======================================

%%
d = inf;
num = size(G);
for i = 1:num(2)
    vi = G(:,i);
    if norm(qrand-vi) < d
        vnew = vi;
        d = norm(qrand-vi);
    end
end
%% output
qnew = vnew;
index = i;
end