%% VALIDAZIONE SONAR DOWN
%Profilo fondale 

function bat = Validazione_sonar(posizione)

 syms x y t z real
    mu = [100, 75];
    sigma = 50*[1,0; 0,3];
    fondale = 2500*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
    mu = [160, 130];
    sigma = 50*[1,0;0,2];
    fondale = fondale + 2500*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
    mu = [90, 30];
    sigma = 140*[10,0;0,2];
    fondale = fondale - 30000*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
    mu = [50, 120];
    sigma = 140*[10,0;0,2];
    fondale = fondale + 30000*exp(-0.5*([x, 150 - y] - mu)*inv(sigma)*([x, 150 - y] - mu)')/(2*pi*sqrt(det(sigma)));
    fondale = fondale + 2.5*cos((sin(x/20)*sin(0.05*x-0.05*(150 - y))+5*cos(0.1*x+0.2*(150 - y)))/5) - 40;
    fondale = - fondale;
    
    
    x = posizione(1);
    y = posizione(2);
    bat = double(subs(fondale));
end
