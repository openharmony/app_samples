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

package ohos.samples.listcontainer.slice;

import ohos.samples.listcontainer.ResourceTable;
import ohos.samples.listcontainer.bean.Contact;
import ohos.samples.listcontainer.provider.ContactItemProvider;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ListContainer;

import java.util.ArrayList;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final int LIST_ITEM_COUNT = 200;

    private ListContainer listContainer;

    private ContactItemProvider contactItemProvider;

    private ArrayList<Contact> contactData;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_layout);

        initComponents();
        initContactData();
        initProvider();
    }

    private void initComponents() {
        listContainer = (ListContainer) findComponentById(ResourceTable.Id_list_container);
        Component btnAdd = findComponentById(ResourceTable.Id_bnt_add);
        btnAdd.setClickedListener(component -> addAndUpdateContact(contactData.size()));
    }

    private void initProvider() {
        contactItemProvider = new ContactItemProvider(this, contactData);
        listContainer.setItemProvider(contactItemProvider);
        listContainer.setReboundEffect(true);
    }

    private void addAndUpdateContact(int index) {
        addContact(index);
        contactItemProvider.update(contactData);
    }

    private void initContactData() {
        contactData = new ArrayList<>();
        for (int i = 0; i < LIST_ITEM_COUNT; i++) {
            addContact(i);
        }
    }

    private void addContact(int index) {
        contactData.add(new Contact("User " + index, "100000000" + index));
    }
}
