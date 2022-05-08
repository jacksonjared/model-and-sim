%%% EE372 - Modeling and Simulation - Assignment 4 - PID controllers
%%% Jared Jackson
%%% Due March 6th

%%% For this assignment, we implemented a PID controller along with a
%%% modeled system for it to control. We were investigating the effects
%%% of different set points and noise on the selection of coefficients.

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time step in seconds
Ts = 1e-3;

%%% Length of simulation in seconds
Stop = 40;

%%% Initial position
P0 = 0;

%%% Initial velocity
V0 = 0;

%%% acceleration due to gravity
g0 = 9.81;

%%% Mass of the object
m0 = 1;

%%% Maximum force the system can produce in the up direction
Fplus = 200;

%%% Maximum force the system can produce in the down direction
Fminus = 0;

%%% Set to 1 to include gaussian noise in the set point
Noise = 0;

%%% Amplitude of added noise
Namp = 1;

%%% What type of set point. Options are STEP or RAMP
Target = "STEP";

%%% Proportional constant
Kp = 100 .* [ 0.1, 0.25, 0.5, 0.75, 1 ];
%%% Kp = 100 .* [1, 1, 1, 1, 1];

%%% Integral constant
Ki = 1 .* [ 0.1, 0.25, 0.5, 0.75, 1 ];
%%% Ki = 0.5 .* [1, 1, 1, 1, 1];

%%% Derivative constant
Kd = 1 .* [ 0.1, 0.25, 0.5, 0.75, 1 ];
%%% Kd = 1 .* [1, 1, 1, 1, 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0:Ts:(Stop - Ts);

%%% Selects between the two set points, defualt to STEP
switch (Target)
	case "RAMP"
		target = [zeros(5,Stop / 2 / Ts) (ones(5, Stop / 2 / Ts) .* (0:Ts:( Stop / 2 ) - Ts) ) ];
	case "STEP"
		target = [zeros(5,Stop / 2 / Ts) ones(5, Stop / 2 / Ts)];
	otherwise
		target = [zeros(5,Stop / 2 / Ts) ones(5, Stop / 2 / Ts)];
end

%%% Creates and adds the noise if desired
if Noise
    noise = Namp * randn( size(target) );
	target = target + noise;
end

%%% Preallocate for speed
position = P0 .* ones( size(target,1), size(target,2) );
P0 = P0 .* ones( size(target,1), 1 );
V0 = V0 .* ones( size(target,1), 1 );

I = 0;

for i=3:(Stop / Ts)

    %%% The error that is the input to the PID controller
	ERROR = [ ( target(:, i - 1) - position(:, i - 1) ), ...
						( target(:, i - 2) - position(:, i - 2) ) ];

    %%% The proportional path
	P = Kp' .* ERROR(:, 1);

    %%% The integral path
	I = Ki' .* 0.5 .* Ts .* ( ERROR(:, 1) + ERROR(:, 2) ) + I;

    %%% The derivative path
	D = Kd' .* ( ERROR(:, 1) - ERROR(:, 2) ) / Ts;

    %%% Combine the paths
	thrust = (P + I + D);

    %%% Limit the output to the system
	if (thrust) > Fplus
		thrust(:) = Fplus;
	elseif (thrust) < Fminus
		thrust(:) = Fminus;
	end

    %%% Flashback to highschool physics and the kinematic equations
	accel = (thrust ./ m0) - g0;
	position(1:5,i) = (accel ./ 2 .* Ts.^2) + (V0 .* Ts) + P0(1:5, 1);
    V0(1:5, 1) = accel .* Ts + V0(1:5, 1);
    P0(1:5, 1) = position(1:5,i);

end

%%% Plot the output
plot(t, target, '--r', t, position, '-', "LineWidth", 2);
set(gca, "XLim", [0 Stop]);
grid on;
xlabel("Time [s]");
ylabel("System posistion relative to start [m]");
legend("Set point", "", "", "", "", ...
	[ 'K_P = ' num2str( Kp(1) ) ', K_I = ' num2str( Ki(1) ) ', K_D = ' num2str( Kd(1) ) ], ...
	[ 'K_P = ' num2str( Kp(2) ) ', K_I = ' num2str( Ki(2) ) ', K_D = ' num2str( Kd(2) ) ], ...
	[ 'K_P = ' num2str( Kp(3) ) ', K_I = ' num2str( Ki(3) ) ', K_D = ' num2str( Kd(3) ) ], ...
	[ 'K_P = ' num2str( Kp(4) ) ', K_I = ' num2str( Ki(4) ) ', K_D = ' num2str( Kd(4) ) ], ...
	[ 'K_P = ' num2str( Kp(5) ) ', K_I = ' num2str( Ki(5) ) ', K_D = ' num2str( Kd(5) ) ]);

%%% See What's Become Of Me
toc