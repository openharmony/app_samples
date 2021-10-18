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

package ohos.samples.pasteboard.paste.slice;

import ohos.samples.pasteboard.paste.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.miscservices.pasteboard.IPasteDataChangedListener;
import ohos.miscservices.pasteboard.PasteData;
import ohos.miscservices.pasteboard.SystemPasteboard;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private Text pasteText;

    private SystemPasteboard pasteboard;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
        initPasteboard();
    }

    private void initComponents() {
        Component copyButton = findComponentById(ResourceTable.Id_paste_button);
        Component clearButton = findComponentById(ResourceTable.Id_clear_button);
        pasteText = (Text) findComponentById(ResourceTable.Id_paste_text);
        copyButton.setClickedListener(this::pasteText);
        clearButton.setClickedListener(this::clearPasteboard);
    }

    private void clearPasteboard(Component component) {
        if (pasteboard != null) {
            pasteboard.clear();
            showTips(this, "Clear succeeded");
        }
    }

    private void pasteText(Component component) {
        String pasteContent = getPasteData();
        pasteText.setText(pasteContent);
    }

    private String getPasteData() {
        String result = "";
        PasteData pasteData = pasteboard.getPasteData();
        if (pasteData == null) {
            return result;
        }
        PasteData.DataProperty dataProperty = pasteData.getProperty();
        boolean hasHtml = dataProperty.hasMimeType(PasteData.MIMETYPE_TEXT_HTML);
        boolean hasText = dataProperty.hasMimeType(PasteData.MIMETYPE_TEXT_PLAIN);
        if (hasHtml || hasText) {
            for (int i = 0; i < pasteData.getRecordCount(); i++) {
                PasteData.Record record = pasteData.getRecordAt(i);
                String mimeType = record.getMimeType();
                if (mimeType.equals(PasteData.MIMETYPE_TEXT_HTML)) {
                    result = record.getHtmlText();
                } else if (mimeType.equals(PasteData.MIMETYPE_TEXT_PLAIN)) {
                    result = record.getPlainText().toString();
                } else {
                    HiLog.info(LABEL_LOG, "%{public}s", "getPasteData mimeType :" + mimeType);
                }
            }
        }
        return result;
    }

    private final IPasteDataChangedListener listener = new IPasteDataChangedListener() {
        @Override
        public void onChanged() {
            PasteData pasteData = pasteboard.getPasteData();
            if (pasteData != null) {
                showTips(MainAbilitySlice.this, "PasteData onChanged");
            }
        }
    };

    private void initPasteboard() {
        pasteboard = SystemPasteboard.getSystemPasteboard(this);
        pasteboard.addPasteDataChangedListener(listener);
    }

    private void showTips(Context context, String msg) {
        new ToastDialog(context).setText(msg).show();
    }
}
