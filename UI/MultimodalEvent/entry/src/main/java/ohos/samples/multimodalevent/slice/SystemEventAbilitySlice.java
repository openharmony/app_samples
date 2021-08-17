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
import ohos.multimodalinput.standard.SystemEventHandle;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.samples.multimodalevent.utils.Utils;

import java.lang.ref.WeakReference;

/**
 * SystemEventAbilitySlice
 *
 * @since 2021-05-25
 */
public class SystemEventAbilitySlice extends AbilitySlice {
    private static final String TAG = "SystemEventAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final Utils utils = Utils.getInstance();

    private final SystemEventHandle systemEventHandle = new SystemEventHandle() {
        @Override
        public boolean onMute(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onClosePage(MultimodalEvent multimodalEvent) {
            HiLog.info(LABEL_LOG, "onClosePage");
            if (multimodalEvent != null) {
                showSystemEvent();
            }
            return false;
        }
    };

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_system_event_ability_slice);
        MultimodalEventHandle.registerStandardizedEventHandle(getAbility(), systemEventHandle);
    }

    private void showSystemEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String message = "Page closed";
        utils.showDialogBox(message, referenceContext.get());
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
        MultimodalEventHandle.unregisterStandardizedEventHandle(getAbility(), systemEventHandle);
    }
}
