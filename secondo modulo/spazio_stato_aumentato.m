function [A_a, Bu_a,Bw_a, Cz,Dzu ,Dzw] = spazio_stato_aumentato(Vx,x_0)
m = 1575;
Iz = 2875;
lf = 1.2;
lr = 1.6;
Caf = 19000;
Car = 33000;

A = [   0               1                 0           0;
        0    -(2*Caf+2*Car)/(m*Vx)        0    -Vx-(2*Caf*lf-2*Car*lr)/(m*Vx);
        0               0                 0           1; 
        0   -(2*Caf*lf-2*Car*lr)/(Iz*Vx)  0    -(2*Caf*lf^2+2*Car*lr^2)/(Iz*Vx)];

B = [   0           (2*Caf)/m             0       (2*Caf*lf)/Iz]';

C = eye(4);

D = zeros(4,1);

Bw = B;
Bu = B;

Cz = [0  0 0 0 1 0;
      0  0 0 0 0 1;
      0  0 0 0 0 0];
  
sqrtrho = 1/1000; 
Dzu =  [0 ; 0 ; sqrtrho];
Dzw =  zeros(size(Cz,1),3);


%sistema aumentato
[n,m] = size(A);
new_row1 = [0  0 -1  0  0  0];
new_row2 = [0  1  0  0 1*15 0];


A_a = [A  zeros(n,2);
       new_row1;
       new_row2];

[n,m] = size(B);
Bu_a = [Bu; zeros(2,m)];

[n,m] = size(C);

C_a = [   C         zeros(n,2);
       zeros(2,m)     eye(2)];
   
[n,m] = size(D);
D_a = [D; zeros(2,m)];

[n,m] = size(Bw);
Bw_a = [Bw         zeros(n,2);
        zeros(2,m)  eye(2,2)];

