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

package ohos.samples.fraction;

import ohos.aafwk.ability.fraction.Fraction;
import ohos.aafwk.content.Intent;
import ohos.agp.colors.RgbColor;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.components.element.ShapeElement;
import ohos.agp.utils.Color;
import ohos.agp.utils.LayoutAlignment;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

/**
 * FractionDemo2
 *
 * @since 2021-06-15
 */
public class NextFraction extends Fraction {

    @Override
    protected Component onComponentAttached(LayoutScatter scatter, ComponentContainer container, Intent intent) {
        // set layout parameters
        DirectionalLayout directionalLayout = new DirectionalLayout(getApplicationContext());
        ComponentContainer.LayoutConfig params = new ComponentContainer.LayoutConfig(
                ComponentContainer.LayoutConfig.MATCH_PARENT, 300);
        directionalLayout.setLayoutConfig(params);
        directionalLayout.setAlignment(LayoutAlignment.CENTER);
        ShapeElement shapeElement = new ShapeElement();
        shapeElement.setRgbColor(new RgbColor(0, 255, 255));
        directionalLayout.setBackground(shapeElement);

        // directionalLayout add text
        Text text = new Text(getApplicationContext());
        text.setText("NextFraction");
        text.setLayoutConfig(new ComponentContainer.LayoutConfig(
                ComponentContainer.LayoutConfig.MATCH_CONTENT, ComponentContainer.LayoutConfig.MATCH_CONTENT));
        text.setTextSize(100);
        text.setTextColor(Color.YELLOW);
        text.setPadding(20, 0, 20, 0);
        directionalLayout.addComponent(text);

        return directionalLayout;
    }
}
