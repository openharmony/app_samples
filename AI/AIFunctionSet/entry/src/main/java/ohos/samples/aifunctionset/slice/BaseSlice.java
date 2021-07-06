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

package ohos.samples.aifunctionset.slice;

import ohos.aafwk.ability.AbilitySlice;

import ohos.samples.aifunctionset.ResourceTable;

import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;

/**
 * Base Slice
 */
public abstract class BaseSlice extends AbilitySlice {
    /**
     * common baseSlice root layout
     */
    public DirectionalLayout rootLayout;

    /**
     * current slice layout
     */
    public Component currComponent;

    /**
     * slice title
     */
    public Text aiTitle;

    /**
     * slice desc
     */
    public Text aiDesc;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_base_layout);

        initCommons();
        initLayout();
        setTitle();
    }

    private void initCommons() {
        rootLayout = (DirectionalLayout) findComponentById(ResourceTable.Id_root_layout);
        aiTitle = (Text) findComponentById(ResourceTable.Id_title);
        aiDesc = (Text) findComponentById(ResourceTable.Id_desc);
        Component back = findComponentById(ResourceTable.Id_back);
        back.setClickedListener(component -> terminate());
    }

    /**
     * common toast method
     *
     * @param msg toast content
     */
    public void showTips(String msg) {
        new ToastDialog(this).setContentText(msg).show();
    }

    /**
     * init slice layout
     */
    public abstract void initLayout();

    /**
     * set slice title and desc
     */
    public abstract void setTitle();

    @Override
    protected void onStop() {
        super.onStop();
        if (currComponent != null) {
            rootLayout.removeComponent(currComponent);
        }
    }
}
