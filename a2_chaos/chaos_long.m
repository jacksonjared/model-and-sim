close all; clear variables; clc;
tic

%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Number of iterations for the equation; Lager = more resolution
iterations = 1000;

%%% (4000 * xRes) points in the X axis; Larger = more resolution; cannot go below 1
xRes = 100;

%%% NUmber of points in the Y axis; Larger = more resolution
yRes = 128;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rRange = 0:1/xRes:4;
X = ones(yRes, 1000);

hold on;
xlim([0 4]);
ylim([0 1]);

for i = 1:(4 * xRes)
  r = linspace(rRange(i), rRange(i + 1), 1000);

  X(1,:) = 0.5;
  for ii = 1:(iterations + yRes)
    cur = 1 + mod(ii, yRes + 1);
    las = 1 + mod(ii - 1, yRes + 1);
    X(cur,:) = r .* X(las,:) .* (1 - X(las,:));
  end

  plot(r, X, '-b');
  
end

toc