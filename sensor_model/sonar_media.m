function media = sonar_media (p_sonar_ned, s_versor_ned,s_versor_ned_1,s_versor_ned_2,s_versor_ned_3,s_versor_ned_4)
d_centrale = seabed_function (p_sonar_ned, s_versor_ned);
d1 = seabed_function (p_sonar_ned, s_versor_ned_1);
d2 = seabed_function (p_sonar_ned, s_versor_ned_2);
d3 = seabed_function (p_sonar_ned, s_versor_ned_3);
d4 = seabed_function (p_sonar_ned, s_versor_ned_4);
media = (d1+d2+d3+d4+d_centrale)/5; 

end

