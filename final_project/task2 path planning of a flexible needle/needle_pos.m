function [tip_pose_out, base_pose_out,A0]= needle_pos(u_phi, u_w,base_pose,radius,width,CB,WS)
% Function Name: generate_path(u_phi,u_w,base_pose,radius,width,CB,WS)
% generate the postion and orientation for needle
% inputs:
% -u_phi: Linear speed
% -u_w: End point of line segment
% -base_pose: Cell array obstacles
% -radius: height of triangle
% -width: width of base of triangle
% -CB: obstacles
% -WS: workspace

% Ouputs:
% -tip_pose_out: position of tip
% -base_pose_out: [x y theta] the body frame of current triangle
% -A0: three vertices of triangle
%% divide part in n part, calculate the path in discrete time
step = 10;
delta_t = 1/step;
tip_post = [];
tip_pos = [tip_post base_pose(1,1)+radius*cos(base_pose(3,1));base_pose(2,1)+radius*sin(base_pose(3,1));base_pose(3,1)]; %% postive of tip when starts
[left_p,right_p ]=find_points(tip_pos(1:2,1),base_pose,width);
A0 = [ left_p tip_pos(1:2,1) right_p];
%% calculate path in each discret time inverval
for i = 1:step
        ang = base_pose(3,1);
        update_angle =  ang+u_w*delta_t;
        base_pose = [base_pose(1,1)+cos(ang)*u_phi*delta_t;base_pose(2,1)+sin(ang)*u_phi*delta_t;update_angle ]; %% update base pose
        tip_pos = [tip_pos [base_pose(1,1)+radius*cos(base_pose(3,1));base_pose(2,1)+radius*sin(base_pose(3,1));update_angle]];
        [left_p,right_p ]=find_points(tip_pos(1:2,i+1),base_pose,width);
        A0 = [ left_p tip_pos(1:2,i+1) right_p];
        if check_collision(A0,CB,WS,tip_pos(1:2,i+1)) == true
            tip_pose_out = [];
            base_pose_out = [];
            A0 = [];
            return
        end           
end

%% find three vertices
A0 = [ left_p tip_pos(1:2,i+1) right_p];
[miny,yindex] = min(A0(2,:));
%% rearrange the lower left corner
if yindex > 1 
   A0 = [A0(:,yindex) A0(:,yindex+1:size(A0,2)) A0(:,1:yindex-1)];
elseif yindex == size(A0,2)
   A0 = [A0(:,yindex) A0(:,1:yindex-1)];
end
tip_pose_out = tip_pos(:,size(tip_pos,2));
base_pose_out = base_pose;
%% end of the function
end
%%
function a = is_poly_intersect(poly1,poly2)
    a = false;
    for i = 1:size(poly1,2)
        if i>1
         a=isintersect_linepolygon([poly1(:,i-1) poly1(:,i)]',poly2); % check for the first polygon
        end
        if a == true
            return 
        end
    end    
end
%%
function b = isintersect_linepolygon(S,Q)
% Function Name: 
% Check if line segment intersects with polygon
%=======================================
% inputs:
% -S: Line segments
% -Q: Polygon
%=======================================
% Ouputs:
% -b: Binary value, true for line intersects with polygon and false for not
% intersect
%=======================================
%% Expand Q so that the end point is the first point
[r,n] = size(Q);
Q = [Q [Q(1,1);Q(2,1)]];
S = S';
p0 = S(:,1);
p1 = S(:,2);

%% if S is a single point, check whether the point is in/on or outside of the polygon
i = 1;
if S(:,1) == S(:,2)
    if inpolygon(S(1,1),S(1,2),Q(1,:),Q(2,:)) == 1
        b = true;
        return;
    else
        b = false;
        return;
    end
 %% if S is a line segement, check whether intersect with the polygon
else
    te = 0;
    tl = 1;
    b = false;
    ds = p1-p0;
    for i = 1:n
       qi = Q(:,i);
       ei = Q(:,i+1)-qi;
       ni = [ei(2,1),-ei(1,1)]   ;
       N = -dot(p0-qi,ni);
       D = dot(ds,ni);
       if D==0
           if N<0
               b = false;
               return;
           end
       end
       
  %%      
       t = N/D;
       if D<0
           te = max(te,t);
           if te>=tl
               b = false;
               return;
           end
       elseif D>0
           tl = min(tl,t);
           if tl<=te
               b = false;
               return
           end
       end 
    end
%%
    if te<=tl
        b = true;
        return;
    else
        b = false;
        return
    end
end
end
%%
function result = check_collision(poly,CB,WS,tip)
    obs_ckeck =  is_poly_intersect(poly,CB{1});
    if size(CB,2)>1
        for i = 2:size(CB,2)
            obs_ckeck = obs_ckeck||is_poly_intersect(poly,CB{i});       
        end
    end
    Cfree_check = inpolygon(tip(1,1),tip(2,1),WS(1,:),WS(2,:));
    result = (obs_ckeck==1)||(Cfree_check==0);
end