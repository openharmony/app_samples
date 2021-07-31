# Distributed Calculator

### Introduction

This sample implements a simple calculator app using JS distributed features. The calculator can perform simple numerical calculations and start a remote calculator Feature Ability \(FA\) to perform collaborative calculation.

-   Remote startup:  **StartAbility**  is used to start a remote app.
-   Collaborative calculation: The  **DistributedDataKit**  distributed data framework is used to implement data synchronization between remote applications.

### Usage

-   Touch the icon on the desktop to start the calculator.
-   Touch the button in the upper right corner of the app, or swipe up, down, left, or right on the screen to display the device selection box.
-   In the device selection box, touch the name of a peer device to start the remote app.
-   After the remote app is started, perform operations on the app at either end. Data can be synchronized between the two apps in real time.
-   In the device selection box, touch the local device to close the remote app.

### Constraints

-   This calculator implements only simple addition, subtraction, multiplication, and division operations. You can implement more complex arithmetic operations on the  **calc**  page based on the current framework.
-   Distributed computing can be implemented only with distributed networking.

