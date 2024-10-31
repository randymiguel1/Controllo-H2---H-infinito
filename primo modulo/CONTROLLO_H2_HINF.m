function K_H2_HINF = CONTROLLO_H2_INF(A,B,Bw)

%Uscita di prestazione (1 stato da pesare + 1 attuatori)
Cz = [1 0 0;
      0 0 0];
      
%parametro di taratura
sqrtrho = 1/100;
%Ingressi di prestazioni (3 stato da pesare + 1 attuatori)
Dzu = [0; sqrtrho];

[nx] = size(A,1);
[nu] = size(B,2);
[nw] = size(Bw,2);
[nz] = size(Cz,1);

gamma_H2 = sdpvar(1,1);
gamma_HINF = sdpvar(1,1);
X = sdpvar(nx);
Y = sdpvar(nu,nx);
Q = sdpvar(nz);
a = 0.8;
b = 0.2;
Dzw = zeros(nz,nu);

%Vincoli HINF
V1= [(A*X+B*Y)+(A*X+B*Y)'         Bw                      (Cz*X+Dzu*Y)';
            Bw'             -gamma_HINF*eye(nw)                    Dzw';
       (Cz*X+Dzu*Y)               Dzw                   -gamma_HINF*eye(nz) ]  <=0;

V2=[X]>=0;

V3=[gamma_HINF]>=0;

%Vincoli H2
V4=[ (A*X+B*Y)+(A*X+B*Y)'      Bw;
              Bw'           -eye(nw) ] <= 0;

V5=[    X              (Cz*X+Dzu*Y)';
     (Cz*X+Dzu*Y)            Q         ]  >= 0;

V6=trace(Q) <= gamma_H2;

V7 = Q >= 0;

V8 = gamma_H2 >= 0;

V = [V1, V2, V3, V4, V5, V6, V7, V8];

optimize(V,(a*gamma_HINF + b*gamma_H2));

%Calcolo del controllore 
K_H2_HINF = double(Y)*inv(double(X));
