function K_HINF = CONTROLLO_H2(A,B,Bw)

%Uscita di prestazione (1 stato da pesare + 1 attuatori)
Cz = [1 0 0;
      0 0 0];
      
%parametro di taratura
sqrtrho = 1/100;
%Ingressi di prestazioni (1 stato da pesare + 1 attuatori)
Dzu = [0; sqrtrho];

[nx] = size(A,1);
[nu] = size(B,2);
[nw] = size(Bw,2);
[nz] = size(Cz,1);

gamma = sdpvar(1,1);
X = sdpvar(nx);
Y = sdpvar(nu,nx);
Q = sdpvar(nz);
Dzw = zeros(nz,nu);
%Problema di Otimizzazione
%Vincoli

V1 = [(A*X+B*Y)+(A*X+B*Y)'                Bw                      (Cz*X+Dzu*Y)';
              Bw'                    -gamma*eye(nw)                    Dzw';
         (Cz*X+Dzu*Y)                     Dzw                     -gamma*eye(nz) ]  <= 0;
V2 = [X] >= 0;
V3 = [gamma] >= 0;
V = [V1, V2, V3];
optimize(V, gamma);

%Calcolo controllore
K_HINF = double(Y)*inv(double(X));
