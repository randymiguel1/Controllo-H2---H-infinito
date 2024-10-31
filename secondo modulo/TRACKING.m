%% 
clear
clc

%% parametri
m = 1575;
Iz = 2875;
Lf = 1.2;
Lr = 1.6;
Cf = 19000;
Cr = 33000;
%velocita longitudinale
Vx = 10;
parametri = [m; Iz; Lf; Lr; Cf; Cr; Vx];

data_scenario1 = load('scenario1.mat');
yaw_0 = data_scenario1.data.ActorSpecifications(1,1).Yaw*(pi/180);  
X0 = data_scenario1.data.ActorSpecifications(1,1).Position(1);
Y0 = data_scenario1.data.ActorSpecifications(1,1).Position(2);

%condizioni iniziali
x_0 = [0 0 yaw_0 0];

%% stato aumentato
[A_a ,Bu_a ,Bw_a ,Cz ,Dzu ,Dzw] = spazio_stato_aumentato(Vx,x_0);

%% controllore
K = HINF(A_a, Bu_a, Bw_a, Cz, Dzu, Dzw);
K_fb = K(1:1,1:4);
K_ff = K(1:1,5:6);

%% generazione traiettoria
setUpModel; % carico lo scenario e faccio tutti i calccoli

risultato_stanley = sim('stanleySimple'); %angoli di riferimento (yaw) simulando il modello con Stanley

yaw_signal.time = risultato_stanley.yaw_simulazione.Time; %tempo di simulazione Stanley

yaw_signal.signals.values = risultato_stanley.yaw_simulazione.Data(1,:)'*(pi/180); %prendo gli angoli dal simulik Stanley

%creo la struttura dei dati
sim.refPose = refPose;
sim.yaw_signal = yaw_signal;
sim.yaw_0 = psi_o;
sim.X0 = X_o;
sim.Y0 = Y_o;
save('sim_data','-struct','sim');

%% Inseguimento della referenza
%risultato_tracking = sim('SIMULAZIONE');

%% //////Figure//////
%figure(2)
%uscita
%plot(risultato_tracking.inseguimento.time, risultato_tracking.inseguimento.signals.values(:,2:3),'LineWidth',3);
%grid;
%title('INSEGUIMENTO');
%xlabel('sec.');
%legend('REFERENCE','REAL')


