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
import ohos.samples.distributedshoppingcart.provider.MegerListProvider;
import ohos.samples.distributedshoppingcart.provider.ProductListProvider;
import ohos.samples.distributedshoppingcart.utils.AddProductDialog;
import ohos.samples.distributedshoppingcart.utils.DeviceListDialog;
import ohos.samples.distributedshoppingcart.utils.DiscountDetailDialog;
import ohos.samples.distributedshoppingcart.utils.LogUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * MegerShoppingCartSlice
 */
public class MegerShoppingCartSlice extends AbilitySlice {
    private static final String TAG = "MegerShoppingCartSlice";
    private static final String LEFT_BRACE = "(";
    private static final String RIGHT_BRACE = ")";
    private static final String ZERO_STR = ".00";
    private static final String MONEY_STR = ":￥";

    private static final int TEST_MONEY_600 = 600;
    private static final int TEST_MONEY_5000 = 5000;

    private ListContainer productListContainer;
    private ProductListProvider productListProvider;
    private ListContainer someOneContainer;
    private MegerListProvider someOneProvider;
    private final List<DeviceInfo> devices = new ArrayList<>();
    private Image imgShare;
    private Image imgMerge;
    private Image imgDetail;
    private Image imgSelectAll;
    private boolean mIsSelectALl = true;
    private Text textPayMoney;
    private Text textDetail;
    private Text textTotalMoney;
    private Text textMyTotalMoney;
    private Text textSomeoneTotalMoney;

