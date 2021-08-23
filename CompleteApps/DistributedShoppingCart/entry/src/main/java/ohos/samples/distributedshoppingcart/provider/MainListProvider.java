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
 * MainListProvider
 */
public class MainListProvider extends BaseItemProvider {
    private final List<ProductInfo> newsInfoList;
    private final Context context;

    /**
     * MainListProvider
     *
     * @param listBasicInfo the basic info list
     * @param context the context
     */
    public MainListProvider(List<ProductInfo> listBasicInfo, Context context) {
        this.newsInfoList = listBasicInfo;
        this.context = context;
    }

    @Override
    public int getCount() {
        return newsInfoList == null ? 0 : newsInfoList.size();
    }

    @Override
    public Object getItem(int idx) {
        return newsInfoList.get(idx);
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
            temp = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_product_item_layout, null, false);
            viewHolder = new ViewHolder();
            viewHolder.image = (Image) temp.findComponentById(ResourceTable.Id_item_news_image);
            viewHolder.content = (Text) temp.findComponentById(ResourceTable.Id_item_news_title);
            viewHolder.param = (Text) temp.findComponentById(ResourceTable.Id_item_news_param);
            viewHolder.param2 = (Text) temp.findComponentById(ResourceTable.Id_item_news_param2);
            viewHolder.price = (Text) temp.findComponentById(ResourceTable.Id_item_news_price);
            viewHolder.discount = (Text) temp.findComponentById(ResourceTable.Id_item_news_discount);
            temp.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) temp.getTag();
        }
        viewHolder.image.setPixelMap(CommonUtils.getPixelMapFromPath(context, newsInfoList.get(position).getImgUrl()));
        viewHolder.content.setText(newsInfoList.get(position).getContent());
        viewHolder.param.setText(newsInfoList.get(position).getParam());
        viewHolder.param2.setText(newsInfoList.get(position).getParam2());
        viewHolder.price.setText(newsInfoList.get(position).getPrice());
        viewHolder.discount.setText(newsInfoList.get(position).getDiscount());
        return temp;
    }

    /**
     * ViewHolder class
     */
    private static class ViewHolder {
        Image image;
        Text content;
        Text param;
        Text param2;
        Text price;
        Text discount;
    }
}
