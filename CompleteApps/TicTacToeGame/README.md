# Tic-Tac-Toe

##### Introduction

This sample is developed using Java. Tic-Tac-Toe is a simple and fun game for two players. It is played on a 3 x 3 grid. Each player's goal is to make three in a row. In this sample app, you can directly select a device on the same LAN to join the game.

##### Usage

1. ###### Starting the Game

   Touch **Start** on the home screen of the sample app to view the devices in the same network, select a device, and touch **OK** to start the FA on that device to join the game.

   

2. ###### Playing the Game

   Touch any open square in the 3 x 3 grid. The corresponding mark, **X** or **O**, is automatically filled.

   The upper left corner of the app shows whether your current mark is **X** or **O**.

   When it's your turn to mark the space, the corresponding icon in the upper left corner will shake and the timer below will start to count. When it's the turn for your opponent, your touch does not take effect.

   

3. ###### Showing the Game Result

   The first player to make three of their own mark in a row vertically, horizontally, or diagonally wins the game. If a party does not mark any space within the specified time, then the other party wins. A dialog box indicating that the party has won the game is displayed to the winner, and a dialog box indicating that the party has lost the game is displayed to the loser. If all nine squares are filled and neither player has three in a row, the game is considered a tie. A dialog box indicating that the game ends in a tie is displayed to both parties.

   

4. Starting the Game Again

   After the game ends, touch the reset button in the lower right corner to play the game again.

   

5. Returning to the Player Selection Page

   After the game ends, touch the back button in the lower left corner to return to the player selection page. You can select another device to start the game.

   

##### Constraints

1. Compilation Constraints

   Set up the DevEco Studio development environment.

   For details, see [Building the Development Environment](https://developer.harmonyos.com/en/docs/documentation/doc-guides/installation_process-0000001071425528).
  

2. Usage Constraints

   This sample app requires two phones in the same network, and only two phones can play the game at the same time.
