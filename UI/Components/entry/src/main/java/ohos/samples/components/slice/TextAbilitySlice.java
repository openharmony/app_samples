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

package ohos.samples.components.slice;

import ohos.samples.components.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;

/**
 * TextAbilitySlice
 */
public class TextAbilitySlice extends AbilitySlice {
    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_text_main_ability);
        initComponents();
    }

    private void initComponents() {
        Text startAutomaticText = (Text) findComponentById(ResourceTable.Id_text_automated);
        startAutomaticText.setText(startAutomaticText.getText() + "T");
        Text startLanternText = (Text) findComponentById(ResourceTable.Id_text_lantern);
        startLanternText.setTruncationMode(Text.TruncationMode.AUTO_SCROLLING);
        startLanternText.startAutoScrolling();
        Component startExampleText = findComponentById(ResourceTable.Id_start_txt_example);
        startExampleText.setClickedListener(component -> startExample());
    }

    private void startExample() {
        Intent intent = new Intent();
        this.present(new TextExampleSlice(), intent);
    }

}

