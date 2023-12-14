function  M = currentSwingWaypoints(puntoDes,puntoCorr,dist)
%Generazione di waypoint aggiuntivi supponendo di conoscere il punto finale
% desiderato sul transetto
%
%   -puntoDes: punto desiderato sulla traiettoria rettilinea; 1x3 [m m m]
%   -puntoCorr: punto stimato di posizione corrente; 1x3 [m m m]
%   -dist: distanza tra waypoint d'emergenza; [m]

    %lunghezza segmento
    lunghezza= sqrt((puntoCorr(1) - puntoDes(1))^2 +(puntoCorr(2)-puntoDes(2))^2 + (puntoCorr(3) - puntoDes(3))^2); 
    
    p = floor(lunghezza/dist); %numero waypoint
    
    distN = puntoCorr(1) - puntoDes(1); %distanza su N tra punto iniziale e finale
    distE = puntoCorr(2) - puntoDes(2); %distanza su E tra punto iniziale e finale
%     distD = puntoCorr(3) - puntoDes(3); %distanza su D tra punto iniziale e finale
    
    deltaE = distE/p; %distanza tra waypoints su East
    deltaN = distN/p; %distanza tra waypoints su North
%     deltaD = distD/p; %distanza tra waypoints su Down
    
    matrix = [];
   
    for i = 1:p-1 %possiamo fermarci a p-1 perché waypoint su traiettoria già fornito
        waypoint = puntoCorr - i * [deltaN deltaE puntoDes(3)];%deltaD];
        matrix = cat(1, matrix, waypoint);
    end
    %matrix = cat(2, matrix, puntoDes);
    M = matrix;   
   
end
