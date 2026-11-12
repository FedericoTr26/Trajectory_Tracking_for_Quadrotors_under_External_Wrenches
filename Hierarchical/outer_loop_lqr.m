%% Outer-loop LQR gain computation (Posture Control)
clear; clc;

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
mux = 4; muy = 4; muz = 4;
R = diag([mux, muy, muz]);  

K = lqr(A, B, Q, R);               


save('controller_gains.mat');
