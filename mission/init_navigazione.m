%% Navigation filter
% Description: here all the parameters used for the navigation filter of the AUV are loaded 
disp('Loading Navigation parameters...')

%% Parametri missione
ned_origin = [42.317744; 10.915136 ; 0];	% LLA ned frame origine
pos_transp = p_transponder;					% transponder position (NED frame)

%% Sensors parameters

% standard devations
cov_gps		= var_gps';				
cov_usbl	= var_usbl([1,3])';		
cov_depth	= var_profondimetro';
cov_ahrs	= var_ahrs';
cov_dvl		= var_dvl';	

%% Filter parameters

ts_filter = 0.05;		% Sampling Time 

% Dimensions
n_state_filter = 3;		% dim space-state
n_input_filter = 6;		% dim filter input 
n_state_aug_filter = n_state_filter + n_input_filter;
						% dim augmented state
n_meas_filter = 5;		% dim measurement space 

% R covariant matrix sensors, order: depth, gps, usbl
R = [cov_gps cov_usbl cov_depth];
R_meas = diag(R);    

% Q covariant matrix inpits, order: roll pitch yaw vx vy vz
Q = [cov_ahrs cov_dvl];
Q_ingressi = diag(Q);

% Covariant matrix initial state 
initial_state_cov = blkdiag(diag(cov_gps(1,1:2)), cov_depth*eye(n_state_filter-2));

% Spheroid for geo2ned function
spheroid = wgs84Ellipsoid;