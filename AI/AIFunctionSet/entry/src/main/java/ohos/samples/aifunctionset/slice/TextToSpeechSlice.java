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

package ohos.samples.aifunctionset.slice;

import ohos.samples.aifunctionset.ResourceTable;
import ohos.samples.aifunctionset.utils.LogUtil;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.TextField;
import ohos.ai.tts.TtsClient;
import ohos.ai.tts.TtsListener;
import ohos.ai.tts.TtsParams;
import ohos.ai.tts.constants.TtsEvent;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.utils.PacMap;

import java.util.UUID;

/**
 * Text To Speech Slice
 */
public class TextToSpeechSlice extends BaseSlice {
    private static final String TAG = SpeechRecognitionSlice.class.getSimpleName();

    private static final int EVENT_MSG_INIT = 0x1000001;

    private boolean initItsResult;

    private TextField inputText;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            initTTSEngine();
        }
    };

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this).parse(ResourceTable.Layout_text_to_speech_slice, null, false);
        rootLayout.addComponent(currComponent);

        initTTSEngine();
        initComponents();
    }

    @Override
    public void setTitle() {
        aiTitle.setText("Text To Speech");
    }

    private void initComponents() {
        inputText = (TextField) findComponentById(ResourceTable.Id_input_text);
        Component startPlay = findComponentById(ResourceTable.Id_start_play);
        startPlay.setClickedListener(this::startPlay);
    }

    private void startPlay(Component component) {
        if (initItsResult) {
            TtsClient.getInstance().speakText(inputText.getText(), null);
        } else {
            showTips("InitTTSEngine Failed");
        }
    }

    private void initTTSEngine() {
        TtsClient.getInstance().create(this, ttsListener);
        TtsParams ttsParams = new TtsParams();
        ttsParams.setDeviceId(UUID.randomUUID().toString());
        initItsResult = TtsClient.getInstance().init(ttsParams);
        if (initItsResult) {
            showTips("InitTTSEngine Succeeded");
        } else {
            handler.sendEvent(EVENT_MSG_INIT, 1000);
        }
    }

    private final TtsListener ttsListener = new TtsListener() {
        @Override
        public void onEvent(int eventType, PacMap pacMap) {
            if (eventType == TtsEvent.CREATE_TTS_CLIENT_SUCCESS) {
                LogUtil.info(TAG, "TTS Client create succeeded");
            }
        }

        @Override
        public void onStart(String utteranceId) {
            LogUtil.info(TAG, utteranceId + " audio synthesis begins");
        }

        @Override
        public void onProgress(String utteranceId, byte[] audioData, int progress) {
            LogUtil.info(TAG, utteranceId + " audio synthesis progress：" + progress);
        }

        @Override
        public void onFinish(String utteranceId) {
            LogUtil.info(TAG, utteranceId + " audio synthesis completed");
        }

        @Override
        public void onSpeechStart(String utteranceId) {
            LogUtil.info(TAG, utteranceId + " begins to speech");
        }

        @Override
        public void onSpeechProgressChanged(String utteranceId, int progress) {
            LogUtil.info(TAG, utteranceId + " speech progress：" + progress);
        }

        @Override
        public void onSpeechFinish(String utteranceId) {
            LogUtil.info(TAG, utteranceId + " speech completed");
        }

        @Override
        public void onError(String utteranceId, String errorMessage) {
            LogUtil.info(TAG, utteranceId + " errorMessage: " + errorMessage);
        }
    };
}
