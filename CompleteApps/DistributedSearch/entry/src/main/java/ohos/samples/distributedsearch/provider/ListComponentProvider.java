/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.distributedsearch.provider;

import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.app.Context;

import java.util.List;

/**
 * The type List component provider.
 *
 * @param <T> the type parameter
 * @since 2021-04-27
 */
public abstract class ListComponentProvider<T> extends BaseItemProvider {
    protected Context context;

    /**
     * Item data
     */
    protected List<T> listBean;

    /**
     * Layout resource id
     */
    protected int resourceId;

    /**
     * Instantiates a new List component provider.
     *
     * @param context the context
     * @param listBean the list bean
     * @param resourceId the resource id
     */
    public ListComponentProvider(Context context, List<T> listBean, int resourceId) {
        this.context = context;
        this.listBean = listBean;
        this.resourceId = resourceId;
    }

    /**
     * Set the data of the view subcomponent
     *
     * @param componentViewHolder componentViewHolder
     * @param item item
     * @param position position
     */
    protected abstract void onItemDataBind(ComponentViewHolder componentViewHolder, T item, int position);

    @Override
    public int getCount() {
        return listBean.size();
    }

    @Override
    public T getItem(int idx) {
        return listBean.get(idx);
    }

    @Override
    public long getItemId(int idx) {
        return idx;
    }

    @Override
    public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
        ComponentViewHolder viewHolder;
        if (component == null) {
            component = LayoutScatter.getInstance(context).parse(resourceId, null, false);
            viewHolder = new ComponentViewHolder(component);
            component.setTag(viewHolder);
        } else {
            viewHolder = (ComponentViewHolder) component.getTag();
        }
        if (viewHolder != null) {
            T item = listBean.get(position);

            // Set the data of the view subcomponent
            onItemDataBind(viewHolder, item, position);

            // Set binding event of item
            viewHolder.getComponentView()
                .setClickedListener(componentView -> onItemClick(componentView, item, position));
        }
        return component;
    }

    /**
     * Set the binding event of item, and the subclass overrides as needed
     *
     * @param component component
     * @param item item
     * @param position position
     */
    protected void onItemClick(Component component, T item, int position) {
    }
}
