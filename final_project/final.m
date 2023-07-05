%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The frequency of the EM wave
freq = 100e6;

%%% The initial amplitude of the E wave
E_0 = 1;

%%% The angle of the wave front with respect to the z axis
theta = 0;

%%% the relative permitivitty of region 1
e_r1 = 8;

%%% the relative permeability of region 1
m_r1 = 2;

%%% the conductivity of region 1
sigma1 = 0;

%%% the relative permitivitty of region 2
e_r2 = 2;

%%% the relative permeability of region 2
m_r2 = 2;

%%% the conductivity of region 2
sigma2 = 0.0;

%%% how long to simulate
time = 1;

%%% for far to simulate
len = 20;

%%% the spacial resolution to simulate
resS = 1e-2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Anon and Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ee_alpha = @(w, mu, epsilon, sigma) (w * sqrt( (mu * epsilon) / 2 )) * ...
				sqrt( sqrt( 1 + (sigma / (w * epsilon))^2 ) - 1 );

ee_beta = @(w, mu, epsilon, sigma) (w * sqrt( (mu * epsilon) / 2 )) * ...
				sqrt( sqrt( 1 + (sigma / (w * epsilon))^2 ) + 1 );

e0 = 8.8541878128 * 10^(-12);

m0 = 4 * pi * 10^(-7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Angular frequency
w = 2 * pi * freq;

%%%
z_1 = 0:resS:(len / 2);
z_2 = z_1(end):resS:len;

%%% Impedance of material 1 and 2
eta_1 = sqrt( (m_r1 * m0) / (e_r1 * e0 - 1i * (sigma1 / w) ) );
eta_2 = sqrt( (m_r2 * m0) / (e_r2 * e0 - 1i * (sigma2 / w) ) );

%%% Reflection coefficients
E_rc = (eta_2 - eta_1) / (eta_2 + eta_1);
H_rc = -E_rc;

%%% Transmition coefficients
E_tc = 1 + E_rc;
H_tc = 1 + H_rc;

%%% Alpha for wave 1 and 2
a_1 = ee_alpha(w, m_r1 * m0, e_r1 * e0, sigma1);
a_2 = ee_alpha(w, m_r2 * m0, e_r2 * e0, sigma2);

%%% Beta for wave 1 and 2
b_1 = ee_beta(w, m_r1 * m0, e_r1 * e0, sigma1);
b_2 = ee_beta(w, m_r2 * m0, e_r2 * e0, sigma2);

%%% Arrays containing the three waves
forward_wave = zeros(1, length(z_1));
transmitted_wave = zeros(1, length(z_1));
reflected_wave = zeros(1, length(z_2));

%%% Accounts for the decay of a wave in a conductive medium
decay_mask_1 = exp(-a_1 .* z_1);
decay_mask_2 = exp(-a_2 .* z_2);

%%% 
unit_time_1 = b_1 / w * resS;
unit_time_2 = b_2 / w * resS;
resT = min(unit_time_2, unit_time_1);

for t = 0:resT:time

  if( mod( t, b_1 / w * resS ) == 0 )
    
    %%% forward wave
    E = real(E_0 * exp(1i * (w * t) ) );
    forward_wave_unmasked = [E, forward_wave(1:end - 1)];
    forward_wave = forward_wave_unmasked .* decay_mask_1;

    %%% reflected wave
    reflected_wave_unmasked = [reflected_wave(2:end), forward_wave(end) * E_rc];
    reflected_wave = reflected_wave_unmasked .* decay_mask_1(end:-1:1);
  
  end

  if( mod( t, b_2 / w * resS ) == 0 )
    
    %%% transmitted wave
    transmitted_wave_unmasked = [forward_wave(end) * E_tc, transmitted_wave(1:end - 1)];
    transmitted_wave = transmitted_wave_unmasked .* decay_mask_2;
  
  end

  plot(z_1, forward_wave + reflected_wave, '-b', z_2, transmitted_wave, '-b');
  ylim([-2 2])
	xlim([0 len]);
	grid on;
	xlabel('Z axis');
	ylabel('E Amplitude');
  title(['Time: ', num2str(round(t,4,'significant')), '[s]']);
	axis square;

  drawnow;

end





