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

package ohos.samples.facerecognition.slice;

import ohos.samples.facerecognition.ResourceTable;
import ohos.samples.facerecognition.utils.ThreadPoolUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.CommonDialog;
import ohos.biometrics.authentication.BiometricAuthentication;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int EVENT_MESSAGE_SUCCESS = 0x1000001;

    private static final int EVENT_MESSAGE_FAIL = 0x1000002;

    private static final int BA_CHECK_NOT_ENROLLED = 4;

    private Text resultText;

    private String result;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case EVENT_MESSAGE_SUCCESS:
                    showDialog(result);
                    resultText.setText(result);
                    break;
                case EVENT_MESSAGE_FAIL:
                    resultText.setText(result);
                    break;
            }
        }
    };

    private BiometricAuthentication biometricAuthentication;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        Component startButton = findComponentById(ResourceTable.Id_start);
        Component cancelButton = findComponentById(ResourceTable.Id_cancel);
        startButton.setClickedListener(this::startFaceUnlock);
        cancelButton.setClickedListener(this::cancelRecognition);
    }

    private synchronized void startFaceUnlock(Component component) {
        try {
            biometricAuthentication = BiometricAuthentication.getInstance(getAbility());
            int availability = biometricAuthentication.checkAuthenticationAvailability(
                BiometricAuthentication.AuthType.AUTH_TYPE_BIOMETRIC_FACE_ONLY,
                BiometricAuthentication.SecureLevel.SECURE_LEVEL_S2, true);
            if (availability == 0) {
                execAuthentication();
            } else if (availability == BA_CHECK_NOT_ENROLLED) {
                result = "Face Unlock not enrolled, set up face Recognition first";
            } else {
                result = "Biometric authentication not support";
            }

        } catch (IllegalAccessException e) {
            result = "Face Recognition error ";
        }
        handler.sendEvent(EVENT_MESSAGE_FAIL);
    }

    private void execAuthentication() {
        ThreadPoolUtil.submit(() -> {
            int authenticationAction = biometricAuthentication.execAuthenticationAction(
                BiometricAuthentication.AuthType.AUTH_TYPE_BIOMETRIC_FACE_ONLY,
                BiometricAuthentication.SecureLevel.SECURE_LEVEL_S2, true, false, null);
            if (authenticationAction == 0) {
                result = "Unlocked successfully";
                handler.sendEvent(EVENT_MESSAGE_SUCCESS);
            } else {
                result = "Authentication failed, face biometric doesn't match";
                handler.sendEvent(EVENT_MESSAGE_FAIL);
            }
        });
    }

    private void cancelRecognition(Component component) {
        if (biometricAuthentication != null) {
            int resultCode = biometricAuthentication.cancelAuthenticationAction();
            if (resultCode == 0) {
                resultText.setText("Cancel succeed.");
            } else {
                resultText.setText("Cancel failed,code = " + resultCode);
            }
        }
    }

    private void showDialog(String message) {
        Component container = LayoutScatter.getInstance(this).parse(ResourceTable.Layout_dialog_layout, null, false);
        Text content = (Text) container.findComponentById(ResourceTable.Id_message);
        content.setText("Recognition result:" + System.lineSeparator() + message);
        CommonDialog commonDialog = new CommonDialog(this);
        commonDialog.setSize(900, 400);
        commonDialog.setCornerRadius(30);
        commonDialog.setContentCustomComponent(container);
        commonDialog.show();
        Component btnOk = container.findComponentById(ResourceTable.Id_btn_ok);
        btnOk.setClickedListener(component -> commonDialog.hide());
    }
}
