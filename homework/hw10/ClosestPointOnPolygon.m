function [closest_pt, line]= ClosestPointOnPolygon(vertices, pt)
% Function Name:  ClosestPointOnTriangleToPoint(vertices, pt)
% Find the point on a triangle which is the closest to the given point pt
% inputs:
% -vertices: a 2 × 3 array of the coordinates of the triangle vertices.
% -pt: a 2 × 1 array of the coordinate of the point.
%
% Ouputs:
% -closest pt: a 2 × 1 array of the coordinate of the closest point. Please make it the first output of your function.
% -line: a 2 × 2 array of the corrdinate of the points on the line where if the closest point locates
% line is a 2 x 1 array if the closest point is in the Voronoi region
% 

%% Define variables
i = 1;
dist = [];
normal = [];
veca = [];
vecb = [];
size_V = size(vertices,2);
%% projection
while i <= 4  
 %% define two vectors a and b for projection
    if i == size_V                      
        a = pt - vertices(:,i);             % a is the vector from vertex to pt
        b = vertices(:,1)-vertices(:,i);    % b is the vector from vertex to the next vertex
    else  
        a = pt - vertices(:,i);
        b = vertices(:,i+1)-vertices(:,i);
    end
    veca = [veca a];
    vecb = [vecb b];
%% projection to determine the normal point 
    r =  dot(a,b)/(norm(b)^2);                  % r determines the direction of projection of a on b
    if r < 0                               % projection on the opposite direction of b        
        dist = [dist norm(pt- vertices(:,i))];
        normal = [normal 1];               % then normal type is 1
    elseif r> 1                            % projection exceeds b
        if i ==size_V 
            dist = [dist norm(pt- vertices(:,1))];
        else                                
            dist = [dist norm(pt- vertices(:,i+1))];    
        end
        normal = [normal 3];                % then normal type is 3
        
    else                                    % projection is on between vertices
        a1 = a;
        b1 = b;
        proj = dot(a1,b1)*b1/(norm(b1)^2);
        dist = [dist norm(pt-(vertices(:,i)+proj))];
        normal = [normal 2];               % then normal type is 2     
    end
    %fprintf('point %d a is %d %d, b is %d %d r is %d dist is %d\n',i,a(1,1),a(2,1),b(1,1),b(2,1),r,dist(i));
    i = i + 1;
end
%% find the coordinate of normal point
[min_dist,min_index] = min(dist);
if normal(min_index) == 2                  % projection is on between vertices, normal point is the sum of projection and origin point
    a1 = veca(:,min_index);
    b1 = vecb(:,min_index);
    proj = dot(a1,b1)*b1/(norm(b1)^2);
    closest_pt = vertices(:,min_index) + proj;
    if min_index == size_V                      % the normal point is on the line
        line = [vertices(:,size_V) vertices(:,1)];
    else
        line = [vertices(:,min_index) vertices(:,min_index+1)];

    end
elseif normal(min_index) == 1              % projection is below vertices, normal point is the origin point
    closest_pt = vertices(:,min_index);     
    if i == 1
        line = [vertices(:,1) vertices(:,2)];      % the normal point is on the vertex
    else
        line = [vertices(:,min_index+1) vertices(:,min_index)];
    end
elseif normal(min_index) == 3              % projection exceeds vertices, normal point is the next vertex
    if i == 3                      
        closest_pt = vertices(:,1);
        line = [vertices(:,size_V) vertices(:,1)];
    else  
        closest_pt = vertices(:,min_index+1);
        line = [vertices(:,min_index) vertices(:,min_index+1)];
    end
else
    closest_pt = [0;0];
    line = [0 ;0];
end

end