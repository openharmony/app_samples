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

import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.app.Context;
import ohos.samples.distributedshoppingcart.ResourceTable;
import ohos.samples.distributedshoppingcart.been.ProductInfo;
import ohos.samples.distributedshoppingcart.utils.CommonUtils;

import java.util.List;

/**
 * MegerListProvider
 */
public class MegerListProvider extends BaseItemProvider {
    private final List<ProductInfo> infoList;
    private final Context context;

    /**
     * MegerListProvider
     *
     * @param listBasicInfo the basic info list
     * @param context the context
     */
    public MegerListProvider(List<ProductInfo> listBasicInfo, Context context) {
        this.infoList = listBasicInfo;
        this.context = context;
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
        ViewHolder viewHolder = new ViewHolder();
        Component temp = component;
        if (temp == null) {
            temp = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_meger_shoping_cart_list, null, false);
            viewHolder.image = (Image) temp.findComponentById(ResourceTable.Id_item_pro_image);
            viewHolder.content = (Text) temp.findComponentById(ResourceTable.Id_item_pro_title);
            viewHolder.param = (Text) temp.findComponentById(ResourceTable.Id_item_pro_param);
            viewHolder.param2 = (Text) temp.findComponentById(ResourceTable.Id_item_pro_param2);
            viewHolder.price = (Text) temp.findComponentById(ResourceTable.Id_item_pro_price);
            viewHolder.discount = (Text) temp.findComponentById(ResourceTable.Id_item_pro_discount);
            viewHolder.num = (Text)temp.findComponentById(ResourceTable.Id_item_pro_num);
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
        return temp;
    }

    /**
     * ViewHolder
     */
    private static class ViewHolder {
        Image image;
        Text content;
        Text param;
        Text param2;
        Text price;
        Text discount;
        Text num;
    }
}
