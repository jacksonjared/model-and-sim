%%% EE372 - Modeling and Simulation - Assignment 6 - Playing with Dice
%%% Jared Jackson
%%% Due April 3th


%%% The assignment is to model a number of fair dice (5 in this case), that do
%%% not interact while being rolled. No fancy math allowed, only Monte Carlo
%%% methods for this assignment. 


%%% Housekeeping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;    %% Just MATLAB things
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The number of dice to role
num_dice = 5;

%%% The number of sides on each dice
num_sides = 6;

%%% The number of rolls to do
num_rolls = 1e6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rolls = zeros(1, num_rolls);

for i = 1:num_rolls
	rolls(i) = sum( randi([1, num_sides], num_dice, 1) );
end

histogram(rolls);

%%% This sigma value only works for num_sides = 6 since I could not derive a
%%% general formula with my very limited statistics knowledge
sigma = 1.75 * sqrt(num_dice);

%%% The mean value of rolling a dice with num_sides num_rolls times
mew = num_dice * (num_sides + 1) / 2;
x = 0:0.1:(num_sides * num_dice) + num_dice;

y = num_rolls * ( 1 / (sigma * sqrt(2 * pi) ) ) .* exp( -0.5 .* ( (x - mew) / sigma ).^2 );

hold on;
plot(x, y, "LineWidth", 2);