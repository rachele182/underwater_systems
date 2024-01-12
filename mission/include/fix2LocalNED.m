function rot = fix2LocalNED(phi, theta, psi)
% Description: compute rotation matrix (RPY) from fixed to local frame

%%Inputs: 
%   -phi:   rotation angle axis x
%   -theta: rotation angle axis y
%   -psi:   rotation angle axis z
%%Output:
%   -rot = rotation matrix 

    r = deg2rad(phi);
    p = deg2rad(theta);
    y = deg2rad(psi);

    rotx = [[1 0 0];
            [0 cos(r) sin(r)];
            [0 -sin(r) cos(r)]];
        
    roty = [[cos(p) 0 -sin(p)];
            [0 1 0];
            [sin(p) 0 cos(p)]];
        
    rotz = [[cos(y) sin(y) 0];
            [-sin(y) cos(y) 0];
            [0 0 1]];
        
    rot = rotx*roty*rotz;

end