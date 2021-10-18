/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.All rights reserved.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.tictactoegame;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.rpc.IRemoteBroker;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteObject;
import ohos.samples.tictactoegame.slice.StartAbilitySlice;
import ohos.samples.tictactoegame.utils.UiUtils;

/**
 * RemoteService Ability
 */
public class RemoteServiceAbility extends Ability {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
    }

    @Override
    public void onBackground() {
        super.onBackground();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onCommand(Intent intent, boolean isRestart, int startId) {
        UiUtils.showTip(this, "onCommand" + isRestart + "," + startId);
    }

    @Override
    public IRemoteObject onConnect(Intent intent) {
        StartAbilitySlice.getHandler().sendEvent(1);
        return new GameRemountObject("GameRemountObject").asObject();
    }

    @Override
    public void onDisconnect(Intent intent) {
    }

    /**
     * GameRemount Object class
     */
    private static class GameRemountObject extends RemoteObject implements IRemoteBroker {
        private static final int COMMAND_PLUS = IRemoteObject.MIN_TRANSACTION_ID;
        private static final int ERR_OK = 0;
        private static final int ERROR = -1;

        GameRemountObject(String descriptor) {
            super(descriptor);
        }

        public IRemoteObject asObject() {
            return this;
        }

        public boolean onRemoteRequest(int code, MessageParcel data,
            MessageParcel reply, MessageOption option) {
            if (code != COMMAND_PLUS) {
                reply.writeInt(ERROR);
                return false;
            }

            int receiveCmd = data.readInt();
            StartAbilitySlice.getHandler().sendEvent(receiveCmd);
            reply.writeInt(ERR_OK);
            return true;
        }
    }
}