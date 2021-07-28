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

package ohos.samples.accessibilityservice.slice;

import ohos.agp.components.Component;
import ohos.agp.window.dialog.ToastDialog;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.samples.accessibilityservice.ResourceTable;
import ohos.samples.accessibilityservice.tts.TtsManager;

/**
 * MainAbilitySlice
 *
 * @since 2021-07-23
 */
public class MainAbilitySlice extends AbilitySlice {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        TtsManager.getInstance().init(this);
        initComponents();
    }

    private void initComponents() {
        Component performBtn = findComponentById(ResourceTable.Id_perform_button);
        performBtn.setClickedListener(this::onClickListener);
        Component keyEventButton = findComponentById(ResourceTable.Id_keyPressEvent_button);
        keyEventButton.setClickedListener(this::enterKeyPressEventPage);
    }

    private void enterKeyPressEventPage(Component component) {
        present(new KeyPressEventSlice(), new Intent());
    }

    private void onClickListener(Component component) {
        String tips = getString(ResourceTable.String_string_button_perform_click);
        new ToastDialog(getContext()).setText(tips).show();
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
        TtsManager.getInstance().destroy();
    }
}
