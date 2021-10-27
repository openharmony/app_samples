# Distributed Search

##### Introduction

This sample is developed using Java. It searches for local images, audio files, and video files and adds them to the distributed file system for quick file sharing. Users can enter a keyword to search for all files in the distributed file system.

##### Usage

1. Search
	Enter a keyword in the text box, and then touch the search button. You can also select a specific category to narrow down the search scope.
2. Viewing the Search Result
	The found files are displayed in a list.
	You can touch a specific record to view the file path.
	If no file is found, a message indicating no result is displayed.
3. Viewing Distributed Devices
	Touch the **Devices** button in the lower right corner of the home screen to view the devices that have been added to the distributed file system.

##### Constraints

1. Compilation Constraints
   
   Set up the DevEco Studio development environment.
  
   For details, see [Building the Development Environment](https://developer.harmonyos.com/en/docs/documentation/doc-guides/installation_process-0000001071425528).
   
2. Usage Constraints

   - To use this sample, two or more phones in the same network must be available.

   - The same user account is used to log in to these devices.

   - Only images, audio files, and video files stored in the external memory card can be searched.
