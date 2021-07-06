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

package ohos.samples.customlayout.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.colors.RgbColor;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.element.ShapeElement;
import ohos.agp.utils.Color;
import ohos.samples.customlayout.ResourceTable;
import ohos.samples.customlayout.component.CustomLayout;

/**
 * MainAbilitySlice
 *
 * @since 2021-07-03
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int COMPONENT_COUNT = 15;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        DirectionalLayout directionalLayout = new DirectionalLayout(getContext());
        directionalLayout.setPadding(32, 32, 32, 32);
        DirectionalLayout.LayoutConfig config = new DirectionalLayout.LayoutConfig(
            DirectionalLayout.LayoutConfig.MATCH_PARENT, DirectionalLayout.LayoutConfig.MATCH_PARENT);
        directionalLayout.setLayoutConfig(config);

        CustomLayout customLayout = new CustomLayout(this, null);
        for (int index = 0; index < COMPONENT_COUNT; index++) {
            customLayout.addComponent(getComponent(index + 1));
        }
        ShapeElement shapeElement = new ShapeElement();
        shapeElement.setRgbColor(new RgbColor(100, 100, 100));
        customLayout.setBackground(shapeElement);
        DirectionalLayout.LayoutConfig layoutConfig = new DirectionalLayout.LayoutConfig(
            DirectionalLayout.LayoutConfig.MATCH_PARENT, DirectionalLayout.LayoutConfig.MATCH_CONTENT);
        customLayout.setLayoutConfig(layoutConfig);
        directionalLayout.addComponent(customLayout);
        super.setUIContent(directionalLayout);
    }

    private Component getComponent(int index) {
        Button button = new Button(getContext());
        ShapeElement shapeElement = new ShapeElement();
        shapeElement.setRgbColor(new RgbColor(200, 200, 200));
        button.setBackground(shapeElement);
        button.setTextColor(Color.WHITE);
        DirectionalLayout.LayoutConfig layoutConfig = new DirectionalLayout.LayoutConfig(300, 100);
        if (index == 1) {
            layoutConfig = new DirectionalLayout.LayoutConfig(1080, 200);
            button.setText(ResourceTable.String_size01);
        } else if (index == 6) {
            layoutConfig = new DirectionalLayout.LayoutConfig(500, 100);
            button.setText(ResourceTable.String_size02);
        } else if (index == 8) {
            layoutConfig = new DirectionalLayout.LayoutConfig(600, 600);
            button.setText(ResourceTable.String_size03);
        } else {
            button.setText("Item" + index);
        }
        layoutConfig.setMargins(10, 10, 10, 10);
        button.setLayoutConfig(layoutConfig);
        return button;
    }
}