function C_obs = fn_c_obstacles(O, A0, q)
%%
% Function Name:  fn_c_obstacles(O, A0, q)
% Computing C-space obstacle of given convex polygonal robotand obstacles
%inputs:
%-O:  a cell array in which each element is a 2 × n array (n: number of vertices) that
%                contains the coordinates of the vertices of the obstacle (in CCW order).

%-A0:   a 2 × m array (m: number of vertices) that contains the coordinates of vertices in
%                A(0).

%-q: robot parameter q = transpose(xt, yt, θ)
%

%Ouputs: 
%-C_obs: C-obstacles as a cell array
%%
C_obs = {};

%% move the robot configuration by parameter q
origin = [0;0];
for i = 1:size(A0,2)
    x = A0(1,i)-origin(1,1);
    y = A0(2,i)-origin(2,1);
    %%  robot rotation
    A0(1,i) =(x*cos(pi*q(3,1))-y*sin(pi*q(3,1)));
    A0(2,i) =(x*sin(pi*q(3,1))+y*cos(pi*q(3,1)));   
    %%  robot transformation
    A0(:,i)=A0(:,i)+q(1:2,1);
    %plot([q(1,1),A0(1,i)],[q(2,1),A0(2,i)],'red') %% after transformation
end
%draw_poly(A0 ,'g*');

%% sort vertex of A0
[miny,yindex] = min(A0(2,:));
if yindex > 1 
   A0 = [A0(:,yindex) A0(:,yindex+1:size(A0,2)) A0(:,1:yindex-1)];
elseif yindex == size(A0,2)
   A0 = [A0(:,yindex) A0(:,1:yindex-1)];
end

%draw_poly(-A0,'C')
%% get C obstacle bt the Minkowski Sum
for i = 1:size(O,2)
    obs = O{i};
    cbs = mink_sum(obs,-A0);
    cbs = cbs+[q(1,1);q(2,1)];  %% offset by transformation of configuration
    [k,av]=convhull(cbs','Simplify',true);
    C_obs{i} = [cbs(:,k)];
end

%% output
C_obs;
end

