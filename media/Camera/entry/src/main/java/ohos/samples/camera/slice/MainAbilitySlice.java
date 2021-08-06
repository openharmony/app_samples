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

package ohos.samples.camera.slice;

import ohos.samples.camera.ResourceTable;
import ohos.samples.camera.TakePhotoAbility;
import ohos.samples.camera.VideoRecordAbility;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        Component takePhoto = findComponentById(ResourceTable.Id_take_photo);
        Component videoRecord = findComponentById(ResourceTable.Id_video_record);
        takePhoto.setClickedListener((component) -> startAbility(TakePhotoAbility.class.getName()));
        videoRecord.setClickedListener((component) -> startAbility(VideoRecordAbility.class.getName()));
    }

    private void startAbility(String abilityName) {
        Operation operation = new Intent.OperationBuilder()
                .withDeviceId("")
                .withBundleName(getBundleName())
                .withAbilityName(abilityName)
                .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        startAbility(intent);
    }
}
