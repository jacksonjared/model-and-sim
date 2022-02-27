%%% EE372 - Modeling and Simulation - Assignment 2 - Introduction to chaos
%%% Jared Jackson
%%% Due Feb 13th

%%% This code is written to model and plot the outcomes of a dripping faucet./s
%%%
%%% The Logistic mapping (not fuction since each input can have multipe
%%% outputs), is just about the simplest logistic function I think exists.
%%% Despite this simplicity, it applies well to a variety of situations like
%%% simple populations, radioactive decay, and of course, dripping water.

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic

%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Number of iterations for the mapping; Lager = more resolution
iterations = 1000;

%%% Number of points in the X axis; Larger = more resolution
xRes = 1e5;

%%% Number of points in the Y axis; Larger = more resolution
yRes = 64;

%%% Set to 1 to apply a colormap to the output plot, anything else is a mono
%%% color plot
colorGraph = 1;

%%% The color map to use if colorGraph is set to 1
cMap = 'hsv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sets the limits on the growth rate to be between 0 and 4 since outside of
%%% that range nothing happens. there will be xRes number of points in the array
r = ones(65,1) .* linspace(0, 4, xRes);

%%% Preinitilizes X and gives it a starting value of 0.5. The starting value
%%% does not actually matter, as long as it is not 0 or 1 since the final value
%%% only depends on the growth rate.
X = 0.5 .* ones(yRes, xRes);

%%% Iterates through the mapping (iterations + Yres) times for every value of r
%%% simultaneously
for i = 2:1:(iterations  + yRes)
  	cur = 1 + mod(i, yRes + 1);
    las = 1 + mod(i - 1, yRes + 1);
    X(cur,:) = r(1,:) .* X(las,:) .* (1 - X(las,:));
end
X(:,end) = NaN;

%%% Call It UI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (colorGraph == 1)
	colormap(cMap);
	C(:,(3 * xRes / 4):xRes) = ones(65,1) .* (0:4/xRes:1);
	patch(r', X', C', 'EdgeColor', 'interp', 'LineWidth', 0.5);
else
	line(r(1,:), X, 'Color', 'blue');
end

set(gca, 'XLim', [0 4], 'YLim', [0 1]);
title(['The Bifurcation Diagram - ' num2str(xRes) ' r points']);
xlabel("Growth rate (r)");
ylabel("convergence value/s");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% See What's Become Of Me
toc