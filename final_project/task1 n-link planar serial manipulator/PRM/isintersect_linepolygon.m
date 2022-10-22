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
       ni = [ei(2,1),-ei(1,1)];      
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
           if te>tl
               b = false;
               return;
           end
       elseif D>0
           tl = min(tl,t);
           if tl<te
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