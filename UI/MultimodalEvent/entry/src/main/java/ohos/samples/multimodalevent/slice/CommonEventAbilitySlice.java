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
import ohos.multimodalinput.standard.CommonEventHandle;
import ohos.multimodalinput.standard.MultimodalEventHandle;
import ohos.samples.multimodalevent.ResourceTable;
import ohos.samples.multimodalevent.utils.Utils;

import java.lang.ref.WeakReference;

/**
 * CommonEventAbilitySlice
 *
 * @since 2021-05-25
 */
public class CommonEventAbilitySlice extends AbilitySlice {
    private static final String TAG = "CommonEventAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final Utils utils = Utils.getInstance();

    private final CommonEventHandle commonEventHandle = new CommonEventHandle() {
        @Override
        public boolean onShowMenu(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onSend(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onCopy(MultimodalEvent multimodalEvent) {
            HiLog.info(LABEL_LOG, "onCopy");
            if (multimodalEvent != null) {
                showCommonEvent();
            }
            return false;
        }

        @Override
        public boolean onPaste(MultimodalEvent multimodalEvent) {
            HiLog.info(LABEL_LOG, "onPaste");
            if (multimodalEvent != null) {
                showCommonEvent();
            }
            return false;
        }

        @Override
        public boolean onCut(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onUndo(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onRefresh(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onStartDrag(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onCancel(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onEnter(MultimodalEvent multimodalEvent) {
            HiLog.info(LABEL_LOG, "onEnter");
            if (multimodalEvent != null) {
                showCommonEvent();
            }
            return false;
        }

        @Override
        public boolean onPrevious(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onNext(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onBack(MultimodalEvent multimodalEvent) {
            return false;
        }

        @Override
        public boolean onPrint(MultimodalEvent multimodalEvent) {
            return false;
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_common_event_ability_slice);
        MultimodalEventHandle.registerStandardizedEventHandle(getAbility(), commonEventHandle);
    }

    private void showCommonEvent() {
        WeakReference<Context> referenceContext = new WeakReference<>(getContext());
        String message = "This is CommonEvent";
        utils.showDialogBox(message, referenceContext.get());
    }

    @Override
    protected void onStop() {
        super.onStop();
        utils.distroyDialogBox();
        MultimodalEventHandle.unregisterStandardizedEventHandle(getAbility(), commonEventHandle);
    }
}
