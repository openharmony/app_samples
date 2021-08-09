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

package ohos.samples.pasteboard.copy.slice;

import ohos.samples.pasteboard.copy.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.TextField;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.miscservices.pasteboard.IPasteDataChangedListener;
import ohos.miscservices.pasteboard.PasteData;
import ohos.miscservices.pasteboard.SystemPasteboard;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private TextField copyText;

    private SystemPasteboard pasteboard;

    private final IPasteDataChangedListener listener = new IPasteDataChangedListener() {
        @Override
        public void onChanged() {
            PasteData pasteData = pasteboard.getPasteData();
            if (pasteData != null) {
                showTips(MainAbilitySlice.this, "PasteData onChanged");
            }
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
        initPasteboard();
    }

    private void initPasteboard() {
        pasteboard = SystemPasteboard.getSystemPasteboard(this);
        pasteboard.addPasteDataChangedListener(listener);
    }

    private void initComponents() {
        Component copyButton = findComponentById(ResourceTable.Id_copy_button);
        Component clearButton = findComponentById(ResourceTable.Id_clear_button);
        copyText = (TextField) findComponentById(ResourceTable.Id_copy_text);
        copyButton.setClickedListener(this::copyText);
        clearButton.setClickedListener(this::clearPasteboard);
    }

    private void copyText(Component component) {
        if (pasteboard != null) {
            pasteboard.setPasteData(PasteData.creatPlainTextData(copyText.getText()));
            showTips(this, "Copy succeeded");
        }
    }

    private void clearPasteboard(Component component) {
        if (pasteboard != null) {
            pasteboard.clear();
            showTips(this, "Clear succeeded");
        }
    }

    private void showTips(Context context, String msg) {
        new ToastDialog(context).setText(msg).show();
    }
}
