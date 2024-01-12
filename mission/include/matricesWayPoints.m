function [transectPoints,turnPoints, orInTurn] = matricesWayPoints(vett, longer, shorter, dist, trans, rot, yaw)
% Description: generation of waypoint matrix with frame alligned to first transectfor all type of trajectory: transects+turns

%%Inputs: 
%   -vett: initial coordinates; 1x3 [m m m]
%   -longer, shorter: measureas of survey ares [m]
%   -dist: distance between waypoints on the same linear tract [m]
%   -trans: transects distance; [m]
%   -rot: idex for moto direction
%   -yaw: yw angle for orientation trajectory

%%Output:
%  M = waypoint matrix

    pts = [];
    count = 0; %Travelled transect number
    
    %Mathematical area management to ensure a complete scan
    %complete usage of transects length 
    if mod(longer,dist)==0
        longerRange = [0:dist:longer];
    else
        longerRange = [[0:dist:longer] [longer:longer]];
    end
    
    %set number of transect to complete
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
 
        pts = cat(3,pts,page);%full matrix, all transects
    end
    
    transectPoints = pts;
    [turnPoints, orInTurn] = virataWayPoints2();
    
    function [turnWayPoints, refOr] = virataWayPoints2()
    %Waypoint generation on the turn (`virata`); we use a paramterized semi-circular trajectory

        r = trans/2;
        nwp = 300;%number of waypoints in the turns 
        t = 1/nwp:1/nwp:(1-1/nwp); %normalized parameter (to reach numerical precision)
        points = [];
        orients = [];

        s = size(transectPoints);
        
        %Generation of reference position points and turns 
        for n = [1:1:s(3)-1] %for each turn 
            page2 = [];%for each turn 
            pageOr = [];%for orientation, for each turn 

            for phi = t %parameters to generate points on a turn
                %waypoint for turns
                pt = transectPoints(s(1),:,n)' + ned2Traj(yaw)'*(rot*[0 r 0] + r*[((-1)^(n-1))*sin(pi*phi) cos(pi*phi) 0])';
                page2 = cat(1, page2, pt');
            end
            
            if rot == 1
                page2 = flip(page2);
            end
            
            %Generation of orientation reference point during turns
            delta = 180/nwp:180/nwp:(180-180/nwp);
            if rot == 1
                if mod(n,2)~=0 %odd turns
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw+delta')))];
                else %even turns
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw+180-delta')))];
                end
            else %rot == -1
                if mod(n,2)~=0 %odd turns
                    angles = [zeros(nwp-1,1) zeros(nwp-1,1) rad2deg(wrapToPi(deg2rad(yaw-delta')))];
                else %even turns
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