%% Example 1: define a vector

a = [1 ; 2 ; 3 ; 4 ; 5]

% Defines a column vector a with entries 1,2,3,4,5. Entries in a column 
%vector are separated by a semicolon (;). space. Matlab treats "a" as a 
%column vector, which can also be thought of as a matrix with dimension 5x1.

%An aside: to suppress the output of a line, end it with a ; (semicolon).
%For example: 

a2 = [1 ; 3 ; 4] ;

%assigns the variable a2 with this corresponding column vector, while the
%semicolon suppresses output in the command window. 


%% Example 2: basic operations on vectors

b = 2 * a

%The line 2 * a returns the scalar multiplication of the vector a by the
%scalar 2. The line "b = 2 * a" creates a new variable b (another 1x5
%matrix) with the entries of 2 * a. 

c = a + 2

%In the expression "a + 2", the value 2 is added to each entry of a. This
%line then creates the new variable c (1x5) with entries a + 2.

%% Example 3: 

%To create a matrix: enter rows as you would for vectors and demarcate the
%end of a row with a semicolon ";". 

M = [0 1 2 ; 3 4 5 ; 6 7 8]

%Matrix multiplication is handled with * (asterisk). For example, if

v = [1 ; 3 ; 5]

%is a 3x1 column vector, then the matrix product Av is given by

M*v

%Note that * is also used for scalar multiplication. MATLAB is smart and
%automatically adjusts based on the dimensions of the variables. 

%% Example 4: 

%Matlab is really good at solving linear systems. To showcase this, we'll
%use the \ (backslash) operator. First, define

b = [1;3;5]

%and

A = [1 2 0; 2 5 -1; 4 10 -1]

%To solve the linear system Ax = b, we assign

x = A \ b

%To show that Ax = b actually holds, we compute the remainder r = Ax - b as
%follows: 

r = A*x-b

%When you run this section, you'll see in the command window that the
%columnn vector r is the 0 vector. This confirms that Ax = b, as desired.
%(Note: once this section is run, the value assigned to the variable r is
%listed in the right-hand window as well.)

%% Example 5: 

%MATLAB is also computer algebra software, and can manipulate algebraic
%equations. For example, you can use the "solve" command for exact 
%solutions to quadratic equations: 

syms z;

solve(z^2 - 3 * z + 1 == 0)

%Note that solutions are stored as the 2x1 vector "ans". 
