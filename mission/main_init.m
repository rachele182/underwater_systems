%% TeamA - PAsqualo
%% Main Initialization File for the integrated system 
%% Description: Here after all the parameters needed for the complete simulation of the survey mission

clear;close;clc

addpath('include');

disp('Loading System parameters...')

%% LOAD Mission File

run missionA.m; % Load mission parameters
stop_time = 1300; % Stop simulation time in simulink 

%% Environmental data

rho = 1030;			% [kg/m^3] Sea Water Density

seaCurrent = [	0.1; %0.05;
				2.5; %0.1
                0];       %[m/s] Sea current speed, values can be modified       

%% Trusthers data [Inspired to Bluerobotics model T200]

D = 0.076;                  % [m] Propeller Diameter
n_max = 340;                % [rad/s] Maximum propeller rotational speed
dead_zone_limit = 31.5;     % [rad/s] Corresponding to about 350RPM
omega = 0.1;                % []  Wake Fraction Number

% kT(J0) function characterization
alpha1 =  0.0113;          % [Ns^2/m/kg/rad^2]
alpha2 = -0.0091;          % [Ns^2/m/kg/rad]

a1 =  rho * D^4 * alpha1;
a2 = -rho * D^3 * alpha2 * (1 - omega);

%% Mission Supervisor & Reference Generator parameters
% here, the Mission Supervisor & Reference Generator parameters parameters are included

run init_supervisor.m

%% Vehicle Model parameters
% here, the Vehicle Model parameters are included
disp('Loading Model parameters...')
run init_modello.m

%% Environment Model & Sensor Model parameters
% here, the Environment Model & Sensor Model parameters parameters are included
run init_sensori.m

%% Controller parameters
% here, the Controller parameters are included
disp('Loading Controller parameters...')
run init_controllo.m

%% Navigation System parameters
% here, the Navigation System parameters are included
run init_navigazione.m

%% System parameters loaded
disp('Done!! Enjoy PAsqualo!')