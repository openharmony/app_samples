# Multimodal Input Standard Event<a name="EN-US_TOPIC_0000001172476679"></a>

### Introduction<a name="section104mcpsimp"></a>

In this sample app of multimodal input, the  **MultimodalEventHandle**  class is used to register standard events that are derived from the base class  **StandardizedEventHandle**. As such, the input events from different devices can be mapped to the standard events for processing.

### Usage<a name="section107mcpsimp"></a>

The home page of the sample app contains the  **TouchEventHandle**,  **KeyEventHandle**,  **CommonEventHandle**,  **MediaEventHandle**,  **SystemEventHandle**, and  **TelephoneEventHandle**  buttons. The specific implementation is as follows:

1.  When you tap the  **TouchEventHandle**  button, you will be redirected to another page. If you tap the  **touchEvent**  button on that page, a popup dialog indicating a standard touch event will be displayed.
2.  When you tap the  **KeyEventHandle**  button, you will be redirected to another page. If you press the volume key on the phone, a popup dialog indicating a standard key pressing event will be displayed.
3.  When you tap the  **CommonEventHandle**  button, you will be redirected to another page. If you press the  **Enter**  key on the keyboard, a popup dialog indicating a standard common event will be displayed.
4.  When you tap the  **MediaEventHandle**  button, you will be redirected to another page. If you insert the headset and press the  **Play**  key on the headset, a popup dialog indicating a standard media event will be displayed.
5.  When you tap the  **SystemEventHandle**  button, you will be redirected to another page. If you press the  **Back**  key to go back, a popup dialog indicating a standard system event will be displayed.
6.  When you tap the  **TelephoneEventHandle**  button, you will be redirected to another page. If you insert the headset and tap the  **Call**  or  **End Call**  button, a popup dialog indicating a standard call event will be displayed.

### Constraints<a name="section117mcpsimp"></a>

This sample can be run only on the standard-system devices.

For details about the applicable devices of multimodal input standard events, see  [Multimodal Input Standard Event Overview](https://developer.harmonyos.com/en/docs/documentation/doc-guides/ui-multimodal-standard-event-overview-0000001079953054).

