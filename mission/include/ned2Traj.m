function rot = ned2Traj(ang)
%Rotation matrix describing the transformation from the local reference
%system onto the trajectory to the general NED reference system,
%considering a simple yaw rotation
%
%   -ang: yaw angle; [°]

        a = deg2rad(ang);
        rot = [cos(a) sin(a) 0; 
               -sin(a) cos(a) 0;
                 0 0 1];
end