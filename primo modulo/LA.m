clc
clear

%% PARAMETRI
V = 90;
L = 2;
d = 4;
alpha = pi/10;
beta = pi/15;

parametri = [V, L, d, alpha, beta]
x_0 = [0; 0; 0];
x_eq = [0; 0; 0];
u_eq = 0;

%% LINEARIZZAZIONE INTORNO AL PUNTO D'EQUILIBRIO
[A,B,C,D] = linmod('modello_lin', x_eq, u_eq);

Bw = B;

%% //////////////ANALISI STRUTTURALI DEL SISTEMA//////
%/////////////////////////////////////////////////////
autovalori = eig(A);
R_matrice = ctrb(A,B)          %calcolo la matrice di raggiungibilita
R_matrice_rank = rank(R_matrice) %calcolo del rango della matrice di raggiungibilita

O_matrice = obsv(A,C)           %calcolo la matrice di ossevarbilita
O_matrice_rank = rank(O_matrice); %calcolo del rango della matrice di raggiungibilita

if R_matrice_rank == 3
    disp('sistema raggiungibile');
else
    disp('sistema non raggiungibile');
end

if O_matrice_rank == 3
    disp('sistema osservabile');
else
    disp('sistema non osservabile');
end 

%% ///////////////////////////////////////////////////
%///////////CONTROLLORE H2////////////////////////////
%/////////////////////////////////////////////////////

K_H2 = CONTROLLO_H2(A,B,Bw);
K_sim = K_H2;
risultato_H2 = sim('modello_la');

%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2
autovalori_H2 = eig(A + B*K_H2);

