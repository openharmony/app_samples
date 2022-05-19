# Mouse Event

### Introduction

This sample simulates a minesweeper game that invokes mouse event-related APIs.

### Usage

1. Minesweeper rules: A player clicks a square to open it. If the player opens a mined cell, the game ends. Otherwise, the opened cell displays a number indicating the quantity of mines diagonally and/or adjacent to it. Right-clicking a cell will flag it, and the quantity of remaining mines decreases by 1. The player wins the game when all the hidden mines are found.
2. Hover the mouse pointer over a gray cell on the screen. The color of the cell becomes lighter.
3. Click a blank cell. A number is displayed in the cell, and this cell does not respond.
4. Right-click a blank cell, and the cell is displayed in red. If the cell contains a mine, the quantity of remaining mines decreases by 1, and the game continues. Otherwise, a dialog box is displayed, indicating that the game is over.
5. Middle-click a cell displayed with a number. The blank cells around that cell blink, and the non-blank cells (opened or flagged cells) do not blink.
6. In the dialog box that indicates the game is over, touch **Restart**. The screen refreshes and a new game starts.
7. In the dialog box that indicates the game is over, touch **Exit**. The game exits and the app is closed.

### Constraints

This sample requires an external mouse. It can only be run on standard-system devices.
