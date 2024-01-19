%% Rotation from NED frame to body frame + translation for USBL transponder
function [x_t_usbl,y_t_usbl,z_t_usbl]= rot_ned_body(xNorth,yEast,zDown,roll,pitch,yaw)
 %Inputs:  yNorth,yEast,zDown = geodetic coordinates
 %         roll,pitch,ywa = euler angles expressing the orientation

 %Outputs: x_t_usbl,y_t_usbl,z_t_usbl = position of transponder in USBL frame 
 
 b2transp_ned = p_transponder-[xNorth;yEast;zDown]; %distance between trasponder and AUV (NED frame)
 %Compute rotation Matrix J1 from NED to BODY frame 
 Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
 Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
 Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
 J1 = Rx'*Ry'*Rz'; 
 transponder_body = J1*b2transp_ned; %transporter position in body frame
 transponder_usbl = transponder_body - p_usbl; %transporter position in USBL sensor frame
 x_t_usbl = transponder_usbl(1);
 y_t_usbl = transponder_usbl(2);
 z_t_usbl = transponder_usbl(3);
end 