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

package ohos.samples.distributedshoppingcart.provider;

import ohos.agp.components.*;
import ohos.app.Context;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.been.ShoppingCartManage;
import ohos.samples.distributedshoppingcart.utils.CommonUtils;

import java.util.List;

/**
 * ProductListProvider
 */
public class ProductListProvider extends BaseItemProvider {
    private final List<ProductInfo> infoList;
    private final Context context;
    private final SelectResultListener listener;

    /**
     * ProductListProvider
     *
     * @param listBasicInfo the basic info list
     * @param context the context
     * @param listener the listener event
     */
    public ProductListProvider(List<ProductInfo> listBasicInfo, Context context,SelectResultListener listener) {
        this.infoList = listBasicInfo;
        this.context = context;
        this.listener = listener;
    }

    /**
     * SelectResultListener
     */
    public interface SelectResultListener {
        /**
         * callBack
         */
        void callBack();
    }
    public List<ProductInfo> getInfoList(){
        return infoList;
    }
    @Override
    public int getCount() {
        return infoList == null ? 0 : infoList.size();
    }

    @Override
    public Object getItem(int i) {
        return infoList.get(i);
    }

    @Override
    public long getItemId(int idx) {
        return idx;
    }

    @Override
    public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
        ViewHolder viewHolder;
        Component temp = component;
        if (temp == null) {
            temp = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_share_shoping_cart_list, null, false);
            viewHolder = new ViewHolder();
            viewHolder.image = (Image) temp.findComponentById(ResourceTable.Id_item_pro_image);
            viewHolder.content = (Text) temp.findComponentById(ResourceTable.Id_item_pro_title);
            viewHolder.param = (Text) temp.findComponentById(ResourceTable.Id_item_pro_param);
            viewHolder.param2 = (Text) temp.findComponentById(ResourceTable.Id_item_pro_param2);
            viewHolder.price = (Text) temp.findComponentById(ResourceTable.Id_item_pro_price);
            viewHolder.discount = (Text) temp.findComponentById(ResourceTable.Id_item_pro_discount);

            viewHolder.imgSelect = (Image)temp.findComponentById(ResourceTable.Id_pro_select);
            viewHolder.imgDec = (Image)temp.findComponentById(ResourceTable.Id_item_pro_dec);
            viewHolder.imgPlus = (Image)temp.findComponentById(ResourceTable.Id_item_pro_plus);
            viewHolder.num = (Text) temp.findComponentById(ResourceTable.Id_item_pro_num);
            temp.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) temp.getTag();
        }
        viewHolder.image.setPixelMap(CommonUtils.getPixelMapFromPath(context, infoList.get(position).getImgUrl()));
        viewHolder.content.setText(infoList.get(position).getContent());
        viewHolder.param.setText(infoList.get(position).getParam());
        viewHolder.param2.setText(infoList.get(position).getParam2());
        viewHolder.price.setText(infoList.get(position).getPrice());
        viewHolder.discount.setText(infoList.get(position).getDiscount());
        viewHolder.num.setText(infoList.get(position).getNum());
        if (infoList.get(position).isSelect()) {
            viewHolder.imgSelect.setPixelMap(ResourceTable.Media_icon_select);
        } else {
            viewHolder.imgSelect.setPixelMap(ResourceTable.Media_icon_unselect);
        }
        initListener(viewHolder,position);
        return temp;
    }

    private void initListener(ViewHolder viewHolder,int pos) {
        if (viewHolder.imgSelect != null) {
            viewHolder.imgSelect.setClickedListener(v -> {
                if (infoList.get(pos).isSelect()) {
                    viewHolder.imgSelect.setPixelMap(ResourceTable.Media_icon_unselect);
                    infoList.get(pos).setSelect(false);

                    ShoppingCartManage.myShoppingCart.get(pos).setSelect(false);
                } else {
                    viewHolder.imgSelect.setPixelMap(ResourceTable.Media_icon_select);
                    infoList.get(pos).setSelect(true);

                    ShoppingCartManage.myShoppingCart.get(pos).setSelect(true);
                }
                listener.callBack();
            });
        }
        if(viewHolder.num == null) {
            return;
        }
        if (viewHolder.imgDec != null) {
            viewHolder.imgDec.setClickedListener(v -> {
                int num = Integer.parseInt(infoList.get(pos).getNum());
                if (num <= 1) {
                    return;
                }
                num--;
                infoList.get(pos).setNum(String.valueOf(num));
                ShoppingCartManage.myShoppingCart.get(pos).setNum(String.valueOf(num));
                viewHolder.num.setText(infoList.get(pos).getNum());
                listener.callBack();
            });
        }
        if (viewHolder.imgPlus != null) {
            viewHolder.imgPlus.setClickedListener(v -> {
                int num = Integer.parseInt(infoList.get(pos).getNum());
                num++;
                infoList.get(pos).setNum(String.valueOf(num));
                ShoppingCartManage.myShoppingCart.get(pos).setNum(String.valueOf(num));
                viewHolder.num.setText(infoList.get(pos).getNum());
                listener.callBack();
            });
        }
    }

    /**
     * ViewHolder class
     */
    private static class ViewHolder {
        Image image;
        Image imgSelect;
        Image imgPlus;
        Image imgDec;
        Text content;
        Text param;
        Text param2;
        Text price;
        Text discount;
        Text num;
    }
}
