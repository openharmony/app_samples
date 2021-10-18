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

package ohos.samples.commonevent.slice;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;

import ohos.samples.commonevent.CommonEventPlugin;
import ohos.samples.commonevent.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.utils.TextAlignment;
import ohos.agp.window.dialog.ListDialog;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements CommonEventPlugin.NotificationEventListener {
    private static final int DIALOG_BOX_WIDTH = 984;

    private final CommonEventPlugin notificationPlugin = new CommonEventPlugin(this);

    private Text resultText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        notificationPlugin.setEvenListener(this);
    }

    private void initComponents() {
        Component subscribeButton = findComponentById(ResourceTable.Id_subscribe_button);
        Component publishButton = findComponentById(ResourceTable.Id_publish_button);
        Component unsubscribeButton = findComponentById(ResourceTable.Id_unsubscribe_button);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        publishButton.setClickedListener(component -> showListPublish());
        subscribeButton.setClickedListener(component -> notificationPlugin.subscribeEvent());
        unsubscribeButton.setClickedListener(component -> notificationPlugin.unSubscribeEvent());
    }

    private void showListPublish() {
        String[] items = new String[] {
            "Publish Disordered CommonEvent", "Publish Permission CommonEvent", "Publish Orderly CommonEvent",
            "Public Sticky CommonEvent"
        };
        ListDialog listDialog = new ListDialog(this);
        listDialog.setAlignment(TextAlignment.CENTER);
        listDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        listDialog.setAutoClosable(true);
        listDialog.setItems(items);
        listDialog.setOnSingleSelectListener((iDialog, index) -> {
            switch (index) {
                case 0:
                    notificationPlugin.publishDisorderedEvent();
                    break;
                case 1:
                    notificationPlugin.publishPermissionEvent();
                    break;
                case 2:
                    notificationPlugin.publishOrderlyEvent();
                    break;
                case 3:
                    notificationPlugin.publishStickyEvent();
                    break;
                default:
                    break;
            }
            resultText.setText("");
            iDialog.destroy();
        });
        listDialog.show();
    }

    @Override
    protected void onStop() {
        super.onStop();
        notificationPlugin.unSubscribeEvent();
    }

    @Override
    public void onEventReceive(String result) {
        resultText.setText(result);
    }
}