%% //////Figure//////
figure(1)
%stati
subplot(211)
plot(risultato_H2.stati.time, risultato_H2.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2.attuatori.time, risultato_H2.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2');
xlabel('sec.');
legend('u')

%% ////////////////////////////////////////////////////
%////////////CONTROLLORE H2 D-STABILITA////////////////
%//////////////////////////////////////////////////////

K_H2D = CONTROLLO_H2D(A,B,Bw);
K_sim = K_H2D;
risultato_H2D = sim('modello_la');
%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2D
autovalori_H2D = eig(A + B*K_H2D)

%% //////Figure//////
figure(2)
%stati
subplot(211)
plot(risultato_H2D.stati.time, risultato_H2D.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2D');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2D.attuatori.time, risultato_H2D.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2D');
xlabel('sec.');
legend('u')

%% ////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE HINF///////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////////

K_HINF = CONTROLLO_HINF(A,B,Bw);
K_sim = K_HINF;
risultato_HINF = sim('modello_la');
%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2D
autovalori_HINF = eig(A + B*K_HINF)

%% //////Figure//////
figure(3)
%stati
subplot(211)
plot(risultato_HINF.stati.time, risultato_HINF.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-HINF');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_HINF.attuatori.time, risultato_HINF.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-HINF');
xlabel('sec.');
legend('u')

%% /////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE H_INF D_STABILITA///////////////////////////
%///////////////////////////////////////////////////////////////////////////////

K_HINFD = CONTROLLO_HINFD(A,B,Bw);
K_sim = K_HINFD;
risultato_HINFD = sim('modello_la');
%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2D
autovalori_HINFD = eig(A + B*K_HINFD)

%% //////Figure//////
figure(4)
%stati
subplot(211)
plot(risultato_HINFD.stati.time, risultato_HINFD.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-HINFD');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_HINFD.attuatori.time, risultato_HINFD.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-HINFD');
xlabel('sec.');
legend('u')

%% /////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE H2_HINF/////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////

K_H2_HINF = CONTROLLO_H2_HINF(A,B,Bw);
K_sim = K_H2_HINF;
risultato_H2_HINF = sim('modello_la');
%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2D
autovalori_H2_HINF = eig(A + B*K_H2_HINF)

%% //////Figure//////
figure(5)
%stati
subplot(211)
plot(risultato_H2_HINF.stati.time, risultato_H2_HINF.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2-HINF');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2_HINF.attuatori.time, risultato_H2_HINF.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2-HINF');
xlabel('sec.');
legend('u')

%% //////Figure//////
figure(6)
%stati
subplot(211)
plot(risultato_H2.stati.time, risultato_H2.stati.signals.values(:,1:1),risultato_H2D.stati.time, risultato_H2D.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE H2 - H2D');
xlabel('sec.');
legend('H2','H2D')


%attuatori
subplot(212)
plot(risultato_H2.attuatori.time, risultato_H2.attuatori.signals.values(:,1:1),risultato_H2D.attuatori.time, risultato_H2D.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2-HINF');
xlabel('sec.');
legend('H2','H2D')

%% //////Figure//////
figure(7)
%stati
subplot(211)
plot(risultato_HINF.stati.time, risultato_HINF.stati.signals.values(:,1:1),risultato_HINFD.stati.time, risultato_HINFD.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE H2 - H2D');
xlabel('sec.');
legend('HINF','HINFD')


%attuatori
subplot(212)
plot(risultato_HINF.attuatori.time, risultato_HINF.attuatori.signals.values(:,1:1),risultato_HINFD.attuatori.time, risultato_HINFD.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2-HINF');
xlabel('sec.');
legend('HINF','HINFD')

%% /////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE ROBUSTO GAIN SCHEDULING/////////////////////
%///////////////////////////////////////////////////////////////////////////////
   
K_S = [];
x_eq_S = [];
u_eq_S = [];
V_S = [];
j = 0;


for i = 0:20:80
        V_1 = V + i;

        parametri = [V_1, L, d, alpha, beta];
        X_eq = [0; 0; 0];
        U_eq = 0;
        [A_1,B_1,C_1,D_1] = linmod('modello_lin',X_eq,U_eq); %vertice
       
if (j > 0)
       K = CONTROLLO_H2_GAIN_SCHEDULING(A_0,A_1,B_0,B_1,B_0,B_1);
       K_S = [K_S; K];
       x_eq_S = [x_eq_S x_eq_0];
       u_eq_S = [u_eq_S u_eq_0]; 
end

       A_0 = A_1;
       B_0 = B_1; 
       x_eq_0 = [1;20;0];
       u_eq_0 = U_eq;
       V_S = [V_S V_1];
       j = j+1;
end      
      

risultato_H2_GS = sim('modello_la_gs');

%% //////Figure//////
figure(8)
%stati
subplot(211)
plot(risultato_H2_GS.stati.time, risultato_H2_GS.stati.signals.values(:,2:2),'LineWidth',1);
yline(0,'--r','LineWidth',1);
grid;
title('ANGOLO TRA AUTO E LINEA DI CORSIA');
xlabel('sec.');

subplot(212)
plot(risultato_H2_GS.stati.time, risultato_H2_GS.stati.signals.values(:,3:3),'LineWidth',1);
yline(0,'--r','LineWidth',1);
grid;
title('ANGOLO STERZATA');
xlabel('sec.');


%% //////Figure//////
figure(9)
%attuatori
subplot(211)
plot(risultato_H2_GS.attuatori.time, risultato_H2_GS.attuatori.signals.values(:,1:1),'LineWidth',1);
grid;
title('ATTUATORI CONTROLLORE-H2-GS');
xlabel('sec.');

%parametro dipendente del tempo
subplot(212)
plot(risultato_H2_GS.incerto.time, risultato_H2_GS.incerto.signals.values(:,1:1),'LineWidth',1);
grid;
title('PARAMETRO VELOCITA');
xlabel('sec.');

%% ///////////////////////////////////////////////////
%///////////CONTROLLORE H2 DISTURBO///////////////////
%/////////////////////////////////////////////////////
K_H2 = CONTROLLO_H2(A,B,Bw);
K_sim = K_H2;
risultato_H2_DISTURBO = sim('modello_la_disturbo');

%% //////Figure//////

figure(10)
%stati
subplot(211)
plot(risultato_H2_DISTURBO.stati.time, risultato_H2_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2-DISTURBO');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2_DISTURBO.attuatori.time, risultato_H2_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2-DISTRUBO');
xlabel('sec.');
legend('u')

%% ////////////////////////////////////////////////////
%////////////CONTROLLORE H2 D-STABILITA DISTURBO///////
%//////////////////////////////////////////////////////
K_H2D = CONTROLLO_H2D(A,B,Bw);
K_sim = K_H2D;
risultato_H2D_DISTURBO = sim('modello_la_disturbo');

%% //////Figure//////
figure(11)
%stati
subplot(211)
plot(risultato_H2D_DISTURBO.stati.time, risultato_H2D_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2D DISTURBO');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2D_DISTURBO.attuatori.time, risultato_H2D_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2D DISTURBO');
xlabel('sec.');
legend('u')

%% ////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE HINF DISTURBO//////////////////////////////
%//////////////////////////////////////////////////////////////////////////////

K_HINF = CONTROLLO_HINF(A,B,Bw);
K_sim = K_HINF;
risultato_HINF_DISTURBO = sim('modello_la_disturbo');


%% //////Figure//////
figure(12)
%stati
subplot(211)
plot(risultato_HINF_DISTURBO.stati.time, risultato_HINF_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-HINF DISTURBO');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_HINF_DISTURBO.attuatori.time, risultato_HINF_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-HINF DISTRUBO');
xlabel('sec.');
legend('u')

%% /////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE H_INF D_STABILITA///////////////////////////
%///////////////////////////////////////////////////////////////////////////////

K_HINFD = CONTROLLO_HINFD(A,B,Bw);
K_sim = K_HINFD;
risultato_HINFD_DISTURBO = sim('modello_la_disturbo');


%% //////Figure//////
figure(13)
%stati
subplot(211)
plot(risultato_HINFD_DISTURBO.stati.time, risultato_HINFD_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-HINFD DISTURBO');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_HINFD_DISTURBO.attuatori.time, risultato_HINFD_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-HINFD DISTURBO');
xlabel('sec.');
legend('u')

%% /////////////////////////////////////////////////////////////////////////////
%///////////////////////CONTROLLORE H2_HINF DISTURBO////////////////////////////
%///////////////////////////////////////////////////////////////////////////////

K_H2_HINF = CONTROLLO_H2_HINF(A,B,Bw);
K_sim = K_H2_HINF;
risultato_H2_HINF_DISTURBO = sim('modello_la_disturbo');
%Comprobazione degli autovalori per vedere l'eficazia del controllore H_2D
autovalori_H2_HINF = eig(A + B*K_H2_HINF)

%% //////Figure//////
figure(14)
%stati
subplot(211)
plot(risultato_H2_HINF_DISTURBO.stati.time, risultato_H2_HINF_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('STATI CONTROLLORE-H2-HINF DISTURBO');
xlabel('sec.');
legend('spostamento laterale')


%attuatori
subplot(212)
plot(risultato_H2_HINF_DISTURBO.attuatori.time, risultato_H2_HINF_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('ATTUATORI CONTROLLORE-H2-HINF DISTURBO');
xlabel('sec.');
legend('u')

%% //////Figure//////
figure(15)
%stati
subplot(211)
plot(risultato_H2_DISTURBO.stati.time, risultato_H2_DISTURBO.stati.signals.values(:,1:1),risultato_H2D_DISTURBO.stati.time, risultato_H2D_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE H2 - H2D CON DISTURBO');
xlabel('sec.');
legend('H2','H2D')


%attuatori
subplot(212)
plot(risultato_H2_DISTURBO.attuatori.time, risultato_H2_DISTURBO.attuatori.signals.values(:,1:1),risultato_H2D_DISTURBO.attuatori.time, risultato_H2D_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARZIONE ATTUATORI CONTROLLORE-H2-HINF CON DISTURBO');
xlabel('sec.');
legend('H2','H2D')

%% //////Figure//////
figure(16)
%stati
subplot(211)
plot(risultato_HINF_DISTURBO.stati.time, risultato_HINF_DISTURBO.stati.signals.values(:,1:1),risultato_HINFD_DISTURBO.stati.time, risultato_HINFD_DISTURBO.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE STATI HINF - HINFD CON DISTURBO');
xlabel('sec.');
legend('HINF','HINFD')


%attuatori
subplot(212)
plot(risultato_HINF_DISTURBO.attuatori.time, risultato_HINF_DISTURBO.attuatori.signals.values(:,1:1),risultato_HINFD_DISTURBO.attuatori.time, risultato_HINFD_DISTURBO.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARAZIONE ATTUATORI CONTROLLORE-H2-HINF CON DISTURBO');
xlabel('sec.');
legend('HINF','HINFD')

%% //////Figure//////
figure(17)
%stati
subplot(211)
plot(risultato_H2_DISTURBO.stati.time, risultato_H2_DISTURBO.stati.signals.values(:,1:1),risultato_H2.stati.time, risultato_H2.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE STATI H2 - H2 CON DISTURBO');
xlabel('sec.');
legend('H2 disturbo','H2')


%attuatori
subplot(212)
plot(risultato_H2_DISTURBO.attuatori.time, risultato_H2_DISTURBO.attuatori.signals.values(:,1:1),risultato_H2.attuatori.time, risultato_H2.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARAZIONE ATTUATORI CONTROLLORE-H2-HINF CON DISTURBO');
xlabel('sec.');
legend('H2 disturbo','H2')

%% //////Figure//////
figure(18)
%stati
subplot(211)
plot(risultato_H2D_DISTURBO.stati.time, risultato_H2D_DISTURBO.stati.signals.values(:,1:1),risultato_H2D.stati.time, risultato_H2D.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE STATI H2D - H2D CON DISTURBO');
xlabel('sec.');
legend('H2D disturbo','H2D')


%attuatori
subplot(212)
plot(risultato_H2D_DISTURBO.attuatori.time, risultato_H2D_DISTURBO.attuatori.signals.values(:,1:1),risultato_H2D.attuatori.time, risultato_H2D.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARAZIONE ATTUATORI CONTROLLORE-H2D-HINFD CON DISTURBO');
xlabel('sec.');
legend('H2D disturbo','H2D')

%% //////Figure//////
figure(19)
%stati
subplot(211)
plot(risultato_HINF_DISTURBO.stati.time, risultato_HINF_DISTURBO.stati.signals.values(:,1:1),risultato_HINF.stati.time, risultato_HINF.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE STATI HINF - HINF CON DISTURBO');
xlabel('sec.');
legend('HINF disturbo','HINF')


%attuatori
subplot(212)
plot(risultato_HINF_DISTURBO.attuatori.time, risultato_HINF_DISTURBO.attuatori.signals.values(:,1:1),risultato_HINF.attuatori.time, risultato_HINF.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARAZIONE ATTUATORI CONTROLLORE-HINF-HINF CON DISTURBO');
xlabel('sec.');
legend('HINF disturbo','HINF')

%% //////Figure//////
figure(20)
%stati
subplot(211)
plot(risultato_HINFD_DISTURBO.stati.time, risultato_HINFD_DISTURBO.stati.signals.values(:,1:1),risultato_HINFD.stati.time, risultato_HINFD.stati.signals.values(:,1:1),'LineWidth',2);
yline(0,'--r','LineWidth',1);
grid;
title('COMPARAZIONE STATI HINFD - HINFD CON DISTURBO');
xlabel('sec.');
legend('HINFD disturbo','HINFD')


%attuatori
subplot(212)
plot(risultato_HINFD_DISTURBO.attuatori.time, risultato_HINFD_DISTURBO.attuatori.signals.values(:,1:1),risultato_HINFD.attuatori.time, risultato_HINFD.attuatori.signals.values(:,1:1),'LineWidth',2);
grid;
title('COMPARAZIONE ATTUATORI CONTROLLORE-HINFD-HINFD CON DISTURBO');
xlabel('sec.');
legend('HINFD disturbo','HINFD')


