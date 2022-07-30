# Distributed Music Player

### Introduction

In this sample, **fileIo** is used to obtain an audio file; **AudioPlayer** is used to play music, pause the playback, and play the next or previous song; **DeviceManager** is used to display the distributed device list and hop music playback across devices. The display effect is as follows:

![](./screenshots/device/distributedMusicPlayer_en.png)

### Concepts

Audio playback: The media subsystem provides audio and video services and implements audio playback by using **AudioPlayer**.

Data hop: The distributed data management module implements collaboration between databases of different devices for applications. The APIs provided by distributed data management can be used to save data to the distributed database and perform operations such as adding, deleting, modifying, and querying data in the distributed database.

### Required Permissions

ohos.permission.DISTRIBUTED_DATASYNC

### Usage

1. Play music. Touch the buttons on the music player to play music, pause the playback, and play the next or previous music clip.

2. Play music across devices. On the Super Device formed by multiple networked devices, touch the **Hop** button and select a device to play the music on the peer device.

### Constraints

- This sample can only be run on standard-system devices.

- This sample is based on the stage model, which is supported from API version 9.

- DevEco Studio 3.0 Beta3 (Build version: 3.0.0.901, built on May 30, 2022) must be used.
