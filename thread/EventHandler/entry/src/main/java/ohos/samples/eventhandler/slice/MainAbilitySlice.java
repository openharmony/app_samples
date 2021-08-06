/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.eventhandler.slice;

import ohos.samples.eventhandler.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int EVENT_MESSAGE_NORMAL = 0x1000001;

    private static final int EVENT_MESSAGE_DELAY = 0x1000002;

    private static final int EVENT_MESSAGE_CROSS_THREAD = 0x1000003;

    private static final int DELAY_TIME = 1000;

    private Text resultText;

    private StringBuffer stringBuffer = new StringBuffer();

    private TestEventHandler handler;

    private EventRunner eventRunner;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initHandler();
        initComponents();
    }

    private void initHandler() {
        eventRunner = EventRunner.create("TestRunner");
        handler = new TestEventHandler(eventRunner);
    }

    private void initComponents() {
        Component sendEventButton = findComponentById(ResourceTable.Id_send_event_button);
        Component postTaskButton = findComponentById(ResourceTable.Id_post_task_button);
        Component sendToMainButton = findComponentById(ResourceTable.Id_send_to_main_button);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        sendEventButton.setClickedListener(this::sendInnerEvent);
        postTaskButton.setClickedListener(this::postRunnableTask);
        sendToMainButton.setClickedListener(this::sendToOriginalThread);
    }

    private void sendInnerEvent(Component component) {
        stringBuffer = new StringBuffer();
        long param = 0L;
        InnerEvent normalInnerEvent = InnerEvent.get(EVENT_MESSAGE_NORMAL, param, null);
        InnerEvent delayInnerEvent = InnerEvent.get(EVENT_MESSAGE_DELAY, param, null);
        handler.sendEvent(normalInnerEvent, EventHandler.Priority.IMMEDIATE);
        handler.sendEvent(delayInnerEvent, DELAY_TIME, EventHandler.Priority.IMMEDIATE);
    }

    private void postRunnableTask(Component component) {
        stringBuffer = new StringBuffer();
        Runnable task1 = () -> {
            stringBuffer.append("Post runnableTask1 done").append(System.lineSeparator());
            getUITaskDispatcher().asyncDispatch(() -> resultText.setText(stringBuffer.toString()));
        };
        Runnable task2 = () -> {
            stringBuffer.append("Post runnableTask2 done").append(System.lineSeparator());
            getUITaskDispatcher().asyncDispatch(() -> resultText.setText(stringBuffer.toString()));
        };
        handler.postTask(task1, EventHandler.Priority.IMMEDIATE);
        handler.postTask(task2, DELAY_TIME, EventHandler.Priority.IMMEDIATE);
    }

    private void sendToOriginalThread(Component component) {
        stringBuffer = new StringBuffer();
        long param = 0;
        InnerEvent innerEvent = InnerEvent.get(EVENT_MESSAGE_CROSS_THREAD, param, eventRunner);
        handler.sendEvent(innerEvent, DELAY_TIME, EventHandler.Priority.IMMEDIATE);
    }

    private class TestEventHandler extends EventHandler {
        private TestEventHandler(EventRunner runner) {
            super(runner);
        }

        @Override
        public void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case EVENT_MESSAGE_NORMAL:
                    stringBuffer.append("Received an innerEvent message").append(System.lineSeparator());
                    getUITaskDispatcher().asyncDispatch(() -> resultText.setText(stringBuffer.toString()));
                    break;
                case EVENT_MESSAGE_DELAY:
                    stringBuffer.append("Received an innerEvent delay message").append(System.lineSeparator());
                    getUITaskDispatcher().asyncDispatch(() -> resultText.setText(stringBuffer.toString()));
                    break;
                case EVENT_MESSAGE_CROSS_THREAD:
                    Object object = event.object;
                    if (object instanceof EventRunner) {
                        EventRunner runner = (EventRunner) object;
                        EventHandler eventHandler = new EventHandler(runner) {
                            @Override
                            public void processEvent(InnerEvent innerEvent) {
                                stringBuffer.append("OriginalThread receive a message");
                                getUITaskDispatcher().asyncDispatch(() -> resultText.setText(stringBuffer.toString()));
                            }
                        };
                        int testEventId = 1;
                        long testParam = 0;
                        InnerEvent innerEvent = InnerEvent.get(testEventId, testParam, null);
                        eventHandler.sendEvent(innerEvent);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
