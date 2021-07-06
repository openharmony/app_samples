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

package ohos.samples.multimodeinput.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.samples.multimodeinput.ResourceTable;

/**
 * MainAbilitySlice
 *
 * @since 2021-05-12
 */
public class MainAbilitySlice extends AbilitySlice {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        Component componentTouch = findComponentById(ResourceTable.Id_touchEvent);
        componentTouch.setClickedListener(listener -> present(new TouchAbilitySlice(), new Intent()));

        Component componentKey = findComponentById(ResourceTable.Id_keyEvent);
        componentKey.setClickedListener(listener -> present(new KeyEventAbilitySlice(), new Intent()));

        Component componentMouse = findComponentById(ResourceTable.Id_mouseEvent);
        componentMouse.setClickedListener(listener -> present(new MouseEventSlice(), new Intent()));

        Component componentSpeech = findComponentById(ResourceTable.Id_speechEvent);
        componentSpeech.setClickedListener(listener -> present(new SpeechAbilitySlice(), new Intent()));
    }

}
