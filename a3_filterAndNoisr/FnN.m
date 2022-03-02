%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic;

%%% FFT paramters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sampling frequency
Fs = 1e4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Signal parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The stop time of the signal
stop = 3;

%%% signal frequency in hertz
freq = 100;

%%% signal amplitude
Samp = 1;

%%% Noise amplitude as a multiple of signal amplitude
Namp = 8;

%%% Include random noise when corrupting signal?
includeNoise = 1;

%%% Include harmonics when corrupting signal?
includeHarmonics = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sampling period
Ts = 1 / Fs;

%%% Time of the signal
time = 0:Ts:(stop - Ts);

%%% The signal
signal = Samp .* sin(2 .* pi .* freq .* time);

%%% Guassian noise
noise = Namp * randn(size(time));

%%% The 2nd, and 3rd harmonic of the signal
harmonics = (Samp / 1.5) .* sin(2 .* pi .* 2 .* freq .* time) + (Samp / 3) .* ...
						sin(2 .* pi .* 3 .* freq .* time);

%%% Intentionally corrupt the signal with all the unwanted distortions
corrupted = signal;
if (includeNoise == 1)
	corrupted = corrupted + noise;
end
if (includeHarmonics == 1)
	corrupted = corrupted + harmonics;
end

%%% Applies the filter and saves the result
filtered = bandPass2nd(corrupted, freq, 1, Ts);

%%% Time vs Amplitude
subplot(3, 2, [1 2]);
yyaxis left;
plot(time, filtered, '-b', 'LineWidth', 1);
ylabel("Filtered Amplitude");
yyaxis right;
plot(time, corrupted, '-r', 'LineWidth', 1);
ylabel("Noisy Amplitude");
xlabel("Time [s]");
grid minor;
title('Heavily Corrupted Signal and Filtered Signal', 'FontSize', 18);
legend('Filtered', 'Noisy');
set(gca, 'XLim', [( stop - (3 / freq) ) stop]);

%%% Frequency vs Amplitude of corrupted signal
subplot(3, 2, 3);
fftPlot(corrupted, Fs);
xlabel("Frequency [Hz]");
ylabel("Frequency Amplitude");
title('Noisy Frequency Domain', 'FontSize', 18);
grid minor;
set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])]);

%%% power spectral density of corrupted signal
subplot(3, 2, 5);
psdPlot(corrupted, Fs);
xlabel("Frequency [Hz]");
ylabel("Power? Amplitude");
title('Noisy PSD', 'FontSize', 18);
grid minor;
set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])]);

%%% Frequency vs Amplitude of filtered signal
subplot(3, 2, 4);
fftPlot(filtered, Fs);
xlabel("Frequency [Hz]");
ylabel("Frequency Amplitude");
title('Filtered Frequency Domain', 'FontSize', 18);
grid minor;
set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])]);

%%% power spectral density of filtered signal
subplot(3, 2, 6);
psdPlot(filtered, Fs);
xlabel("Frequency [Hz]");
ylabel("Power? Amplitude");
title('Filtered PSD', 'FontSize', 18);
grid minor;
set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])]);

%%% See What's Become Of Me
toc;

%%% Function Junction, What's your Conjunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plots a power spectral density of a signal. I am very unconfident in this, I
%%% haven't found enough good resources to understand how this works.
function psdPlot(signal, Fs)
	len = length(signal);
	psd = (abs( fft(signal, len) ) .^2) ./ len ./ Fs;
	x = Fs .* (0:len / 2) ./ len;
	plot( x, psd( 1:(len / 2) + 1 ), 'LineWidth', 1 );
end

%%% Plots the frequency domain of a signal
function fftPlot(signal, Fs)
	y = fft(signal);
	len = length(signal);
	yfft = 2 * abs(y / len);
	xfft = Fs .* ( 0:(len / 2) ) ./ len;
	plot( xfft, yfft( 1:(len / 2) + 1 ), 'LineWidth', 1 );
end

%%% Applies a 2nd order bandpass filter with a center frequency of f0 and a
%%% width of fw to an input signal x with timestep T
function y = bandPass2nd(x, f0, fw, T)

	%%% Bilinear Frequency prewarping
	w0 = (2 / T) * tan( (2 * pi * f0) * T / 2);
	ww = (2 / T) * tan( (2 * pi * fw) * T / 2);

	%%% Intermediate variables to shorten filter
	len = length(x);
	a =2 * T * ww;
	b = (w0 * T)^2;
	c = 4 + b;
	d = a + c;

	%%% Coefficients for the LCCDE representing the BP filter
	coeff = [ ( (8 - (2 * b)) / (d) ) ( (a - c) / (d) ) ( a / d ) ( (-a) / d ) ];
	
	%%% Output array
	y = zeros(1, len);

	%%% Loops through the signal and applies the BP filter
	for i = 3:len
		y(i) = ( coeff(1) * y(i - 1) ) + ( coeff(2) * y(i - 2) ) + ...
					 ( coeff(3) * x(i) ) + ( coeff(4) * x(i - 2) );
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%