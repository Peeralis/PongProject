# Pong Game (2-Player) using Vivado

## Overview
This project implements a classic Pong game for two players using FPGA design in Vivado. The game is displayed on a VGA monitor and controlled via external input devices.

## Features
- **Two-player gameplay**: Each player controls a paddle to hit the ball.
- **VGA Output**: Displays the game on a monitor.
- **Score tracking**: Keeps track of points for each player.
- **Collision detection**: Handles ball and paddle interactions.
- **Real-time gameplay**: Smooth motion and fast response.

## Hardware Requirements
- FPGA board
- VGA display
- Input controllers (buttons or switches)

## Software Requirements
- Vivado Design Suite (for synthesis and implementation)
- Verilog or VHDL for hardware description

## Implementation Details
### 1. VGA Controller
Generates VGA signals for displaying the game on a monitor.

### 2. Game Logic
- Ball movement and collision detection.
- Paddle movement controlled via input.
- Score tracking and game reset conditions.

### 3. Input Handling
- Buttons or switches are used for paddle control.
- Debouncing techniques ensure stable input.

## How to Run the Project
1. Open Vivado and create a new project.
2. Add the source files and constraints.
3. Synthesize and implement the design.
4. Generate the bitstream and program the FPGA.
5. Connect the VGA display and input devices.
6. Play the game!

## Credits
Developed by [PeemGitHub](https://github.com/Peemgithub) and [Peeralis](https://github.com/Peeralis).

## License
This project is open-source under the MIT License.

