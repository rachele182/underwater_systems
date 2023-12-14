%% Questo script carica nel workspace i parametri necessari per la navigazione
disp('Loading Navigation parameters...')

%% Parametri missione
ned_origin = [42.317744; 10.915136 ; 0];	% LLA dell'origine terna ned
pos_transp = p_transponder;					% NED del transponder USBL

%% Parametri sensori

% deviazione std
cov_gps		= var_gps';				
cov_usbl	= var_usbl([1,3])';		
cov_depth	= var_profondimetro';
cov_ahrs	= var_ahrs';
cov_dvl		= var_dvl';	

%% Parametri filtro

ts_filter = 0.05;		% Sampling Time del filtro

% Dimensioni
n_state_filter = 3;		% dim spazio di stato
n_input_filter = 6;		% dim ingresso filtro
n_state_aug_filter = n_state_filter + n_input_filter;
						% dim stato aumentato
n_meas_filter = 5;		% dim spazio misure


% R matrice covarianza sensori misura. ordine: depth, gps, usbl
R = [cov_gps cov_usbl cov_depth];
R_meas = diag(R);    

% Q matrice covarianza sensori ingressi. roll pitch yaw vx vy vz
Q = [cov_ahrs cov_dvl];
Q_ingressi = diag(Q);

% Matrice covarianza stato iniziale
initial_state_cov = blkdiag(diag(cov_gps(1,1:2)), cov_depth*eye(n_state_filter-2));


% Spheroid for geo2ned function
spheroid = wgs84Ellipsoid;