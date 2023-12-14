function [transectPoints,turnPoints, orInTurn] = matricesWayPoints(vett, longer, shorter, dist, trans, rot, yaw)
% Funzione che genera le matrici contenenti tutti gli waypoints "standard",
% nel sdr locale allineato al primo transetto, sia sui transetti che per le
% virate
%
%   -vett: coordinate punto iniziale dell'area; 1x3 [m m m]
%   -longer, shorter: misure area da scansionare (maggiore e minore); [m]
%   -dist: distanza tra waypoints sullo stesso rettilineo; [m]
%   -trans: distanza tra transetti; [m]
%   -rot: indicatore per la direzione di moto
%   -yaw: angolo di yaw per orientazione di riferimento su traiettoria

    pts = [];
    count = 0; %Travelled transect number
    
    %Mathematical area management to ensure a complete scan
    %utilizzo completo lunghezza transetti
    if mod(longer,dist)==0
        longerRange = [0:dist:longer];
    else
        longerRange = [[0:dist:longer] [longer:longer]];
    end
    
    %impostazione numero di transetti da compiere
    if mod(shorter,trans) <= trans/2
        shorterRange =[0:trans:shorter];
    else
        shorterRange =[0:trans:shorter-mod(shorter,trans)+trans];
    end

    %Actual waypoints generation
    for short = shorterRange
        page = [];%transetto
        
        for  long = longerRange
            %waypoint ad ogni iterazione
            way = vett' + ned2Traj(yaw)'*[long; rot*short; 0];
            %aggiungo alla riga del transetto corrente
            page = cat(1,page,way');  
        end
        
        if mod(count,2) == 1
            %{
                even numbered transects are travelled "bottom-top",
                odd numbered transects are travelled "top-bottom"
            %}
            page = flip(page);
        end
        
        count = count+1;
 
        pts = cat(3,pts,page);%intera matrice, tutti i transetti
    end
    
    transectPoints = pts;
    [turnPoints, orInTurn] = virataWayPoints2();
    
    function [turnWayPoints, refOr] = virataWayPoints2()
    %Generazione di waypoint sulla traiettoria di riferimento durante la
    % fase di virata; si utilizza una curva semicircolare parametrizzata

        r = trans/2;
        nwp = 300;%numero waypoints che vogliamo generare nella virata
        t = 1/nwp:1/nwp:(1-1/nwp); %parametro, "normalizzato" solo per precisione numerica
        points = [];
        orients = [];

        s = size(transectPoints);
        
        %Generazione riferimenti di posizione per transetti e virate
        for n = [1:1:s(3)-1] %per ogni virata
            page2 = [];%per ogni virata
            pageOr = [];%per orientazione, per ogni virata

            for phi = t %parametri per generazione punti su una virata
                %waypoint in virata
                pt = transectPoints(s(1),:,n)' + ned2Traj(yaw)'*(rot*[0 r 0] + r*[((-1)^(n-1))*sin(pi*phi) cos(pi*phi) 0])';
                page2 = cat(1, page2, pt');
            end
            
            if rot == 1
                page2 = flip(page2);
            end
            
            %Generazione riferimenti di orientazione per le virate
            delta = 180/nwp:180/nwp:(180-180/nwp);
            if rot == 1
                if mod(n,2)~=0 %virate dispari
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw+delta')))];
                else %virate pari
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw+180-delta')))];
                end
            else %rot == -1
                if mod(n,2)~=0 %virate dispari
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw-delta')))];
                else %virate pari
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw+180+delta')))];
                end
            end
                
            points = cat(3, points, page2);
            orients = cat(3, orients, angles);
        end

        turnWayPoints = points;
        refOr = orients;

    end

end