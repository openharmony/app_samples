# Native_image



### Introduction

Native_image provides access to pixel data and pixel map information. This sample shows how to declare a Java Native Interface (JNI) and use the JNI to lock, access, or unlock the pixel data.

### Usage

1. When you touch **AccessPixels**, the call result is displayed. (**AccessPixels** is used to obtain the memory address of a given **PixelMap** object and lock the memory.)

2. When you touch **GetImageInfo**, the **PixelMap** object information is displayed.

3. When you touch **UnAccessPixels**, the call result is displayed. (**UnAccessPixels** is used to unlock the memory.)

### Constraints

This sample can only be run on large-system devices.
