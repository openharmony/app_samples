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
import ohos.multimodalinput.standard.KeyEventHandle;
import ohos.multimodalinput.standard.MultimodalEventHandle;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.samples.multimodalevent.utils.Utils;

import java.lang.ref.WeakReference;

/**
 * KeyEventAbilitySclice
 *
 * @since 2021-05-24
 */
public class KeyEventAbilitySclice extends AbilitySlice {
    private static final String TAG = "KeyEventAbilitySclice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    /**
     * BACK_KEY_CODE BACK KEY KEYCODE
     */
    private static final int BACK_KEY_CODE = 2;

    private final Utils utils = Utils.getInstance();

    private final KeyEventHandle keyEventHandle = keyEvent -> {
        HiLog.info(LABEL_LOG, "keyEvent");
        if (keyEvent != null && keyEvent.isKeyDown()) {
            int keyCode = keyEvent.getKeyCode();
            if (keyCode != BACK_KEY_CODE) {
                showKeyEvent();
            }
        }
        return false;
    };

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_key_event_ability_slice);
        MultimodalEventHandle.registerStandardizedEventHandle(getAbility(), keyEventHandle);
    }

    private void showKeyEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String message = "This is keyEvent";
        utils.showDialogBox(message, referenceContext.get());
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
        MultimodalEventHandle.unregisterStandardizedEventHandle(getAbility(), keyEventHandle);
    }
}
