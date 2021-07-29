# Accessibility Service<a name="EN-US_TOPIC_0000001133985994"></a>

### Introduction<a name="section104mcpsimp"></a>

This sample shows how to use the accessibility service. This service inherits from  **AccessibleAbility**  to listen for window changes, click events, and physical keys of the system to perform some operations.

1. Configure the types of events to listen for in the  **accessibility\_ability\_config.xml**  file.

2.  **MyAccessibilityService**  inherits from  **AccessibleAbility**. It listens for screen changing events and provides prompts; listens for click events, plays voice prompts, and executes global events; listens for the volume key events to scroll the text up and down.

### Usage<a name="section110mcpsimp"></a>

1. Go to  **Settings**  \>  **Accessibility features**  \>  **Accessibility**  \>  **Installed services**, enable  **Accessibility**, and return to the app operation.

2. Go to the app screen and touch  **Click, Back to home**. The service listens to the touch of the button, broadcasts the button content, and executes the global HOME event to return to the home screen.

3. Touch  **KeyPressEventPage**. On the screen displayed, the text can be scrolled up and down by pressing the volume key.

### Constraints<a name="section116mcpsimp"></a>

This sample can only be run on large-system devices.

