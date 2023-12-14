%% IPOTESI SEMPLIFICATIVE GRUPPO 3
% - Il veicolo viene considerato come un ellissoide di semiassi a = 1.1m, b = c = 0.15m, avente massa di 100kg poi zavorrato a 106kg
% - Il centro di massa viene considerato posizionato in z = 0.005 SOLO per quanto riguarda il calcolo del vettore gravità.
%   Ai fini della matrice di massa, Coriolis ecc ecc viene considerato coincidente con il centro di simmetria dell'ellissoide.
% - I thruster sono considerati posizionati in modo perfetto e privo di errore di montaggio
% - La forza di galleggiamento varia linearmente da 0 a (4/3)*pi*a*b*c*rho*g per eta(3) che va rispettivamente da -0.15 a 0.15
%   Questo descrive in modo accettabile la condizione di veicolo semi-sommerso.
% - I termini di drag relativi a roll pitch e yaw sono calcolati ipotizzando un raggio medio per il calcolo della velocità e dell'area di impatto.
%   %Raggi medi per gli effetti di rotazione
%   r_mx = a/3; 
%   r_my = b/3; 
%   r_mz = c/3;
%   %Aree di impatto
%   S_roll = (r_my*r_mz)*pi; 
%   S_pitch = (r_mx*r_my)*pi; 
%   S_yaw = (r_mx*r_mz)*pi;
% - Nella trasformazione da NED a llDepth la profondità non è calcolata con la funzione ned2geodetic ma è presa direttamente come Depth = zDown
% - I primi 3 termini della matrice di massa aggiunta sono considerati uguali tra loro per evitare accoppiamento nella matrice di Coriolis

%% Vehicle Model parameters
% here, the Vehicle Model parameters are included

current_speed = [seaCurrent(1) seaCurrent(2) seaCurrent(3)]';
init_position = [pointP(1),pointP(2),0.15,0,0,deg2rad(alpha)]';%[48.5767  67 30 0 0 deg2rad(alpha)];%
% init_position = [prova(1), prova(2), prova(3), 0, 0, deg2rad(alpha)]';%Posizione iniziale in terna NED

init_velocity = [0 0 0 0 0 0]'; %Velocità iniziale in terna Body
H0 = 0;
%Definizione delle proprietà geometriche e di massa del veicolo
Rg = [0 0 0.005]'; %Posizione centro di massa
Rb = [0 0 0]'; %Posizione centro di galleggiamento
g = 9.81; %m/s^2
m = 106; %kg (di cui 6 di zavorra)
a = 1.1; %m
b = 0.15; %m
c = 0.15; %m
V = (4/3)*pi*a*b*c; %m^3
W = m*g*[0 0 1]'; %Forza peso in terna NED
Ixx = 0.93304097392; %kg*m^2
Iyy = 25.58745481378; %kg*m^2
Izz = 25.58745481378; %kg*m^2
Ixy = 0;
Ixz = 0;
Iyz = 0;

%Matrice di Massa
M11 = blkdiag(m,m,m);
M12 = zeros(3); %Trascuriamo che il centro di massa sia leggermente sotto il centro di galleggiamento
M21 = M12';
M22 = [Ixx -Ixy -Ixz;-Ixy Iyy -Iyz;-Ixz -Iyz Izz];
Mrb =[M11 M12;M21 M22]; %Matrice di massa

%Matrice di Massa Aggiunta
e=1-(b/a)^2;
alpha_0=(((2*(1-e^2))/(e^3))*((1/2)*(log((1+e)/(1-e)-e))));
beta_0=(1/e^2)-(((1-e^2))/2*(e^3))*(log((1+e)/(1-e)));

%Xadd = -((alpha_0)/(2-alpha_0))*m;
Xadd = -((beta_0)/(2-beta_0))*m;
Yadd = -((beta_0)/(2-beta_0))*m;
Zadd = -((beta_0)/(2-beta_0))*m;
Kadd = 0;
Madd = -((((1/5)*(b^2-a^2)^2))*(alpha_0-beta_0))/((((2*(b^2-a^2)^2))+(b^2-a^2)^2)*(alpha_0-beta_0)*m);
Nadd = -((((1/5)*(b^2-a^2)^2))*(alpha_0-beta_0))/((((2*(b^2-a^2)^2))+(b^2-a^2)^2)*(alpha_0-beta_0)*m);

Ma = -blkdiag(Xadd,Yadd,Zadd,Kadd,Madd,Nadd);

%Matrice di Massa completa (e relativa inversa)
M = Mrb + Ma;
M_inv = inv(M);

%Definizione della Matrice di Allocazione dei Thruster
TAM1 = [0 0 1 1 0 0 0;0 0 0 0 0 1 1;1 1 0 0 1 0 0];
TAM2 = [0.15 -0.15 0 0 0 0 0;-0.6 -0.6 0 0 1.2 0 0;0 0 -0.2 0.2 0 -0.9 0.9];
TAM = [TAM1;TAM2];

%Dati necessari al calcolo matrice damping
%Coefficenti di Drag
cd_x=0.4; 
cd_y=1; 
cd_z=1; 
cd_roll=0.04; 
cd_pitch=0.7; 
cd_yaw=0.7;
%Raggi medi per gli effetti di rotazione
r_mx = a/3; 
r_my = b/3; 
r_mz = c/3;
%Aree di impatto
S_x = b*c*pi; 
S_y = a*b*pi; 
S_z = a*c*pi;
S_roll = (r_my*r_mz)*pi; 
S_pitch = (r_mx*r_my)*pi; 
S_yaw = (r_mx*r_mz)*pi;

%Posizioni Thruster in terna Body
Ax = 0.6; %m
Ay = 0.15; %m
Az = 0.005; %m
Bx = 0.6; %m
By = -0.15; %m
Bz = 0.005; %m
Cx = 0; %m
Cy = 0.2; %m
Cz = 0; %m
Dx = 0; %m
Dy = -0.2; %m
Dz = 0; %m
Ex = -1.2; %m
Ey = 0; %m
Ez = 0.005; %m
Fx = -0.9; %m
Fy = 0; %m
Fz = 0; %m
Gx = 0.9; %m
Gy = 0; %m
Gz = 0; %m
ag = [Ax Ay Az]';
bg = [Bx By Bz]';
cg = [Cx Cy Cz]';
dg = [Dx Dy Dz]';
eg = [Ex Ey Ez]';
fg = [Fx Fy Fz]';
gg = [Gx Gy Gz]';

%Orientazione thruster in terna Body
orA = [0 0 1]; %asse z
orB = [0 0 1]; %asse z
orC = [1 0 0]; %asse x
orD = [1 0 0]; %asse x
orE = [0 0 1]; %asse z
orF = [0 1 0]; %asse y
orG = [0 1 0]; %asse y