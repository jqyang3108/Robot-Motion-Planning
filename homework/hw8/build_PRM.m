function [path, V, G] = build_PRM(qI,qG,NumNodes,K,O,xmax,ymax)
% Function Name: build_PRM
% get vertices, edges of the graph and find the shortest path from qI to qG
%=======================================
% inputs:
% -qI: 1x2 matrix coordinates of the initial point
% -qG: 1x2 matrix coordinates of the goal point
% -K: Number of nearest nieghbors
% -NumNodes: Number of node of the map
% -O: Cell array obstacles
% -xmax: Maxmimum size of x in a 2D square box of workspace
% -ymax: Maxmimum size of y in a 2D square box of workspace
%=======================================
% Ouputs:
% -path: 2xN path connecting qI and qG
% -V: The set of vertices V 
% -G: The weighted adjacency matrix G

%%
WS = [0 xmax xmax 0;0 0 ymax ymax];
path = [];
%% test input
if (is_Cfree(O, qI,WS)==0)
   fprintf('\nError: qI is not in C free! Check your qI ') ;
   return;
elseif (is_Cfree(O, qG,WS)==0)
   fprintf('\nError: qG is not in C free! Check your qG ') ;
   return;
end

%% get path
[P,V,G,Vcurrent_set,qprime_set] = PRM_Path(qI,qG,NumNodes,K,O,WS);
num_path = size(P);
% if path intersect with obs or did not reach qG, run again
while isempty(P)||(P(num_path(2))~= NumNodes)
   [P,V,G,Vcurrent_set,qprime_set] = PRM_Path(qI,qG,NumNodes,K,O,WS);
   num_path = size(P);
end
for i = 1:num_path(2)
    path = [path V(:,P(i))];
end
%% plot
%{
% plot the path
for i = 1:num_path(2)
    if i~=1
        %plot([V(1,P(i-1)) V(1,P(i))],[V(2,P(i-1)) V(2,P(i))],'green','LineWidth',3)
    end
end
% plot line between nodes
num = size(Vcurrent_set);
for i = 1:num(2)
   %plot([Vcurrent_set(1,i) qprime_set(1,i)],[Vcurrent_set(2,i) qprime_set(2,i)],'black') 
end
%}
%% output
path = [path qG];
end
