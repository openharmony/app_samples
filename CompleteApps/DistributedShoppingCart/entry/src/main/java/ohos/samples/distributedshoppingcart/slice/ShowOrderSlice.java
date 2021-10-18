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
 * ShowOrderSlice
 */
public class ShowOrderSlice extends AbilitySlice {
    private static final String ZERO_STR = ".00";
    private static final String MONEY_STR = ":￥";



    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_submit_order);
        initView(intent);
    }

    private void initView(Intent intent) {
        Text commitOrder;
        int total = intent.getIntParam(ShoppingCartManage.TOTAL_MONEY,0);
        int discount = intent.getIntParam(ShoppingCartManage.DISCOUNT_MONEY,0);
        Text textTotal = (Text)findComponentById(ResourceTable.Id_pro_money);
        textTotal.setText(MONEY_STR + total + ZERO_STR);

        Text textDiscount = (Text)findComponentById(ResourceTable.Id_pro_discountmoney);
        textDiscount.setText("-" + MONEY_STR + discount + ZERO_STR);

        Text textPay = (Text)findComponentById(ResourceTable.Id_share_shoping_cart);
        textPay.setText(MONEY_STR + (total-discount) + ZERO_STR);

        Text textNeedPay = (Text)findComponentById(ResourceTable.Id_order_money);
        textNeedPay.setText(MONEY_STR + (total-discount) + ZERO_STR);

        commitOrder = (Text)findComponentById(ResourceTable.Id_commit_order);
        commitOrder.setClickedListener(v -> {
            Intent inte = new Intent();
            inte.setParam(ShoppingCartManage.NEED_PAY, MONEY_STR + (total-discount) + ZERO_STR);
            present(new ShowPaySlice(),inte);
        });
    }

    @Override
    protected void onBackground() {
        super.onBackground();
    }

    @Override
    protected void onActive() {
        super.onActive();
    }

    @Override
    protected void onInactive() {
        super.onInactive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }
}
