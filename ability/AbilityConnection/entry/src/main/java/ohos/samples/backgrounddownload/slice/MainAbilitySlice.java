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
import ohos.samples.backgrounddownload.utils.Const;
import ohos.samples.backgrounddownload.utils.DownloadServiceConnection;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Text;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements DownloadServiceConnection.DownloadStateChangeListener {
    private DownloadServiceConnection abilityConnection;

    private Text stateText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        initData();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_launch_button).setClickedListener(component -> startAnotherAbility());
        findComponentById(ResourceTable.Id_start_button).setClickedListener(
            component -> abilityConnection.startService());
        findComponentById(ResourceTable.Id_new_task_button).setClickedListener(
            component -> abilityConnection.startTask(Const.DOWNLOAD_FILE_URL));
        findComponentById(ResourceTable.Id_cancel_task_button).setClickedListener(
            component -> abilityConnection.cancelTask());
        findComponentById(ResourceTable.Id_stop_button).setClickedListener(
            component -> abilityConnection.stopService());
        stateText = (Text) findComponentById(ResourceTable.Id_state_text);
    }

    private void initData() {
        abilityConnection = new DownloadServiceConnection(this);
    }

    @Override
    public void onActive() {
        super.onActive();
        abilityConnection.setDownLoadStateChangeListener(this);
    }

    private void startAnotherAbility() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName("ohos.samples.backgrounddownload")
            .withAbilityName("ohos.samples.backgrounddownload.AnotherAbility")
            .build();
        intent.setOperation(operation);
        startAbility(intent);
    }

    @Override
    public void onDownloadStateChange(String message) {
        stateText.setText(message);
    }
}
