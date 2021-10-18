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

package ohos.samples.rpcclient.slice;

import ohos.samples.rpcclient.ResourceTable;
import ohos.samples.rpcclient.util.LogUtil;

import ohos.samples.rpcserver.CalculatorInterfaceProxy;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.InputAttribute;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.agp.window.dialog.ToastDialog;
import ohos.bundle.ElementName;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final int TOAST_DURATION = 3000;

    private static final int INVALID = -1;

    private CalculatorInterfaceProxy interfaceProxy;

    private int firstNumber;

    private int secondNumber;

    private TextField firstTextField;

    private TextField secondTextField;

    private Text resultText;

    private ToastDialog toastDialog;

    private String message;

    private final IAbilityConnection connection = new IAbilityConnection() {
        @Override
        public void onAbilityConnectDone(ElementName elementName, IRemoteObject remoteObject, int resultCode) {
            interfaceProxy = new CalculatorInterfaceProxy(remoteObject);
            addNumbers();
        }

        @Override
        public void onAbilityDisconnectDone(ElementName elementName, int resultCode) {
            LogUtil.info(TAG, "onAbilityDisconnectDone");
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_blility);
        initComponents();
    }

    @Override
    protected void onInactive() {
        super.onInactive();
        if (toastDialog != null && toastDialog.isShowing()) {
            toastDialog.cancel();
            toastDialog = null;
        }
    }

    private void initComponents() {
        Component addButton = findComponentById(ResourceTable.Id_add_button);
        addButton.setClickedListener(component -> startAddCalculator());
        firstTextField = (TextField) findComponentById(ResourceTable.Id_first_textField);
        firstTextField.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        secondTextField = (TextField) findComponentById(ResourceTable.Id_second_textField);
        secondTextField.setTextInputType(InputAttribute.ENTER_KEY_TYPE_GO);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
    }

    private void startAddCalculator() {
        try {
            firstNumber = Integer.parseInt(firstTextField.getText());
            secondNumber = Integer.parseInt(secondTextField.getText());
            startServer();
        } catch (NumberFormatException e) {
            LogUtil.error(TAG, "Number Format Exception");
            showTip("Format incorrect or bound exceeded");
        }
    }

    private void addNumbers() {
        int sum = INVALID;
        try {
            sum = interfaceProxy.addNumber(firstNumber, secondNumber);
        } catch (RemoteException | NumberFormatException e) {
            LogUtil.error(TAG, "Remote Exception or Number Format Exception");
            showTip("Format incorrect or bound exceeded");
        }
        resultText.setText(String.valueOf(sum));
    }

    private void startServer() {
        if (interfaceProxy != null) {
            addNumbers();
        } else {
            Intent intent = new Intent();
            ElementName elementName = new ElementName("", "ohos.samples.rpcserver",
                "ohos.samples.rpcserver.ServiceAbility");
            intent.setElement(elementName);
            connectAbility(intent, connection);
        }
    }

    private void showTip(String msg) {
        message = msg;
        toastDialog = new ToastDialog(getApplicationContext());
        toastDialog.setText(message);
        toastDialog.setAutoClosable(false);
        toastDialog.setDuration(TOAST_DURATION);
        toastDialog.show();
    }
}