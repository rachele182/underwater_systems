disp('Loading Mission parameters...')

%% The area of interest is a rectangular area defind through a corner and sides towards North and East (this will not be modified)

areaOfInterestCorner = [42.317744;
                        10.915136]; % Lat/Lon [decimal degrees]
         
northSideLength = 200;              % [m]
eastSideLength = 150;               % [m]

averageDepth = 40;                  % [m]

%% Mission Parameters
% The area of the survey is a rectangular area defined through a corner,
% length and orientation (alpha w.r.t. North) of a side, length of the
% perpendicular side (orientation w.r.t. North is alpha + 90°)

initPoint = [ 42.317984;
              10.916219;
               0       ];           % Lat/Lon [decimal degrees], depth [m]
           
surveyAreaCorner = [42.318165;
                    10.915941];     % Lat/Lon [decimal degrees]
                
firstSideLength = 45;               % [m]
alpha = 30;                         % [deg]
secondSideLength = 25;              % [m]

altitude = 10;                      % [m]

lineSpaceBetweenTransects = 4;      % [m]

cruiseSpeed = 0.5;                  % [m/s]

disp('Done')