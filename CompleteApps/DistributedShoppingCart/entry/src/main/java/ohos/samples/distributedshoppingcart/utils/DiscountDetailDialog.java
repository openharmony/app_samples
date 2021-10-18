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

package ohos.samples.distributedshoppingcart.utils;

import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;

public class DiscountDetailDialog {
    private static final int DIALOG_WIDTH = 1080;
    private static final int DIALOG_HEIGHT = 1500;

    private static final String ZERO_STR = ".00";
    private static final String MONEY_STR = "￥";

    private static final int TEXT_MONEY_NBR = 5;
    private static final int TEXT_IDX_0 = 0;
    private static final int TEXT_IDX_1 = TEXT_IDX_0 + 1;
    private static final int TEXT_IDX_2 = TEXT_IDX_1 + 1;
    private static final int TEXT_IDX_3 = TEXT_IDX_2 + 1;
    private static final int TEXT_IDX_4 = TEXT_IDX_3 + 1;

    private static final int[] TEXT_RESOURCE_ID = {
        ResourceTable.Id_text1, ResourceTable.Id_text2,
        ResourceTable.Id_text3, ResourceTable.Id_text4,
        ResourceTable.Id_text5
    };

    private final int count;
    private CommonDialog commonDialog;
    private final int[] text = {0};
    private final int[] srcMoney = {0};

    public DiscountDetailDialog(Context context, int[] text, int[] src, int count) {
        System.arraycopy(text, 0, this.text, 0, text.length);
        System.arraycopy(src, 0, srcMoney, 0, src.length);

        this.count = count;
        initView(context);
    }

    private void initView(Context context) {
        commonDialog = new CommonDialog(context);
        commonDialog.setAlignment(LayoutAlignment.BOTTOM);
        commonDialog.setSize(DIALOG_WIDTH, DIALOG_HEIGHT);
        commonDialog.setAutoClosable(true);
        Component dialogLayout = LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_discount_detail, null, false);
        commonDialog.setContentCustomComponent(dialogLayout);
        for (int idx = 0; idx < TEXT_MONEY_NBR; idx++) {
            ((Text)dialogLayout.findComponentById(TEXT_RESOURCE_ID[idx])).setText(MONEY_STR + text[idx] + ZERO_STR);
        }

        ((Text)dialogLayout.findComponentById(ResourceTable.Id_head_text5)).setText(ShoppingCartManage.devName);

        Image imgDetail = (Image) dialogLayout.findComponentById(ResourceTable.Id_meger_discount_detail);
        imgDetail.setClickedListener(v -> commonDialog.hide());

        Text textPayMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_to_pay_money);
        textPayMoney.setText(context.getString(ResourceTable.String_settle_accounts_label) + "("+ count +")");

        String tmp = context.getString(ResourceTable.String_original_price_label) + MONEY_STR;

        Text textMySrcTotalMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_my_price);
        textMySrcTotalMoney.setText(tmp + srcMoney[0] + ZERO_STR);

        Text textSomeoneSrcTotalMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_some_price);
        textSomeoneSrcTotalMoney.setText(tmp + srcMoney[1] + ZERO_STR);

        Text textMyTotalMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_my_money);
        textMyTotalMoney.setText(context.getString(ResourceTable.String_my_label)
            + MONEY_STR + text[TEXT_IDX_3] + ZERO_STR);

        Text textSomeoneTotalMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_some_money);
        textSomeoneTotalMoney.setText(ShoppingCartManage.devName + MONEY_STR + text[TEXT_IDX_4] + ZERO_STR);

        Text textTotalMoney = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_money);
        textTotalMoney.setText(context.getString(ResourceTable.String_total_label)
            + MONEY_STR + text[TEXT_IDX_2] + ZERO_STR);

        Text textDetail = (Text)dialogLayout.findComponentById(ResourceTable.Id_meger_total_discount);
        textDetail.setText(context.getString(ResourceTable.String_discount)
            + text[TEXT_IDX_1] + context.getString(ResourceTable.String_discount_details));

        dialogLayout.findComponentById(ResourceTable.Id_share_meger_icon_cancel).setClickedListener(
                component -> commonDialog.hide());
        dialogLayout.findComponentById(ResourceTable.Id_detail_meger_dialog).setClickedListener(component -> commonDialog.hide());
    }

    /**
     * show dialog
     */
    public void show() {
        commonDialog.show();
    }
}
