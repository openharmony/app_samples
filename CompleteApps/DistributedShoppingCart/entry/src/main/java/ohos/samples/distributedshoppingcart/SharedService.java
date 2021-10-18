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

package ohos.samples.distributedshoppingcart;

import manager.NewsDemoIDLStub;
import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;
import ohos.samples.distributedshoppingcart.utils.LogUtils;

/**
 * SharedService
 */
public class SharedService extends Ability {
    private static final String DESCRIPTOR = "ohos.samples.distributedshoppingcart.idl.ITencentNewsAIDL";
    private static final String TAG = "SharedService";

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
    }

    @Override
    protected IRemoteObject onConnect(Intent intent) {
        return new MyBinder(DESCRIPTOR);
    }

    /**
     * MyBinder class
     */
    private static class MyBinder extends NewsDemoIDLStub {
        MyBinder(String descriptor) {
            super(descriptor);
        }

        @Override
        public void tranAndShare(String[] array, String opt) {
            LogUtils.i(TAG, "SharedService tranAndShare");
            try {
                Intent intent = new Intent();
                Operation operation = new Intent.OperationBuilder()
                        .withAction(ShoppingCartManage.SUB_EVENT)
                        .build();
                intent.setOperation(operation);
                intent.setParam(ShoppingCartManage.ACTION_EVENT, opt);
                CommonEventData eventData = new CommonEventData(intent);
                CommonEventManager.publishCommonEvent(eventData);
            } catch (RemoteException e) {
                LogUtils.i(TAG, "publishCommonEvent occur exception.");
            }
        }
    }
}
