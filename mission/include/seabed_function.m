
function sol_t = seabed_function(p_sonar_ned, s_versor_ned)
%%Description: function used to simulate the sonar sensors --> in this model we research the solution of the equation i.e the intersection between the seabed point and the line projected by the sonar. 
%%Inputs: p_sonar_ned = point descibing (in a simplified assumption) the sonar
%         versor_ned = versor indicating the direction of the sonar ray (3x1)

    global xfond4 yfond4 zfond4 tfond4 fondale 
    
    sonar = p_sonar_ned + tfond4*s_versor_ned;
    vars = [xfond4, yfond4, zfond4, tfond4];
    eqns = [fondale == zfond4; sonar == [xfond4; yfond4; zfond4]];
    
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
