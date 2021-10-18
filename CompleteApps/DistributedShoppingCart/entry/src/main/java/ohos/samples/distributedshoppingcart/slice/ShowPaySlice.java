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
import ohos.agp.components.Image;
import ohos.agp.components.Text;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;

/**
 * ShowPaySlice
 */
public class ShowPaySlice extends AbilitySlice {
    private Image payHuawei;
    private Image payBankCard;
    private Image payYunQuick;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_pay_money);
        initView(intent);
    }

    private void initView(Intent intent) {
        Text pay;
        String money = intent.getStringParam(ShoppingCartManage.NEED_PAY);
        Text payMoney = (Text)findComponentById(ResourceTable.Id_need_pay_money);
        payMoney.setText(money);
        pay = (Text)findComponentById(ResourceTable.Id_pay_order);
        payHuawei = (Image)findComponentById(ResourceTable.Id_pay_huawei);
        payHuawei.setClickedListener(v -> {
            payHuawei.setPixelMap(ResourceTable.Media_icon_select);
            payYunQuick.setPixelMap(ResourceTable.Media_icon_unselect);
            payBankCard.setPixelMap(ResourceTable.Media_icon_unselect);
        });
        payYunQuick = (Image)findComponentById(ResourceTable.Id_pay_yun_quick);
        payYunQuick.setClickedListener(v -> {
            payHuawei.setPixelMap(ResourceTable.Media_icon_unselect);
            payYunQuick.setPixelMap(ResourceTable.Media_icon_select);
            payBankCard.setPixelMap(ResourceTable.Media_icon_unselect);
        });
        payBankCard = (Image)findComponentById(ResourceTable.Id_pay_bank_card);
        payBankCard.setClickedListener(v -> {
            payHuawei.setPixelMap(ResourceTable.Media_icon_unselect);
            payYunQuick.setPixelMap(ResourceTable.Media_icon_unselect);
            payBankCard.setPixelMap(ResourceTable.Media_icon_select);
        });
        pay.setClickedListener(v -> present(new PaySuccSlice(),new Intent()));
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
