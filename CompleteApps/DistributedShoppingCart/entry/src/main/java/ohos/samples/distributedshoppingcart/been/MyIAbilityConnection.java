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

package ohos.samples.distributedshoppingcart.been;

import manager.INewsDemoIDL;
import manager.NewsDemoIDLStub;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.app.Context;
import ohos.bundle.ElementName;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;
import ohos.samples.distributedshoppingcart.SharedService;
import ohos.samples.distributedshoppingcart.utils.LogUtils;

/**
 * MyIAbilityConnection
 */
public class MyIAbilityConnection implements IAbilityConnection {
    private static final int TRAN_UNM = 8;
    private static final int TRAN_IDX_0 = 0;
    private static final int TRAN_IDX_1 = TRAN_IDX_0 + 1;
    private static final int TRAN_IDX_2 = TRAN_IDX_1 + 1;
    private static final int TRAN_IDX_3 = TRAN_IDX_2 + 1;
    private static final int TRAN_IDX_4 = TRAN_IDX_3 + 1;
    private static final int TRAN_IDX_5 = TRAN_IDX_4 + 1;
    private static final int TRAN_IDX_6 = TRAN_IDX_5 + 1;
    private static final int TRAN_IDX_7 = TRAN_IDX_6 + 1;


    private final String option;
    private final Context context;
    private final String devicesId;

    /**
     * MyIAbilityConnection
     *
     * @param devicesId the device id
     * @param opt the opt string
     * @param context the context
     */
    public MyIAbilityConnection(String devicesId, String opt,Context context) {
        this.option = opt;
        this.context = context;
        this.devicesId = devicesId;
    }

    /**
     * startAbilityFa
     */
    public void startAbilityFa() {
        Intent intent = new Intent();
        Operation operation =
            new Intent.OperationBuilder()
                .withDeviceId(devicesId)
                .withBundleName(context.getBundleName())
                .withAbilityName(SharedService.class.getName())
                .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
                .build();
        intent.setOperation(operation);

        context.connectAbility(intent, this);
    }

    @Override
    public void onAbilityConnectDone(
            ElementName elementName, IRemoteObject remoteObject, int i) {
        INewsDemoIDL sharedManager = NewsDemoIDLStub.asInterface(remoteObject);
        try {
            String[] array = new String[ShoppingCartManage.myShoppingCart.size() * TRAN_UNM];
            for (int idx = 0; idx < ShoppingCartManage.myShoppingCart.size(); idx++) {
                ProductInfo info;
                info = ShoppingCartManage.myShoppingCart.get(idx);
                array[idx * TRAN_UNM + TRAN_IDX_0] = info.getImgUrl();
                array[idx * TRAN_UNM + TRAN_IDX_1] = info.getContent();
                array[idx * TRAN_UNM + TRAN_IDX_2] = info.getParam();
                array[idx * TRAN_UNM + TRAN_IDX_3] = info.getParam2();
                array[idx * TRAN_UNM + TRAN_IDX_4] = info.getPrice();
                array[idx * TRAN_UNM + TRAN_IDX_5] = info.getDiscount();
                array[idx * TRAN_UNM + TRAN_IDX_6] = info.getNum();
                array[idx * TRAN_UNM + TRAN_IDX_7] = info.getTitle();
            }
            sharedManager.tranAndShare(array,option);
        } catch (RemoteException e) {
            LogUtils.i("MyIAbilityConnection", "connect successful,but have remote exception");
        }
    }

    @Override
    public void onAbilityDisconnectDone(ElementName elementName, int i) {
        context.disconnectAbility(this);
    }
}
