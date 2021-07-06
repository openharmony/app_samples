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

package ohos.samples.delegator.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.bundle.ElementName;
import ohos.samples.delegator.ResourceTable;

import static ohos.samples.delegator.utils.Const.REQUEST_CODE;
import static ohos.samples.delegator.utils.Const.RESULT_OK;

/**
 * MainAbilitySlice
 *
 * @since 2021-05-19
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String BUNDLE_NAME = "ohos.samples.delegator";
    private Button startAbility;
    private Button startAbilityForResult;
    private Text displayText;
    private TextField editText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        initView();
        initEventListener();
    }

    private void initView() {
        Component startAbilityComment = findComponentById(ResourceTable.Id_button_startAbility);
        if (startAbilityComment instanceof Button) {
            startAbility = (Button) startAbilityComment;
        }
        Component startAbilityForResultComponent = findComponentById(ResourceTable.Id_button_startAbilityForResult);
        if (startAbilityForResultComponent instanceof  Button) {
            startAbilityForResult = (Button) startAbilityForResultComponent;
        }
        Component displayTextComponent = findComponentById(ResourceTable.Id_text_displayText);
        if (displayTextComponent instanceof Text) {
            displayText = (Text) displayTextComponent;
        }
        Component editTextComment = findComponentById(ResourceTable.Id_text_editMain);
        if (editTextComment instanceof TextField) {
            editText = (TextField) editTextComment;
        }
    }

    private void initEventListener() {
        startAbility.setClickedListener(component -> {
            ElementName elementNameFirst = new ElementName();
            elementNameFirst.setBundleName(BUNDLE_NAME);
            elementNameFirst.setAbilityName("FirstAbility");
            Intent intentFirstAbility = new Intent();
            intentFirstAbility.setElement(elementNameFirst);
            intentFirstAbility.setParam("First", editText.getText());
            startAbility(intentFirstAbility);

        });
        startAbilityForResult.setClickedListener(component -> {
            ElementName elementNameSecond = new ElementName();
            elementNameSecond.setBundleName(BUNDLE_NAME);
            elementNameSecond.setAbilityName("SecondAbility");
            Intent intentSecondAbility = new Intent();
            intentSecondAbility.setElement(elementNameSecond);
            intentSecondAbility.setParam("Second", editText.getText());
            startAbilityForResult(intentSecondAbility, REQUEST_CODE);
        });
    }

    @Override
    protected void onAbilityResult(int requestCode, int resultCode, Intent resultData) {
        if (requestCode == REQUEST_CODE && resultCode == RESULT_OK) {
            if (resultData != null) {
                String response = resultData.getStringParam("Main");
                displayText.setText(response);
            }
        }
    }
}
