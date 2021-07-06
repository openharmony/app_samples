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

package ohos.samples.distributedcommoneventsample.slice;

import ohos.samples.distributedcommoneventsample.DistributeNotificationPlugin;
import ohos.samples.distributedcommoneventsample.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.window.dialog.ToastDialog;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice
    implements DistributeNotificationPlugin.DistributeNotificationEventListener {
    private static final int TOAST_DURATION = 3000;

    private DistributeNotificationPlugin notificationPlugin;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        notificationPlugin = new DistributeNotificationPlugin();
        notificationPlugin.setEventListener(this);
        initComponents();
    }

    private void initComponents() {
        Component publishButton = findComponentById(ResourceTable.Id_publish);
        publishButton.setClickedListener(component -> notificationPlugin.publishCommonEvent());
        Component subscribeButton = findComponentById(ResourceTable.Id_subscribe);
        subscribeButton.setClickedListener(component -> notificationPlugin.subscribeCommonEvent());
        Component unsubscribeButton = findComponentById(ResourceTable.Id_unsubscribe);
        unsubscribeButton.setClickedListener(component -> notificationPlugin.unsubscribeCommonEvent());
    }

    @Override
    public void onEventPublish(String result) {
        showToast(result);
    }

    @Override
    public void onEventSubscribe(String result) {
        showToast(result);
    }

    @Override
    public void onEventUnsubscribe(String result) {
        showToast(result);
    }

    @Override
    public void onEventReceive(String result) {
        showToast(result);
    }

    @Override
    public void onStop() {
        super.onStop();
        notificationPlugin = null;
    }

    private void showToast(String msg) {
        ToastDialog dialog = new ToastDialog(this);
        dialog.setDuration(TOAST_DURATION);
        dialog.setAutoClosable(false);
        dialog.setContentText(msg);
        dialog.show();
    }
}
