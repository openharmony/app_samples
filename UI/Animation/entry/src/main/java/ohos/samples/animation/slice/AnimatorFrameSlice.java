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

package ohos.samples.animation.slice;

import ohos.samples.animation.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.element.FrameAnimationElement;

/**
 * AnimatorFrameSlice
 */
public class AnimatorFrameSlice extends AbilitySlice {
    private FrameAnimationElement frameAnimationElement;

    private DirectionalLayout componentContainer;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_animator_frame_slice_layout);
        initAnimator();
        initComponents();
    }

    private void initAnimator() {
        frameAnimationElement = new FrameAnimationElement(getContext(), ResourceTable.Graphic_animation_element);
    }

    private void initComponents() {
        componentContainer = (DirectionalLayout) findComponentById(ResourceTable.Id_frame_container);
        Component startButton = findComponentById(ResourceTable.Id_start_animation_button);
        startButton.setClickedListener(this::startAnimation);

        Component component = new Component(getContext());
        component.setWidth(500);
        component.setHeight(500);
        component.setBackground(frameAnimationElement);
        componentContainer.addComponent(component);
    }

    private void startAnimation(Component component) {
        frameAnimationElement.start();
    }

    @Override
    protected void onStop() {
        componentContainer.removeAllComponents();
    }
}
