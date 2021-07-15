# Lightweight Preferences Database<a name="EN-US_TOPIC_0000001080279654"></a>

### Introduction<a name="section103mcpsimp"></a>

The lightweight  **Preferences**  database supports lightweight key-value operations and allows local apps to store a small amount of data. This sample shows how to create, delete, update, and query preferences data in an app by using  **Preferences**. It mainly covers the preferences data for the login and home screen background color.

### Usage<a name="section105mcpsimp"></a>

1.  On the startup screen of your app, choose not to display this screen again. After this preference setting is saved, the app should skip the startup screen and directly display the simulated login screen the next time it starts up.
2.  On the simulated login screen, enter the user name and password to log in. The app will automatically remember the login status so that no login is required in future.
3.  On the home screen, apply a background color by selecting the corresponding color. Clear preferences settings to clear the saved background color.

### Constraints<a name="section110mcpsimp"></a>

This sample can only be run on large-system devices.

