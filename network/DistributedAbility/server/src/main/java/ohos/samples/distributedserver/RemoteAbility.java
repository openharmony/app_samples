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

package ohos.samples.distributedserver;

import ohos.samples.distributedserver.utils.LogUtil;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.CommonDialog;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;

/**
 * Custom service type atomic ability for distributed input method.
 */
public final class RemoteAbility extends Ability {
    private static final String TAG = RemoteAbility.class.getSimpleName();

    private static final String ABILITY_DESCRIPTION = "ohos.samples.distributedserver.RemoteAbility";

    private static final int NOTIFICATION_ID = 10013;

    private static final int DIALOG_WIDTH = 900;

    private static final int DIALOG_CORNER_RADIUS = 30;

    private final RemoteAgentStub remoteAgent = new RemoteAgentStub(ABILITY_DESCRIPTION) {
        @Override
        public void setRemoteObject() {
            LogUtil.info(TAG, " RemoteAgentStub setRemoteObject");
        }
    };

    @Override
    public IRemoteObject onConnect(Intent intent) {
        String connectedDeviceName = intent.getStringParam("ClientDeviceName");
        LogUtil.info(TAG, "onConnect Success , ConnectedDeviceName : " + connectedDeviceName);
        super.onConnect(intent);
        showDialog("Connect Success");
        showNotification(this, "Connect Success");
        return remoteAgent;
    }

    @Override
    public void onDisconnect(Intent intent) {
        super.onDisconnect(intent);
        showNotification(this, "Disconnected");
        showDialog("Disconnected");
        cancelBackgroundRunning();
    }

    @Override
    public void onStop() {
        LogUtil.info(TAG, "onStop");
        super.onStop();
        cancelBackgroundRunning();
    }

    private void showNotification(Ability ability, String text) {
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setTitle("DistributedServer message").setText(text);
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
            content);
        NotificationRequest request = new NotificationRequest(NOTIFICATION_ID);
        request.setContent(notificationContent);
        ability.keepBackgroundRunning(NOTIFICATION_ID, request);
        try {
            NotificationHelper.publishNotification(request);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "Exception in showNotification");
        }
    }

    private void showDialog(String message) {
        Component container = LayoutScatter.getInstance(this).parse(ResourceTable.Layout_dialog_layout, null, false);
        Text content = (Text) container.findComponentById(ResourceTable.Id_message);
        content.setText(message);
        CommonDialog commonDialog = new CommonDialog(this);
        commonDialog.setSize(DIALOG_WIDTH, DirectionalLayout.LayoutConfig.MATCH_CONTENT);
        commonDialog.setCornerRadius(DIALOG_CORNER_RADIUS);
        commonDialog.setContentCustomComponent(container);
        commonDialog.show();
        Button btnOk = (Button) container.findComponentById(ResourceTable.Id_btn_ok);
        btnOk.setClickedListener(component -> commonDialog.hide());
    }
}