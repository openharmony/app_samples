# Native_layer



### Introduction

Native_layer declares the Java Native Interface (JNI) related to the native layer. This sample exemplifies how to use the JNI of Native_layer to obtain the native layer that matches the Java surface object. Besides obtaining the information about the native layer, you can also set its size and format.

### Usage

1. Click **Get nativelayer info** to obtain the width, height, and format of the native layer for the surface object by calling the JNI.

2. Click **Set nativelayer width and height**. In the width and height text boxes, enter int values, and then click **OK**. The graphics and text on the surface will be drawn based on your settings.

3. Click **Set nativelayer format**. In the format text box, enter an int value, and then click **OK** to set the format of the native layer.

### Constraints

This sample can only be run on large-system devices.
