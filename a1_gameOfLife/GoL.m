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


%%% Housekeeping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear variables; clc;    %% Just 'MATLAB' things
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Sandbox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The size of the board, NxN
global sizeBoard;
sizeBoard = 100;

%%% The limit on how many generations to simulate; used to prevent infinite
%%% loops
limit = 100;

%%% Sets how the starting board for the game should be created. Set to 0 to be
%%% prompted to make a board. Set to 1 to import "input.png" from the current
%%% directory as the starting board; be aware that "input.png" must be a square
%%% black and white image. Set to 2 to generate a random board; the random board
%%% can be edited before the simulation starts. 
inputBoardMethode = 2;

%%% The time between each generation. Note that at larger board sizes, the time
%%% between generations if more dependent on how long it takes to compute the
%%% next board
genTime = 0.0000000001;


%%% There are 8 squares surrounding each square, and as such, no array can go 
%%% above 8. The first three arrays apply to living squares and cannot have any
%%% overlap. The last array applies to dead squares and must be a subset of the
%%% survive array.

%%% How many adjacent squares will cause the square to die. [0 1] for conway's
%%% Game of Life
global underpopulation;
underpopulation = {0 1};

%%% How many adjacent squares a living square needs to survive. [2 3] for
%%% Conway's Game of Life
global survive;
survive = {2 3};

%%% How many adjacent squares will kill the square. [4:8] for Conway's Game of
%%% Life
global overpopulation;
overpopulation = {4 5 6 7 8};

%%% How many adjacent squares must be present for a dead square to become alive.
%%% [3] for Conway's Game of Life
global reproduction;
reproduction = {3};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% A NxN array that represents the game board. A 0 denotes a dead square, and a
%%% 1 denotes a living square
global board;

%%% Keeps track of how many generations have gone by in the simulation
global generations;
generations = 0;

%%% Sets up the board as specified in workspace by the randomboard toggle
switch inputBoardMethode
  case 0
    board = zeros(sizeBoard);
  case 1
    try
      board = flip(rgb2gray(double(imread('./input.png'))));
    catch ERROR
      if (strcmp(ERROR.message,'File "./input.png" does not exist.'))
        randomBoard();
      else
        rethrow(ERROR)
      end
    end
    sizeBoard = size(board, 1);
  otherwise
    randomBoard();
end
global lastboard;
lastboard = board;
displayBoard();
set(gca, 'YDir', 'normal');
colormap(gca, [0 0 0; 1 1 1]);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
axis equal;
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
  displayBoard();
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Game loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% This is the main game loop, to borrow terminology. It will simulate and
%%% display the board until either a steady state is reached or the specified
%%% number of generations has occured
while (generations ~= limit)
  lastboard = board;
  updateBoard();
  if lastboard == board
    generations = generations - 1;
    limit = generations;
  end
  displayBoard();
  pause(genTime);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Function junction, what's your conjunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Generates a random NxN matrix of values [0 1] to act as the game board. The
%%% edge squares are all set to dead.
function randomBoard()
  global board;
  global sizeBoard;
  board = randi([0 1], sizeBoard, sizeBoard);
  board(1, : ) = 0;
  board(sizeBoard, : ) = 0;
  board(: , 1) = 0;
  board(: , sizeBoard) = 0;
end

%%% Draws the board as a black and white image in a figure; black for dead, and
%%% white for alive
function displayBoard()
  global board;
  global generations;
  image(board + 1);
  title(['Current generation: ' num2str(generations)]);
end

%%% Updates the board to the next generation.
function updateBoard()
  global board;
  global sizeBoard;
  global underpopulation;
  global survive;
  global overpopulation;
  global reproduction;
  global generations;
  generations = generations + 1;
  numNeighborMatrix = conv2(board, [1 1 1; 1 0 1; 1 1 1], 'same');
  for i = 2:(sizeBoard - 1)
    for ii = 2:(sizeBoard - 1)
      switch numNeighborMatrix(i, ii)
				case underpopulation %%% dies of lonely
          board(i, ii) = 0;
				case overpopulation %%% dies of overpopulation
          board(i, ii) = 0;
				case reproduction %%% just right to reproduce
          board(i, ii) = 1;
				case survive %%% just right to survive
          board(i, ii) = board(i, ii);
      end
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%