%% Mission A: Lawn-mower survey
%% Supervisor Module
%% Description: Here after all the parameters needed for thetrajectory definition and way-points interpolations

disp('Loading Supervisor parameters...');

%% Choice of larger side 
if(firstSideLength >= secondSideLength)
    greaterSide = firstSideLength;
    lesserSide = secondSideLength;
    angle = alpha; 
    rot = 1; %movimento con prima virata CW
else
    greaterSide = secondSideLength;
    lesserSide = firstSideLength;
    angle = alpha + 90;
    rot = -1; %movimento con prima virata CCW
end

%Orientations on the transects
orPari = wrapToPi([0 0 deg2rad(angle+180)]);
orDispari = wrapToPi([0 0 deg2rad(angle)]);

%Point P
[pN, pE, pDepth] = geodetic2ned(initPoint(1), initPoint(2), initPoint(3),areaOfInterestCorner(1), areaOfInterestCorner(2), 0,wgs84Ellipsoid);
pointP = [pN, pE, 0.15];

%Point A: on the surface as initiali condition
[aN, aE, ~] = geodetic2ned(surveyAreaCorner(1), surveyAreaCorner(2), 0, areaOfInterestCorner(1), areaOfInterestCorner(2), 0,wgs84Ellipsoid);
pointA = [aN, aE, 0.15];
orientA = [0, 0, wrapToPi(deg2rad(angle))];

%Rotation Matrix to get initial rotation 
rotMatrix = ned2Traj(angle); %angle in °

%Number of transects 
nTran = floor(lesserSide/lineSpaceBetweenTransects) + ...
    (mod(lesserSide-lineSpaceBetweenTransects/2,lineSpaceBetweenTransects)~=0);

wpOffset = 2.5; %standard distance between transect; [m]

%Matrices of position+orientation for waypoints on the transects
[trWP, turnWP, turnRef] = matricesWayPoints([aN, aE, averageDepth - altitude], greaterSide, lesserSide, wpOffset, lineSpaceBetweenTransects,rot,angle);
nWPTran = size(trWP,1); %number of waypoints for each transect
nWPTurn = size(turnWP,1); %number of waypoints for each turn

%parameters 
page = 1; %transect/turn
wpTR = 1; %current WP index on the transect
wpTU = 1; %current WP index on the turn

%Orientation angle calculation to go from P to A point 
paNED = pointA-pointP;
y = deg2rad(angle);%initial orientation vehicle 
rotz = [[cos(y) sin(y) 0];
            [-sin(y) cos(y) 0];
            [0 0 1]];
paNED = rotz*paNED';
xb = [1;0;0];
val = xb'*paNED/(norm(xb)*norm(paNED));
if paNED(2)>=0
    orDes = wrapToPi(y+acos(val));
else
    orDes = wrapToPi(y-acos(val));
end

%Calculcation of return angle P at the end 
puntoFin = trWP(nWPTran,:,size(trWP,3));
paNEDrit = pointP - [puntoFin(1),puntoFin(2),0.15];
if mod(size(trWP,3),2) == 0
    yrit = deg2rad(angle+180);
else
    yrit = deg2rad(angle);
end
rotzrit = [[cos(yrit) sin(yrit) 0];
            [-sin(yrit) cos(yrit) 0];
            [0 0 1]];
paNEDrit = rotz*paNEDrit';
xb = [1;0;0];
valrit = xb'*paNEDrit/(norm(xb)*norm(paNEDrit));
if mod(nTran,2)~=0
    if paNEDrit(2)>=0
        orDesRit = wrapToPi(yrit+acos(valrit));%+pi?
    else
        orDesRit = wrapToPi(yrit-acos(valrit));
    end
else
    if paNEDrit(2)>=0
        orDesRit = wrapToPi(yrit+acos(valrit)+pi);%+pi?
    else
        orDesRit = wrapToPi(yrit-acos(valrit)+pi);
    end
end

