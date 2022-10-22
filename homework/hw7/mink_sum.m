function Q = mink_sum(O, A0)
% Function Name:  mink_sum(O, A0)
% Find the Minkwski Sum of O and A0
% inputs:
% -O: a cell array. Each element is a 2×n array (n: number of vertices) that contains the coordinates of the vertices of the obstacle (in CCW order).
% -type: : a 2 × m array (m: number of vertices) that contains the coordinates of vertices in A(0).

% Ouputs:
% -Q: 2*n array that contains vertices of C obstacle
%% sort vertex of A0
[miny,yindex] = min(A0(2,:));
if yindex > 1 
   A0 = [A0(:,yindex) A0(:,yindex+1:size(A0,2)) A0(:,1:yindex-1)];
elseif yindex == size(A0,2)
   A0 = [A0(:,yindex) A0(:,1:yindex-1)];
end
%%
Q = [];
remove_index = [];
i = 1;
j = 1;
m = size(A0,2);
n = size(O,2);
p = edge(O);          %%  pipi+1
a = edge(A0);     %% and ajai+1
%%
while size(Q,2) < m+n
    %% angle between edges and x-axis
    anglep = angle(p(:,i));
    anglea = angle(a(:,j));
    %%
    Q = [Q [O(:,i)+A0(:,j)]];      
    %% move to next O vertex

    if anglep < anglea
        %fprintf('\n%d p:%.2f < a:%.2f n = %d i = %d  j = %d \n',size(Q,2),anglep ,anglea,n,i,j)   
        if i<=n+1
            i = i+1;
        end
    %% move to next A0 vertex
    elseif anglep > anglea 
       %  fprintf('\n%d p:%.2f > a:%.2f i = %d  j = %d\n',size(Q,2),anglep ,anglea,i,j)    
        if j<=m+1
            j = j+1;
        end
    else
       % fprintf('\n%d p:%.2f = a:%.2f\ni =%d j =%d \n',size(Q,2),anglep ,anglea,i,j)
        if i<=n+1
            i = i+1;
        end
        if j<=m+1
            j = j+1;
        end
    end
    
    %% an+1 = a1  bm+1 = b1
    if i >n
        i = 1;
    end
    if j> m
        j = 1;
    end   
end

%% remove reduant points by removing vertex whose inner angle is greater that 180 degrees.
eq = edge(Q);
for i  =1:size(Q,2)  
    if i == size(Q,2)
        edge1 = -eq(:,i);
        edge2 = eq(:,1);
    else
        edge1 = -eq(:,i);
        edge2 = eq(:,i+1);
    end
    %% find inner angle of each vertex
    angle1 = angle([edge1(1,1);edge1(2,1)]);
    angle2 = angle([edge2(1,1);edge2(2,1)]);
    innerangle = abs(angle2-angle1);
    if innerangle>180
        innerangle = 360-innerangle;
    end
    if (angle2>=180)&&(angle2>angle1)&&(angle1>=180)
        innerangle = 360-innerangle;
    end
    %% if a vertex whose inner angle is greater that 180 degree add it to a remove to-do list
    if innerangle >= 180
        remove_index = [remove_index i+1];
    end
end
%% if there is no vertex whose inner angle is greater that 180 degree, use origin Q
if isempty(remove_index)==0
    Qout = [];
    size_Q = size(Q,2);
    %% remove vertex  whose inner angle is greater that 180 degree
    for i = 1:size(remove_index)  
        for j = 1:size_Q
            if j ~=  remove_index(i)
                Qout =[Qout Q(:,j)];
            end
        end
    end
    Q = Qout;
end
%% remove duplicated points
Q = unique(Q', 'rows', 'stable')';

%% output
Q;
end
