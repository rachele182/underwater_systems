%% Rotazione da body a Ned frame + posizione sonar in Ned frame
function [p_sonar_ned, s_versor_ned] = rot_body_ned(xNorth,yEast,zDown,roll,pitch,yaw,tilt,p_sonar_body)
 
%init
 
 Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
 Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
 Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
 J1 = Rz*Ry*Rx; %matrice di rotazione da body a ned frame 


 s_versor_body = [sin(tilt); 0 ; cos(tilt)];	% direzione sonar in terna body
 

 % versore beam centrale
 s_versor_ned = J1*s_versor_body;
 
 
 
 cs2sensor_ned = J1*p_sonar_body; % distanza cds-sensore in Ned
 
 
 %Posizione sensore in Ned frame:
 p_sonar_ned = [xNorth; yEast; zDown] + cs2sensor_ned;
 
end


