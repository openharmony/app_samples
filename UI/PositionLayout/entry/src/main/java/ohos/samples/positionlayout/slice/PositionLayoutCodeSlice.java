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

package ohos.samples.positionlayout.slice;

import ohos.samples.positionlayout.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.colors.RgbColor;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.PositionLayout;
import ohos.agp.components.Text;
import ohos.agp.components.element.ShapeElement;

import java.util.Locale;

/**
 * Position Layout Code Slice
 */
public class PositionLayoutCodeSlice extends AbilitySlice {
    /**
     * height with the textComponents and the buttons
     */
    private static final int HEIGHT = 150;

    /**
     * the x_position of the button
     */
    private static final int BUTTON_POSITION_X = 110;

    /**
     * the y_position of the button
     */
    private static final int BUTTON_POSITION_Y = 700;

    /**
     * the x_position of the textComponent
     */
    private static final int TEXT_POSITION_X = 30;

    /**
     * the number of the textComponents
     */
    private static final int TEXT_COMPONENT_NUMBER = 4;

    /**
     * the number of the buttons
     */
    private static final int BUTTON_NUMBER = 10;

    /**
     * white color
     */
    private static final int COLOR_WHITE = 0xFFFFFFFF;

    /**
     * the layout
     */
    private PositionLayout rootLayout;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);

        initPositionLayout();
        addTextComponents();
        addButtons();

        super.setUIContent(this.rootLayout);
    }

    private void initPositionLayout() {
        rootLayout = new PositionLayout(this);
        this.rootLayout.setContentPosition(0, 0);
        this.rootLayout.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT);
        this.rootLayout.setHeight(ComponentContainer.LayoutConfig.MATCH_PARENT);

        ShapeElement shapeElement = new ShapeElement();
        shapeElement.setShape(ShapeElement.ALPHA_MIN);
        shapeElement.setRgbColor(new RgbColor(COLOR_WHITE));
        this.rootLayout.setBackground(shapeElement);
    }

    private void addTextComponents() {
        for (int textComponentIndex = 0; textComponentIndex < TEXT_COMPONENT_NUMBER; textComponentIndex++) {
            Text text = createTextComponent();
            text.setText(String.format(Locale.ENGLISH, "Text %d: Hello World", textComponentIndex));
            text.setContentPosition(TEXT_POSITION_X, HEIGHT * textComponentIndex);
            this.rootLayout.addComponent(text);
        }
    }

    private void addButtons() {
        for (int buttonIndex = 0; buttonIndex < BUTTON_NUMBER; buttonIndex++) {
            Button button = createButton();
            button.setText(String.format(Locale.ENGLISH, "Button %d", buttonIndex));
            button.setContentPosition(BUTTON_POSITION_X * buttonIndex, BUTTON_POSITION_Y + HEIGHT * buttonIndex);
            this.rootLayout.addComponent(button);
        }
    }

    private Button createButton() {
        Component component = LayoutScatter.getInstance(getContext())
            .parse(ResourceTable.Layout_button_layout, null, false);
        return (Button) component;
    }

    private Text createTextComponent() {
        Component component = LayoutScatter.getInstance(getContext())
            .parse(ResourceTable.Layout_textComponent_layout, null, false);
        return (Text) component;
    }
}
