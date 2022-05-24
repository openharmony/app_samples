# eTS Running Lock

### Introduction

This sample shows how to test the running lock that prevents the system from entering sleep mode. It uses the black and white wallpapers to simulate the screen-off and screen-on states.

### Usage

1. Touch **Query support** to check whether the system supports the running lock.

2. Touch **Timing out screen 5s after**. The screen is turned off 5s later (simulated with a black wallpaper).

2. Enable the running lock. The system will be blocked from entering sleep mode. Five seconds after the setting, the screen will always on (simulated with a white wallpaper).

3. Disable the running lock. After 5 seconds, the screen turns off (simulated with a black wallpaper).

4. After the screen is turned off, touch any area on the screen to turn it on (simulated with a white wallpaper).

### Constraints

This sample can only be run on standard-system devices.
