%% AUV MODEL
%% Assumptions: the AUV is consideread as an elipsoid with semiaxes a=1.1m, b=c=0.15 m, with mass equal to 100kg.
% COM is considered in z = 0.005 ONLY for the gravity vector calculation. Center of simmetry of ellipsoid is considered for Mass matrix, Coriolis and so on calculations. 
% Bouyancy force varies linearly from 0 to (4/3)*pi*a*b*c*rho*g for eta(3) which is from -0.15 to 0.15.

% drag  values for roll pitch and yaw are calculated assunming a medium radius for velocity and impact area.

% Medium Radius 
%   r_mx = a/3; 
%   r_my = b/3; 
%   r_mz = c/3;

%  Impact Areas
%   S_roll = (r_my*r_mz)*pi; 
%   S_pitch = (r_mx*r_my)*pi; 
%   S_yaw = (r_mx*r_mz)*pi;

%% Vehicle Model parameters
% here, the Vehicle Model parameters are included

current_speed = [seaCurrent(1) seaCurrent(2) seaCurrent(3)]';
init_position = [pointP(1),pointP(2),0.15,0,0,deg2rad(alpha)]';%[48.5767  67 30 0 0 deg2rad(alpha)];%
init_velocity = [0 0 0 0 0 0]'; %initial velocity 
H0 = 0;

%Geometric properties of the AUV 
Rg = [0 0 0.005]'; %Center of mass position 
Rb = [0 0 0]'; %Center of bouyancy position 
g = 9.81; %m/s^2
m = 106; %kg (6kg = zavorra)
% semi-axes 
a = 1.1;  %m
b = 0.15; %m
c = 0.15; %m
V = (4/3)*pi*a*b*c; %m^3
W = m*g*[0 0 1]'; %weight force (NED frame)
% Inertias 
Ixx = 0.93304097392; %kg*m^2
Iyy = 25.58745481378; %kg*m^2
Izz = 25.58745481378; %kg*m^2
Ixy = 0;
Ixz = 0;
Iyz = 0;

% Mass Matrix
M11 = blkdiag(m,m,m);
M12 = zeros(3); %Trascuriamo che il centro di massa sia leggermente sotto il centro di galleggiamento
M21 = M12';
M22 = [Ixx -Ixy -Ixz;-Ixy Iyy -Iyz;-Ixz -Iyz Izz];
Mrb =[M11 M12;M21 M22]; %Matrice di massa

% Added Mass Matrix
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

%Mass Matrix complete (and Invert)
M = Mrb + Ma;
M_inv = inv(M);

%Thruster allocation Matrix
TAM1 = [0 0 1 1 0 0 0;0 0 0 0 0 1 1;1 1 0 0 1 0 0];
TAM2 = [0.15 -0.15 0 0 0 0 0;-0.6 -0.6 0 0 1.2 0 0;0 0 -0.2 0.2 0 -0.9 0.9];
TAM = [TAM1;TAM2];

%Drag Coeficients 
cd_x=0.4; 
cd_y=1; 
cd_z=1; 
cd_roll=0.04; 
cd_pitch=0.7; 
cd_yaw=0.7;
%Medium Radius for rotation 
r_mx = a/3; 
r_my = b/3; 
r_mz = c/3;
%Impact Areas 
S_x = b*c*pi; 
S_y = a*b*pi; 
S_z = a*c*pi;
S_roll = (r_my*r_mz)*pi; 
S_pitch = (r_mx*r_my)*pi; 
S_yaw = (r_mx*r_mz)*pi;

%Trusther positions (body frame)
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

%truster orientation 
orA = [0 0 1]; %asse z
orB = [0 0 1]; %asse z
orC = [1 0 0]; %asse x
orD = [1 0 0]; %asse x
orE = [0 0 1]; %asse z
orF = [0 1 0]; %asse y
orG = [0 1 0]; %asse y