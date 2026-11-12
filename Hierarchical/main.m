clear; close all; clc;
run("params.m");
run("traj_gen.m");
out = sim("quadcopter_ctrl.slx");
% === SETUP PLOT ===
plotStyle = {'DefaultAxesFontName', 'Times New Roman', ...
    'DefaultTextInterpreter', 'latex', 'DefaultAxesTickLabelInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', 'DefaultAxesFontSize', 16, ...
    'DefaultLineLineWidth', 1.5, 'Color', 'w'};

outputFolder = fullfile(fileparts(mfilename('fullpath')), 'figures');
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

%% === POSITION COMPARISON ===
figure(plotStyle{:}, 'Name','Position Comparison','Position',[100 100 800 700]);

subplot(3,1,1);
plot(out.x.Time, out.x.Data, 'b', t, xd, 'r--');
ylabel('[m]');
legend('$x$', '$x_d$', 'Location','best');
grid on; box on;

subplot(3,1,2);
plot(out.y.Time, out.y.Data, 'b', t, yd, 'r--');
ylabel('[m]');
legend('$y$', '$y_d$', 'Location','best');
grid on; box on;

subplot(3,1,3);
plot(out.z.Time, out.z.Data, 'b', t, zd, 'r--');
ylabel('[m]');
xlabel('Time [s]');
legend('$z$', '$z_d$', 'Location','best');
grid on; box on;

sgtitle('Position Comparison','Interpreter','latex');
print(gcf, '-depsc2', fullfile(outputFolder, 'position_comparison.eps'));

%% === POSITION ERROR ===
figure(plotStyle{:}, 'Name','Position Error','Position',[100 100 800 700]);
components = {'e_x','e_y','e_z'};
labels = {'$e_x$','$e_y$','$e_z$'};
for i = 1:3
    subplot(3,1,i);
    plot(out.(components{i}).Time, out.(components{i}).Data, 'b');
    ylabel('[m]');
    legend(labels{i}, 'Interpreter','latex','Location','best');
    grid on; box on;
end
xlabel('Time [s]');
sgtitle('Position Error', 'Interpreter','latex');
print(gcf, '-depsc2', fullfile(outputFolder, 'position_error.eps'));

%% === ATTITUDE ERROR ===
figure(plotStyle{:}, 'Name','Attitude Error','Position',[100 100 800 700]);
att_err = {'e_phi','e_theta','e_psi'};
att_labels = {'$\phi$', '$\theta$', '$\psi$'};
for i = 1:3
    subplot(3,1,i);
    plot(out.(att_err{i}).Time, out.(att_err{i}).Data, 'b');
    ylabel('[rad]');
    legend(['$e_', att_labels{i}(2:end-1), '$'], 'Interpreter','latex','Location','best');
    grid on; box on;
end
xlabel('Time [s]');
sgtitle('Attitude Error', 'Interpreter','latex');
print(gcf, '-depsc2', fullfile(outputFolder, 'attitude_error.eps'));

%% === ATTITUDE ANGLES COMPARISON ===
figure(plotStyle{:}, 'Name','Angle Comparison','Position',[100 100 800 700]);

angle_fields = {'phi','theta','psi'};
angle_d_fields = {'phi_d','theta_d','psi_ws'}; % psi_ws è un array [t, val]
angle_labels = {'\phi', '\theta', '\psi'};     % senza $ per costruzione della stringa

for i = 1:3
    subplot(3,1,i);

    t_actual = out.(angle_fields{i}).Time;
    val_actual = out.(angle_fields{i}).Data;
    plot(t_actual, val_actual, 'b'); hold on;

    if strcmp(angle_fields{i}, 'psi')
        t_des = psi_ws(:,1);
        val_des = psi_ws(:,2);
    else
        t_des = out.(angle_d_fields{i}).Time;
        val_des = out.(angle_d_fields{i}).Data;
    end
    plot(t_des, val_des, 'r--');

    ylabel('[rad]');
    legend(['$' angle_labels{i} '$'], ['$' angle_labels{i} '_d$'], ...
           'Interpreter','latex','Location','best');

    grid on; box on;
end

xlabel('Time [s]');
sgtitle('Angle Comparison', 'Interpreter','latex');
print(gcf, '-depsc2', fullfile(outputFolder, 'angle_comparison.eps'));

%% === 3D TRAJECTORY COMPARISON
figure(plotStyle{:}, 'Name','3D Trajectory ','Position',[100 100 800 600]);

p_b = out.p_b.Data;
p_d = out.p_d.Data;

plot3(p_b(:,1), p_b(:,2), p_b(:,3), 'b', 'DisplayName', '$\mathbf{p}_B$'); hold on;
plot3(p_d(:,2), p_d(:,1), p_d(:,3), 'r--', 'DisplayName', '$\mathbf{p}_{d}$');


grid on; box on; axis vis3d;
xlabel('$y$ [m]', 'Interpreter','latex');
ylabel('$x$ [m]', 'Interpreter','latex');
zlabel('$z$ [m]', 'Interpreter','latex');
legend('Interpreter','latex','Location','best');
title('3D Trajectory Comparison ', 'Interpreter','latex');

view(40, 25);
print(gcf, '-depsc2', fullfile(outputFolder, 'trajectory_point_3D.eps'));


%% === TOTAL THRUST FORCE ===
figure(plotStyle{:}, 'Name','Total Thrust','Position',[100 100 800 400]);
plot(out.F.Time, out.F.Data, 'b');
ylabel('[N]');
xlabel('Time [s]');
title('Total Thrust Force $u_T$', 'Interpreter','latex');
legend('$u_T$', 'Interpreter','latex', 'Location','best');
grid on; box on;

print(gcf, '-depsc2', fullfile(outputFolder, 'u_T.eps'));
