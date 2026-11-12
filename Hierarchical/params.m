m = 1.8;                
g = 9.81;               
L = 0.23;               

Ixx = 0.0347563;
Iyy = 0.0347563;
Izz = 0.0577;
J = diag([Ixx, Iyy, Izz]);

k = 3e-6;
b = 2e-7;

%Initial Condition
x0 = 0; y0 = 0; z0 = 0;
dx0 = 0; dy0 = 0; dz0 = 0;

phi0 = 0;               
theta0 = 0;             
psi0 = pi/4;            
dphi0 = 0; dtheta0 = 0; dpsi0 = 0;

% --- SIMULATION PARAMETERS ---
T_sim = 60;
Ts = 0.001;

% --- MIXING MATRIX ---
mixing_matrix = [1,     1,     1,     1;          % F
                 -L,    +L,    0,     0;          % τφ (roll)
                 1,     0,     -L,    L;          % τθ (pitch)  
                 -b/k,  -b/k,  b/k,   b/k];       % τψ (yaw)


inv_mixing = inv(mixing_matrix);

A = [0 1 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 1 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 1;
     0 0 0 0 0 0];

B = [0 0 0;
     1 0 0;
     0 0 0;
     0 1 0;
     0 0 0;
     0 0 1];

Q = eye(6);
mux = 2; muy = 2; muz = 2;
R = diag([mux, muy, muz]);

K = lqr(A, B, Q, R);

save('controller_gains.mat', 'K', 'mux', 'muy', 'muz');

k1x = K(1,1); k2x = K(1,2);
k1y = K(2,3); k2y = K(2,4);  
k1z = K(3,5); k2z = K(3,6);

% SETTLING TIME FOR OUTER LOOP
tss_x = 10/k2x;  
tss_y = 10/k2y;  
tss_z = 10/k2z;
min_tss = min([tss_x, tss_y, tss_z]);


% --- INNER LOOP GAINS---
rho = 0.1;

% DESIRED SETTLING TIME FOR INNER LOOP
tss_inner_desired = rho * min_tss;

k2_phi = 10 / tss_inner_desired;               
k2_theta = k2_phi;                            
k2_psi = k2_phi;

k1_phi = sqrt(k2_phi / 2);
k1_theta = k1_phi;
k1_psi = k1_phi;

tuning_factor = 6;
k1_phi = k1_phi * tuning_factor;
k2_phi = k2_phi * tuning_factor;
k1_theta = k1_theta * tuning_factor;
k2_theta = k2_theta * tuning_factor;
k1_psi = k1_psi * tuning_factor;
k2_psi = k2_psi * tuning_factor;

xi_inner_actual = k2_phi / (2 * sqrt(k1_phi));
tss_inner_actual = 10 / k2_phi;

poles_inner = roots([1, k2_phi, k1_phi]);
is_stable_inner = all(real(poles_inner) < 0);

% --- SAVE PARAMETERS INSIDE FILE.mat ---
save('quadcopter_params.mat', ...
     'm', 'g', 'L', 'Ixx', 'Iyy', 'Izz', 'J', 'k', 'b', ...
     'K', 'k1x', 'k2x', 'k1y', 'k2y', 'k1z', 'k2z', ...
     'k1_phi', 'k2_phi', 'k1_theta', 'k2_theta', 'k1_psi', 'k2_psi', ...
     'x0', 'y0', 'z0', 'dx0', 'dy0', 'dz0', ...
     'phi0', 'theta0', 'psi0', 'dphi0', 'dtheta0', 'dpsi0', ...
     'T_sim', 'Ts', 'mixing_matrix', 'inv_mixing', 'rho', ...
     'tss_inner_desired', 'tss_inner_actual', 'min_tss', 'tuning_factor');