%% SENSORE USBL
function [bearing,elevation,range] = usbl(xNorth,yEast,zDown,roll,pitch,yaw)
%init
 [x_t_usbl,y_t_usbl,z_t_usbl]= rot_ned_body(xNorth,yEast,zDown,roll,pitch,yaw); 
 %coordinate sferiche in uscita dal sensore
 range = sqrt((x_t_usbl)^2+(y_t_usbl)^2+(z_t_usbl^2));
 elevation = asin(z_t_usbl/range);
 bearing = atan2(y_t_usbl,x_t_usbl);
end
