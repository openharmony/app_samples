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
import ohos.multimodalinput.event.TouchEvent;
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
public class TouchAbilitySlice extends AbilitySlice {
    private static final String TAG = "TouchAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final Utils utils = Utils.getInstance();

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_first_main_ability_slice);

        Component componentTouch = findComponentById(ResourceTable.Id_touch_event_button);
        HiLog.info(LABEL_LOG, "setTouchEventListener");
        componentTouch.setTouchEventListener(onTouchEvent);
    }

    private void showTouchEvent(TouchEvent touchEvent) {
        Date date = new Date();
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String[] items = new String[] {
                "This is TouchEvent",
                "Current Time：" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                        Locale.getDefault()).format(date.getTime()),
                "Operation Start Time: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                        Locale.getDefault()).format(date.getTime() - touchEvent.getStartTime()),
                "Event Phase: " + touchEvent.getPhase()
        };
        utils.showDialogBox(items, referenceContext.get());
    }

    private final Component.TouchEventListener onTouchEvent = (component, touchEvent) -> {
        HiLog.info(LABEL_LOG, "onTouchEvent");
        showTouchEvent(touchEvent);
        return true;
    };

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
    }
}
