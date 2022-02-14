%%% EE372 - Modeling and Simulation - Assignment 2 - Introduction to chaos
%%% Jared Jackson
%%% Due Feb 13th


%%% This code is written to model and plot the outcomes of a dripping faucet.
%%%
%%% The Logistic mapping (mapping, not fuction since each input can have multipe
%%% outputs), is just about the simplest logistic function I think exists.
%%% Despite this simplicity, it applies well to a variety of situations like
%%% simple populations, radioactive decay, and of course, dripping water.
%%%
%%% 

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic

%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Number of iterations for the equation; Lager = more resolution
iterations = 1000;

%%% (4/xRes + 1) points in the X axis; Smaller = more resolution
xRes = 1/1000;

%%% NUmber of points in the Y axis; Larger = more resolution
yRes = 128;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


r = 0:xRes:4;
X = zeros((iterations), (4/xRes + 1));
X(1,:) = 0.5;

for i = 2:1:(iterations  + yRes)
  X(i,:) = r .* X(i - 1,:) .* (1 - X(i - 1,:));
end

%%% Call It UI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(r, X(iterations :iterations  + yRes,:), '-b');
xlim([0 4]);
ylim([0 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% See What's Become Of Me
toc