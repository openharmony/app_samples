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

package ohos.samples.backgrounddownload.slice;

import ohos.samples.backgrounddownload.ResourceTable;
import ohos.samples.backgrounddownload.utils.DownloadServiceConnection;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;

/**
 * AnotherAbilitySlice
 */
public class AnotherAbilitySlice extends AbilitySlice implements DownloadServiceConnection.DownloadStateChangeListener {
    private DownloadServiceConnection downloadServiceConnection;

    private Text stateText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_another_ability_slice);
        initComponents();
        initData();
    }

    private void initComponents() {
        stateText = (Text) findComponentById(ResourceTable.Id_state_text);
        findComponentById(ResourceTable.Id_start_button).setClickedListener(
            component -> downloadServiceConnection.startService());
        findComponentById(ResourceTable.Id_stop_button).setClickedListener(
            component -> downloadServiceConnection.stopService());
        findComponentById(ResourceTable.Id_cancel_task_button).setClickedListener(
            component -> downloadServiceConnection.cancelTask());
    }

    private void initData() {
        downloadServiceConnection = new DownloadServiceConnection(this);
        downloadServiceConnection.setDownLoadStateChangeListener(this);
    }

    @Override
    public void onDownloadStateChange(String message) {
        stateText.setText(message);
    }
}
