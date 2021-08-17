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

package ohos.samples.multimodeinput.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.samples.multimodeinput.ResourceTable;
import ohos.samples.multimodeinput.utils.Utils;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * MmiPointAbilitySlice
 *
 * @since 2021-05-12
 */
public class SpeechAbilitySlice extends AbilitySlice {
    private static final String TAG = "SpeechAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String VOICE_EVENT_KEY = "MOVE";

    private final Utils utils = Utils.getInstance();

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_second_main_ability_slice);
        Component componentSpeech = findComponentById(ResourceTable.Id_speech_event_button);
        componentSpeech.subscribeVoiceEvents(new Component.VoiceEvent(VOICE_EVENT_KEY));
        componentSpeech.setSpeechEventListener(onSpeechEvent);
    }

    private final Component.SpeechEventListener onSpeechEvent = (component, speechEvent) -> {
        HiLog.info(LABEL_LOG, "onSpeechEvent");
        if (speechEvent.getActionProperty().equals(VOICE_EVENT_KEY)) {
            showSpeechEvent();
        }
        return false;
    };

    private void showSpeechEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String[] items = new String[] {
                "This is speechEvent",
                "Current Time：" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                        Locale.getDefault()).format(new Date().getTime())
        };
        utils.showDialogBox(items, referenceContext.get());
    }

    @Override
    protected void onActive() {
        super.onActive();
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
    }
}
