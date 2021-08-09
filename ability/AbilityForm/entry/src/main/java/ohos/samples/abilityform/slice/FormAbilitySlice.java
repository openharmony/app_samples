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

package ohos.samples.abilityform.slice;

import ohos.samples.abilityform.ResourceTable;

import ohos.aafwk.ability.AbilityForm;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.account.AccountAbility;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.dispatcher.TaskDispatcher;
import ohos.app.dispatcher.task.TaskPriority;
import ohos.bundle.AbilityInfo;
import ohos.bundle.IBundleManager;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;

import java.util.List;

/**
 * FormAbilitySlice
 */
public class FormAbilitySlice extends AbilitySlice {
    private static final String TAG = FormAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private DirectionalLayout containerLayout;

    private AbilityInfo abilityInfo;

    private AbilityForm abilityForm;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_form_layout);
        initComponents();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_load_form_button).setClickedListener(this::loadForm);
        findComponentById(ResourceTable.Id_remove_form_button).setClickedListener(this::removeForm);
        containerLayout = (DirectionalLayout) findComponentById(ResourceTable.Id_container_layout);
    }

    private void removeForm(Component component) {
        if (abilityForm == null) {
            return;
        }
        releaseAbilityForm(abilityForm);
        containerLayout.removeAllComponents();
    }

    private void loadForm(Component component) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName("ohos.samples.abilityformprovider")
            .withAbilityName("ohos.samples.abilityformprovider.FormAbility")
            .build();
        intent.setOperation(operation);

        try {
            List<AbilityInfo> abilityInfos = getBundleManager().queryAbilityByIntent(intent,
                IBundleManager.GET_ABILITY_INFO_WITH_PERMISSION,
                AccountAbility.getAccountAbility().getOsAccountLocalIdFromProcess());
            if (abilityInfos == null || abilityInfos.size() <= 0) {
                new ToastDialog(this).setText("No abilityForm found").show();
                return;
            }
            HiLog.info(LABEL_LOG, "%{public}s", "Found ability: " + abilityInfos.size());
            abilityInfo = abilityInfos.get(0);
        } catch (RemoteException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "loadForm: remoteException");
        }
        showForm(intent);
    }

    private void showForm(Intent intent) {
        TaskDispatcher globalTaskDispatcher = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        globalTaskDispatcher.asyncDispatch(() -> FormAbilitySlice.this.acquireAbilityFormAsync(intent, new AbilityForm.OnAcquiredCallback() {
            @Override
            public void onAcquired(AbilityForm form) {
                if (form == null) {
                    HiLog.info(LABEL_LOG, "%{public}s", "showForm: Form is null");
                    return;
                }
                abilityForm = form;
                addForm();
            }

            @Override
            public void onDestroyed(AbilityForm form) {
                abilityForm = null;
                HiLog.error(LABEL_LOG, "%{public}s", "showForm: AbilityForm on destroy");
            }
        }));
    }

    private void addForm() {
        containerLayout.removeAllComponents();
        DirectionalLayout directionalLayout = new DirectionalLayout(FormAbilitySlice.this, null);
        directionalLayout.setHeight(abilityInfo.getDefaultFormHeight());
        directionalLayout.setWidth(abilityInfo.getDefaultFormWidth());
        directionalLayout.setAlignment(LayoutAlignment.CENTER);
        directionalLayout.addComponent(abilityForm.getComponent());
        containerLayout.addComponent(directionalLayout);
    }
}
