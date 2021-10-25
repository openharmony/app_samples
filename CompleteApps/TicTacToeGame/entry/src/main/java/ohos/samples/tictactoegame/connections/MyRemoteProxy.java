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

package ohos.samples.tictactoegame.connections;

import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.IRemoteBroker;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;

/**
 * MyRemoteProxy class
 */
public class MyRemoteProxy implements IRemoteBroker {
    private static final int COMMAND_PLUS = IRemoteObject.MIN_TRANSACTION_ID;
    private static final int ERR_OK = 0;

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(0, 0, "");
    private static final String LOG_FORMAT = "%{public}s: %{public}s";

    private final IRemoteObject remote;

    /**
     * MyRemoteProxy
     *
     * @param remote the remote
     */
    public MyRemoteProxy(IRemoteObject remote) {
        this.remote = remote;
    }

    /**
     * asObject: get the IRemote Object
     *
     * @return IRemote Object
     */
    public IRemoteObject asObject() {
        return remote;
    }

    /**
     * sendCmd
     *
     * @param cmd the cmd to send
     */
    public void sendCmd(int cmd) {
        MessageParcel data = MessageParcel.obtain();
        data.writeInt(cmd);

        MessageParcel reply = MessageParcel.obtain();
        MessageOption option = new MessageOption(MessageOption.TF_SYNC);
        try {
            remote.sendRequest(COMMAND_PLUS, data, reply, option);
            int ec = reply.readInt();
            if (ec != ERR_OK) {
                throw new RemoteException();
            }
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, LOG_FORMAT, "MyRemoteProxy", "" + e);
        }


    }
}

