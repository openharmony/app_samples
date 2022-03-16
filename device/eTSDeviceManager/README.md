# DeviceManager



### Introduction

This sample shows the use of the **DeviceManager** API in eTS, including obtaining the trusted device list, scanning for devices, authenticating devices, and subscribing to device status changes.

### Usage

1. The sample app automatically obtains the trusted devices and displays them in the **online** state on the device list. It also scans for devices and displays the discovered devices in the **discover** state on the device list.

2. Touch a device in the **discover** state to trigger authentication. After the authentication is complete, the page is automatically refreshed.

3. Subscribe to device status changes. When the device status changes, the page is automatically refreshed.

### Constraints

1. This sample requires a networking test.

2. This sample can only be run on standard-system devices.
