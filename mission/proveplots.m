%% Prove Plots 
%% Description: In this script you can load the output of the simulation (as .mat file) and plot the wanted signals. 


val1 = load('out_prova_velalta+corrente.mat');
val2 = load('out_mission_default.mat')
figure(1);

%E.G: Plot comparison between estimed and ideal position 
plot(val1.out.pos.signals.values(2,:))
xlabel('campioni')
ylabel('posizione east [m]')
title('posizione')
grid on
hold on 
plot(val2.out.pos.signals.values(2,:))
% grid on
% xlabel('campioni')
% ylabel('posizione [m]')

% plot(out.fls_down.signals.values(1,:))
% xlabel('campioni')
% ylabel('posizione [m]')
% grid on

% plot(out.est_velocity(1,:))
% title('PAsqualo Plot')
% grid on
% xlabel('tempo [s]')
% ylabel('velocità [m/s]')
% hold off
% %%Custom 
% set(gca,'FontSize',20)
% set(findall(gcf,'type','text'),'FontSize',20)