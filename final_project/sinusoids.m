%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The frequency of the EM wave
freq = 100e6;

%%% The initial amplitude of the EM wave
E_1 = 1;

%%% The angle of the wave front with respect to the z axis
theta = 45;

%%% the relative permitivitty of region 2
e_r = 2;

%%% the relative permeability of region 2
m_r = 1;

%%% the conductivity of region 2
sigma = 0;

%%% the space resolution to simulate
res = 0.01;

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

%%% grids of parameters 
[Y1, Z1] = meshgrid(0:res:10, 0:res:10);
[Y2, Z2] = meshgrid(0:res:10, 10:res:20);
t = 0;
time = 0:1e-10:1e-8;
direction = 0:1:90;

figure;
colormap('copper');

%%% rotate the wave over a full quadrant
for theta = direction

%%% the wave in the first region (free space)
alpha_v = ee_alpha(w, m0, e0, 0);
beta_v = ee_beta(w, m0, e0, 0);
R1 = Z1 .* cosd(theta) + Y1 .* sind(theta);
E_z1 = E_1 * cosd(theta);
E_y1 = E_1 * sind(theta);
Er_v = (E_z1^2 + E_y1^2)^0.5 .* exp(-alpha_v .* R1) .* exp( 1i .* ( w .* t - beta_v .* R1 ) );

%%% the wave in the second region
alpha_m = ee_alpha(w, m_r * m0, e_r * e0, sigma);
beta_m = ee_beta(w, m_r * m0, e_r * e0, sigma);
R2 = Z2 .* cosd(theta) + Y2 .* sind(theta);
E_z2 = E_z1;
E_y2 = E_y1 / e_r;
Er_m = (E_z2^2 + E_y2^2)^0.5 .* exp(-alpha_m .* R2) .* exp( 1i .* ( w .* t - beta_m .* R2 ) );

%%% plot a top down view of the two waves
subplot(1,2,1)
cla;
surface(Z1, Y1, real(Er_v), 'EdgeColor','none');
surface(Z2, Y2, real(Er_m), 'EdgeColor','none');
axis square;
view([0, 0, 1]);
xlabel('Z axis [m]');
ylabel('Y axis [m]');
zlabel('E Field Amplitude');
grid on;
xlim([Z1(1) Z2(end)]);
ylim([Y1(1) Y2(end)]);

%%% plot a side shot of the two waves
subplot(1,2,2)
cla;
surface(Z1, Y1, real(Er_v), 'EdgeColor','none');
surface(Z2, Y2, real(Er_m), 'EdgeColor','none');
axis square;
view([1, -1, 1]);
xlabel('Z axis [m]');
ylabel('Y axis [m]');
zlabel('E Field Amplitude');
grid on;
xlim([Z1(1) Z2(end)]);
ylim([Y1(1) Y2(end)]);

%%% force MATLAB to draw every loop
drawnow;
end