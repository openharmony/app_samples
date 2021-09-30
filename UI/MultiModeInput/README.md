# Multimodal Input<a name="EN-US_TOPIC_0000001126596074"></a>

### Introduction<a name="section104mcpsimp"></a>

This sample app of multimodal input illustrates how to use APIs such as  **KeyEventListener**,  **TouchEventListener**, and  **SpeechEventListener**  to handle corresponding key, touch, and speech events.

### Usage<a name="section107mcpsimp"></a>

The home page of the sample app contains the  **touchEvent**,  **keyEvent**,  **mouseEvent**, and  **speechEvent**  buttons. The specific implementation is as follows:

1.  When you tap the  **touchEvent**  button, you will be redirected to another page. If you tap the  **touch**  button on that page, a popup dialog indicating a touch event will be displayed.
2.  When you tap the  **keyEvent**  button, you will be redirected to another page. If you press the volume key on the phone, a popup dialog indicating a key pressing event will be displayed.
3.  When you tap the  **mouseEvent**  button, you will be redirected to another page. If you tap the  **mouse**  button on that page by pressing the left key of the mouse, a popup dialog indicating a mouse click event will be displayed.
4.  When you tap the  **speechEvent**  button, you will be redirected to another page. If you press the voice assistant button on the remote control of HUAWEI Vision, a popup dialog indicating a speech event will be displayed.

### Constraints<a name="section115mcpsimp"></a>

This sample can only be run on standard-system devices.

The support for multimodal input events varies depending on device types. For details, see  [Multimodal Input Overview](https://developer.harmonyos.com/en/docs/documentation/doc-guides/ui-multimodal-overview-0000000000031876).

