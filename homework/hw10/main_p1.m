clear;
clc;
close all;

%% test case
bounds=[0 100 100 0 ;0 0 100 100];
CB={[0 50 50 0 ;25 25 50 50 ],[80 80 70 70;50 100 100 50]};
qI=[0.5;0.5]; qG=[95;85];

%%
figure(1);
hold on;
%%
draw_poly(bounds,'WS')
for i = 1:size(CB,2)
    draw_poly(CB{i},'O')
end
plot(qI(1,1) ,qI(2,1) , 'r*');
plot(qG(1,1) ,qG(2,1) , 'r*');
a = potiential_field(qI,qG,CB);

%%
hold off
grid on
axis equal
title('Potiential Field Method')
axis([0 100 0 100])