function [out, node] = FindIntersections(S,CB)
% Function Name: 
% Find all the intersection points of sweep lines with obs
%=======================================
% inputs:
% -S: A set of line segments in the plane
% -CB:  Obstacles
%=======================================
% Ouputs:
% -Q: The set of intersection points among the segments in S, with for each intersection point the segments that contain it.
% -node: Midpoint of every line segment which is a possible node of the path
%=======================================
%%
j = 2;
start_point = [];
end_point = [];
node = [];
left_end_line_seg = {};
right_end_line_seg = {};
out = {};
xmin = S{1}(1,1);
xmax = S{3}(1,1);
ymin = S{1}(1,2);
ymax = S{3}(1,2);
%% insert the segment endpoints into Q; 
for i = 1:size(S,2)
    end_point = [end_point S{i}(2,:)'];
end
sort(end_point(1,:),2);
xy = sortrows([end_point(1,:);end_point(2,:)].',1).';
end_point = [sort(end_point(1,:),2); xy(2,:)];

%%  when a left endpoint is inserted, the corresponding segment should be stored with it.
for i = 1:size(S,2)
    a = end_point(:,i);
    for j = 1:size(S,2)
        if a == S{j}(2,:)'
            start_point = [start_point S{j}(1,:)'];
        end
    end  
    if start_point(1,i) > end_point(1,i)
        x = start_point(:,i)';
        y = end_point(:,i)';
        left_end_line_seg = [left_end_line_seg, {[x;y]}];
    elseif start_point(1,i) < end_point(1,i)
        x = start_point(:,i)';
        y = end_point(:,i)';
        right_end_line_seg = [right_end_line_seg, {[x;y]}];
    end
end

%% leave space for the most left and right vertical sweep lines
Q = unique(end_point(1,:));
Q(1) = [];
Q(size(Q,2)) = [];

%% Find all the intersection points of each sweep line
while isempty(Q)==0
    p = Q(1) ;    %%event point p
    Q(:,1) = [] ;
    [R,L,C] = HandleEventPoint(p,left_end_line_seg,right_end_line_seg,S);
    pt = [];
   %% intersection point of interior endpoints
    for i = 1:size(C,2)
        slope = (C{i}(2,2)-C{i}(1,2))/(C{i}(2,1)-C{i}(1,1));
        if (slope == Inf)||(slope == -Inf)
            pt = [pt ;[p C{i}(2,2)]];
        else
            pt = [pt ;[p C{i}(1,2)+slope*(p-C{i}(1,1))]];
        end
    end
    %% intersection point of right endpoints
    for i = 1:size(R,2)
        pt = [pt; R{i}(2,:)];
    end
    %% intersection point of left endpoints
    for i = 1:size(L,2)
        pt = [pt; L{i}(2,:)];
    end
    
    %% sort all the intersection from top to bottom
    pt = [[p ymin];pt;[p ymax]];
    pt = sort(pt',2,'descend');  
    num_intersect = size(pt);
    a = [];
    %% find midpoints node of all the line segments between intersection points
    for i = 2:num_intersect(2)
        if is_intersect_obs(CB, pt(:,i-1)', pt(:,i)') ==0
            x = pt(1,i);
            y = (pt(2,i)+ pt(2,i-1))/2;
        end
        a = [a ;[x y]];
        node = [node [x;y]];
    end    
    a = [[p j];sort(unique(a,'rows'),1,'descend')];
    out = [out {a}];
    j = j+1;
end
%% output
out = [{[xmin 1;xmin (ymax+ymin)/2]}  ,out,{[xmax j;xmax (ymax+ymin)/2]}];
node = [[xmin;(ymax+ymin)/2]  unique(node','rows')' [xmax;(ymax+ymin)/2]];
%% plot 
%{
num = size(left_end_line_seg);
for i = 1:num(2)
   
a = left_end_line_seg{i}(1,:);
b = left_end_line_seg{i}(2,:);
plot([a(1,1) b(1,1)],[a(1,2) b(1,2)],'b','LineWidth',3)

end
num = size(right_end_line_seg);
for i = 1:num(2)
a = right_end_line_seg{i}(1,:);
b = right_end_line_seg{i}(2,:);
plot([a(1,1) b(1,1)],[a(1,2) b(1,2)],'b','LineWidth',3)
end
%}
end