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
import ohos.aafwk.content.Operation;
import ohos.agp.components.Image;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.MyIAbilityConnection;
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;
import ohos.samples.distributedshoppingcart.provider.ProductListProvider;
import ohos.samples.distributedshoppingcart.utils.AddProductDialog;
import ohos.samples.distributedshoppingcart.utils.DeviceListDialog;
import ohos.samples.distributedshoppingcart.utils.LogUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * ShareShoppingCartSlice
 */
public class ShareShoppingCartSlice extends AbilitySlice {
    private static final String TAG = "ShareShoppingCartSlice";
    private static final String LEFT_BRACE = "(";
    private static final String RIGHT_BRACE = ")";
    private static final String ZERO_STR = ".00";
    private static final String MONEY_STR = ":￥";

    private static final int TEST_MONEY_600 = 600;
    private static final int TEST_MONEY_5000 = 5000;

    private ListContainer productListContainer;
    private ProductListProvider productListProvider;
    private Text payMoney;
    private Text textTotalMoney;
    private int totalMoney = 0;
    private final List<DeviceInfo> devices = new ArrayList<>();
    private Image selectAll;
    private boolean mIsSelectAll = true;
    private Image imgShare;
    private Image imgMerge;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_share_shopping_cart);
        ShoppingCartManage.actionShoppingCart = "action.share";
        LogUtils.i(TAG, "ShareShoppingCartSlice onStart");
        initView();
        initListener();
        productListContainer.setItemProvider(productListProvider);
        productListProvider.notifyDataChanged();
    }
    private void updateListView() {
        productListProvider.notifyDataChanged();
        productListContainer.invalidate();
        productListContainer.scrollToCenter(0);
    }
    private void initView() {
        textTotalMoney = (Text)findComponentById(ResourceTable.Id_total_money);
        payMoney = (Text)findComponentById(ResourceTable.Id_to_pay_money);
        payMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
            + ShoppingCartManage.myShoppingCart.size() + RIGHT_BRACE);
        imgShare = (Image)findComponentById(ResourceTable.Id_share_shoping_cart);
        imgMerge = (Image)findComponentById(ResourceTable.Id_distribute_shoping_cart);
        selectAll = (Image) findComponentById(ResourceTable.Id_rb_select_all);

        Text emptyText;
        if (!ShoppingCartManage.myShoppingCart.isEmpty()) {
            emptyText = (Text)findComponentById(ResourceTable.Id_empty_shopingcart);
            emptyText.setVisibility(1);
            findComponentById(ResourceTable.Id_shoping_list).invalidate();
        } else {
            emptyText = (Text)findComponentById(ResourceTable.Id_empty_shopingcart);
            emptyText.setVisibility(0);
            findComponentById(ResourceTable.Id_shoping_list).invalidate();
        }
        productListContainer = (ListContainer) findComponentById(ResourceTable.Id_shopingcart_container);
        productListProvider = new ProductListProvider(ShoppingCartManage.myShoppingCart,
            this, this::getTotalMoney);
        getTotalMoney();
    }

    private void getTotalMoney() {
        totalMoney = 0;
        int proNum = 0;
        for (int idx = 0; idx < productListProvider.getCount(); idx++){
            ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
            if (info.isSelect()) {
                int num = Integer.parseInt(info.getNum());
                double price = Double.parseDouble(info.getPrice());
                totalMoney += num * price;
                proNum++;
            }
            payMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
                + proNum + RIGHT_BRACE);
        }
        String tmp = getString(ResourceTable.String_total_label) + MONEY_STR;
        textTotalMoney.setText(tmp + totalMoney + ZERO_STR);
        payMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
            + ShoppingCartManage.myShoppingCart.size() + RIGHT_BRACE);
        updateListView();
    }

    private void initListener() {
        productListContainer.setItemClickedListener(
            (listContainer, component, position, id) -> { }
        );
        imgMerge.setClickedListener(v -> {
            initDevices();
            showDeviceList(ShoppingCartManage.MEGER_EVENT);
        });
        imgShare.setClickedListener(v -> {
            initDevices();
            showDeviceList(ShoppingCartManage.SHARE_EVENT);
        });

        payMoney.setClickedListener(v -> {
            Intent intent = new Intent();
            Operation operation = new Intent.OperationBuilder().build();
            intent.setOperation(operation);
            intent.setParam(ShoppingCartManage.TOTAL_MONEY, totalMoney);
            int discount = (totalMoney / TEST_MONEY_5000) * TEST_MONEY_600;
            intent.setParam(ShoppingCartManage.DISCOUNT_MONEY, discount);
            present(new ShowOrderSlice(), intent);
        });
        selectListener();
    }

    private void selectListener() {
        if (selectAll == null) {
            return;
        }
        selectAll.setClickedListener(v -> {
            totalMoney = 0;
            if (mIsSelectAll) {
                for (int idx = 0; idx < productListProvider.getCount(); idx++) {
                    ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
                    info.setSelect(false);
                    ShoppingCartManage.myShoppingCart.get(idx).setSelect(false);
                }
                totalMoney = 0;
                mIsSelectAll = false;
                selectAll.setPixelMap(ResourceTable.Media_icon_unselect);
                payMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
                    + 0 + RIGHT_BRACE);
            } else {
                for (int idx = 0; idx < productListProvider.getCount(); idx++) {
                    ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
                    int num= Integer.parseInt(info.getNum()) ;
                    double price = Double.parseDouble(info.getPrice());
                    totalMoney += num * price;
                    info.setSelect(true);
                    ShoppingCartManage.myShoppingCart.get(idx).setSelect(true);
                }
                mIsSelectAll = true;
                selectAll.setPixelMap(ResourceTable.Media_icon_select);
                payMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
                    + ShoppingCartManage.myShoppingCart.size() + RIGHT_BRACE);
            }
            String tmp = getString(ResourceTable.String_total_label) + MONEY_STR;
            textTotalMoney.setText(tmp + totalMoney + ZERO_STR);
            updateListView();
        });
    }

    private void initDevices() {
        if (devices.size() > 0) {
            devices.clear();
        }
        List<DeviceInfo> deviceInfos = DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
        devices.addAll(deviceInfos);
    }

    private void showDeviceList(String opt){
        new DeviceListDialog(ShareShoppingCartSlice.this, opt, (devId,option) -> {
            MyIAbilityConnection myIAbilityConnection = new MyIAbilityConnection(devId,option,getContext());
            myIAbilityConnection.startAbilityFa();
            new AddProductDialog(this,getString(ResourceTable.String_share_success_info)).show();
        }).show();
    }

    @Override
    public void onActive() {
        LogUtils.i(TAG, "connect successful,but have remote exception");
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }
}
