%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic;

%%% FFT paramters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sampling frequency
Fs = 1e4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Filter parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Filter center frequency
Fc = 100;

%%% Filter width
Fw = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Signal parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The stop time of the signal
stop = 4;

%%% signal frequency in hertz
freq = 100;

%%% signal amplitude
Samp = 1;

%%% Noise amplitude
Namp = 1;

%%% Include random noise when corrupting signal?
includeNoise = 1;

%%% Include harmonics when corrupting signal?
includeHarmonics = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sampling period
Ts = 1 / Fs;

%%% Time of the signal
time = 0:Ts:stop;

%%% The signal
signal = Samp .* sin(2 .* pi .* freq .* time);

%%% Guassian noise
noise = Namp * randn(size(time));

%%% The 2nd, and 3rd harmonic of the signal
harmonics = (Samp / 1.5) .* sin(4 .* pi .* freq .* time) + (Samp / 2.25) .* ...
						sin(6 .* pi .* freq .* time);

%%% Intentionally corrupt the signal with all the unwanted distortions
corrupted = signal;
if (includeNoise == 1)
	corrupted = corrupted + noise;
end
if (includeHarmonics == 1)
	corrupted = corrupted + harmonics;
end

%%% Applies the filter and saves the result
filtered = bandPass2nd(corrupted, Fc, Fw, Ts);

%%% Time vs Amplitude
subplot(3, 2, [1 2]);
yyaxis left;
plot(time, filtered, '-b', 'LineWidth', 1);
ylim([(max(filtered) * -1.1) (max(filtered) * 1.1)]);
ylabel("Filtered Amplitude");
yyaxis right;
plot(time, corrupted, '-r', 'LineWidth', 1);
ylim([(max(corrupted) * -1.0) (max(corrupted) * 1.0)]);
ylabel("Noisy Amplitude");
xlabel("Time [s]");
grid minor;
title('Noisy and Filtered Time Domain', 'FontSize', 18);
legend('Filtered', 'Noisy');
set(gca, 'XLim', [( stop - (3 / freq) ) stop]);

%%% Frequency vs Amplitude of corrupted signal
subplot(3, 2, 3);
s1 = fftPlot(corrupted, Fs, freq);
title(['Noisy Frequency Domain. The SNR is ' num2str(s1) ' dB'], ...
	 		 'FontSize', 18);

%%% power spectral density of corrupted signal
subplot(3, 2, 5);
psdPlot(corrupted, Fs, freq);
title('Noisy PSD', 'FontSize', 18);

%%% Frequency vs Amplitude of filtered signal
subplot(3, 2, 4);
s3 = fftPlot(filtered, Fs, freq);
title(['Filtered Frequency Domain. The SNR is ' num2str(s3) ' dB'], ...
			 'FontSize', 18);

%%% power spectral density of filtered signal
subplot(3, 2, 6);
psdPlot(filtered, Fs, freq);
title('Filtered PSD', 'FontSize', 18);

%%% See What's Become Of Me
toc;

%%% Function Junction, What's your Conjunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plots a power spectral density of a signal. I just read wiki articles and
%%% tried things out until this seemed to work so I am not totally confident in
%%% it
function psdPlot(signal, Fs, freq)
	
	%%% The length of the input signal
	len = length(signal) - 1;

	%%% 
	psd = abs(fft(signal) .* 0.707 ).^2 ./ (1e4 * len);

	%%% Convert to dBw for better dynamic range
	psd_dBw = 10 .* log10( psd(1:(len / 2)) );

	%%% Setting and scaling the frequency interval to plot against
	f = Fs .* (0:(len / 2) - 1) ./ len;

	%%% Plot the PSD in dBw
	plot( f, psd_dBw, 'LineWidth', 1 );

	%%% Formatting
	xlabel("Frequency [Hz]");
	ylabel("Amplitude [dBw]");
	grid minor;
	set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])], ...
					 'YLim', [(-5 + mean(psd_dBw)) (5 + max(psd_dBw))]);
end

%%% Plots the frequency domain of a signal
function SNR = fftPlot(signal, Fs, freq)

	%%% The length of the input signal
	len = length(signal) - 1;

	%%% The amplitude of each frequency that makes up the input signal, aka the
	%%% fourier transform
	yfft = 2 .* abs( fft(signal) ./ len );
	yfft = yfft( 1:(len / 2) );

	yfft_dB = 10 * log10(yfft);

	%%% Setting and scaling the frequency interval to plot against
	f = Fs .* ( 0:(len / 2) -1 ) ./ len;

	%%% Calculate the signal to noise ratio
	SNR = round( ( yfft_dB(len / Fs * freq + 1) - mean(yfft_dB) ), 1);

	%%% Plot the fourier transform
	plot( f, yfft, 'LineWidth', 1 );

	%%% Formatting
	xlabel("Frequency [Hz]");
	ylabel("Amplitude");
	grid minor;
	set(gca, 'XLim', [0 min([(5 * freq) (Fs / 2)])], ...
					 'YLim', [0 (1.1 * max(yfft))]);
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