% script da eseguire dopo simulink
close all
%% USBL DEBUG
% bear = out.bear.signals.values(1,1,:);
% bear = reshape(bear, size(bear,3),1,1);
% 
% range = out.range.signals.values(1,1,:);
% range = reshape(range, size(range,3),1,1);
% 
% polarplot(bear,range);
% 
% x = range.*cos(bear);
% y = range.*sin(bear);
% 
% plot(x, y)
%% Combined state-measurements plot
% figure(1)
% %pos = out.pos.signals.values;
% load('dataset_navigation.mat');
% pos = zeros(size(out.pos.signals.values,1), size(out.pos.signals.values,3));
% for i = 1:size(out.pos.signals.values,3)
% 	pos(:,i) = out.pos.signals.values(:,1,i);
% end
% 
% plot(pos(2,:), pos(1,:))
% hold on
% plot(USBL(:,3),USBL(:,2), 'r*')
% plot(GPS(:,3),GPS(:,2), 'g*')
% axis equal
%% covariance plot
% figure(2)
% cov = out.poscov.Data;
% hold on
% for i = 1:20:size(out.pos.signals.values,3)
% 	plotEllipses(pos([2,1],i)', [cov(2,2,i), cov(1,1,i)]);
% end
% plot(pos(2,:), pos(1,:), 'r')
% axis equal
%% covariance plot + real meas
figure(1)
clf
%load('dataset_navigation.mat');
pos = zeros(size(out.pos.signals.values,1), size(out.pos.signals.values,3));
for i = 1:size(out.pos.signals.values,3)
	pos(:,i) = out.pos.signals.values(:,1,i);
end
pos_true = zeros(size(out.pos_true.signals.values,1), size(out.pos_true.signals.values,3));
for i = 1:size(out.pos_true.signals.values,3)
	pos_true(:,i) = out.pos_true.signals.values(:,1,i);
end

GPS = zeros(size(out.GPS.signals.values,1), size(out.pos.signals.values,3));
for i = 1:size(out.GPS.signals.values,3)
	GPS(:,i) = out.GPS.signals.values(:,1,i);
end
USBL = zeros(size(out.USBL.signals.values,2), size(out.pos.signals.values,1));
for i = 1:size(out.USBL.signals.values,1)
	USBL(:,i) = out.USBL.signals.values(i,:);
end

cov = out.poscov.Data;
hold on
for i = 1:10:size(out.pos.signals.values,3)
	%plotEllipses(pos([2,1],i)', [cov(2,2,i), cov(1,1,i)]);
end
plot(pos(2,:), pos(1,:), 'b')
plot(pos_true(2,:),pos_true(1,:), ':r')
plot(GPS(2,:), GPS(1,:), 'g*')
plot(USBL(2,:), USBL(1,:), 'r*')
plot(pos_transp(2),pos_transp(1),'k.', 'MarkerSize',30)
plot(pos(2,:), pos(1,:), 'b')
plot(pos_true(2,:),pos_true(1,:), 'r')
title('covariance plot + real meas')
grid on
xlabel('Est [m]')
ylabel('Nord [m]')
legend('Posizione Stimata','Posizione Vera','GPS','USBL','Posizione Transponder',)
axis equal

%% 6 DOF animation Down = UP
orient = zeros(size(out.orient.signals.values,2),size(out.orient.signals.values,1));
for i = 1:size(out.orient.signals.values,1)
	orient(:,i) = out.orient.signals.values(i,:)';
end

rotPlot = zeros(3,3,size(out.orient.signals.values,1) );
for i = 1:size(out.orient.signals.values,1)
	rotPlot(:,:,i) = eul2rotm(orient(:,i)', 'XYZ');
end

Spin = 120;
samplePeriod = 0.1;
SamplePlotFreq = 1;
%SamplePlotFreq = 20;
posPlot = pos';
SixDofAnimation(posPlot, rotPlot, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 1, 'ShowArrowHead', false, ...
                'Xlabel', 'Nord [m]', 'Ylabel', 'Est [m]', 'Zlabel', 'Alt [m]', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));
%% 6 DOF animation Down = Down
posDown = pos;
posDown(3,:) =  -pos(3,:);
orientDown = zeros(size(out.orient.signals.values,2),size(out.orient.signals.values,1));
for i = 1:size(out.orient.signals.values,1)
	orientDown(:,i) = out.orient.signals.values(i,:)';
end

rotPlotDown = zeros(3,3,size(out.orient.signals.values,1) );
for i = 1:size(out.orient.signals.values,1)
	rotPlotDown(:,:,i) = eul2rotm(orientDown(:,i)', 'XYZ') * rotx(pi);
end

Spin = 200;
samplePeriod = 0.1;
%SamplePlotFreq = 1;
SamplePlotFreq = 20;
posPlot = posDown';
SixDofAnimation(posPlot, rotPlotDown, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 1, 'ShowArrowHead', false, ...
                'Xlabel', 'Nord [m]', 'Ylabel', 'Est [m]', 'Zlabel', 'Alt [m]', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));



