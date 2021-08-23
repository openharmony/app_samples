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

package manager;

import ohos.rpc.IRemoteBroker;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;
import ohos.rpc.RemoteObject;
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;

/**
 * NewsDemoIDLStub
 */
public abstract class NewsDemoIDLStub extends RemoteObject implements INewsDemoIDL {
    private static final String DESCRIPTOR = "com.huawei.distributed.shoppingcart.INewsDemoIDL";
    private static final int COMMAND_TRAN_SHARE = IRemoteObject.MIN_TRANSACTION_ID;

    /**
     * NewsDemoIDLStub
     *
     * @param descriptor the descriptor
     */
    public NewsDemoIDLStub(String descriptor) {
        super(descriptor);
    }

    @Override
    public IRemoteObject asObject() {
        return this;
    }

    /**
     * asInterface
     *
     * @param object the object
     * @return INewsDemoIDL object
     */
    public static INewsDemoIDL asInterface(IRemoteObject object) {
        if (object == null) {
            return null;
        }

        INewsDemoIDL result = null;
        IRemoteBroker broker = object.queryLocalInterface(DESCRIPTOR);
        if (broker != null) {
            if (broker instanceof INewsDemoIDL) {
                result = (INewsDemoIDL) broker;
            }
        } else {
            result = new NewsDemoIDLProxy(object);
        }

        return result;
    }

    @Override
    public boolean onRemoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option)
            throws RemoteException {
        String token = data.readInterfaceToken();
        if (!DESCRIPTOR.equals(token)) {
            return false;
        }
        if (code == COMMAND_TRAN_SHARE) {
            ShoppingCartManage.productInfoList.clear();
            String opt = data.readString();
            String[] array = data.readStringArray();
            for (int idx = 0;idx < array.length;) {
                ProductInfo info = new ProductInfo();
                info.setImgUrl( array[idx++]);
                info.setContent(array[idx++]);
                info.setParam(array[idx++]);
                info.setParam2(array[idx++]);
                info.setPrice(array[idx++]);
                info.setDiscount(array[idx++]);
                info.setNum(array[idx++]);
                info.setTitle(array[idx++]);
                ShoppingCartManage.productInfoList.add(info);
            }
            tranAndShare(array, opt);
            reply.writeNoException();
            return true;
        }
        return super.onRemoteRequest(code, data, reply, option);
    }
}
