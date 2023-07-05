%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The frequency of the EM wave
freq = 100e6;

%%% The initial amplitude of the EM wave
E_0 = 1;

%%% the relative permitivitty of region 1
e1_r = 1;

%%% the relative permeability of region 1
m1_r = 1;

%%% the relative permitivitty of region 2
e2_r = 2;

%%% the relative permeability of region 2
m2_r = 2;

%%% the conductivity of region 1
sigma1 = 0;

%%% the conductivity of region 2
sigma2 = 0;

%%% the space resolution to simulate
res = 0.01;

len = 20;
%%% len = physconst('LightSpeed') / freq * 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Anon and Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ee_alpha = @(w, mu, epsilon, sigma) (w * sqrt( (mu * epsilon) / 2 )) * ...
				sqrt( sqrt( 1 + (sigma / (w * epsilon))^2 ) - 1 );

ee_beta = @(w, mu, epsilon, sigma) (w * sqrt( (mu * epsilon) / 2 )) * ...
				sqrt( sqrt( 1 + (sigma / (w * epsilon))^2 ) + 1 );

e0 = 8.8541878128 * 10^(-12);

m0 = 4 * pi * 10^(-7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = 2 * pi * freq;

eta1 = sqrt( (m1_r * m0) / (e1_r * e0 - 1i * (sigma1 / w) ) );
eta2 = sqrt( (m2_r * m0) / (e2_r * e0 - 1i * (sigma2 / w) ) );

H_0 = E_0 / eta1;

E_rc = (eta2 - eta1) / (eta2 + eta1);
H_rc = -E_rc;

E_tc = 1 + E_rc;
H_tc = 1 + H_rc;

z1 = 0:res:(len / 2);
z2 = z1(end):res:len;

zero = zeros(1, length(z1));

[X, Y] = meshgrid([ (-2 * E_0):(2 * E_0) (-2 * E_0 / eta1):(2 * E_0 / eta1) ]);
Z = (len / 2) + zeros( size(X, 1), size(Y, 2) );

a1 = ee_alpha(w, m1_r * m0, e1_r * e0, sigma1);
a2 = ee_alpha(w, m2_r * m0, e2_r * e0, sigma2);

b1 = ee_beta(w, m1_r * m0, e1_r * e0, sigma1);
b2 = ee_beta(w, m2_r * m0, e2_r * e0, sigma2);

for t = 0:(res / w):inf

	E_i = E_0 .* exp(-a1 .* z1) .* exp(1i * ( w .* t - b1 .* z1 ) );

  E_R = E_rc .* (E_i(end)) .* exp(a1 .* z1 ) .* exp(1i * ( w .* t + b1 .* z1 ) );
	E_T = E_tc .* (E_i(end)) .* exp(-a2 .* (z2 - z2(1)) ) .* exp(1i * ( w .* t - b2 .* (z2 - z2(1)) ) );

	H_i = H_0 .* exp(-a1 .* z1) .* exp(1i * ( w .* t - b1 .* z1 ) );
	H_R = H_rc .* H_0 .* exp(a1 .* z1) .* exp(1i * ( w .* t + b1 .* z1 ) );
	H_T = H_tc .* H_0 .* exp(-a2 .* z2) .* exp(1i * ( w .* t - b2 .* z2 ) );

	%%% subplot(3,2,[1, 3, 5])
	%%% plot3(z1, zero, real(E_i + E_R), z2, zero, real(E_T), z1, real(H_i + H_R), zero, z2, real(H_T), zero, [0 len], [0 0], [0 0], '-k' );
  plot3(z1, zero, real(E_i + E_R), z1, zero, real(E_i), z1, zero, real(E_R), z2, zero, real(E_T), [0 len], [0 0], [0 0], '-k' );
	%%% surface(Z, Y, X, 'EdgeColor', 'none', 'FaceColor', 'red', 'FaceAlpha', 0.1);
	ylim([(-2 * H_0) (2 * H_0)])
	zlim([(-2 * E_0) (2 * E_0)]);
	grid on;
	xlabel('Z axis');
	ylabel('Y axis');
	zlabel('X Axis');
	axis square;
	%%% view([-1 -1 1]);
  view([0 -1 0]);

% 	subplot(3,2,2)
% 	plot( z1, abs(E_i) .* abs(H_i) - abs(E_R) .* abs(H_R), z2, abs(E_T) .* abs(H_T) );
% 	xlabel('Incident - Reflected | Transmitted');
% 	ylabel('EM Wave Energy');
% 
% 	subplot(3,2,4)
% 	plot( z1, abs(E_i) .* abs(H_i), z2, abs(E_T) .* abs(H_T) + abs(E_R) .* abs(H_R) );
% 	xlabel('Incident | Reflected + Transmitted');
% 	ylabel('EM Wave Energy');
% 
% 	subplot(3,2,6)
% 	plot( z1, abs(E_i + E_R) .* abs(H_i + H_i), z2, abs(E_T) .* abs(H_T) );
% 	xlabel('Standing Wave | Reflected + Transmitted');
% 	ylabel('EM Wave Energy');

	drawnow;

end