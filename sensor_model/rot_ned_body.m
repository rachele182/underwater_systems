%% Rotazione da ned a body frame + traslazione in usbl frame
function [x_t_usbl,y_t_usbl,z_t_usbl]= rot_ned_body(xNorth,yEast,zDown,roll,pitch,yaw)
%  init
 b2transp_ned = p_transponder-[xNorth;yEast;zDown]; %vettore distanza trasponder - veicolo espresso in ned 
 Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
 Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
 Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
 J1 = Rx'*Ry'*Rz'; %matrice di rotazione da ned a body frame 
 transponder_body = J1*b2transp_ned; %posizione transponder in terna body 
 transponder_usbl = transponder_body - p_usbl;  %posizione trasponder in terna usbl 
 x_t_usbl = transponder_usbl(1);
 y_t_usbl = transponder_usbl(2);
 z_t_usbl = transponder_usbl(3);
end 