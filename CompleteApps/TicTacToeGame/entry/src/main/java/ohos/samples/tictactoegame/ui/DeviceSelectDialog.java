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

package ohos.samples.tictactoegame.ui;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.samples.tictactoegame.ResourceTable;
import ohos.samples.tictactoegame.data.mode.DeviceData;
import ohos.samples.tictactoegame.ui.listcomponent.CommentViewHolder;
import ohos.samples.tictactoegame.ui.listcomponent.ListComponentAdapter;
import ohos.samples.tictactoegame.utils.DeviceUtils;

import java.util.ArrayList;
import java.util.List;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;

/**
 * DeviceSelectDialog
 */
public class DeviceSelectDialog extends CommonDialog {
    private static final int RADIO_SIZE = 10;

    private DeviceInfo mCheckedDevice;
    private final List<DeviceData> mDeviceList = new ArrayList<>();
    private ListComponentAdapter listComponentAdapter;

    /**
     * OnclickListener
     */
    public interface OnclickListener {
        void onYesClick(DeviceInfo deviceInfo);
    }

    private final Context mContext;
    private OnclickListener mOnclickListener;

    /**
     * DeviceSelectDialog
     *
     * @param context the context
     */
    public DeviceSelectDialog(Context context) {
        super(context);
        this.mContext = context;
    }

    /**
     * setListener
     *
     * @param listener the listener
     */
    public void setListener(OnclickListener listener) {
        mOnclickListener = listener;
    }

    private void initDeviceList() {
        List<DeviceInfo> deviceInfoList = DeviceUtils.getRemoteDevice();
        mDeviceList.clear();
        for (DeviceInfo deviceInfo : deviceInfoList) {
            mDeviceList.add(new DeviceData(false, deviceInfo));
        }
        if (deviceInfoList.size() > 0) {
            mCheckedDevice = deviceInfoList.get(0);
        }
    }

    private void initUi(Component rootView) {
        listComponentAdapter = new ListComponentAdapter<DeviceData>(mContext,
                mDeviceList, ResourceTable.Layout_dialog_device_item) {
            @Override
            public void onBindViewHolder(CommentViewHolder commonViewHolder, DeviceData item, int position) {
                commonViewHolder.getTextView(ResourceTable.Id_item_desc).setText(item.getDeviceInfo().getDeviceName());
                switch (item.getDeviceInfo().getDeviceType()) {
                    case SMART_PHONE:
                        commonViewHolder.getImageView(ResourceTable.Id_item_type).setPixelMap(
                            ResourceTable.Media_dv_phone);
                        break;
                    case SMART_PAD:
                        commonViewHolder.getImageView(ResourceTable.Id_item_type).setPixelMap(
                            ResourceTable.Media_dv_pad);
                        break;
                    case SMART_WATCH:
                        commonViewHolder.getImageView(ResourceTable.Id_item_type).setPixelMap(
                            ResourceTable.Media_dv_watch);
                        break;
                }
                commonViewHolder.getImageView(ResourceTable.Id_item_check).setPixelMap(
                    item.isChecked() ? ResourceTable.Media_checked_point : ResourceTable.Media_uncheck_point);
            }

            @Override
            public void onItemClick(Component component, DeviceData item, int position) {
                super.onItemClick(component, item, position);
                for (DeviceData deviceData : mDeviceList) {
                    deviceData.setChecked(false);
                }
                mDeviceList.get(position).setChecked(true);
                listComponentAdapter.notifyDataChanged();
                mCheckedDevice = item.getDeviceInfo();
            }
        };

        ListContainer mContainer = (ListContainer) rootView.findComponentById(
            ResourceTable.Id_list_container_device);
        mContainer.setItemProvider(listComponentAdapter);

        Text operateYes = (Text) rootView.findComponentById(ResourceTable.Id_operate_yes);
        operateYes.setClickedListener(component -> {
            if (mOnclickListener != null && mCheckedDevice != null) {
                mOnclickListener.onYesClick(mCheckedDevice);
            }
        });
        Text operateNo = (Text) rootView.findComponentById(ResourceTable.Id_operate_no);
        operateNo.setClickedListener(component -> hide());
    }

    @Override
    protected void onCreate() {
        super.onCreate();

        Component rootView = LayoutScatter.getInstance(mContext).parse(
            ResourceTable.Layout_dialog_layout_device, null, false);

        initDeviceList();
        initUi(rootView);

        setSize(MATCH_PARENT, MATCH_CONTENT);
        setAlignment(LayoutAlignment.BOTTOM);
        setCornerRadius(RADIO_SIZE);
        setAutoClosable(true);
        setContentCustomComponent(rootView);
        setTransparent(true);
    }
}
