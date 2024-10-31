function  K = CONTROLLO_H2_GAIN_SCHEDULING(A_S,A_S1,B_S,B_S1,Bw0_S,Bw1_S)

%Uscita di prestazione (1 stato da pesare + 1 attuatori)
Cz = [1 0 0;
      0 0 0];
      
%parametro di taratura
sqrtrho = 1/10;
%Ingressi di prestazioni (1 stato da pesare + 1 attuatori)
Dzu = [0; sqrtrho];

[nx] = size(A_S,1);
[nu] = size(B_S,2);
[nw] = size(Bw0_S,2);
[nz] = size(Cz,1);

gamma = sdpvar(1,1);
X = sdpvar(nx);
Y = sdpvar(nu,nx);
Q = sdpvar(nz);



%Vincoli
V1 = [ (A_S*X+B_S*Y)+(A_S*X+B_S*Y)'   Bw0_S;
                 Bw0_S'           -eye(nw) ] <= 0;

V2 = [           X              (Cz*X+Dzu*Y)';
            (Cz*X+Dzu*Y)             Q         ]  >= 0;

V3 = [ (A_S1*X+B_S1*Y)+(A_S1*X+B_S1*Y)'     Bw1_S;
              Bw1_S'              -eye(nw) ] <= 0;

V4 = [           X              (Cz*X+Dzu*Y)';
             (Cz*X+Dzu*Y)            Q         ]  >= 0;

V5 = trace(Q) <= gamma;

V6 = X >= 0;

V7 = Q >= 0;

V8 = gamma >= 0;

V = [V1, V2, V3, V4, V5, V6, V7, V8];
optimize(V,gamma);
K = double(Y)*inv(double(X));
