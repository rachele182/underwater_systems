%% Script animazione
% This script execute the complete animation of a mission of the AUV
% it is possible to execute it by loading .mat file or by having saved in the folder an uotupt of the simulation (from simulink file)

addpath('include_funz');
%clear all
load('out_mission_default.mat')
clearvars -except out 

%% data init, load values
pos = zeros(size(out.pos.signals.values,1), size(out.pos.signals.values,3));
for i = 1:size(out.pos.signals.values,3)
	pos(:,i) = out.pos.signals.values(:,1,i);
end

fls_down = zeros(size(out.fls_down.signals.values,1), size(out.fls_down.signals.values,3));
for i = 1:size(out.fls_down.signals.values,3)
	fls_down(:,i) = out.fls_down.signals.values(:,1,i);
end

fls_front = zeros(size(out.fls_front.signals.values,1), size(out.fls_front.signals.values,3));
for i = 1:size(out.fls_front.signals.values,3)
	fls_front(:,i) = out.fls_front.signals.values(:,1,i);
end

orient = zeros(size(out.orient.signals.values,1),size(out.orient.signals.values,3));
for i = 1:size(out.orient.signals.values,3)
	orient(:,i) = out.orient.signals.values(:,1,i);
end
rotPlot = zeros(3,3,size(out.orient.signals.values,3) );
for i = 1:size(out.orient.signals.values,3)
	rotPlot(:,:,i) = eul2rotm(orient(:,i)', 'XYZ') * rotx(pi);
end


% Sonar values 
p_sonar_down = [0;0;0.15]; 
p_sonar_front = [1.1000;0;0];

% surf generation
passo_mesh = 0.5;
x_surf_max = ceil(max(pos(1,:))) + 25;
x_surf_min = floor(min(pos(1,:))) - 25;
y_surf_max = ceil(max(pos(2,:))) + 25;
y_surf_min = floor(min(pos(2,:))) - 25;

[X_nord,Y_est] = meshgrid(	x_surf_min:passo_mesh:x_surf_max,...
							y_surf_min:passo_mesh:y_surf_max);

Z_down = arrayfun(@(x,y) depth_fondale(x,y), X_nord, Y_est);

%% Animation parameters 
rate_anim = 100;			% rate of animation execution
t0 = 1;						% initial time
tend = size(pos,2);			% final time of animation 
length_sist_rif = 2;		% lenghts of reference systems
View = [30 20];				% initial view 
Spin = 0;					% variation of view angle (longitudianl)[degree]
ang_cono = deg2rad(15/2);	% angle of sonar cone fls_down

% show_impostazioni
sist_body_show		= 1;	% flag to print reference system body		
traiettoria_show	= 1;	% flag to print trajectrory
coni_show			= 1;	% flag to print cones (sonars)

scale_pasqualo = 3;			% scale to plot AUV 

%% Animation code
figure(1)
clf 
set(	gca, 'drawmode', 'fast');
		lighting phong;
		set(gcf, 'Renderer', 'zbuffer');

% surface
fondale = surf(X_nord,Y_est,-Z_down,-Z_down,'EdgeColor', 'none', 'FaceAlpha',1);

% Load AUV model 
stl_offset = [-1.1; -0.15; -0.15];
p_veicolo = patch(stlread('veicolo.stl'));
T_veicolo = hgmat(rotx(pi)/1000*scale_pasqualo, [0 0 0]');
t_veicolo = hgtransform('Parent',gca);
set(t_veicolo,'Matrix',T_veicolo);
set(p_veicolo,'Parent',t_veicolo);
set(p_veicolo, 'facec', [255,191,0]./255);             % Set the face color (force it)
set(p_veicolo, 'EdgeColor', 'none'); 

hold on
colormap(gca, winter)
%colormap(yellow)    % change color map

for t = t0:rate_anim:tend
	% init animaz
	if t ~= t0
		child_each_plot = sist_body_show*3 + traiettoria_show*2 + coni_show*2;
		unplot(child_each_plot) ;
	end
	
	% update vectors_now
	fls_down_now = fls_down(:,t);	% lettura sonar down
	fls_front_now = fls_front(:,t);	% lettura sonar front
	pos_now = pos(:,t);				% posizione PAsqualo
	pos_now(3) = -pos_now(3);		% correzione per plot
	pos_tillnow = pos(:,1:t);		% vett posizioni fino ad adesso
	rot_body_now = rotPlot(:,:,t);	% orientazione
	
	if sist_body_show == 1
		% quivers body
		qx = rot_body_now * [length_sist_rif; 0; 0];
		qy = rot_body_now * [0; length_sist_rif; 0];
		qz = rot_body_now * [0; 0; length_sist_rif];
	end
	
	if coni_show == 1
		pos_fls_down	= pos_now + rot_body_now * p_sonar_down;
		delta_fls_down	= rot_body_now * [0; 0; 1] * fls_down_now;
		pos_fls_down_end = pos_fls_down + delta_fls_down;

		r_cono_finale_down = fls_down_now * tan(ang_cono);

		pos_fls_front	= pos_now + rot_body_now * p_sonar_front;
		delta_fls_front	= rot_body_now * [1; 0; 1]/sqrt(2) * fls_front_now * 1.1; 
		pos_fls_front_end = pos_fls_front + delta_fls_front;

		r_cono_finale_front = fls_down_now * 1.1 * tan(ang_cono);
	end
	% plot config
	axis equal;
    grid on;
	hold on
    view(View(1, 1) + Spin * t/tend, View(1, 2));
	xlabel('Nord [m]');
	ylabel('Est [m]');
	zlabel('Alt [m]');
	Title = ['PAsqualo Animazione (frame ', num2str(t), ' di ', num2str(tend), ')'];
	title(Title)
	
	% §D elements 
	if traiettoria_show == 1
		% trajectory
		plot3(pos_tillnow(1,:),pos_tillnow(2,:),-pos_tillnow(3,:),...
			'-','Color', [0.2 0.2 1],'LineWidth',1.5);

		% trajectory on seabed 
		plot3(pos_tillnow(1,:),pos_tillnow(2,:),...
			-arrayfun(@(x,y) depth_fondale(x,y), pos_tillnow(1,:), pos_tillnow(2,:)),...
			'-','Color',[0.9 0.9 0.9],'LineWidth',0.5);
	end
	
	% veihicle
	T_veicolo_now = hgmat(rot_body_now/1000*scale_pasqualo,...
				pos_now + rot_body_now * scale_pasqualo * stl_offset);
	set(t_veicolo,'Matrix',T_veicolo_now);
	
	if sist_body_show == 1
		% quivers	
		quiver3(pos_now(1),pos_now(2),pos_now(3),...
				qx(1),qx(2),qx(3), 'r', 'ShowArrowHead', false)	% x body
		quiver3(pos_now(1),pos_now(2),pos_now(3),...
				qy(1),qy(2),qy(3), 'g', 'ShowArrowHead', false)	% y-body
		quiver3(pos_now(1),pos_now(2),pos_now(3),...
				qz(1),qz(2),qz(3), 'b', 'ShowArrowHead', false)	% z-body
	end
 	
	if coni_show == 1
		% cone for sonar down
		Cone(pos_fls_down', pos_fls_down_end',...
			[0,r_cono_finale_down], 15, [0.8 0.8 0.8], 0, 0)

		% cone for sonar front
		Cone(pos_fls_front', pos_fls_front_end',...
			[0,r_cono_finale_front], 15, [0.9 0.9 0.9], 0, 0)
	end
	
	% end stuff	
	axis equal;
	grid on;
	drawnow;
end