# EternityII
Puzzle solver

Brute force approach is considered (Python algorithm) - something to do for Raspberry Pi 4 

Algorithm setup:
- Init piece and 3 hints could be added to the board at the begining
- Defining a path acording which pieces will be added to board

Algorith idea:
- It is possible to generate all possibilities for move 1, 2, etc. 
- Generate all possbilities for 5th move (about 500k)
- Pick randomly one possibility and continue searching for 5 minutes
- More than one possibility can be calculated at the same time 

Warning: It could need a lot of data space, for example if the first move have 40 possibilities the second can have 2k possibilities and the third can have 5k possibilities. Grow is exponential. For example, the 5th move have 500k possibilites (for default path) ~ 8Gb of data.

Thingspeak channel to monitor results of calculation...

https://thingspeak.com/channels/857664
