% Copyright 2018 - 2020, The MathWorks Inc.

g = 9.80665;         % gravity constant
m_r = 0.2948;        % mass of the rod
m_w = 0.0695;        % mass of the inertia wheel
R = 0.05;            % radius of the inertia wheel
r = 0.02;            % cross section radius of the rod
l = 0.13;            % corresponding lengths
l_AD = l;
l_AC = l;            % assume wheel is mounted on the top of the pendulum
l_AB = l/2;
I_w_C = 0.5*m_w*R^2; % corresponding inertias
I_w_A = I_w_C + m_w*l_AC^2;
I_r_B = (1/12)*m_r*(3*r^2+l_AD^2);
I_r_A = I_r_B + m_r*l_AB^2;