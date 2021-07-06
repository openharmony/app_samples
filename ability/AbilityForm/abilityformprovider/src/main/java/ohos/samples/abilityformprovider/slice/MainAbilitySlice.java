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

package ohos.samples.abilityformprovider.slice;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;
import static ohos.agp.utils.LayoutAlignment.CENTER;

import ohos.samples.abilityformprovider.FormAbility;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.colors.RgbColor;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.Text;
import ohos.agp.components.element.ShapeElement;

/**
 * FormSlice
 */
public class MainAbilitySlice extends AbilitySlice {
    /**
     * Text show result
     */
    public static Text text;

    private DirectionalLayout directionalLayout;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        initComponents();
        super.setUIContent(directionalLayout);
    }

    private void initComponents() {
        directionalLayout = new DirectionalLayout(this);
        directionalLayout.setWidth(MATCH_PARENT);
        directionalLayout.setHeight(MATCH_PARENT);
        directionalLayout.setAlignment(CENTER);

        ShapeElement background = new ShapeElement();
        background.setShape(ShapeElement.RECTANGLE);
        background.setRgbColor(new RgbColor(0xFFFFFFFF));
        directionalLayout.setBackground(background);

        text = new Text(this);
        text.setTextSize(60);
        text.setText(FormAbility.generateFormText());
        directionalLayout.addComponent(text);
    }
}
