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

package ohos.samples.distributedsearch.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.ListContainer;
import ohos.agp.components.RadioButton;
import ohos.agp.components.RadioContainer;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.agp.utils.Color;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.samples.distributedsearch.provider.FileItemViewHolder;
import ohos.samples.distributedsearch.provider.FileListProvider;
import ohos.samples.distributedsearch.ui.DeviceSelectDialog;
import ohos.samples.distributedsearch.ui.PopupDialog;
import ohos.samples.distributedsearch.utils.DistributedFile;
import ohos.samples.distributedsearch.utils.WidgetHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int BUTTON_COORD_X = 350;
    private static final int BUTTON_COORD_Y = 700;
    private static final int DEVICE_COORD_X = 320;
    private static final int DEVICE_COORD_Y = 700;

    private static final int MSG_SHOW_TIME = 2000;

    private String mSearchKey = "";
    private TextField mTextField;
    private int mFileType = DistributedFile.FILE_TYPE_IMAGE;

    private RadioButton mButtonImage;
    private RadioButton mButtonAudio;
    private RadioButton mButtonVideo;
    private RadioButton mButtonText;
    private RadioButton mButtonFileAll;
    FileListProvider<FileItemViewHolder> fileProvider;
    private final ArrayList<FileItemViewHolder> mFileList = new ArrayList<>();
    private ListContainer listview;
    private Text result;
    private Image mButton;
    private Button mDevice;
    private DistributedFile mDistributedFile;
    private RadioContainer mRadioContainer;
    private Image searchImage;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_everything);

        mDistributedFile = new DistributedFile(this);
        mDistributedFile.start();

        initUi();
        setEventListener();
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }


    private void initUi() {
        listview = (ListContainer)this.findComponentById(ResourceTable.Id_listview);
        fileProvider = new FileListProvider<>(this, mFileList);
        listview.setItemProvider(fileProvider);

        listview.setVisibility(Component.HIDE);

        result = (Text) findComponentById(ResourceTable.Id_result_info);
        result.setVisibility(Component.VISIBLE);

        mRadioContainer = (RadioContainer)findComponentById(ResourceTable.Id_radio_container);

        mButtonImage = (RadioButton) this.findComponentById(ResourceTable.Id_sel_image);
        mButtonAudio = (RadioButton) this.findComponentById(ResourceTable.Id_sel_audio);
        mButtonVideo = (RadioButton) this.findComponentById(ResourceTable.Id_sel_video);
        mButtonText = (RadioButton) this.findComponentById(ResourceTable.Id_sel_text);
        mButtonFileAll = (RadioButton) this.findComponentById(ResourceTable.Id_sel_all);
        mRadioContainer.mark(0);
        mButtonImage.setClickable(false);

        mTextField = (TextField)this.findComponentById(ResourceTable.Id_textEntry);
        mTextField.setTextColor(Color.BLACK);
        searchImage = (Image)this.findComponentById(ResourceTable.Id_searchButton);

        mButton = (Image)findComponentById(ResourceTable.Id_AnimaBttn);
        mDevice = (Button)findComponentById(ResourceTable.Id_deviceBttn);

        mButton.setPosition(BUTTON_COORD_X, BUTTON_COORD_Y);
        mDevice.setPosition(DEVICE_COORD_X, DEVICE_COORD_Y);
        mButton.setVisibility(Component.VISIBLE);
        mDevice.setVisibility(Component.HIDE);
    }

    private void setEventListener() {
        setListViewEvent();
        setRadioContainerEvent();

        searchImage.setClickedListener(component -> {
            mSearchKey = mTextField.getText();
            if (!availableKey(mSearchKey)) {
                WidgetHelper.showTips(this, getString(ResourceTable.String_input_notice_msg), MSG_SHOW_TIME);
                return;
            }

            setListFile();
        });

        mButton.setClickedListener(component -> {
            mButton.setVisibility(Component.HIDE);
            if (mDevice != null) {
                mDevice.setVisibility(Component.VISIBLE);
                mDevice.setFocusable(Component.FOCUS_ENABLE);
            }
        });

        mDevice.setClickedListener(component -> {

            mDevice.setVisibility(Component.HIDE);
            if (mButton != null) {
                mButton.setVisibility(Component.VISIBLE);
                mButton.setFocusable(Component.FOCUS_ENABLE);
            }
            DeviceSelectDialog mDialog = new DeviceSelectDialog(this);
            mDialog.show();
        });
    }

    private void setListViewEvent() {
        listview.setItemClickedListener((container, component, position, id) -> {
            FileItemViewHolder item = (FileItemViewHolder) listview.getItemProvider().getItem(position);
            if (item != null && item.getFilepath() != null) {
                WidgetHelper.showTips(this,
                        getString(ResourceTable.String_file_path_label) + ": " +
                                item.getFilepath() + "/" + item.getFilename(), MSG_SHOW_TIME);
            }
        });
        listview.setItemLongClickedListener((container, component, position, id) -> {
            FileItemViewHolder item = (FileItemViewHolder) listview.getItemProvider().getItem(position);
            if (item != null) {
                PopupDialog mDialog = new PopupDialog(this);
                mDialog.show();
            }
            return true;
        });
    }

    private void setRadioContainerEvent() {
        mRadioContainer.setMarkChangedListener((radioContainer, idx) -> {
            RadioButton[] mRadioButton = {
                mButtonImage,
                mButtonAudio,
                mButtonVideo,
                mButtonText,
                mButtonFileAll
            };

            if (mFileType == idx) {
                return;
            }

            if (mRadioButton[mFileType] != null) {
                mRadioButton[mFileType].setTextColor(Color.GRAY);
                mRadioButton[mFileType].setClickable(true);
            }
            mFileType = idx;
            mRadioButton[mFileType].setClickable(false);

            mSearchKey = mTextField.getText();
            if (availableKey(mSearchKey)) {
                setListFile();
            }
        });
    }

    private boolean getFileViewList() {
        List<String> list;
        if (!mDistributedFile.hasCheckResult()) {
            return false;
        }
        list = mDistributedFile.getFile(mFileType);
        if (list == null || list.size() == 0) {
            return false;
        }

        getFileList(list, mSearchKey);

        return mFileList.size() > 0;
    }

    private void getFileList(List<String> list, String key) {
        mFileList.clear();
        for (String filename : list) {
            String device;
            String name;
            String path = null;

            int idx = filename.lastIndexOf('/');
            if (idx < 0) {
                name = filename;
            } else {
                name = filename.substring(idx + 1);
                path = filename.substring(0, idx + 1);
            }
            idx = name.indexOf('+');
            if (idx < 0) {
                device = getString(ResourceTable.String_local_device_name);
            } else {
                device = name.substring(0, idx);
                if (DistributedFile.isLocalDevice(this, device, 0)) {
                    device = getString(ResourceTable.String_local_device_name);
                }
                name = name.substring(idx + 1);
            }

            if (filename.contains(key)) {
                int ico = ResourceTable.Media_icon_file;
                int type = mDistributedFile.checkFileType(name);

                if (type == DistributedFile.FILE_TYPE_IMAGE) {
                    ico = ResourceTable.Media_icon_img;
                } else if (type == DistributedFile.FILE_TYPE_AUDIO) {
                    ico = ResourceTable.Media_icon_music;
                } else if (type == DistributedFile.FILE_TYPE_VIDEO) {
                    ico = ResourceTable.Media_icon_video;
                }

                FileItemViewHolder viewHolder = new FileItemViewHolder(name, path, device, ico);
                mFileList.add(viewHolder);
            }
        }
    }

    private boolean availableKey(String key) {
        if (key == null || key.length() == 0) {
            return false;
        }
        return !key.contains(" ");
    }

    private void setListFile() {
        if (getFileViewList()) {
            result.setVisibility(Component.HIDE);
            listview.setVisibility(Component.VISIBLE);
            fileProvider.notifyDataChanged();
        } else {
            result.setVisibility(Component.VISIBLE);
            listview.setVisibility(Component.HIDE);
        }
    }
}
