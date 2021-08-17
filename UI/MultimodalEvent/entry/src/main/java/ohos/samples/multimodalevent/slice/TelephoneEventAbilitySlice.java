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

package ohos.samples.multimodalevent.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.multimodalinput.event.MultimodalEvent;
import ohos.multimodalinput.standard.MultimodalEventHandle;
import ohos.multimodalinput.standard.TelephoneEventHandle;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.samples.multimodalevent.utils.Utils;

import java.lang.ref.WeakReference;

/**
 * TelephoneEventAbilitySlice
 *
 * @since 2021-05-24
 */
public class TelephoneEventAbilitySlice extends AbilitySlice {
    private static final String TAG = "TelephoneEventAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final Utils utils = Utils.getInstance();

    private final TelephoneEventHandle telephoneEventHandle = new TelephoneEventHandle() {
        @Override
        public boolean onAnswer(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onRefuse(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onHangup(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onTelephoneControl(MultimodalEvent multimodalEvent) {
            HiLog.info(LABEL_LOG, "onTelephoneControl");
            if (multimodalEvent != null) {
                showTelphoneEvent();
            }
            return false;
        }
    };

    private void showTelphoneEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String message = "This is showTelephoneEvent";
        utils.showDialogBox(message, referenceContext.get());
    }

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_tel_event_ability_slice);
        MultimodalEventHandle.registerStandardizedEventHandle(getAbility(), telephoneEventHandle);
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
        MultimodalEventHandle.unregisterStandardizedEventHandle(getAbility(), telephoneEventHandle);
    }
}
