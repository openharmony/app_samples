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

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Image;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.CommonEventSupport;
import ohos.event.commonevent.MatchingSkills;
import ohos.rpc.RemoteException;
import ohos.samples.distributedshoppingcart.MainAbility;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;
import ohos.samples.distributedshoppingcart.provider.MainListProvider;
import ohos.samples.distributedshoppingcart.utils.CommonUtils;
import ohos.samples.distributedshoppingcart.utils.LogUtils;
import ohos.samples.distributedshoppingcart.utils.MegerDialog;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private ListContainer listContainer;
    private List<ProductInfo> productList = new ArrayList<>();
    private MainListProvider listProvider;
    private MyCommonEventSubscriber subscriber;
    private Text textNum;

    class MyCommonEventSubscriber extends CommonEventSubscriber {
        MyCommonEventSubscriber(CommonEventSubscribeInfo info) {
            super(info);
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            Intent intent = commonEventData.getIntent();
            actionSubscriber(intent);
        }
    }

    /**
     * actionSubscriber
     *
     * @param intent the intent
     */
    public void actionSubscriber(Intent intent) {
        String opt = intent.getStringParam(ShoppingCartManage.ACTION_EVENT);
        if (ShoppingCartManage.devName == null || ShoppingCartManage.devName.equals("")) {
            ShoppingCartManage.getDevices();
        }
        if (opt.equals(ShoppingCartManage.MEGER_EVENT)) {
            new MegerDialog(this,getString(ResourceTable.String_meger_cart_label),
            getString(ResourceTable.String_friends_info) + ShoppingCartManage.devName
                + getString(ResourceTable.String_meger_cart_request), ()-> {
                ShoppingCartManage.addProductList(ShoppingCartManage.someOneShoppingCart,
                    ShoppingCartManage.productInfoList);
                Intent inte = new Intent();
                inte.setParam(ShoppingCartManage.MEGER_EVENT,"sendback");
                present(new MegerShoppingCartSlice(),inte);
            }).show();
        } if ("sendback".equals(opt)) {
                ShoppingCartManage.addProductList(ShoppingCartManage.someOneShoppingCart,
                    ShoppingCartManage.productInfoList);
                Intent inte = new Intent();
                present(new MegerShoppingCartSlice(),inte);
        } else if (opt.equals(ShoppingCartManage.SHARE_EVENT)) {
            new MegerDialog(this,getString(ResourceTable.String_shared_cart_label),
                getString(ResourceTable.String_friends_info)+ ShoppingCartManage.devName
                + getString(ResourceTable.String_shared_cart_request), ()-> {
                ShoppingCartManage.addProductList(ShoppingCartManage.myShoppingCart,
                    ShoppingCartManage.productInfoList);
                present(new ShareShoppingCartSlice(),new Intent());
            }).show();
        }
    }

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_product_list_layout);
        initData();
        initListener();
        listContainer.setItemProvider(listProvider);
        listProvider.notifyDataChanged();
        subscribe();
        if (ShoppingCartManage.devName == null || ShoppingCartManage.devName.equals("")) {
            ShoppingCartManage.getDevices();
        }
    }

    private void subscribe() {
        LogUtils.e("subscribe", "PICTURE_GAME_EVENT subscribeCommonEvent");
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(ShoppingCartManage.SUB_EVENT);
        matchingSkills.addEvent(CommonEventSupport.COMMON_EVENT_SCREEN_ON);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        subscriber = new MyCommonEventSubscriber(subscribeInfo);
        try {
            CommonEventManager.subscribeCommonEvent(subscriber);
        } catch (RemoteException e) {
            LogUtils.e("subscribe", "subscribeCommonEvent occur exception.");
        }
    }

    private void initData() {
        textNum = (Text) findComponentById(ResourceTable.Id_cart_num);
        if (ShoppingCartManage.myShoppingCart.size() > 0) {
            textNum.setText(String.valueOf(ShoppingCartManage.myShoppingCart.size()));
        } else {
            textNum.setVisibility(1);
        }
        Gson gson = new Gson();
        productList =
                gson.fromJson(
                        CommonUtils.getStringFromJsonPath(this, "entry/resources/rawfile/product_datas.json"),
                        new TypeToken<List<ProductInfo>>() { }.getType());
        listProvider = new MainListProvider(productList, this);
    }

    private void initListener() {
        Image img = (Image)findComponentById(ResourceTable.Id_car_cart);
        img.setClickedListener(v-> {
            Intent intent = new Intent();
            if (ShoppingCartManage.actionShoppingCart.equals("action.share")) {
                present(
                        new ShareShoppingCartSlice(),intent
                );
            } else {
                present(
                        new MegerShoppingCartSlice(),intent
                );
            }
        });

        listContainer = (ListContainer) findComponentById(ResourceTable.Id_news_container);
        listContainer.setItemClickedListener(
            (listContainer, component, position, id) -> {
                Intent intent = new Intent();
                Operation operation =
                    new Intent.OperationBuilder()
                        .withBundleName(getBundleName())
                        .withAbilityName(MainAbility.class.getName())
                        .build();
                intent.setOperation(operation);
                intent.setParam(ShoppingCartManage.INTENT_TITLE, productList.get(position).getTitle());
                intent.setParam(ShoppingCartManage.INTENT_CONTENT, productList.get(position).getContent());
                intent.setParam(ShoppingCartManage.INTENT_IMAGE, productList.get(position).getImgUrl());
                intent.setParam(ShoppingCartManage.INTENT_IMAGE_DETAIL, productList.get(position).getImgDetail());
                intent.setParam(ShoppingCartManage.INTENT_OTHER_CONTENT, productList.get(position).getOtherContent());
                intent.setParam(ShoppingCartManage.INTENT_PRICE, productList.get(position).getPrice());
                intent.setParam(ShoppingCartManage.INTENT_PARAM, productList.get(position).getParam());
                intent.setParam(ShoppingCartManage.INTENT_PARAM2, productList.get(position).getParam2());
                intent.setParam(ShoppingCartManage.INTENT_DISCOUNT, productList.get(position).getDiscount());
                present(new ProductDetailAbilitySlice(),intent);
            });
    }

    @Override
    public void onActive() {
        if (ShoppingCartManage.myShoppingCart.size() > 0) {
            textNum.setVisibility(0);
            textNum.setText(String.valueOf(ShoppingCartManage.myShoppingCart.size()));
        } else {
            textNum.setVisibility(1);
        }
        findComponentById(ResourceTable.Id_car_shoppingcart).invalidate();
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
        unSubscribe();
    }

    private void unSubscribe() {
        try {
            CommonEventManager.unsubscribeCommonEvent(subscriber);
        } catch (RemoteException e) {
            LogUtils.i("unSubscribe", "unSubscribe Exception");
        }
    }
}