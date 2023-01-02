# Labyrinth-An-FPGA-Game
## Overview
Labyrinth is a puzzle game where the player must navigate a small metal ball through a maze of obstacles to reach the end goal. In this project, we have implemented a digital version of the game on an FPGA board containing an RGB matrix and push buttons. The maze is generated using binary tree algorithm. The objective of the game is to navigate the ball from starting point to the finishing point.
## Hardware and Software Requirements
To play the game, you will need the following hardware: <br /> <br />
&emsp; •	An FPGA development board (MAX 10) with an RGB matrix and push buttons <br /> <br />
The game is implemented using VHDL and compiled using Quartus SJ Lite Edition Version  18.0.0, the code is written in assembly language and was translated using the asm.tcl script.
## Gameplay
The objective of the game is to move the ball from the start position to the finish position by pressing the push buttons to control the direction of the ball. 
The game starts by randomly generating start and finish points and then a random maze is generated using binary tree algorithm. Each level is completed when the ball reaches the end position. When level is completed, a new maze is randomly generated for the next level.
