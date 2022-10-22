clear;
clc;

%%  p1
%% test case 1
test = 1;
i = 1;
while test <=4
    if test == 1
        vertice = [1 2 5; 1 3 1];
        pt = [5;3];
    elseif test ==2
        vertice = [1 2 5; 1 3 1];
        pt = [6;1];
    elseif test ==3
        vertice = [1 2 5; 1 3 -2];
        pt = [0;3];
    elseif test ==4
        vertice = [4 8 9; 5 5 1];
        pt = [0;3];        
    else 
        vertice = [1 6 5; 1 3 1];
        pt = [2;3];
    end
    
    figure(1);
    subplot(2,2,test)
    hold on;
    draw_poly(vertice','C')
    plot(pt(1,1),pt(2,1),'ro')

%%
    closept = ClosestPointOnTriangleToPoint(vertice, pt);
    plot(closept(1,1),closept(2,1),'blackd')
    plot([pt(1,1) closept(1,1)],[pt(2,1) closept(2,1)],'red')
    
    title('The closet point (black diamond) is ',['(',num2str(round(closept(1,1),2)), ', ' ,num2str(round(closept(2,1),2)),')'])
    hold off;
    grid on;
    axis([-4 4 -4 4]);
    axis equal;
    test = test + 1;
end


