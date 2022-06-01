# NativeAPI

### Introduction

This sample shows how to call C++ APIs in eTS and how C++ APIs call back JS APIs to play the Gomoku game. The native APIs implement the calculation logic, and eTS implements UI rendering and re-rendering.

For details about how to use the native APIs, see [Using Native APIs in Application Projects](https://gitee.com/openharmony/docs/blob/master/en/application-dev/napi/napi-guidelines.md).

### How to Use

1. Start the sample app. An empty checkerboard is displayed. In this example, AI places black chess pieces, and you place white chess pieces. Touch **Start game**. AI drops the first black piece.

2. Touch a crosspoint on the checkerboard to drop a white piece on it. AI automatically calculates the position and places a black piece.

3. When the game ends, a message will be displayed and the checkerboard will be cleared.

### Constraints

1. This sample can only be run on standard-system devices.

2. The DevEco Studio version used in this sample must be 3.0.0.900 or later.
