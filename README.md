To address the task requirements, I designed an automaton with 10 states, facilitating state transitions on the rising edge of the clock signal in the sequential part. 
Let me elucidate the functionality within each state and the underlying rationale guiding the automaton's design.

Initially, I defined the 10 states using macros. The state 0: INIT serves as the starting point, where I assigned initial coordinates to the variables "row" and "col," initialized "done" to 0, 
and set "maze_oe" to 1. This setup allows for subsequent evaluation of the cell's content in the next state (S1).
States S1, S3, S5, and S7 operate on a similar principle, differing in their respective significance. For instance, S1 represents the state when the 'character' moves from the east of the maze (right), 
while S3, S5, and S7 depict movements from the south, north, and west, respectively.

Half of the task involved conceptualization using visual aids such as Paint, hence I'll attach a small image to complement the explanation. 

![image](https://github.com/ioana-roxana-b/Maze/assets/67548504/7fef4e29-2b9d-4e9d-a92c-15f2765c2c50)

Let's consider the scenario where the 'character' moves northward, thus finding itself in state S5, with the wall to track located eastward. 
Here's the sequence of actions: Initially, it checks if it's positioned on the maze's edge (row==63 || row==0 || col==63 || col==0) and whether the current cell contains the value 0 or 2 (i.e., maze_in!=1). 
If these conditions are met, signifying arrival at the destination, the 'character' halts its movement by setting "done" to 1 on the subsequent rising clock edge and transitions to the STOP state. 
Here, it marks the cell with 2 (maze_we=1) and sets "maze_oe" to 0, indicating cessation of further readings. If the destination hasn't been reached yet, it proceeds to the next condition, checking if the current 
position contains the value 0 or 1. If the value is 0, the cell is marked with 2, and a transition to an additional state, S6, is made.
The supplementary states S2, S4, S6, and S8 were introduced to address a specific issue where setting both "maze_oe" and "maze_we" to 1 inadvertently resulted in marking cells with 2 instead of 1, 
leading to unexpected behavior. Additionally, at the onset of the second "always" block, "maze_we" was initialized to 0 to rectify an oversight where its value remained 1 after modification, causing 
erroneous markings on subsequent cycles.

In the supplementary state S6, "maze_oe" is set to 1, and the adjacent wall (cell to the right, i.e., col=col+1) is examined. If the wall to the right (east) is found to be 0 or 1, a transition to the 
state corresponding to movement eastward (S1 in this case) is initiated. Here, the same evaluations as in S5 are repeated. If the adjacent cell contains the value 0, it's marked with 2, and the examination 
of the right wall continues. Otherwise, the 'character' returns to the previous cell (col=col-1) without altering the cell's contents, with "maze_oe" set to 1 to enable subsequent state evaluation.

In essence, the 'character' consistently follows the right-hand wall, adhering to the task's stipulations. It continuously evaluates the cell's content, retreats if encountering a value of 1, and 
proceeds until finding a permissible cell marked with 0 or 2.
