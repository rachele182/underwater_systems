function [p_sonar_ned, s_versor_ned] = rot_body_ned(xNorth,yEast,zDown,roll,pitch,yaw,tilt,p_sonar_body)
 
 %Inputs:  yNorth,yEast,zDown = geodetic coordinates
 %         roll,pitch,ywa = euler angles expressing the orientation
 %         tilt,psonar_body,beam_wodth = parameters sonar 
 %Outputs: p_sonar_ned,s_versor_ned = position and versor of sensor in NED frame 

 %Compute J1 = rotation matrix from body to ned Frame
 Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
 Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
 Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
 J1 = Rz*Ry*Rx; %matrice di rotazione da body a ned frame 
 
 %from NED frame to BODY frame 
 s_versor_body = [sin(tilt); 0 ; cos(tilt)];	%sonar direction in body frame 
 
 %central beam versors 
 s_versor_ned = J1*s_versor_body;
 cs2sensor_ned = J1*p_sonar_body; %distnce between sensor and CDS in ned frame
 %central beam point 
 p_sonar_ned = [xNorth; yEast; zDown] + cs2sensor_ned;
 
end


