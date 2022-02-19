%%% This one is faster for higher resolutions but slower for smaller resolutions

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic

%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Number of iterations for the equation; Lager = more resolution
iterations = 1000;

%%% Number of points in the X axis; Larger = more resolution
xRes = 1e4;

%%% Number of points in the Y axis; Larger = more resolution
yRes = 256;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:4

	r = linspace((i-1), i, xRes/4);

	X = 0.5 .* ones(yRes, xRes/4);

	for ii = 2:1:(iterations  + yRes)

		cur = 1 + mod(ii, yRes + 1);
    las = 1 + mod(ii - 1, yRes + 1);
    X(cur,:) = r .* X(las,:) .* (1 - X(las,:));

	end

	line(r, X);

end

%%% Call It UI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlim([2.5 4]);
ylim([0 1]);
title(['The Bifurcation Diagram - ' num2str(xRes) ' r Values']);
xlabel("Growth rate (r)");
ylabel("Final value/s");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% See What's Become Of Me
toc