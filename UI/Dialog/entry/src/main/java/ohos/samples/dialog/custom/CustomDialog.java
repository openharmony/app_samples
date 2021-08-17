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

package ohos.samples.dialog.custom;

import static ohos.samples.dialog.slice.MainAbilitySlice.DIALOG_BOX_CORNER_RADIUS;
import static ohos.samples.dialog.slice.MainAbilitySlice.DIALOG_BOX_WIDTH;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;

import ohos.samples.dialog.ResourceTable;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.agp.utils.TextAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;

import java.util.regex.Pattern;

/**
 * CustomDialog
 */
public class CustomDialog extends CommonDialog {
    private static final String PATTERN = "^\\d$";
    private TextField checkCode1;
    private TextField checkCode2;
    private TextField checkCode3;
    private TextField checkCode4;
    private TextField checkCode5;
    private TextField checkCode6;
    private Text titleText;
    private Component confirmButton;
    private ConfirmListener confirmListener;
    private final Context context;

    /**
     * CustomDialog
     *
     * @param abilityContext Context
     */
    public CustomDialog(Context abilityContext) {
        super(abilityContext);
        this.context = abilityContext;
        initComponents();
        setCornerRadius(DIALOG_BOX_CORNER_RADIUS);
        setAlignment(TextAlignment.CENTER);
        setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
    }

    private void initComponents() {
        Component customComponent = LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_custom_dialog_content, null, true);
        checkCode1 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_1_textfield);
        checkCode2 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_2_textfield);
        checkCode3 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_3_textfield);
        checkCode4 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_4_textfield);
        checkCode5 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_5_textfield);
        checkCode6 = (TextField) customComponent.findComponentById(ResourceTable.Id_num_6_textfield);
        titleText = (Text) customComponent.findComponentById(ResourceTable.Id_title_text);
        confirmButton = customComponent.findComponentById(ResourceTable.Id_confirm_button);
        setObserver(checkCode1, checkCode2);
        setObserver(checkCode2, checkCode3);
        setObserver(checkCode3, checkCode4);
        setObserver(checkCode4, checkCode5);
        setObserver(checkCode5, checkCode6);
        setObserver(checkCode6, null);
        super.setContentCustomComponent(customComponent);
        confirm();
    }

    /**
     * set title
     *
     * @param string String
     */
    public void setTitle(String string) {
        titleText.setText(string);
    }

    private void setObserver(TextField textField, Component textFieldNext) {
        textField.addTextObserver((string, start, before, count) -> matchNumber(string, textField, textFieldNext));
    }

    private void matchNumber(String string, TextField textField, Component textFieldNext) {
        boolean isMatch = Pattern.matches(PATTERN, string);
        if (isMatch) {
            textField.setText(string);
        }
        if (textFieldNext != null) {
            textFieldNext.requestFocus();
        }
    }

    private String getContent() {
        return "" + checkCode1.getText() + checkCode2.getText()
                + checkCode3.getText() + checkCode4.getText() + checkCode5.getText() + checkCode6.getText();
    }

    private void confirm() {
        confirmButton.setClickedListener(component -> {
            if (confirmListener != null) {
                confirmListener.onConfirmListener(getContent());
            }
        });
    }

    /**
     * setOnConfirmListener
     *
     * @param confirm ConfirmListener
     */
    public void setOnConfirmListener(ConfirmListener confirm) {
        confirmListener = confirm;
    }
}
