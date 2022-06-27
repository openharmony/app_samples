# USB management

### Introduction

This example demonstrates the use of USB device management, including USB device insertion and removal status monitoring and USB device information display. The results are as follows:

![](screenshots/device/DeviceList.png)

# Related Conceptions

1. [Subscribe to USB Listening Events](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-commonEvent.md#commoneventcreatesubscriber) : Obtain the interface usage status by subscribing to the USB insertion and removal listening events.

2. [Get USB Device List](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-usb.md#usbgetdevices): Gets the list of plugged in USB devices.

### Related permissions

Not involved

### Usage

1. Open the **USB Listening** switch, and the interface pops up the prompt of "Start Listening...".

2. Plug in the device, the interface will have a "USB plugged in" prompt, the device list will show the plugged in device. If the list is not updated in time, you can manually refresh the drop-down list.

3. Click on the device, the pop-up box will display the specific information of the USB device, click the **OK** button to return to the main page.

4. Unplug the USB device, the interface will have a "removed device" prompt, and the device list will remove the device model. If the list is not updated in time, you can manually refresh the drop-down list.

### Constraints and Restrictions

1. This example is only supported to run on standard systems.

2. This example needs to use DevEco Studio version 3.0.0.901 and above to compile and run.
