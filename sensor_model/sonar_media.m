% Navigation and Guide Systems Projet
% Master Degree in Robotics and Automation Engineering, Dipartimento di Ingegneria, Universita´ di Pisa
% Authors: Rachele Nebbia Colomba, Chiara Sammarco, Francesco Vezzi, Matteo Paiano
% copyright            : (C) 2021 Dipartimento di Ingegneria dell´Informazione (DII) // Universita´ di Pisa    
% email                : rachelenebbia <at> gmail <dot> com

function media = sonar_media (p_sonar_ned, s_versor_ned,s_versor_ned_1,s_versor_ned_2,s_versor_ned_3,s_versor_ned_4)
%%Description: model of sonar calculating an average of 5 consecutive points to obtain smooth profile
d_centrale = seabed_function (p_sonar_ned, s_versor_ned);
d1 = seabed_function (p_sonar_ned, s_versor_ned_1);
d2 = seabed_function (p_sonar_ned, s_versor_ned_2);
d3 = seabed_function (p_sonar_ned, s_versor_ned_3);
d4 = seabed_function (p_sonar_ned, s_versor_ned_4);
media = (d1+d2+d3+d4+d_centrale)/5; 

end

