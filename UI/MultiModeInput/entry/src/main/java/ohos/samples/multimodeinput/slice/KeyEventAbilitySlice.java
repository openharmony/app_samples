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
import ohos.multimodalinput.event.KeyEvent;
import ohos.samples.multimodeinput.ResourceTable;
import ohos.samples.multimodeinput.utils.Utils;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * KeyAbilitySlice
 *
 * @since 2021-05-12
 */
public class KeyEventAbilitySlice extends AbilitySlice {
    private static final String TAG = "KeyEventAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    /**
     * BACK_KEY_CODE BACK KEY KEYCODE
     */
    private static final int BACK_KEY_CODE = 2;

    private final Utils utils = Utils.getInstance();

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_key_main_ability_slice);
        Component componentKey = findComponentById(ResourceTable.Id_key_event_text);
        HiLog.info(LABEL_LOG, "setKeyEventListener");
        componentKey.setKeyEventListener(onKeyEvent);
        componentKey.setTouchFocusable(true);
        componentKey.setFocusable(Component.FOCUS_ENABLE);
        componentKey.requestFocus();
    }

    private void showKeyEvent(KeyEvent keyEvent) {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String[] items = new String[] {
                "This is keyEvent",
                "Current Time：" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                        Locale.getDefault()).format(new Date().getTime()),
                "keyCode Value: " + keyEvent.getKeyCode(),
                "Key press duration: " + keyEvent.getKeyDownDuration(),
                "Is Key Pressed: " + keyEvent.isKeyDown()
        };
        utils.showDialogBox(items, referenceContext.get());
    }

    private final Component.KeyEventListener onKeyEvent = (component, keyEvent) -> {
        HiLog.info(LABEL_LOG, "onKeyEvent");
        if (keyEvent.isKeyDown()) {
            int keyCode = keyEvent.getKeyCode();
            if (keyCode != BACK_KEY_CODE) {
                showKeyEvent(keyEvent);
            }
        }
        return false;
    };

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
    }
}
