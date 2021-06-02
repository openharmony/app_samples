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
import ohos.agp.animation.AnimatorProperty;
import ohos.agp.components.Component;

/**
 * AnimatorAbilitySlice
 */
public class AnimatorPropertySlice extends AbilitySlice {
    private Component propertyAnimationImage;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_animator_property_slice_layout);
        initComponents();
    }

    private void initComponents() {
        propertyAnimationImage = findComponentById(ResourceTable.Id_property_animation_image);
        Component scaleButton = findComponentById(ResourceTable.Id_animator_scale_button);
        Component rotateButton = findComponentById(ResourceTable.Id_animator_rotate_button);
        Component alphaButton = findComponentById(ResourceTable.Id_animator_alpha_button);
        Component translateButton = findComponentById(ResourceTable.Id_animator_translate_button);

        scaleButton.setClickedListener(this::startScaleAnimation);
        rotateButton.setClickedListener(this::startRotateAnimation);
        alphaButton.setClickedListener(this::startAlphaAnimation);
        translateButton.setClickedListener(this::startTranslateAnimation);
    }

    private void startScaleAnimation(Component component) {
        propertyAnimationImage.setScale(1, 1);
        AnimatorProperty animator = propertyAnimationImage.createAnimatorProperty();
        animator.setCurveType(Animator.CurveType.ANTICIPATE_OVERSHOOT);
        animator.scaleY(0.7f);
        animator.scaleX(1.5f);
        animator.setDuration(2000);
        animator.setLoopedCount(2);
        animator.start();
    }

    private void startRotateAnimation(Component component) {
        propertyAnimationImage.setRotation(0);
        AnimatorProperty animator = propertyAnimationImage.createAnimatorProperty();
        animator.setCurveType(Animator.CurveType.ANTICIPATE_OVERSHOOT);
        animator.rotate(360);
        animator.setDuration(2000);
        animator.setLoopedCount(2);
        animator.start();
    }

    private void startAlphaAnimation(Component component) {
        propertyAnimationImage.setAlpha(1);
        AnimatorProperty animator = propertyAnimationImage.createAnimatorProperty();
        animator.alpha(0.2f);
        animator.setDuration(1000);
        animator.setLoopedCount(2);
        animator.start();
    }

    private void startTranslateAnimation(Component component) {
        AnimatorProperty animator = propertyAnimationImage.createAnimatorProperty();
        animator.moveToX(0);
        animator.setDuration(1000);
        animator.setLoopedCount(2);
        animator.start();
    }
}
