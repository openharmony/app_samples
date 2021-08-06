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

package ohos.samples.search.slice;

import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.app.dispatcher.TaskDispatcher;
import ohos.app.dispatcher.task.TaskPriority;
import ohos.data.search.SearchAbility;
import ohos.data.search.connect.ServiceConnectCallback;
import ohos.samples.search.ResourceTable;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.samples.search.utils.LogUtils;
import ohos.samples.search.utils.SearchUtils;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * MainAbilitySlice
 *
 * @since 2021-07-23
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private SearchAbility searchAbility;

    private SearchUtils searUtils;

    private Text searchResult;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        initComponents();
        connectService();
    }

    private void connectService() {
        LogUtils.info(TAG, "connect search service");
        TaskDispatcher task = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        searchAbility = new SearchAbility(getContext());
        searUtils = new SearchUtils(getContext(), searchAbility);
        task.asyncDispatch(() -> {
            CountDownLatch lock = new CountDownLatch(1);

            // connect to SearchService
            searchAbility.connect(new ServiceConnectCallback() {
                @Override
                public void onConnect() {
                    lock.countDown();
                }

                @Override
                public void onDisconnect() {
                }
            });
            try {
                lock.await(3000, TimeUnit.MILLISECONDS);
                if (searchAbility.hasConnected()) {
                    searchResult.setText(ResourceTable.String_connect_service_succeed);
                } else {
                    searchResult.setText(ResourceTable.String_connect_service_failed);
                }
            } catch (InterruptedException e) {
                LogUtils.info(TAG, "connect search service failed");
            }
        });
    }

    private void initComponents() {
        Component btnBuildIndexForms = findComponentById(ResourceTable.Id_btnBuildIndexForms);
        btnBuildIndexForms.setClickedListener(this::buildIndexForms);
        Component btnReadIndexForms = findComponentById(ResourceTable.Id_btnReadIndexForms);
        btnReadIndexForms.setClickedListener(this::readIndexForms);
        Component btnInsertIndexData = findComponentById(ResourceTable.Id_btnInsertIndexData);
        btnInsertIndexData.setClickedListener(this::insertIndexData);
        Component btnUpdateIndexData = findComponentById(ResourceTable.Id_btnUpdateIndexData);
        btnUpdateIndexData.setClickedListener(this::updateIndexData);
        Component btnDeleteIndexData = findComponentById(ResourceTable.Id_btnDeleteIndexData);
        btnDeleteIndexData.setClickedListener(this::deleteIndexData);
        Component btnDeleteIndexDataByQuery = findComponentById(ResourceTable.Id_btnDeleteIndexDataByQuery);
        btnDeleteIndexDataByQuery.setClickedListener(this::deleteByQuery);
        Component btnGetSearchHitCount = findComponentById(ResourceTable.Id_btnGetHitCount);
        btnGetSearchHitCount.setClickedListener(this::getSearchHitCount);
        Component btnSearchByGroup = findComponentById(ResourceTable.Id_btnSearchByGroup);
        btnSearchByGroup.setClickedListener(this::searchByGroup);
        Component btnSearchByPage = findComponentById(ResourceTable.Id_btnSearchByPage);
        btnSearchByPage.setClickedListener(this::searchByPage);

        Component searchComponent = findComponentById(ResourceTable.Id_searchResult);
        if (searchComponent instanceof Text) {
            searchResult = (Text) searchComponent;
        }
    }

    private void searchByPage(Component component) {
        searchResult.setText(searUtils.searchByPage());
    }

    private void searchByGroup(Component component) {
        searchResult.setText(searUtils.searchByGroup());
    }

    private void getSearchHitCount(Component component) {
        searchResult.setText(searUtils.getSearchHitCount());
    }

    private void deleteByQuery(Component component) {
        int result = searUtils.deleteIndexByQuery();
        if (result == 1) {
            LogUtils.info(TAG, "updateIndexData succeed");
            searchResult.setText(ResourceTable.String_succeed);
        } else {
            LogUtils.error(TAG, "updateIndexData failed");
            searchResult.setText(ResourceTable.String_failed);
        }
    }

    private void deleteIndexData(Component component) {
        int result = searUtils.deleteIndexData();
        if (result > 0) {
            LogUtils.error(TAG, "updateIndexData failed num=" + result);
            searchResult.setText(ResourceTable.String_failed);
        } else {
            LogUtils.info(TAG, "updateIndexData succeed");
            searchResult.setText(ResourceTable.String_succeed);
        }
    }

    private void updateIndexData(Component component) {
        int result = searUtils.updateIndexData();
        if (result > 0) {
            LogUtils.error(TAG, "updateIndexData failed num=" + result);
            searchResult.setText(ResourceTable.String_failed);
        } else {
            LogUtils.info(TAG, "updateIndexData succeed");
            searchResult.setText(ResourceTable.String_succeed);
        }
    }

    private void insertIndexData(Component component) {
        int result = searUtils.insertIndexData();
        if (result > 0) {
            LogUtils.error(TAG, "insertIndexData failed num=" + result);
            searchResult.setText(ResourceTable.String_failed);
        } else {
            LogUtils.info(TAG, "insertIndexData succeed");
            searchResult.setText(ResourceTable.String_succeed);
        }
    }

    private void readIndexForms(Component component) {
        searchResult.setText(searUtils.readIndexForms());
    }

    private void buildIndexForms(Component component) {
        int result = searUtils.buildIndexForms();
        if (result == 1) {
            LogUtils.info(TAG, "buildIndexForms succeed");
            searchResult.setText(ResourceTable.String_succeed);
        } else {
            LogUtils.error(TAG, "buildIndexForms failed");
            searchResult.setText(ResourceTable.String_failed);
        }
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }
}
