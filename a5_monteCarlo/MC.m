%%% EE372 - Modeling and Simulation - Assignment 5 - Monte Carlo
%%% Jared Jackson
%%% Due Mar 13th

%%% This code is written to calculate integrals using monte carlo integration.
%%%
%%% If you see monte carlo in the name, its going to involve random sampling
%%% in order to reach some numerical answer. In this case, monte carlo
%%% integraton involves picking points at random and seeing if they fall within
%%% some bounding shape. The ratio of points in and out of the shape can then be
%%% used to calculate the area of the shape. If you pick the shapes correctly,
%%% this will give you the area under the curve, or the integral.

%%% Test equations
%   1) y = x.^2 from 0 to 10 => 333.33
%   2) y = tand(x) from 0 to 90 => \inf
%   3) y = sqrt(16 - x.^2) from 0 to 4 => 12.566
%   4) y = sind(10 * x) .* exp(x / -100) + cosd(x) + 2 from 0 to 360 => 725.555

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time step for the function
Ts = 1e-3;

%%% Integral lower bounds
Start = 0;

%%% Integral upper bounds
Stop = 10;

%%% How many points to use for monte carlo integration
Points = 1e4;

%%% Which test equation to use. 1 - 4 accepted, anything else defualts to 1
Equ = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% X interval broken up into time steps
x = Start:Ts:Stop;

%%% Selects the equation to use basted on user choice
switch Equ
	case 1
		y = x.^2;
		Equ = 'Y = X^2';
		Ans = '333.33';
	case 2
		y = tand(x);
		Equ = 'Y = tand(X)';
		Ans = '';
	case 3
		y = sqrt(16 - x.^2);
		Equ = 'Y = sqrt(16 - X^2)';
		Ans = '12.566';
	case 4
		y = sind(10 * x) .* exp(x / -100) + cosd(x) + 2;
		Equ = 'Y = sind(10X) * e^{X / -100} + cosd(X) + 2';
		Ans = '725.555';
	otherwise
		y = x.^2;
end

%%% Bounding box for area calculation
yMax = max(y);
yMin = 0;

%%% Area of the rectangle bounding the function over the interval
rArea = (Stop - Start) * (yMax - yMin);

%%% How many points are below the function
below = 0;

%%% Keeps track of random points to be ploted later
xP = zeros(1, Points);
yP = zeros(1, Points);

%%% Picks Points random points for monte carlo integration
for i = 1:Points

	%%% Random X position aligned to the time step
	xP(i) = randi([1 length(x)]);

	%%% Random Y from 0 to yMax
	yP(i) = yMax * rand(1);

	%%% If the point is below the function increment below
	if yP(i) < y( xP(i) )
		below = below + 1;
	end

end

%%% Estimate the integral with monte carlo integration
area_estimation = rArea * (below / Points);

%%% Don't let plot override scatter
hold on;

%%% Plots the random points
scatter( (xP * Ts), yP, 'r.');

%%% Plots the equation being integrated
plot(x, y, '-b', "LineWidth", 2);

%%% Set window to be the bounding box
set(gca, "XLim", [Start Stop], "YLim", [yMin yMax]);

%%% Fromating the graph
grid on;
xlabel('X');
ylabel('f(X)');
t = title([Equ '    |    Monte Carlo Integration: ' num2str(area_estimation) ...
			'    True Value: ' Ans]);

%%% See What's Become Of Me
toc