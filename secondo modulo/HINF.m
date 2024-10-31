function [K] = HINF(A_a, Bu_a, Bw_a, Cz, Dzu, Dzw)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
warning('off','YALMIP:strict');
warning('off','sedumi:strict');

nx=size(A_a,1);
nu=size(Bu_a,2);
nw=size(Bw_a,2);
nz=size(Cz,1);

X = sdpvar(nx,nx);
Y = sdpvar(nu,nx);
gamma_INF = sdpvar(1);

V1 =  (X >= 0) ;

V2 = ([(A_a*X+Bu_a*Y)+(A_a*X+Bu_a*Y)'            Bw_a                (Cz*X+Dzu*Y)';
             Bw_a'                 -gamma_INF*eye(nw)          Dzw';
          Cz*X+Dzu*Y                     Dzw            -gamma_INF*eye(nz)] <= 0);
           
V3 = (gamma_INF >= 0); 

V = [V1, V2, V3];

options = sdpsettings('solver','sedumi','verbose',0);
res = optimize( V, gamma_INF, options);
K = double(Y)*inv(double(X));

end

