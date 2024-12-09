Readme about Midterm Project: Connect 4

1. Author Name: AccelerateZ
3. Known or Potential Bugs: 
   1. Known Bugs: Currently, no known bugs. Everything works as expected if you run it correctly on MARS, the MIPS simulator. 
   2. Runtime Error: However, there might be some exceptions or errors that could occur during the input process. If the program is waiting to input a number, but a character, including a pure 'Enter', is entered, it will throw a Runtime Exception that is invalid integer input. This is the instruction by Prof. Qian: (Ask and validate user input (MARS will crash if the user gives no input or a letter, this is fine!) )
   3. Potential Bugs: Although testing so many times to testify the correctness of the program, it is impossible to test all the possible situations. Therefore, there might be some potential bugs.
4. Anything Else Helping Grader Grade it More Easily:
   1. Thinking and Implementing Directly: All the logic is followed by institution and the instruction of the project. No more complex, perplexing, or unnecessary logic is added.
   2. C to Mips Conversion: The program is initially written in C and then converted to MIPS assembly language. Most of the logic is kept the same, which delivers a clear, understandable, easy-to-follow and consistent programming experience.
   3. Special Processing For MIPS: Some special processing is added to the program to make it run correctly and simply on MIPS stimulator. For example, in C, we traverse the board and use a bunch of if-statements to check the win condition, regardless of the position of the token that just placed. However, due to the complexity of loops and arrays in MIPS, I change the logic to check the win condition by checking the token that just placed and its neighbors. This makes the program run more smoothly and efficiently on MIPS.
   4. Clear and Understandable Comments: All the code is commented clearly and understandably. The comments are added to the code to explain the logic and the purpose of the code. This makes the code more readable and understandable.

(Below is the more detailed description of the project. If you are insterested, just have a glance.)

5. Description: This is a MIPS assembly language program that implements a 2-player Connect-4 game. The game allows two players to take turns placing tokens on a 7x6 board. The objective is to create a line of 4 consecutive tokens either horizontally, vertically, or diagonally.

6. Features: 
   1. Horizontal Check: The program checks for 4 consecutive tokens horizontally.
   2. Vertical Check: The program checks for 4 consecutive tokens vertically.
   3. Principal Diagonal Check: The program checks for 4 consecutive tokens on the principal diagonal.
   4. Auxiliary Diagonal Check: The program checks for 4 consecutive tokens on the auxiliary diagonal.
   5. Win Detection: The program detects when a player wins the game.
   6. Draw Detection: The program detects when the game ends in a draw.
   7. Board Display: The program displays the current state of the board after each move.
   8. Player Prompts: The program prompts players to enter a column to place their token.

7. How to Play:
   1. The game starts with a welcome message and displays the initial empty board.
   2. Player 1 is prompted to enter a column number (0-6) to place their token.
   3. Player 2 is then prompted to enter a column number (0-6) to place their token.
   4. The game continues with players taking turns until one player wins by forming a line of 4 consecutive tokens or the board is full, resulting in a draw.

8.  Instruction:
   1. It is written in MIPS assembly language and can be run on a MIPS simulator, therefore, please load it into a MIPS simulator to run the program.
   2. Assbmle the code and run it on the simulator.
   3. Follow the prompts to play the game.