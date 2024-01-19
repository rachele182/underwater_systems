 function [p_sonar_ned, s_versor_ned,s_versor_ned_1,s_versor_ned_2,s_versor_ned_3,s_versor_ned_4] = rot_body_ned_media(xNorth,yEast,zDown,roll,pitch,yaw,tilt,p_sonar_body,beam_width)
 
 %% Description: function to obtain the "medium" point between points calculated by sonar
 %Inputs: yNorth,yEast,zDown = geodetic coordinates
 %        roll,pitch,ywa = euler angles expressing the orientation
 %        til,psonar_body,beam_wodth = parameters sonar 

 %Compute J = rotation matrix from body to ned Frame
 Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
 Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
 Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
 J1 = Rz*Ry*Rx; 
 
 s_versor_body = [sin(tilt); 0 ; cos(tilt)];%versor of central point (body frame )
 % Versor sonar beam rays (4 beams)
 Rx_beam_minus = [1 0 0; 0 cos(beam_width/2) -sin(beam_width/2); 0 sin(beam_width/2) cos(beam_width/2)];
 Rx_beam_plus = [1 0 0; 0 cos(-beam_width/2) -sin(-beam_width/2); 0 sin(-beam_width/2) cos(-beam_width/2)];
 Ry_beam_minus = [cos(beam_width/2) 0 sin(beam_width/2); 0 1 0; -sin(beam_width/2) 0 cos(beam_width/2)];
 Ry_beam_plus = [cos(-beam_width/2) 0 sin(-beam_width/2); 0 1 0; -sin(-beam_width/2) 0 cos(-beam_width/2)];
 s_versor_body_1 = Rx_beam_minus*s_versor_body;
 s_versor_body_2 = Rx_beam_plus*s_versor_body;
 s_versor_body_3 = Ry_beam_minus*s_versor_body;
 s_versor_body_4 = Ry_beam_plus*s_versor_body;  
 %From body to ned frame
 s_versor_ned = J1*s_versor_body; % versore beam centrale sonar in terna ned 
 s_versor_ned_1 = J1*s_versor_body_1;
 s_versor_ned_2 = J1*s_versor_body_2;
 s_versor_ned_3 = J1*s_versor_body_3;
 s_versor_ned_4 = J1*s_versor_body_4;
 cs2sensor_ned = J1*p_sonar_body; 
 %position of sensor in ned frame 
 p_sonar_ned = [xNorth; yEast; zDown] + cs2sensor_ned;

end

