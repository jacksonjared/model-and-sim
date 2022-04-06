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

%%% 1 to overlay the distribution on the histogram, anything else to not
fancyMath = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rolls = zeros(1, num_rolls);

for i = 1:num_rolls
	rolls(i) = sum( randi([1, num_sides], num_dice, 1) );
end

if(fancyMath == 1)
	subplot(1, 2, 1);
end
h = histogram(rolls, 'Normalization', 'probability');
xlabel("The Sum of " + num2str(num_dice) + " Dice");
ylabel("The Porbability of the Sum");
axis square;

%%% The section where I fail the "No Fancy Math" part %%%%%%%%%%%%%%%%%%%%%%%%%%

if (fancyMath == 1)

	%%% This sigma value only works for num_sides = 6 since I could not derive a
	%%% general formula with my very limited statistics knowledge
	sigma = 1.75 * sqrt(num_dice);

	%%% The mean value of rolling a dice with num_sides num_rolls times
	mew = num_dice * (num_sides + 1) / 2;

	x = 0.01:0.01:(num_sides * num_dice) + num_dice;
	
	%%% a normal distribution. this is only valid of 3 or more dice. I did
	%%% eventually find an equation for any number of dice with any number of
	%%% sides, but it is complicated to type in and strictly speaking unnecessary
	%%% for this assignment so I probably will not bother with it.
	y = (1 / (sigma * sqrt(2 * pi))) .* exp(-0.5 .* ((x - mew) / sigma).^2);

	hold on;
	plot(x, y, '-r', "LineWidth", 2);

	perror = zeros(1, h.NumBins);
	
	for i = 1:h.NumBins
		a_true = y(100 * (i + num_dice - 1));
		a_calc = h.Values(i);
		perror(i) = abs(a_calc - a_true) / a_true * 100;
	end

	subplot(1, 2, 2);
	plot(num_dice:(h.NumBins + num_dice - 1), perror, '-bo');
	set(gca, 'XLim', [num_dice (h.NumBins + num_dice - 1)], ...
		'YLim', [0 max(perror)]);
	xlabel("The Sum of " + num2str(num_dice) + " Dice");
	ylabel("Percent Error");
	axis square;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%