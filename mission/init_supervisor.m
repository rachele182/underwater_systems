 % Parametri interni al blocco Supervisor
 disp('Loading Supervisor parameters...');

%% Scelta lato maggiore e calcoli conseguenti
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

%% Elaborazioni di grandezze d'utilizzo
%Orientazioni sui transetti
orPari = wrapToPi([0 0 deg2rad(angle+180)]);
orDispari = wrapToPi([0 0 deg2rad(angle)]);

%Punto P
[pN, pE, pDepth] = geodetic2ned(initPoint(1), initPoint(2), initPoint(3),areaOfInterestCorner(1), areaOfInterestCorner(2), 0,wgs84Ellipsoid);
pointP = [pN, pE, 0.15];

%Punto A: in superficie come riferimento, sott'acqua per inizio scansioni
[aN, aE, ~] = geodetic2ned(surveyAreaCorner(1), surveyAreaCorner(2), 0, areaOfInterestCorner(1), areaOfInterestCorner(2), 0,wgs84Ellipsoid);
pointA = [aN, aE, 0.15];
orientA = [0, 0, wrapToPi(deg2rad(angle))];

%Matrice di rotazione per l'allineamento alla traiettoria iniziale
rotMatrix = ned2Traj(angle); %angolo in °

%Numero di transetti da compiere
nTran = floor(lesserSide/lineSpaceBetweenTransects) + ...
    (mod(lesserSide-lineSpaceBetweenTransects/2,lineSpaceBetweenTransects)~=0);

wpOffset = 2.5; %distanza tra waypoints standard; [m]

%Matrici di posizione degli waypoint in transetto e di posizione e orientazione
% degli waypoint in virata
[trWP, turnWP, turnRef] = matricesWayPoints([aN, aE, averageDepth - altitude], greaterSide, lesserSide, wpOffset, lineSpaceBetweenTransects,rot,angle);
nWPTran = size(trWP,1); %numero di waypoint per transetto
nWPTurn = size(turnWP,1); %numero di waypoint per virata

%parametri per indicizzazione matrici di waypoint
page = 1; %transetto/virata da compiere
wpTR = 1; %indice WP corrente sul transetto
wpTU = 1; %indice WP corrente in virata

%Calcolo angolo di orientazione per dirigersi da P ad A
paNED = pointA-pointP;
y = deg2rad(angle);%orientazione iniziale del veicolo calato in acqua
rotz = [[cos(y) sin(y) 0];
            [-sin(y) cos(y) 0];
            [0 0 1]];
paNED = rotz*paNED';
xb = [1;0;0];
val = xb'*paNED/(norm(xb)*norm(paNED));%coseno dell'angolo minore tra asse di surge e PA
if paNED(2)>=0
    orDes = wrapToPi(y+acos(val));
else
    orDes = wrapToPi(y-acos(val));
end

%Calcolo angolo di ritorno in P a fine missione
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

%% Parametri per i vari stati
%flag di stato corrente
current_state = [0 0 0 0 0 0 0 0];

%positioning
velPos = [0.5 0 0 0 0 0];

%diving
endDiv = 0.4 ; %misura indicante la parte terminale del tratto di immersione; [m]
velSub = [0 0 0.2 0 0 0];
velRidSub = [0 0 0 0 0 0]; 

%surfacing
velSurf = [-velSub(1:3) velSub(4:6)];

%transect
velTran = [cruiseSpeed 0 0 0 0 0]; %inizializzata a velocità di crociera su surge
velRid = [0.2 0 0 0 0 0]; %velocità ridotta per gli ultimi metri di tratti rettilinei

%WP d'emergenza
%margine di sicurezza di 2m
%distanza laterale tra WP d'emergenza di 0.5m
%rising time di 5s, velocità fissa a 0.2m/s -> 1m longitudinali per
%compiere 0.5m laterali ->4m long totali per tornare in transetto da 2m di
%distanza
%rising time e settling time con oscillazioni a 0.1m dal valore di riferimento
wpEmerg = [];
vEmergTran = [0.2 0.2 0.2 0 0 0];
%vEmergTurn = [0.2 0.2 0.2 0.0175 0.0175 0.0175];%1°/s
idxEmerg = 1;
distEmerg = 0.5; %distanza laterale tra WP d'emergenza; [m]
%dare due WP avanti come riferimento
%stringere errore di riconoscimento per ritorno in transetto?<=0.5m
%stringere precisione per ultimi 2 WP su transetto?1m
offset = 2; %distanza laterale oltre la quale effettuare riallineamento; [m]
offsetLast = 1;

%turn
velTurn = [0.2 0.2 0 0 0 0.2/(lineSpaceBetweenTransects/2)]; %10°/s 

%% Errori accettabili
errSphere = [1.5 1.5 1.5];

%durante positioning
errPosPos = [1 1 1];%[m m m]
errOrPos = [0.785398 0.785398 0.0872665]; % 45 deg 45 deg 5 deg
errVelPos = [0.05 0.05 0.05 0.0175 0.0175 0.0175];%1°/s

%durante diving
errPosDiv = [1 1 1];
errOrDiv = [0.3491 0.3491 0.0873];% 20 deg, 20 deg, 5 deg
errVelDiv = [0.05 0.05 0.05 0.0175 0.0175 0.0175]; %1°/s

%durante transetti
errPosTrans = [1 1 1];
errPosTransLast = [0.5 0.5 0.5];
errOrTrans = [0.261799 0.261799 0.174533]; % 15 deg 15 deg 10 deg
errVelTrans =  [0.1 0.1 0.1 0.0175 0.0175 0.0175];%1°/s

%durante virate
errPosTurn = [1 1 1];
errOrTurn = [0.261799 0.261799 0.174533];% 15 15 10
errVelTurn = [0.1 0.1 0.1 0.0175 0.0175 0.0175];

%durante surfacing
errPosSurf = errPosDiv;
errOrSurf = errOrDiv;
errVelSurf = [0.2 0.2 0.2 0.3491 0.3491 0.3491];

%per WP d'emergenza in transetto
errPosWPTrans = [0.5 0.2 0.2];
errOrWPTrans = [0.261799 0.261799 0.174533];%15 15 5
errVelWPTrans = [0.15 0.05 0.05 0.0175 0.0175 0.0175];%1 rad/s

%per WP d'emergenza in virata
errPosWPTurn= [1 1 1];
errOrWPTurn = [0.261799 0.261799 0.174533];% 15 deg, 15 deg, 5 deg
errVelWPTurn = [0.1 0.1 0.1 0.0175 0.0175 0.0175];

%% TEST OBSTACLE
tSalto = 8; %[s]
profGap = 4; %[m]

minGap = 1; %gap minimo per variare profondità; [m]
minDist = 2; %per ignorare "scoglietti"; [m]

bound = cruiseSpeed*tSalto; %da controllo: salto di 4m in 25s, quindi 
%distanza massima percorsa in tale tempo in condizioni ideali
distNeeded = bound*2; %per sicurezza, così da considerare fluidodinamica, correnti, etc...

maxRatio = profGap / distNeeded;

%misure del veicolo
a = 1.10; %[m]
b = 0.15; %[m] 
c = 0.15; %[m]

semix = a;
semiy = 0;
semiz = 0;
 
safeMargin = 0.5;

theta_f = 45;

%points = [];
%disp('	Supervisor loaded.');