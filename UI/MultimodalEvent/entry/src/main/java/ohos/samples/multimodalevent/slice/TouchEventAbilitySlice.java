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
import ohos.multimodalinput.standard.MultimodalEventHandle;
import ohos.multimodalinput.standard.TouchEventHandle;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.samples.multimodalevent.utils.Utils;

import java.lang.ref.WeakReference;

/**
 * TouchEventAbilitySlice
 *
 * @since 2021-05-24
 */
public class TouchEventAbilitySlice extends AbilitySlice {
    private static final String TAG = "TouchEventAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static int count = 0;

    private final Utils utils = Utils.getInstance();

    private final TouchEventHandle touchEventHandle = touchEvent -> {
        HiLog.info(LABEL_LOG, "ontouch touchevent2");
        if (touchEvent != null) {
            if (count > 0) {
                return false;
            }
            count++;
            showTouchEvent();
        }
        return false;
    };

    private void showTouchEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String message = "This is touchEvent";
        utils.showDialogBox(message, referenceContext.get());
    }

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_touch_event_ability_slice);
        MultimodalEventHandle.registerStandardizedEventHandle(getAbility(), touchEventHandle);
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
        MultimodalEventHandle.unregisterStandardizedEventHandle(getAbility(), touchEventHandle);
    }
}
