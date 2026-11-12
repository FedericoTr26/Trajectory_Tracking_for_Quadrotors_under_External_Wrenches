T_final = 60;
Ts = 0.001;
t = (0:Ts:T_final)';

theta = -(2*pi/20)*t;

xd = -2 + 2*cos(-theta);
yd = 2*sin(theta);
dxd = gradient(xd, Ts);
dyd = gradient(yd, Ts);
ddxd = gradient(dxd, Ts);
ddyd = gradient(dyd, Ts);

s = t/30;
zd = 3*s.^2 - 2*s.^3;
zd(t>=30) = 1;
dzd = gradient(zd, Ts);
ddzd = gradient(dzd, Ts);

psi_d = zeros(size(t));      
dpsi_d = zeros(size(t));    
ddpsi_d = zeros(size(t));    


xd_ws = [t, xd];
dxd_ws = [t, dxd];
ddxd_ws = [t, ddxd];
yd_ws = [t, yd];
dyd_ws = [t, dyd];
ddyd_ws = [t, ddyd];
zd_ws = [t, zd];
dzd_ws = [t, dzd];
ddzd_ws = [t, ddzd];
psi_ws = [t, psi_d];
dpsi_ws = [t, dpsi_d];
ddpsi_ws = [t, ddpsi_d];

save('desired_traj_signals.mat', ...
    'xd_ws','dxd_ws','ddxd_ws', ...
    'yd_ws','dyd_ws','ddyd_ws', ...
    'zd_ws','dzd_ws','ddzd_ws', ...
    'psi_ws','dpsi_ws','ddpsi_ws');

%% Plots
figure('Position',[100 100 1200 800]);


subplot(2,2,1);
plot3(yd, xd, zd, 'b-', 'LineWidth', 2);
grid on; box on; axis vis3d; %axis equal
xlabel('y [m]'); ylabel('x [m]'); zlabel('z [m]');
xlim([-3 3]); ylim([-5.5 1]); zlim([0 1]);
title('Desired Trajectory 3D');
view(40,25);


subplot(2,2,2);
plot(t, psi_d, 'r--', 'LineWidth', 2);
grid on;
xlabel('Time [s]'); ylabel('\psi_d [rad]');
title('\psi_d from the paper (constant = 0)');
ylim([-0.5 0.5]);


subplot(2,2,3);
plot(xd, yd, 'b-', 'LineWidth', 2);
grid on; axis equal;
xlabel('x [m]'); ylabel('y [m]');
title('Circular trajectory xy');
xlim([-5 1]); ylim([-3 3]);


subplot(2,2,4);
plot(t, dpsi_d, 'g-', 'LineWidth', 1.5);
hold on;
plot(t, ddpsi_d, 'm-', 'LineWidth', 1.5);
grid on;
xlabel('Time [s]'); ylabel('Derivatives of \psi_d');
title('Derivatives of \psi_d');
legend('d\psi_d/dt', 'd²\psi_d/dt²', 'Location', 'best');