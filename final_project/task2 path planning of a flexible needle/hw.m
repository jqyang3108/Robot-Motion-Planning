clear
clc

%% p1
41+57;

%% p2.a
A = [1 2 3;2 -1 3;4 -1 12];
b = [115; 1421; 4214];

ansp2a = A \ b;

%% p2.b
M = [1 2 3 115; 2 -1 3 1421; 4 -1 12 4214]    
rref(M);


%% p3
M = [4 -7 -33;-3 8 44;-3 7 37];
rref(M);

%% p4
A = [1 2 3;2 -1 3];
b = [115; 1421];

ansp4 = A\b;

M = [1 2 3 115; 2 -1 3 1421];
rref(M);
w = [1.8;0.6;1];
v = [591.4; -238.2; 0];
a = 1;







A = [3 3 3;3 3 3]
[cd,d]=size(A);

sprintf("Domain is %d, codomain is %d",d,cd)

A = [01 0;0 -1]
