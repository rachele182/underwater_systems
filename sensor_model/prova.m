
xNorth = 100;
yEast = 75;
zDown = 0;
roll = 0*pi/180;
pitch = 0*pi/180;
yaw = 0*pi/180;

[p_sonar_ned, s_versor_down,s_versor_ned_down_1,s_versor_ned_down_2,s_versor_ned_down_3,s_versor_ned_down_4] = rot_body_ned(xNorth,yEast,zDown,roll,pitch,yaw,tilt_down,p_sonar_down,beam_width);
% sol_t_down = seabed_function(p_sonar_down,s_versor_down);


media = sonar_media (p_sonar_ned,s_versor_down,s_versor_ned_down_1,s_versor_ned_down_2,s_versor_ned_down_3,s_versor_ned_down_4)

% [p_sonar_front, s_versor_front] = rot_body_ned(xNorth,yEast,zDown,roll,pitch,yaw,tilt_front,p_sonar_front);
% sol_t_front = seabed_function(p_sonar_front, s_versor_front)