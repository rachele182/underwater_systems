%% Seabed function --> sonar down
function sol_t = seabed_function(p_sonar_ned,s_versor_ned)
    global xfond4 yfond4 zfond4 tfond4 fondale 
    
    %% Modellazione sonar 
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
            soluz = [soluz 300]; %in caso di nessuna soluzione restituisce il fondoscala del sensore
            break;
        end
        
    end
sol_t = min(soluz); %distanza in uscita dal sonar 
      

end

