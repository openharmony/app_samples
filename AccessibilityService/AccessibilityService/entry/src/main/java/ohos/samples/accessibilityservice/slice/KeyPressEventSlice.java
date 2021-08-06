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

package ohos.samples.accessibilityservice.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.TabList;
import ohos.samples.accessibilityservice.ResourceTable;
import ohos.samples.accessibilityservice.service.MyAccessibilityService;
import ohos.samples.accessibilityservice.utils.LogUtils;

/**
 * MainAbilitySlice
 *
 * @since 2021-07-23
 */
public class KeyPressEventSlice extends AbilitySlice {
    private static final String TAG = KeyPressEventSlice.class.getSimpleName();

    private static TabList tabList;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_key_press_event);
        MyAccessibilityService.setNeedCustomVolumeKey(true);
        initComponents();
    }

    /**
     * scrollUp
     */
    public static void scrollUp() {
        LogUtils.info(TAG, "scrollUp");
        if (tabList != null && tabList.getSelectedTabIndex() > 0) {
            tabList.selectTabAt(tabList.getSelectedTabIndex() - 1);
        }
    }

    /**
     * scrollDown
     */
    public static void scrollDown() {
        LogUtils.info(TAG, "scrollDown");
        if (tabList != null && tabList.getSelectedTabIndex() < tabList.getTabCount() - 1) {
            tabList.selectTabAt(tabList.getSelectedTabIndex() + 1);
        }
    }

    private void initComponents() {
        Component component = findComponentById(ResourceTable.Id_tabList);
        if (component instanceof TabList) {
            tabList = (TabList) component;
        }
        for (int i = 0; i < 10; i++) {
            TabList.Tab tab = tabList.new Tab(getContext());
            tab.setText(ResourceTable.String_text_content);
            tabList.addTab(tab);
        }
        tabList.selectTabAt(0);
    }


    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
        tabList.removeAllComponents();
        MyAccessibilityService.setNeedCustomVolumeKey(false);
    }
}
