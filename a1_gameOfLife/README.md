# Assignment 1 - Conway's [Game of] Life

## Rambles

This first assignment was fairly straight forward, except for maybe the model. During the entire assignment, but most prominently while writing the report, I had to think about what the actual model was in this case; there were two trains of though that I considered while speaking with my classmates about it: Conway's Life **IS** the model or we were modeling Conway's Life.

Conway's Life is already a ***VERY*** simple model of populations, with only 4 rules to distinguish it in the broad category of Cellular Automaton. I think, however, that is entirely besides the point of what Conway's intentions were; I would need to read the  entire originally published paper to make that call though, and I only read the introduction. Nevertheless, this is a solid stance to take.

The other side, we were modeling Conway's Life, also seems to hold some merit. I am leaning toward the first line of reasoning though, but it seems to depend entirely on where you draw the line between model and simulation. As I understand it now, the model is the rules or framework that you think something follows and the simulation is how you choose to implement the rules. In this case then, Conway's Life would be the thing itself, Conway's 4 rules would be the model (along with the rules implied by being a Cellular Automaton), and the simulation would be the state machine I wrote to step forward in generations.

## I Don't Understand MATLAB

My background is in C and ASM programming for embedded systems, so I always have a bit of a process when writing MATLAB programs. I will start by writing it as if it was C, and after being disappointed by how utter abysmal the performance is, I will remember to rewrite it to take advantage of matrixes (matrices? the dictionary lists both). 

The biggest time saver on this project was also the most baffling thing about it. In Conway's life, you need to know how many living neighbors each cell has. I, naively apparently, assumed that straight addition would be the fastest way to find this out; after all, it is only one cpu cycle to add numbers, what could be faster?

Convolutions. Convolutions were just over twice as fast.

My best guess it that whatever MATLAB does under the hood to make matrix operations so efficient, is to the detriment of everything else. At the end of the day, taking the discrete convolution of two matrixes involves multiplication and just as much addition so it has no right to be faster than just adding everything up.

That all is to say: I don't understand MATLAB