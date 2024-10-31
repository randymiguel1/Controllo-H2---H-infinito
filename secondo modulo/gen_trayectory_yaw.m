 clear;
 clc;
 setUpModel;% Carga el escenario y hace los calculos
 velt_res = 10;% velocita di riferimento (m*s)
 res = sim('stanleySimple'); % angulos de referencia que genera el modelo simulado en stanleySimple
 yaw_signal.time = res.yaw_simulazione.Time; % tiempo de sim= tiempo de la sim del simulik Stanley
 yaw_signal.signals.values=res.yaw_simulazione.Data(1,:)'*(pi/180); % Cojo los angulos simulik Stanley
 sim.refPose = refPose;
 sim.yaw_signal = yaw_signal;
 sim.yaw_0 = psi_o;
 sim.X0 = X_o;
 sim.Y0 = Y_o;
 save('sim_data','-struct','sim');