%% Parameters to detect the current stace 
%Current state flag 
current_state = [0 0 0 0 0 0 0 0];

%positioning
velPos = [0.5 0 0 0 0 0];

%diving
endDiv = 0.4 ; %diving tract [m]
velSub = [0 0 0.2 0 0 0];
velRidSub = [0 0 0 0 0 0]; 

%surfacing
velSurf = [-velSub(1:3) velSub(4:6)];

%transect
velTran = [cruiseSpeed 0 0 0 0 0]; %initialization of cruise velocity
velRid = [0.2 0 0 0 0 0]; %reduced velocity 

%Emergency WP 
%security margin of 2m
%security lateral distance between waypoints of 0.5m
%rising time of 5s, fixed velocity of 0.2m/s -> 1m longitudinali per
%compiere 0.5m laterali ->4m long totali per tornare in transetto da 2m di
%distanza
%rising time e settling time con oscillazioni a 0.1m dal valore di riferimento
wpEmerg = [];
vEmergTran = [0.2 0.2 0.2 0 0 0];
%vEmergTurn = [0.2 0.2 0.2 0.0175 0.0175 0.0175];%1°/s
idxEmerg = 1;
distEmerg = 0.5; %lateral distance between emergency WP; [m]
%give two WPs as reference 
offset = 2; %max distance, above this start re-alling manuever; [m]
offsetLast = 1;

%turn
velTurn = [0.2 0.2 0 0 0 0.2/(lineSpaceBetweenTransects/2)]; %10°/s 

%% Errori accettabili
errSphere = [1.5 1.5 1.5];

%positioning
errPosPos = [1 1 1];%[m m m]
errOrPos = [0.785398 0.785398 0.0872665]; % 45 deg 45 deg 5 deg
errVelPos = [0.05 0.05 0.05 0.0175 0.0175 0.0175];%1°/s

%diving
errPosDiv = [1 1 1];
errOrDiv = [0.3491 0.3491 0.0873];% 20 deg, 20 deg, 5 deg
errVelDiv = [0.05 0.05 0.05 0.0175 0.0175 0.0175]; %1°/s

%transect phase 
errPosTrans = [1 1 1];
errPosTransLast = [0.5 0.5 0.5];
errOrTrans = [0.261799 0.261799 0.174533]; % 15 deg 15 deg 10 deg
errVelTrans =  [0.1 0.1 0.1 0.0175 0.0175 0.0175];%1°/s

%turns
errPosTurn = [1 1 1];
errOrTurn = [0.261799 0.261799 0.174533];% 15 15 10
errVelTurn = [0.1 0.1 0.1 0.0175 0.0175 0.0175];

%surfacing
errPosSurf = errPosDiv;
errOrSurf = errOrDiv;
errVelSurf = [0.2 0.2 0.2 0.3491 0.3491 0.3491];                               

%emergency WP transect
errPosWPTrans = [0.5 0.2 0.2];
errOrWPTrans = [0.261799 0.261799 0.174533];%15 15 5
errVelWPTrans = [0.15 0.05 0.05 0.0175 0.0175 0.0175];%1 rad/s

%emergency WP during turns
errPosWPTurn= [1 1 1];
errOrWPTurn = [0.261799 0.261799 0.174533];% 15 deg, 15 deg, 5 deg
errVelWPTurn = [0.1 0.1 0.1 0.0175 0.0175 0.0175];

%% TEST OBSTACLE
tSalto = 8; %[s]
profGap = 4; %[m]

minGap = 1; %minimum gap to modify depth; [m]
minDist = 2; %minimum distance to ignore transects; [m]

bound = cruiseSpeed*tSalto; 
distNeeded = bound*2; 

maxRatio = profGap / distNeeded;

%AUV parameters 
a = 1.10; %[m]
b = 0.15; %[m] 
c = 0.15; %[m]

semix = a;
semiy = 0;
semiz = 0;
 
safeMargin = 0.5;

theta_f = 45;

%points = [];
disp('	Supervisor loaded.');