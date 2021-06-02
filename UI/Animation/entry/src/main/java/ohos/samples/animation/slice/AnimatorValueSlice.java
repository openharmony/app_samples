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
import ohos.agp.animation.Animator;
import ohos.agp.animation.AnimatorValue;
import ohos.agp.components.Component;

/**
 * AnimatorValueSlice
 */
public class AnimatorValueSlice extends AbilitySlice {
    private Component valueAnimationImage;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_animator_value_slice_layout);
        initComponents();
    }

    private void initComponents() {
        valueAnimationImage = findComponentById(ResourceTable.Id_value_animation_image);
        Component springButton = findComponentById(ResourceTable.Id_animator_spring_button);
        springButton.setClickedListener(component -> startValueAnimator(Animator.CurveType.SPRING));
        Component anticipateButton = findComponentById(ResourceTable.Id_animator_anticipate_button);
        anticipateButton.setClickedListener(component -> startValueAnimator(Animator.CurveType.ANTICIPATE));
        Component cycleButton = findComponentById(ResourceTable.Id_animator_cycle_button);
        cycleButton.setClickedListener(component -> startValueAnimator(Animator.CurveType.CYCLE));
        Component overshootButton = findComponentById(ResourceTable.Id_animator_overshoot_button);
        overshootButton.setClickedListener(component -> startValueAnimator(Animator.CurveType.OVERSHOOT));
        Component smoothStepButton = findComponentById(ResourceTable.Id_animator_smoothStep_button);
        smoothStepButton.setClickedListener(component -> startValueAnimator(Animator.CurveType.SMOOTH_STEP));
        Component cubicHermit = findComponentById(ResourceTable.Id_animator_cubic_button);
        cubicHermit.setClickedListener(component -> startValueAnimator(Animator.CurveType.CUBIC_HERMITE));
    }

    private void startValueAnimator(int curvyType) {
        AnimatorValue animator = new AnimatorValue();
        animator.setDuration(2000);
        animator.setDelay(0);
        animator.setLoopedCount(1);
        animator.setCurveType(curvyType);
        animator.setValueUpdateListener(
            (animatorValue, value) -> valueAnimationImage.setContentPosition((int) (700 * value),
                valueAnimationImage.getContentPositionY()));
        animator.start();
    }
}
