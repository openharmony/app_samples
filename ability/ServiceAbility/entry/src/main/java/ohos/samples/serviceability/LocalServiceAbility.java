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

import ohos.samples.serviceability.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteObject;

/**
 * LocalServiceAbility
 */
public class LocalServiceAbility extends Ability {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();
    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        HiLog.info(LABEL_LOG, "%{public}s",  "onStart");
        showTips(this, "LocalService onStart");
    }

    @Override
    public void onCommand(Intent intent, boolean restart, int startId) {
        super.onCommand(intent, restart, startId);
        HiLog.info(LABEL_LOG, "%{public}s",  "onCommand");
        showTips(this, "LocalService onCommand");
    }

    @Override
    public IRemoteObject onConnect(Intent intent) {
        showTips(LocalServiceAbility.this, "LocalService onConnect ");
        return new CurrentRemoteObject();
    }

    @Override
    public void onDisconnect(Intent intent) {
        super.onDisconnect(intent);
        showTips(LocalServiceAbility.this, "LocalService onDisconnect ");
    }

    @Override
    public void onStop() {
        super.onStop();
        showTips(this, "LocalService onStop");
    }

    private static class CurrentRemoteObject extends RemoteObject {
        private CurrentRemoteObject() {
            super("CurrentRemoteObject");
        }

        @Override
        public boolean onRemoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option) {
            HiLog.info(LABEL_LOG, "%{public}s",  "onRemoteRequest ");
            return true;
        }
    }

    private void showTips(Context context, String msg) {
        new ToastDialog(context).setText(msg).show();
    }
}
