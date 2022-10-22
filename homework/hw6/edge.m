function out = edge(vertex)
%%
%Get the edges of polygon by given vertices
%inputs:
%-vertex: Vertices of given polygon

%Ouputs:
%-out: Edges 
%%
out = [];
for i = 2:size(vertex,2)
    out = [out [(vertex(1,i) - vertex(1,i-1)) ; (vertex(2,i) - vertex(2,i-1))]];
end
out = [out [(vertex(1,1)-vertex(1,i) ) ; (vertex(2,1) - vertex(2,i))]];