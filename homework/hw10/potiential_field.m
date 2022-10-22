function out = potiential_field(qI,qG,CB)
% Function Name:  potiential_field(qI,qG,CB)
% Find the path from qI to qG by potiential field method
% inputs:
% -qI: start point
% -qG: goal point
% -CB; obstacles
%
% Ouputs:
% -out: a 2 × n array of the vertices of the path

%%
step = 5;
tolerance = .5;
grad_q = [];
%%
q = qI;
gradient = U_repulsive(q, CB)+U_attractive(q,qG);
d = q-step*gradient;
grad_q = [grad_q d];

%%
i = 0;
while norm(qG-d) >tolerance
    q = d;
    gradient = U_repulsive(q, CB)+U_attractive(q,qG);
    d = q-step*gradient;
    grad_q = [grad_q d];
    %fprintf('\nqG:%.2f d:%.2f dist:%.2f\n',qG,d,diff)
    i = i+1;
    %plot(d(1,1),d(2,1),'rx')

end
for i = 2:size(grad_q,2)
    plot([grad_q(1,i-1),grad_q(1,i)],[grad_q(2,i-1),grad_q(2,i)],'black')
end
out = grad_q;

end