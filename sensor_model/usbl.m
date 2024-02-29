% Underwater Systems Project
% Master Degree in Robotics and Automation Engineering, Dipartimento di Ingegneria, Universita´ di Pisa
% Authors: Rachele Nebbia Colomba, Chiara Sammarco, Francesco Vezzi, Matteo Paiano
% copyright            : (C) 2021 Dipartimento di Ingegneria dell´Informazione (DII) // Universita´ di Pisa    
% email                : rachelenebbia <at> gmail <dot> com

%% USBL Sensor
function [bearing,elevation,range] = usbl(xNorth,yEast,zDown,roll,pitch,yaw)
%init
 [x_t_usbl,y_t_usbl,z_t_usbl]= rot_ned_body(xNorth,yEast,zDown,roll,pitch,yaw); 
 %csphere coordinates --> USBL output 
 range = sqrt((x_t_usbl)^2+(y_t_usbl)^2+(z_t_usbl^2));
 elevation = asin(z_t_usbl/range);
 bearing = atan2(y_t_usbl,x_t_usbl);
end
