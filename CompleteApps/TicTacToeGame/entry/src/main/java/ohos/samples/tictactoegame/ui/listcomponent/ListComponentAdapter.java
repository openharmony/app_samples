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

package ohos.samples.tictactoegame.ui.listcomponent;

import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.app.Context;

import java.util.List;

/**
 * ListComponentAdapter class
 *
 * @param <T> params type
 */
public abstract class ListComponentAdapter<T> extends BaseItemProvider {
    private final Context mContext;
    private final List<T> mListBean;
    private final int mXmlId;

    /**
     * ListComponentAdapter
     *
     * @param context the context
     * @param list the list
     * @param xmlId the xml file id
     */
    public ListComponentAdapter(Context context, List<T> list, int xmlId) {
        this.mContext = context;
        this.mListBean = list;
        this.mXmlId = xmlId;
    }

    /**
     * onBindViewHolder
     *
     * @param commonViewHolder the adapter holder
     * @param item the item in the holder
     * @param position the item position
     */
    public abstract void onBindViewHolder(CommentViewHolder commonViewHolder, T item, int position);

    @Override
    public int getCount() {
        return mListBean.size();
    }

    @Override
    public T getItem(int idx) {
        return mListBean.get(idx);
    }

    @Override
    public long getItemId(int idx) {
        return idx;
    }

    @Override
    public Component getComponent(int i, Component component, ComponentContainer componentContainer) {
        CommentViewHolder commentViewHolder = CommentViewHolder.getCommentViewHolder(mContext, component, mXmlId);
        T item = mListBean.get(i);

        onBindViewHolder(commentViewHolder, item, i);
        commentViewHolder.getConvertView().setClickedListener(component1 -> onItemClick(component, item, i));
        return commentViewHolder.getConvertView();
    }

    public void onItemClick(Component component, T item, int position) {
    }
}