% Underwater Systems Project
% Master Degree in Robotics and Automation Engineering, Dipartimento di Ingegneria, Universita´ di Pisa
% Authors: Rachele Nebbia Colomba, Chiara Sammarco, Francesco Vezzi, Matteo Paiano
% copyright            : (C) 2021 Dipartimento di Ingegneria dell´Informazione (DII) // Universita´ di Pisa    
% email                : rachelenebbia <at> gmail <dot> com

function  sol_t = fondale_piatto(p_sonar_ned, s_versor_ned)
%% Flat seabed model
% Description: script file to validate sonar model in terms of rotation angles: pitch and roll 
%Inputs: p_sonar_ned: sensor position in NED frame
%        s_versor_ned: versor espressing sonar direction 
%Output: sol_t = solution of the intersection between sonar equation and FLAT seabed function 
syms x y z t
bat = 40; %batimetry
%Sonar model equation 
sonar = p_sonar_ned + t*s_versor_ned;
vars = [x, y, z, t];
eqns = [bat == z; sonar == [x; y; z]];

range = 300;

soluz = [];
    for n = 1:5
        [sol_x, sol_y, sol_z, sol_t] = vpasolve(eqns,vars,[NaN NaN; NaN NaN; NaN NaN; 0 range],'Random',true);
        sol_t = double(sol_t);
        soluz = [soluz sol_t];
        range = sol_t;
        if isempty(sol_t)
            soluz = [soluz 300];
            break;
        end
        
    end
sol_t = min(soluz);

end
