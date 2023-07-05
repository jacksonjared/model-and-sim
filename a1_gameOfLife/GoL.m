%%% EE372 - Modeling and Simulation - Assignment 1 - Conway's Game of Life
%%% Jared Jackson
%%% Due Jan 30th


%%% This code is written to model and simulate Conway's game of life.
%%%
%%% The four rules of the game are modeled with four arrays and a state machine.
%%% The board is a NxN array of a specified size, with the edges treated as
%%% static since an infinte board is impractical (impossible).
%%%
%%% There is a choice of a random starting board or making one yourself; the
%%% random board can be edited after it is generated. Once the board is made,
%%% each generation is simulated and displayed until a specified limit is hit or
%%% a steady state is reached.


%%% Just MATLAB things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The size of the board, NxN
sizeBoard = 200;

%%% The limit on how many generations to simulate; used to prevent infinite
%%% loops
limit = 1000;

%%% Sets how the starting board for the game should be created. Set to 0 to be
%%% prompted to make a board. Set to 1 to import "input.png" from the current
%%% directory as the starting board; be aware that "input.png" must be a square
%%% black and white image. Set to 2 to generate a random board; the random board
%%% can be edited before the simulation starts. 
inputBoardMethode = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Sets up the board as specified in workspace by the randomboard toggle
switch inputBoardMethode
  case 0
    board = zeros(sizeBoard);
  case 1
    try
      board = flip(rgb2gray(double(imread('./input.png'))));
    catch ERROR
      if (strcmp(ERROR.message,'File "./input.png" does not exist.'))
        board = randi([0 1], sizeBoard, sizeBoard);
      else
        rethrow(ERROR)
      end
    end
    sizeBoard = size(board, 1);
  otherwise
    board = randi([0 1], sizeBoard, sizeBoard);
end
image(board + 1);
title('Current generation: 0');
set(gca, 'YDir', 'normal');
colormap(gca, [0 0 0; 1 1 1]);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
axis square;
hold on;


%%% UI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% This is my rustic UI; it's all the rage nowadays. Or maybe I don't want to
%%% bother learning how to make a real GUI right now, who could know.
%%% The user can click on squares to toggle their state in the figure window.
%%% Simply click outside of the board to start the simulation
userInput = 1;
while userInput
  [xRaw, yRaw] = ginput(1);
  xPos = round(xRaw);
  yPos = round(yRaw);
  try
    board(yPos, xPos) = mod(board(yPos, xPos) + 1, 2);
	catch ERROR
		userInput = 0;
  end  
  image(board + 1);
  title('Current generation: 0');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Game loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% This is the main game loop, to borrow terminology. It will simulate and
%%% display the board until the specified number of generations has occured
for gen = 0:limit
 
  numNeighborMatrix = conv2(board, [1 1 1; 1 0 1; 1 1 1], 'same');
  board = (board .* (numNeighborMatrix == 2)) + (numNeighborMatrix == 3);

  image(board + 1);
  title(['Current generation: ' num2str(gen)]);
  drawnow;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
