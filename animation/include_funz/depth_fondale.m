function z = depth_fondale(x,y)
% questa funzione calcola la profondita` data una posizione in Nord East
mu = [100, 75];
sigma = 50*[1,0; 0,3];
z = 2500*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
mu = [160, 130];
sigma = 50*[1,0;0,2];
z = z + 2500*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
mu = [90, 30];
sigma = 140*[10,0;0,2];
z = z - 30000*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
mu = [50, 120];
sigma = 140*[10,0;0,2];
z = z + 30000*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
z = z + 2.5*cos((sin(x/20)*sin(0.05*x-0.05*(150 - y))+5*cos(0.1*x+0.2*(150 - y)))/5) - 40;
z = - z;

end