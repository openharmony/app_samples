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

package ohos.samples.accessibilityservice.tts;

import ohos.ai.tts.TtsClient;
import ohos.ai.tts.TtsListener;
import ohos.ai.tts.TtsParams;
import ohos.ai.tts.constants.TtsEvent;
import ohos.app.Context;
import ohos.data.distributed.common.KvManagerConfig;
import ohos.data.distributed.common.KvManagerFactory;
import ohos.samples.accessibilityservice.utils.LogUtils;
import ohos.utils.PacMap;

/**
 * TtsManager
 *
 * @since 2021-07-23
 */
public class TtsManager {
    private static final String TAG = TtsManager.class.getSimpleName();

    private static TtsManager instance;

    private final TtsClient ttsClient;

    private Context mContext;

    private final TtsListener tsListener = new TtsListener() {
        @Override
        public void onStart(String s) {
            LogUtils.info(TAG, "TtsListener,onStart:" + s);
        }

        @Override
        public void onProgress(String s, byte[] bytes, int i) {
            LogUtils.info(TAG, "TtsListener,onProgress:" + s);
        }

        @Override
        public void onFinish(String s) {
            LogUtils.info(TAG, "TtsListener,onFinish:" + s);
        }

        @Override
        public void onError(String s, String s1) {
            LogUtils.info(TAG, "TtsListener,onError:" + s);
        }

        @Override
        public void onEvent(int event, PacMap pacMap) {
            LogUtils.info(TAG, "TtsListener,onEvent:" + event);
            if (event == TtsEvent.CREATE_TTS_CLIENT_SUCCESS) {
                TtsParams ttsParams = new TtsParams();
                String deviceId = KvManagerFactory.getInstance()
                        .createKvManager(new KvManagerConfig((mContext))).getLocalDeviceInfo().getId();
                ttsParams.setDeviceId(deviceId);
                ttsClient.init(ttsParams);
            }
        }

        @Override
        public void onSpeechStart(String s) {
            LogUtils.info(TAG, "TtsListener,onSpeechStart:" + s);
        }

        @Override
        public void onSpeechProgressChanged(String s, int i) {
            LogUtils.info(TAG, "TtsListener,onSpeechProgressChanged:" + s);
        }

        @Override
        public void onSpeechFinish(String s) {
            LogUtils.info(TAG, "TtsListener,onSpeechFinish:" + s);
        }
    };

    /**
     * getInstance
     *
     * @return TtsManager
     */
    public static TtsManager getInstance() {
        if (instance == null) {
            synchronized (TtsManager.class) {
                instance = new TtsManager();
            }
        }
        return instance;
    }

    TtsManager() {
        ttsClient = TtsClient.getInstance();
    }

    /**
     * log error
     *
     * @param context Context
     */
    public void init(Context context) {
        mContext = context;
        ttsClient.create(context, tsListener);
    }

    /**
     * log error
     *
     * @param text String
     * @param utteranceId String
     */
    public void speakText(String text, String utteranceId) {
        ttsClient.speakText(text, utteranceId);
    }

    /**
     * destroy
     */
    public void destroy() {
        ttsClient.destroy();
    }
}
