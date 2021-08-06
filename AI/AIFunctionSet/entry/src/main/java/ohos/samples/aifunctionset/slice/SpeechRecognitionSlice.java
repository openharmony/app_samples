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
import ohos.samples.aifunctionset.bean.AsrBean;
import ohos.samples.aifunctionset.utils.LogUtil;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.TextField;
import ohos.ai.asr.AsrClient;
import ohos.ai.asr.AsrIntent;
import ohos.ai.asr.AsrListener;
import ohos.ai.asr.util.AsrResultKey;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.utils.PacMap;
import ohos.utils.zson.ZSONException;
import ohos.utils.zson.ZSONObject;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Speech Recognition Slice
 */

public class SpeechRecognitionSlice extends BaseSlice {
    private static final String TAG = SpeechRecognitionSlice.class.getSimpleName();

    private static final int EVENT_MSG_INIT = 0x1000001;

    private static final int EVENT_MSG_PARSE_START = 0x1000002;

    private static final int EVENT_MSG_PARSE_END = 0x1000003;

    private static final int EVENT_MSG_ERROR = 0x1000004;

    private static final int VALID_LENGTH = 1280;

    private static final String RAW_AUDIO_WAV = "entry/resources/rawfile/asr_test.wav";

    private static final String RAW_AUDIO_PCM = "entry/resources/rawfile/asr_date_conversion.pcm";

    private AsrClient asrClient;

    private TextField outText;

    private String result;

    private String wavCachePath;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case EVENT_MSG_INIT:
                    showTips("InitAIEngine Success");
                    break;
                case EVENT_MSG_PARSE_START:
                    outText.setText("Doing now, please wait a moment ...");
                    break;
                case EVENT_MSG_PARSE_END:
                    parseJson();
                    break;
                case EVENT_MSG_ERROR:
                    showTips(result);
                    break;
            }
        }
    };

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this)
            .parse(ResourceTable.Layout_speech_recognition_slice, null, false);
        rootLayout.addComponent(currComponent);
        initData();
        initComponents();
        initAIEngine();
    }

    private void initData() {
        wavCachePath = new File(getFilesDir(), "asr_test.wav").getPath();
        String pcmCachePath = new File(getFilesDir(), "asr_date_conversion.pcm").getPath();
        writeToDisk(RAW_AUDIO_WAV, wavCachePath);
        writeToDisk(RAW_AUDIO_PCM, pcmCachePath);
    }

    private void initComponents() {
        outText = (TextField) findComponentById(ResourceTable.Id_out_text);
        Component startButton = findComponentById(ResourceTable.Id_start_parse);
        startButton.setClickedListener(this::start);
    }

    private void start(Component component) {
        showTips("start parse ...");
        asrClient.startListening(new AsrIntent());
        File file = new File(wavCachePath);
        if (!file.exists()) {
            return;
        }
        int initialSize = new Long(file.length()).intValue();
        try (ByteArrayOutputStream bos = new ByteArrayOutputStream(initialSize);
            BufferedInputStream in = new BufferedInputStream(new FileInputStream(file))) {
            byte[] buffer = new byte[VALID_LENGTH];
            int len;
            while (true) {
                len = in.read(buffer, 0, VALID_LENGTH);
                if (len == -1) {
                    break;
                }
                bos.reset();
                bos.write(buffer, 0, len);
                asrClient.writePcm(bos.toByteArray(), VALID_LENGTH);
            }
        } catch (IOException e) {
            LogUtil.error(TAG, "startParse : IOException ");
        }
    }

    private void initAIEngine() {
        asrClient = AsrClient.createAsrClient(this).orElse(null);
        if (asrClient != null) {
            AsrIntent asrIntent = new AsrIntent();
            useDefaultAsrIntent(asrIntent);
            asrIntent.setAudioSourceType(AsrIntent.AsrAudioSrcType.ASR_SRC_TYPE_PCM);
            asrClient.init(asrIntent, asrListener);
        }
    }

    private void useDefaultAsrIntent(AsrIntent asrIntent) {
        asrIntent.setVadEndWaitMs(2000);
        asrIntent.setVadFrontWaitMs(4800);
        asrIntent.setTimeoutThresholdMs(20000);
    }

    @Override
    public void setTitle() {
        aiTitle.setText("Speech Recognition");
    }

    @Override
    protected void onStop() {
        super.onStop();
        release();
    }

    private void parseJson() {
        try {
            AsrBean asrBean = ZSONObject.stringToClass(result, AsrBean.class);
            if (asrBean != null && asrBean.getResult().size() > 0) {
                AsrBean.Result resultContent = asrBean.getResult().get(0);
                outText.setText("Result:" + System.lineSeparator() + resultContent.getWord());
            }
        } catch (ZSONException e) {
            LogUtil.error(TAG, "parseJson ZSONException");
        }
    }

    private final AsrListener asrListener = new AsrListener() {
        @Override
        public void onInit(PacMap pacMap) {
            result = pacMap.getString(AsrResultKey.RESULTS_RECOGNITION);
            handler.sendEvent(EVENT_MSG_INIT);
        }

        @Override
        public void onBeginningOfSpeech() {
            LogUtil.info(TAG, "onBeginningOfSpeech");
        }

        @Override
        public void onRmsChanged(float value) {
            LogUtil.info(TAG, "onRmsChanged :" + value);
        }

        @Override
        public void onBufferReceived(byte[] bytes) {
            LogUtil.info(TAG, "onRmsChanged :" + new String(bytes));
        }

        @Override
        public void onEndOfSpeech() {
            LogUtil.info(TAG, "onEndOfSpeech ");
        }

        @Override
        public void onError(int errorCode) {
            result = "onError code :" + errorCode;
            handler.sendEvent(EVENT_MSG_ERROR);
        }

        @Override
        public void onResults(PacMap pacMap) {
            LogUtil.info(TAG, "onResults :" + result);
            result = pacMap.getString(AsrResultKey.RESULTS_RECOGNITION);
            handler.sendEvent(EVENT_MSG_PARSE_END);
        }

        @Override
        public void onIntermediateResults(PacMap pacMap) {
            LogUtil.info(TAG, "onIntermediateResults :" + result);
            result = pacMap.getString(AsrResultKey.RESULTS_RECOGNITION);
            handler.sendEvent(EVENT_MSG_PARSE_END);
        }

        @Override
        public void onEnd() {
            LogUtil.info(TAG, "onEnd");
        }

        @Override
        public void onEvent(int i, PacMap pacMap) {
            LogUtil.info(TAG, "onEvent");
        }

        @Override
        public void onAudioStart() {
            LogUtil.info(TAG, "onAudioStart");
            handler.sendEvent(EVENT_MSG_PARSE_START);
        }

        @Override
        public void onAudioEnd() {
            LogUtil.info(TAG, "onAudioEnd");
        }
    };

    private void release() {
        if (asrClient != null) {
            asrClient.stopListening();
            asrClient.cancel();
            asrClient.destroy();
        }
    }

    private void writeToDisk(String rawFilePathString, String targetFilePath) {
        File file = new File(targetFilePath);
        if (file.exists()) {
            return;
        }
        RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry(rawFilePathString);
        try (FileOutputStream output = new FileOutputStream(new File(targetFilePath))) {
            Resource resource = rawFileEntry.openRawFile();
            byte[] cache = new byte[1024];
            int len = resource.read(cache);
            while (len != -1) {
                output.write(cache, 0, len);
                len = resource.read(cache);
            }
        } catch (IOException e) {
            LogUtil.error(TAG, "writeToDisk IOException");
        }
    }
}
