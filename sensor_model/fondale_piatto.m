%% Fondale piatto
% Validazione sonar per angoli di orientazione di pitch and roll
function  sol_t = fondale_piatto(p_sonar_ned, s_versor_ned)
syms x y z t
bat = 40; %batimetria 

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
