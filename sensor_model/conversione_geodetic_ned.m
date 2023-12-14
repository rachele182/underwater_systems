%Carico le condizioni iniziali 
% init
%%%Conversione da  WGS84 a NED frame
lat0 =  42.317744; 
lon0 = 10.915136; 
h0=0; 
wgs84 = wgs84Ellipsoid;
%Posizione corrente (per prova):
% lat = 42.317746;
% lon = 10.9152; 
% h = 0; %[m]
format long
%  
[lat,lon,alt] = ned2geodetic(100,75,32,lat0,lon0,h0,wgs84)





