%% Script plot2D
% Questo script esegue il plot di una missione compiuta da PAsqualo 
% caricando un file.mat o avendo in memoria un output di simulazione.
% Fatto da: Gruppo Navigazione

% Aggiornato 10 Giugno 19:03
addpath('include_funz');

%run main_init.m

%load('L:\sub_navigation\TeamA PAsqualo\plot_animazione\out_mission_default_fix_timescale.mat')
load('out_prova_velalta+corrente.mat')
%% plots init

%pos_transp = [100;75;33.7943];

pos = zeros(size(out.pos.signals.values,1), size(out.pos.signals.values,3));
for i = 1:size(out.pos.signals.values,3)
	pos(:,i) = out.pos.signals.values(:,1,i);
end
pos_true = zeros(size(out.pos_true.signals.values,1), size(out.pos_true.signals.values,3));
for i = 1:size(out.pos_true.signals.values,3)
	pos_true(:,i) = out.pos_true.signals.values(:,1,i);
end

% GPS = [];
% for i = 1:size(out.GPS.signals.values,3)
% 	if norm(out.GPS.signals.values(:,1,i),2) < 1e5
% 		GPS = [GPS, out.GPS.signals.values(:,1,i)];
% 	end
% end
% USBL = zeros(size(out.USBL.signals.values,2), size(out.pos.signals.values,1));
% for i = 1:size(out.USBL.signals.values,1)
% 	USBL(:,i) = out.USBL.signals.values(i,:);
% end

cov = out.poscov.signals.values;

%% covariance plot + real meas
figure(1)
clf

hold on
for i = 1:2:min(size(out.poscov.signals.values,3),200)
	%plotEllipses(pos([2,1],i)', 3*[sqrt(cov(2,2,i)), sqrt(cov(1,1,i))]);
end

%plot area of survey interest
[pointRec(1),pointRec(2),~] = geodetic2ned(...
	surveyAreaCorner(1), surveyAreaCorner(2), 0 ,...
	areaOfInterestCorner(1), areaOfInterestCorner(2), 0,...
	wgs84Ellipsoid);


rect_first_side = (firstSideLength/2).*[sin(deg2rad(alpha)), cos(deg2rad(alpha))];
rect_second_side = (secondSideLength/2).*[sin(deg2rad(alpha+90)), cos(deg2rad(alpha+90))];

rect_center = [pointRec(2) pointRec(1)] + rect_first_side + rect_second_side;
draw_rectangle(rect_center,...
				secondSideLength,...
				firstSideLength,...
				-alpha, [0 0 0]);

% plot(GPS(2,:), GPS(1,:), 'g*', 'MarkerSize',2)
% plot(USBL(2,:), USBL(1,:), 'r*','MarkerSize',2)
plot(pos_transp(2),pos_transp(1),'k.', 'MarkerSize',30)
plot(pos(2,:), pos(1,:), 'g')
plot(pos_true(2,:),pos_true(1,:), 'r')
pos_iniz = [pos(2,1), pos(1,1)];
plot(pos_iniz(1),pos_iniz(2),'^m', 'MarkerSize',15)



title('PAsqualo Plot')
grid on
xlabel('Est [m]')
ylabel('Nord [m]')
legend('Area di interesse','Posizione Transponder','Posizione Stimata','Posizione Vera', 'Posizione Iniziale');
axis equal

%% sonard_down
figure(9)
hold on
box on
grid on
title('Sonar Down')
xlabel('Time [s]')
ylabel('Output [m]')
plot(out.fls_down.time, reshape(out.fls_down.signals.values, size(out.fls_down.signals.values,3),1))

%% plot3D
postrue = zeros(size(out.pos_true.signals.values,3), size(out.pos_true.signals.values,1));
for i = 1 : size(out.pos_true.signals.values,1)
    postrue(:,i) = out.pos_true.signals.values(i,1,:);
end

figure(10)
grid on
box on
title('trajectory')
plot3(postrue(:,2),postrue(:,1), -postrue(:,3),'LineWidth',2)
xlabel('Est [m]')
ylabel('Nord [m]')
zlabel('Down [m]')

%% custom save
set(gca,'FontSize',20)
set(findall(gcf,'type','text'),'FontSize',20)

