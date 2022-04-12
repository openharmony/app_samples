# StageCallAbility

### Introduction

This sample shows how to start an ability and use the **Call** function of the stage model, including starting another ability, creating a callee, and accessing the callee.

### Usage

1. Start the demo app. The main ability is started, and **Call Sample** is displayed on the page.

2. Touch **Start Callee Ability**. **Callee Ability** is displayed on the page.

3. Switch to the **MainAbility** page and touch **Obtain Caller** to obtain the caller interface. The main ability is the caller, and the callee ability is the callee. This operation does not switch the **Callee Ability** page to the foreground.

4. In the text box below **Enter message to send**, enter a string, for example, "play music".

5. Touch **Send Message Through Call** to serialize the string entered and send the processed string to the callee. A message is displayed on the **MainAbility** page, indicating that the message is sent successfully. Switch to the **Callee Ability** page, and you can see the **play music** message sent by the caller.

6. Touch **Release Caller** to release the caller interface. After the caller is released, the main ability cannot send data to the callee ability.

### Constraints

1. This sample can only be run on standard-system devices.
2. This sample demonstrates the stage model, which supports only API version 9.
