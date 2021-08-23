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
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;
import ohos.samples.distributedshoppingcart.utils.AddProductDialog;
import ohos.samples.distributedshoppingcart.utils.CommonUtils;

/**
 * ProductDetailAbilitySlice
 */
public class ProductDetailAbilitySlice extends AbilitySlice {
    private Text iconShared;
    private Text textNum;
    private Image shoppingCart;
    private final ProductInfo productInfo = new ProductInfo();

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_product_detail_layout);
        productInfo.setTitle(intent.getStringParam(ShoppingCartManage.INTENT_TITLE));
        productInfo.setContent(intent.getStringParam(ShoppingCartManage.INTENT_CONTENT));
        productInfo.setOtherContent(intent.getStringParam(ShoppingCartManage.INTENT_OTHER_CONTENT));
        productInfo.setImgUrl(intent.getStringParam(ShoppingCartManage.INTENT_IMAGE));
        productInfo.setImgDetail(intent.getStringParam(ShoppingCartManage.INTENT_IMAGE_DETAIL));
        productInfo.setParam(intent.getStringParam(ShoppingCartManage.INTENT_PARAM));
        productInfo.setParam2(intent.getStringParam(ShoppingCartManage.INTENT_PARAM2));
        productInfo.setPrice(intent.getStringParam(ShoppingCartManage.INTENT_PRICE));
        productInfo.setDiscount(intent.getStringParam(ShoppingCartManage.INTENT_DISCOUNT));
        initView();
        initListener();
    }

    private void initView() {
        textNum = (Text) findComponentById(ResourceTable.Id_cart_num_detail);
        if (ShoppingCartManage.myShoppingCart.size() > 0) {
            textNum.setText(String.valueOf(ShoppingCartManage.myShoppingCart.size()));
        } else {
            textNum.setVisibility(1);
        }
        shoppingCart = (Image)findComponentById(ResourceTable.Id_image_shoppingCart);
        iconShared = (Text) findComponentById(ResourceTable.Id_add_product);
        iconShared.setTouchFocusable(true);
        Text newsContent = (Text) findComponentById(ResourceTable.Id_title_content);
        Image newsImage = (Image) findComponentById(ResourceTable.Id_image_content);
        newsContent.setText(productInfo.getContent());
        newsImage.setPixelMap(CommonUtils.getPixelMapFromPath(this, productInfo.getImgDetail()));
        Text otherCont = (Text)findComponentById(ResourceTable.Id_title_other_content);
        otherCont.setText(productInfo.getOtherContent());
        Text priceText = (Text)findComponentById(ResourceTable.Id_product_price);
        priceText.setText(productInfo.getPrice());
        Text paramText = (Text)findComponentById(ResourceTable.Id_item_param);
        paramText.setText(productInfo.getParam());
        Text param2Text = (Text)findComponentById(ResourceTable.Id_item_param2);
        param2Text.setText(productInfo.getParam2());
        Text discountText = (Text)findComponentById(ResourceTable.Id_item_discount);
        discountText.setText(productInfo.getDiscount());
    }

    private void initListener() {
        shoppingCart.setClickedListener(v -> {
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
        iconShared.setClickedListener(v -> {
            new AddProductDialog(this,getString(ResourceTable.String_add_succ_label)).show();
            ShoppingCartManage.addProductInfo(ShoppingCartManage.myShoppingCart,productInfo);
            if (ShoppingCartManage.myShoppingCart.size() > 0) {
                textNum.setVisibility(0);
                textNum.setText(String.valueOf(ShoppingCartManage.myShoppingCart.size()));
            } else {
                textNum.setVisibility(1);
            }
            findComponentById(ResourceTable.Id_car_shoppingcart_layout).invalidate();
            findComponentById(ResourceTable.Id_parent_layout).invalidate();
        });
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
    }
}
