%Description: Convert from WGS84 to NED frame
%Initial condition: 
lat0 =  42.317744; 
lon0 = 10.915136; 
h0=0; 
wgs84 = wgs84Ellipsoid;
format long
%  
[lat,lon,alt] = ned2geodetic(100,75,32,lat0,lon0,h0,wgs84)





