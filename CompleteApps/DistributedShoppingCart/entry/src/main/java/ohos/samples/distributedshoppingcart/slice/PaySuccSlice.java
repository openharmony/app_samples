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

package ohos.samples.distributedshoppingcart.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;

/**
 * PaySuccSlice
 */
public class PaySuccSlice extends AbilitySlice {
    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_pay_success);
        initView();
    }

    private void initView() {
        Text toHeadSlice = (Text)findComponentById(ResourceTable.Id_to_first_slice);
        toHeadSlice.setClickedListener(v -> {
            ShoppingCartManage.myShoppingCart.clear();
            ShoppingCartManage.someOneShoppingCart.clear();
            ShoppingCartManage.actionShoppingCart = "action.share";
            present(new MainAbilitySlice(),new Intent());
        });
    }

    @Override
    protected void onBackground() {
        super.onBackground();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onInactive() {
        super.onInactive();
    }

    @Override
    protected void onActive() {
        super.onActive();
    }
}
