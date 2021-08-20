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
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.app.Context;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.samples.distributedsearch.utils.LogUtil;

import java.util.List;

/**
 * the file list provider
 *
 * @param <T> the type parameter
 */
public class FileListProvider<T> extends BaseItemProvider {
    private final static String TAG = "FileListProvider";
    private final Context mContext;
    private final List<T> mList;

    /**
     * create FileListProvider
     *
     * @param context the context
     * @param listBean the list bean
     */
    public FileListProvider(Context context, List<T> listBean) {
        mContext = context;
        mList = listBean;
    }

    @Override
    public int getCount() {
        return mList == null ? 0 : mList.size();
    }

    @Override
    public T getItem(int idx) {
        return (mList == null || mList.size() == 0) ? null : mList.get(idx);
    }

    @Override
    public long getItemId(int idx) {
        return idx;
    }

    @Override
    public Component getComponent(int idx, Component component, ComponentContainer componentContainer) {
        FileItemViewHolder holder;

        if (component == null) {
            component = LayoutScatter.getInstance(mContext).parse(ResourceTable.Layout_file_item, null, false);
        }

        holder = (FileItemViewHolder)mList.get(idx);
        if (holder == null) {
            LogUtil.error(TAG, "FileItemViewHolder[]" + idx + " is null");
            return component;
        }

        Image icon = (Image)component.findComponentById(ResourceTable.Id_imageIcon);
        icon.setPixelMap(holder.getIconId());

        Text name = (Text)component.findComponentById(ResourceTable.Id_filename);
        name.setText(holder.getFilename());
        Text devName = (Text)component.findComponentById(ResourceTable.Id_deviceinfo);
        devName.setText(mContext.getString(ResourceTable.String_file_source_label) + ": " + holder.getDevicename());

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
