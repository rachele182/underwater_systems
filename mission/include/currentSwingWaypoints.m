function  M = currentSwingWaypoints(puntoDes,puntoCorr,dist)
% Description: generation of added waypoints assuming to know the final desired point on the transect

%%Inputs: 
%   -puntoDes: desired point on the trajectory; 1x3 [m m m]
%   -puntoCorr: estimated current point; 1x3 [m m m]
%   -dist: distance between emergeny waypoints; [m]
%%Output:
%    M = waypoint matrix

    %segment length 
    lunghezza= sqrt((puntoCorr(1) - puntoDes(1))^2 +(puntoCorr(2)-puntoDes(2))^2 + (puntoCorr(3) - puntoDes(3))^2); 
    
    p = floor(lunghezza/dist); %waypoint number
    
    distN = puntoCorr(1) - puntoDes(1); %distance on N axis between initial and final point 
    distE = puntoCorr(2) - puntoDes(2); %distance on E axis between initial and final point 
%     distD = puntoCorr(3) - puntoDes(3); %distance on D axis between initial and final point 
    
    deltaE = distE/p; %waypoints distance on East
    deltaN = distN/p; %waypoints distance on North
%     deltaD = distD/p; %distanza tra waypoints su Down
    
    matrix = [];
   
    for i = 1:p-1 
        waypoint = puntoCorr - i * [deltaN deltaE puntoDes(3)];%deltaD];
        matrix = cat(1, matrix, waypoint);
    end
    %matrix = cat(2, matrix, puntoDes);
    M = matrix;   
   
end
