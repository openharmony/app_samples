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

package ohos.samples.pageability.slice;

import ohos.samples.pageability.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityContinuation;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.agp.components.Component;
import ohos.agp.components.TextField;
import ohos.agp.window.dialog.ToastDialog;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

/**
 * ContinuationAbilitySlice
 */
public class ContinuationAbilitySlice extends AbilitySlice implements IAbilityContinuation {
    private static final String TAG = ContinuationAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String MESSAGE_KEY = "ohos.samples.pageability.MESSAGE_KEY";

    private String message;

    private boolean isContinued;

    private TextField messageTextField;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ohos.samples.pageability.ResourceTable.Layout_continuation_ability);
        initComponents();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_continue_button).setClickedListener(this::migrateAbility);
        messageTextField = (TextField) findComponentById(ResourceTable.Id_message_textField);
        if (isContinued && message != null) {
            messageTextField.setText(message);
        }
    }

    private void migrateAbility(Component component) {
        String messageSend = messageTextField.getText();
        if (messageSend.isEmpty()) {
            new ToastDialog(this).setText("Message can not be null").show();
            return;
        }

        try {
            continueAbility();
        } catch (IllegalStateException illegalStateException) {
            HiLog.error(LABEL_LOG, "%{public}s", "migrateAbility: IllegalStateException");
        }
    }

    @Override
    public boolean onStartContinuation() {
        return true;
    }

    @Override
    public boolean onSaveData(IntentParams intentParams) {
        intentParams.setParam(MESSAGE_KEY, messageTextField.getText());
        return true;
    }

    @Override
    public boolean onRestoreData(IntentParams intentParams) {
        if (intentParams.getParam(MESSAGE_KEY) instanceof String) {
            message = (String) intentParams.getParam(MESSAGE_KEY);
            isContinued = true;
        }
        return true;
    }

    @Override
    public void onCompleteContinuation(int code) {
        terminate();
    }
}
