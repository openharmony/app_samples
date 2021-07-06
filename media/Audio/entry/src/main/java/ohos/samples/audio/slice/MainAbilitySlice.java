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

package ohos.samples.audio.slice;

import ohos.samples.audio.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
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
        Component playerButton = findComponentById(ResourceTable.Id_player_button);
        Component capturerButton = findComponentById(ResourceTable.Id_capturer_button);
        Component shortSoundPlayer = findComponentById(ResourceTable.Id_short_sound_button);

        playerButton.setClickedListener(component -> present(new PlayerSlice(), new Intent()));
        capturerButton.setClickedListener(component -> present(new AudioRecorderSlice(), new Intent()));
        shortSoundPlayer.setClickedListener(component -> present(new ShortSoundPlayerSlice(), new Intent()));
    }
}
