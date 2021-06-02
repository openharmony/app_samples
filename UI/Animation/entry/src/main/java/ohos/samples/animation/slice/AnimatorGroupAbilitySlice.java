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
import ohos.agp.animation.AnimatorGroup;
import ohos.agp.animation.AnimatorValue;
import ohos.agp.components.Component;

/**
 * AnimatorGroupAbilitySlice
 */
public class AnimatorGroupAbilitySlice extends AbilitySlice {
    private AnimatorValue targetAnimator1;

    private AnimatorValue targetAnimator2;

    private AnimatorValue targetAnimator3;

    private AnimatorValue targetAnimator4;

    private AnimatorGroup animatorGroup;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_animator_group_slice_layout);
        initComponents();
        animatorGroup = new AnimatorGroup();
    }

    private void initComponents() {
        Component targetImage1 = findComponentById(ResourceTable.Id_target_image1);
        targetAnimator1 = getValueAnimator(targetImage1);
        Component targetImage2 = findComponentById(ResourceTable.Id_target_image2);
        targetAnimator2 = getValueAnimator(targetImage2);
        Component targetImage3 = findComponentById(ResourceTable.Id_target_image3);
        targetAnimator3 = getValueAnimator(targetImage3);
        Component targetImage4 = findComponentById(ResourceTable.Id_target_image4);
        targetAnimator4 = getValueAnimator(targetImage4);

        findComponentById(ResourceTable.Id_serially_animator_button).setClickedListener(this::startSeriallyAnimator);
        findComponentById(ResourceTable.Id_parallel_animator_button).setClickedListener(this::startParallelAnimator);
        findComponentById(ResourceTable.Id_builder_animator_button).setClickedListener(this::startBuilderAnimator);
    }

    private void startBuilderAnimator(Component component) {
        AnimatorGroup.Builder animatorGroupBuilder = animatorGroup.build();
        animatorGroupBuilder.addAnimators(targetAnimator1)
            .addAnimators(targetAnimator2, targetAnimator3)
            .addAnimators(targetAnimator4);
        animatorGroup.start();
    }

    private void startParallelAnimator(Component component) {
        animatorGroup.runParallel(targetAnimator1, targetAnimator2, targetAnimator3, targetAnimator4);
        animatorGroup.start();
    }

    private void startSeriallyAnimator(Component component) {
        animatorGroup.runSerially(targetAnimator1, targetAnimator2, targetAnimator3, targetAnimator4);
        animatorGroup.start();
    }

    private AnimatorValue getValueAnimator(Component component) {
        AnimatorValue animator = new AnimatorValue();
        animator.setDuration(2000);
        animator.setLoopedCount(0);
        animator.setCurveType(Animator.CurveType.BOUNCE);
        animator.setValueUpdateListener(
            (animatorValue, value) -> component.setContentPosition(component.getContentPositionX(),
                (int) (800 * value)));
        return animator;
    }
}
