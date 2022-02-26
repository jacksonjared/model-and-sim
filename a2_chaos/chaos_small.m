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
xRes = 1e4;

%%% NUmber of points in the Y axis; Larger = more resolution
yRes = 64;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sets the limits on the growth rate to be between 0 and 4 since outside of
%%% that range nothing happens. there will be xRes number of points in the array
r = linspace(0, 4, xRes);

%%% Preinitilizes X and gives it a starting value of 0.5. The starting value
%%% does not actually matter, as long as it is not 0 or 1 since the final value
%%% only depends on the growth rate.
X = 0.5 .* ones(yRes, xRes);

%%% Iterates through the mapping (iterations + Yres) times for every value of r
%%% simultaneously
for i = 2:1:(iterations  + yRes)
  	cur = 1 + mod(i, yRes + 1);
    las = 1 + mod(i - 1, yRes + 1);
    X(cur,:) = r .* X(las,:) .* (1 - X(las,:));
end

%%% Call It UI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
line(r, X, 'Color', 'blue');
%%lineXColor(r, X, 'hsv');
set(gca, 'XLim', [0 4], 'YLim', [0 1]);
title(['The Bifurcation Diagram - ' num2str(xRes) ' r Values']);
xlabel("Growth rate (r)");
ylabel("Final value/s");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% See What's Become Of Me
toc

%%% This will plot the bifurcation diagram with a gradiant color on the x axis
%%% but it is VERY slow since MATLAB doesn't allow multiple colors per line, so
%%% it has to plot a new line between each point.
function lineXColor(x, y, cmap)
numPoints = length(x);
pointColor = max(1, round( (0:numPoints) ./ numPoints .* 256));
cmp = colormap(cmap);
for i = 1:(numPoints - 1)
	line([x(i) x(i + 1)], [y(:, i) y(:, i + 1)], "color", cmp(pointColor(i),:) )
end
end