    private Text textMySrcTotalMoney;
    private Text textSomeoneSrcTotalMoney;
    private int totalMoney = 0;
    private int myTotalMoney = 0;
    private int someoneTotalMoney = 0;
    private int totalSrcMoney = 0;
    private int mySrcTotalMoney = 0;
    private int someoneSrcTotalMoney = 0;
    private int discountMoney = 0;
    private int count = 0;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_meger_shoping_cart);
        ShoppingCartManage.actionShoppingCart = "action.meger";
        initView();
        initListener();
        productListContainer.setItemProvider(productListProvider);
        productListProvider.notifyDataChanged();
        someOneContainer.setItemProvider(someOneProvider);
        someOneProvider.notifyDataChanged();
        initDevices();
        String action = intent.getStringParam(ShoppingCartManage.MEGER_EVENT);
        if (action != null && "sendback".equals(action)) {
            initDevices();
            MyIAbilityConnection myIAbilityConnection =
                    new MyIAbilityConnection(devices.get(0).getDeviceId(),"sendback", getContext());
            myIAbilityConnection.startAbilityFa();
            new AddProductDialog(this,getString(ResourceTable.String_meger_success_info)).show();
        }
    }

    private void updateListView() {
        productListProvider.notifyDataChanged();
        productListContainer.invalidate();
        productListContainer.scrollToCenter(0);

        someOneProvider.notifyDataChanged();
        someOneContainer.invalidate();
        someOneContainer.scrollToCenter(0);
    }

    private void initView() {
        imgShare = (Image)findComponentById(ResourceTable.Id_share_shopingcart);
        imgMerge = (Image)findComponentById(ResourceTable.Id_distribute_shopingcart);
        imgDetail = (Image)findComponentById(ResourceTable.Id_meger_discount_detail);
        textDetail = (Text)findComponentById(ResourceTable.Id_meger_total_discount);
        textPayMoney = (Text)findComponentById(ResourceTable.Id_meger_to_pay_money);
        textPayMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE
            + ShoppingCartManage.myShoppingCart.size() + RIGHT_BRACE);
        imgSelectAll = (Image)findComponentById(ResourceTable.Id_meger_select_all);
        textTotalMoney = (Text)findComponentById(ResourceTable.Id_meger_total_money);
        textMyTotalMoney = (Text)findComponentById(ResourceTable.Id_meger_total_my_money);
        textMySrcTotalMoney = (Text)findComponentById(ResourceTable.Id_meger_total_my_price);
        textSomeoneTotalMoney = (Text)findComponentById(ResourceTable.Id_meger_total_some_money);
        textSomeoneSrcTotalMoney = (Text)findComponentById(ResourceTable.Id_meger_total_some_price);
        ((Text)findComponentById(ResourceTable.Id_meger_dev_name)).setText(ShoppingCartManage.devName
            + getString(ResourceTable.String_shopping_cart_slice));

        productListContainer = (ListContainer) findComponentById(ResourceTable.Id_my_container);
        productListProvider = new ProductListProvider(ShoppingCartManage.myShoppingCart, this,()-> {
            getTotalMoney();
            updateListView();
        });
        someOneContainer = (ListContainer) findComponentById(ResourceTable.Id_someone_container);
        someOneProvider = new MegerListProvider(ShoppingCartManage.someOneShoppingCart, this);
        getTotalMoney();
    }

    private void getTotalMoney() {
        getMyTotalMoney();
        getSomeoneTotalMoney();
        totalSrcMoney = mySrcTotalMoney + someoneSrcTotalMoney;
        discountMoney = TEST_MONEY_600 * (totalSrcMoney / TEST_MONEY_5000);
        totalMoney = totalSrcMoney - discountMoney;
        myTotalMoney = mySrcTotalMoney - (int)(discountMoney * ((double)mySrcTotalMoney
            / (double) (mySrcTotalMoney + someoneSrcTotalMoney)));
        someoneTotalMoney = someoneSrcTotalMoney - (int)(discountMoney * ((double)someoneSrcTotalMoney
            / (double) (mySrcTotalMoney + someoneSrcTotalMoney)));
        textMyTotalMoney.setText(getString(ResourceTable.String_my_label) + MONEY_STR + myTotalMoney + ZERO_STR);
        textSomeoneTotalMoney.setText(ShoppingCartManage.devName + MONEY_STR + someoneTotalMoney + ZERO_STR);
        textTotalMoney.setText(getString(ResourceTable.String_total_label) + MONEY_STR + totalMoney + ZERO_STR);
        textDetail.setText(getString(ResourceTable.String_discount) + discountMoney
            + getString(ResourceTable.String_discount_details));
    }

    private void getMyTotalMoney() {
        mySrcTotalMoney = 0;
        count = 0;
        for (int idx = 0; idx < productListProvider.getCount(); idx++) {
            ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
            if (info.isSelect()) {
                int num = Integer.parseInt(info.getNum());
                double price = Double.parseDouble(info.getPrice());
                mySrcTotalMoney += num * price;
                count++;
            }
        }
        String tmp = getString(ResourceTable.String_original_price_label) + MONEY_STR;
        textMySrcTotalMoney.setText(tmp + mySrcTotalMoney+ ZERO_STR);
        textPayMoney.setText(getString(ResourceTable.String_settle_accounts_label) + LEFT_BRACE+ count + RIGHT_BRACE);
    }

    private void getSomeoneTotalMoney() {
        someoneSrcTotalMoney = 0;
        for(int idx = 0; idx < someOneProvider.getCount(); idx++) {
            ProductInfo info = (ProductInfo) someOneProvider.getItem(idx);
            if (info.isSelect()) {
                int num = Integer.parseInt(info.getNum());
                double price = Double.parseDouble(info.getPrice());
                someoneSrcTotalMoney += num * price;
            }
        }
        String tmp = getString(ResourceTable.String_original_price_label) + MONEY_STR;
        textSomeoneSrcTotalMoney.setText(tmp+someoneSrcTotalMoney + ZERO_STR);
    }

    private void initListener() {
        productListContainer.setItemClickedListener(
            (listContainer, component, position, id) -> {
            });

        imgDetail.setClickedListener(v -> {
        });

        textDetail.setClickedListener(v -> {
        });

        int[] mMoney = {totalSrcMoney, discountMoney, totalMoney, myTotalMoney, someoneTotalMoney};
        int[] mTotalMoney = {mySrcTotalMoney, someoneSrcTotalMoney};
        Image layout = (Image)findComponentById(ResourceTable.Id_meger_discount_detail);
        layout.setClickedListener(v-> new DiscountDetailDialog(this, mMoney, mTotalMoney, count).show());
        textPayMoney.setClickedListener(v -> {
            Intent intent = new Intent();
            Operation operation = new Intent.OperationBuilder().build();
            intent.setOperation(operation);
            intent.setParam(ShoppingCartManage.TOTAL_MONEY,mySrcTotalMoney);
            int discount = mySrcTotalMoney - myTotalMoney;
            intent.setParam(ShoppingCartManage.DISCOUNT_MONEY,discount);
            present(new ShowOrderSlice(),intent);
        });
        imgMerge.setClickedListener(
            v-> showDeviceList(ShoppingCartManage.MEGER_EVENT));
        imgShare.setClickedListener(
            v-> showDeviceList(ShoppingCartManage.SHARE_EVENT));
        initSelectAllListener();
    }

    private void initSelectAllListener() {
        imgSelectAll.setClickedListener(v -> {
            if(mIsSelectALl) {
                for (int idx = 0; idx < productListProvider.getCount(); idx++) {
                    ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
                    info.setSelect(false);
                    ShoppingCartManage.myShoppingCart.get(idx).setSelect(false);
                }
                mIsSelectALl = false;
                imgSelectAll.setPixelMap(ResourceTable.Media_icon_unselect);
                textPayMoney.setText(getString(ResourceTable.String_settle_accounts_label)
                    + LEFT_BRACE + 0 + RIGHT_BRACE);
            } else {
                for (int idx = 0; idx < productListProvider.getCount(); idx++){
                    ProductInfo info = (ProductInfo) productListProvider.getItem(idx);
                    info.setSelect(true);
                    ShoppingCartManage.myShoppingCart.get(idx).setSelect(true);
                }
                mIsSelectALl = true;
                imgSelectAll.setPixelMap(ResourceTable.Media_icon_select);
                textPayMoney.setText(getString(ResourceTable.String_settle_accounts_label)
                    + LEFT_BRACE + ShoppingCartManage.myShoppingCart.size() + RIGHT_BRACE);
            }
            getTotalMoney();
            updateListView();
        });
    }

    private void initDevices() {
        if (devices.size() > 0) {
            devices.clear();
        }
        List<DeviceInfo> deviceInfos =
                DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
        devices.addAll(deviceInfos);
    }

    private void showDeviceList(String opt) {
        new DeviceListDialog(MegerShoppingCartSlice.this, opt,
            (devId,option) -> {
                MyIAbilityConnection myIAbilityConnection = new MyIAbilityConnection(devId,option,getContext());
                myIAbilityConnection.startAbilityFa();
                new AddProductDialog(this,getString(ResourceTable.String_meger_success_info)).show();
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
