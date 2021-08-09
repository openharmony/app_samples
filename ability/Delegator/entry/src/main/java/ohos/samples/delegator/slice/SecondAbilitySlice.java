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
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.samples.delegator.ResourceTable;

import static ohos.samples.delegator.utils.Const.RESULT_OK;

/**
 * SecondAbilitySlice
 *
 * @since 2021-05-19
 */
public class SecondAbilitySlice extends AbilitySlice {
    private TextField reSpouseText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_second);
        Component setResult = findComponentById(ResourceTable.Id_button_second_to_main);
        Component receivedTextComponent = findComponentById(ResourceTable.Id_text_main_to_second);
        if ( receivedTextComponent instanceof Text) {
            Text receivedText = (Text) receivedTextComponent;
            if (intent != null) {
                String content = intent.getStringParam("Second");
                receivedText.setText(content);
            }
        }
        Component reSpouseTextComment = findComponentById(ResourceTable.Id_text_editSecond);
        if (reSpouseTextComment instanceof TextField) {
            reSpouseText = (TextField) reSpouseTextComment;
        }
        setResult.setClickedListener(component -> {
            Intent response = new Intent();
            String res = reSpouseText.getText();
            response.setParam("Main", res);
            getAbility().setResult(RESULT_OK, response);
            terminateAbility();
        });
    }
}
