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

package ohos.samples.serviceability;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.event.notification.NotificationRequest;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteObject;

/**
 * ForegroundServiceAbility
 */
public class ForegroundServiceAbility extends Ability {
    private static final int NOTIFICATION_ID = 0XD0000002;

    private static class ServiceRemoteObject extends RemoteObject {
        private ServiceRemoteObject() {
            super("RemoteObject");
        }
    }

    @Override
    protected void onStart(Intent intent) {
        startForeground();
        super.onStart(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
        cancelBackgroundRunning();
    }

    @Override
    protected IRemoteObject onConnect(Intent intent) {
        return new ServiceRemoteObject();
    }

    private void startForeground() {
        NotificationRequest request = new NotificationRequest(NOTIFICATION_ID).setTapDismissed(true);
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setTitle("Foreground Service").setText("I'm a Foreground Service");
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
            content);
        request.setContent(notificationContent);
        keepBackgroundRunning(NOTIFICATION_ID, request);
    }
}
