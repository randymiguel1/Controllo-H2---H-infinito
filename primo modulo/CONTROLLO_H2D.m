function K_H2D = CONTROLLO_H2D(A,B,Bw)
alpha_H2 = -78;
theta_H2 = pi/3;

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


%Problema di Otimizzazione
%Vincoli

V1 = [ (A*X+B*Y)+(A*X+B*Y)'   Bw;
              Bw'           -eye(nw) ] <= 0;
V2=[    X              (Cz*X+Dzu*Y)';
     (Cz*X+Dzu*Y)            Q         ]  >= 0;

V3=trace(Q) <= gamma;

V4= [sin(theta_H2)*((A*X+B*Y)+(A*X+B*Y)')    cos(theta_H2)*(-(A*X+B*Y)+(A*X+B*Y)');
     cos(theta_H2)*((A*X+B*Y)-(A*X+B*Y)')    sin(theta_H2)*((A*X+B*Y)+(A*X+B*Y)') ] <= 0;

V5= 2*alpha_H2*X + (A*X+B*Y) + (A*X+B*Y)' <= 0 ;

V = [V1, V2, V3, V4, V5];
optimize(V,gamma);

%Calcolo del controllore 
K_H2D = double(Y)*inv(double(X));
