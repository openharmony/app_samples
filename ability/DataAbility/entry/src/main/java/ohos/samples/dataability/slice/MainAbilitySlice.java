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

package ohos.samples.dataability.slice;

import ohos.app.dispatcher.task.TaskPriority;
import ohos.samples.dataability.ResourceTable;
import ohos.samples.dataability.utils.Const;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.ability.DataAbilityOperation;
import ohos.aafwk.ability.DataAbilityRemoteException;
import ohos.aafwk.ability.IDataAbilityObserver;
import ohos.aafwk.ability.OperationExecuteException;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.data.dataability.DataAbilityPredicates;
import ohos.data.rdb.ValuesBucket;
import ohos.data.resultset.ResultSet;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.utils.net.Uri;

import java.io.BufferedReader;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.security.SecureRandom;
import java.util.ArrayList;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private Text logText;

    private DataAbilityHelper databaseHelper;

    private final IDataAbilityObserver dataAbilityObserver = () -> {
        HiLog.info(LABEL_LOG, "%{public}s", "database change");
        query(true);
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        initDatabaseHelper();
    }

    private void initComponents() {
        Component insertButton = findComponentById(ResourceTable.Id_insert_button);
        insertButton.setClickedListener(this::insert);
        Component deleteButton = findComponentById(ResourceTable.Id_delete_button);
        deleteButton.setClickedListener(this::delete);
        Component updateButton = findComponentById(ResourceTable.Id_update_button);
        updateButton.setClickedListener(this::update);
        Component queryButton = findComponentById(ResourceTable.Id_query_button);
        queryButton.setClickedListener(component -> query(false));
        Component batchInsertButton = findComponentById(ResourceTable.Id_batch_insert_button);
        batchInsertButton.setClickedListener(this::batchInsert);
        Component batchExecuteButton = findComponentById(ResourceTable.Id_batch_execute_button);
        batchExecuteButton.setClickedListener(this::batchExecute);
        Component readFileButton = findComponentById(ResourceTable.Id_read_file_button);
        readFileButton.setClickedListener(this::readTextFile);
        logText = (Text) findComponentById(ResourceTable.Id_log_text);
    }

    private void initDatabaseHelper() {
        databaseHelper = DataAbilityHelper.creator(this);
        databaseHelper.registerObserver(Uri.parse(Const.BASE_URI), dataAbilityObserver);
    }

    private void batchExecute(Component component) {
        DataAbilityPredicates predicates = new DataAbilityPredicates();
        // test data
        predicates.between(Const.DB_COLUMN_USER_ID, 1, 3);
        DataAbilityOperation deleteOperation = DataAbilityOperation.newDeleteBuilder(
            Uri.parse(Const.BASE_URI + Const.DATA_PATH)).withPredicates(predicates).build();

        ValuesBucket valuesBucket = new ValuesBucket();
        valuesBucket.putString(Const.DB_COLUMN_NAME, getRandomName());
        valuesBucket.putInteger(Const.DB_COLUMN_AGE, getRandomAge());
        DataAbilityOperation insertOperation = DataAbilityOperation.newInsertBuilder(
            Uri.parse(Const.BASE_URI + Const.DATA_PATH)).withValuesBucket(valuesBucket).build();

        ArrayList<DataAbilityOperation> operations = new ArrayList<>();
        operations.add(deleteOperation);
        operations.add(insertOperation);
        try {
            databaseHelper.executeBatch(Uri.parse(Const.BASE_URI + Const.DATA_PATH), operations);
            query(true);
        } catch (DataAbilityRemoteException | OperationExecuteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "batchExecute: dataAbilityRemoteException|operationExecuteException");
        }
    }

    private void delete(Component component) {
        DataAbilityPredicates predicates = new DataAbilityPredicates();
        // test data
        predicates.between(Const.DB_COLUMN_USER_ID, 1, 2);
        try {
            databaseHelper.delete(Uri.parse(Const.BASE_URI + Const.DATA_PATH), predicates);
        } catch (DataAbilityRemoteException | IllegalStateException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "delete: dataRemote exception|illegalStateException");
        }
    }

    private void insert(Component component) {
        String name = getRandomName();
        int age = getRandomAge();

        ValuesBucket valuesBucket = new ValuesBucket();
        valuesBucket.putString(Const.DB_COLUMN_NAME, name);
        valuesBucket.putInteger(Const.DB_COLUMN_AGE, age);
        try {
            databaseHelper.insert(Uri.parse(Const.BASE_URI + Const.DATA_PATH), valuesBucket);
        } catch (DataAbilityRemoteException | IllegalStateException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "insert: dataRemote exception|illegalStateException");
        }
    }

    private void query(boolean queryAll) {
        getGlobalTaskDispatcher(TaskPriority.DEFAULT).asyncDispatch(() -> {
            String[] columns = new String[]{Const.DB_COLUMN_NAME, Const.DB_COLUMN_AGE, Const.DB_COLUMN_USER_ID};
            DataAbilityPredicates predicates = new DataAbilityPredicates();
            if (!queryAll) {
                // test data
                predicates.between(Const.DB_COLUMN_USER_ID, 2, 4);
            }
            try {
                ResultSet resultSet = databaseHelper.query(Uri.parse(Const.BASE_URI + Const.DATA_PATH), columns,
                        predicates);
                appendText(resultSet);
            } catch (DataAbilityRemoteException | IllegalStateException exception) {
                HiLog.error(LABEL_LOG, "%{public}s", "query: dataRemote exception|illegalStateException");
            }
        });
    }

    private void appendText(ResultSet resultSet) {
        if (!resultSet.goToFirstRow()) {
            HiLog.info(LABEL_LOG, "%{public}s", "query:No result found");
            return;
        }
        int queryCount = 0;
        int allowQueryMaxCount = 100;
        StringBuilder appendStr = new StringBuilder();
        int nameIndex = resultSet.getColumnIndexForName(Const.DB_COLUMN_NAME);
        int ageIndex = resultSet.getColumnIndexForName(Const.DB_COLUMN_AGE);
        int userIndex = resultSet.getColumnIndexForName(Const.DB_COLUMN_USER_ID);
        do {
            queryCount++;
            String name = resultSet.getString(nameIndex);
            int age = resultSet.getInt(ageIndex);
            int userId = resultSet.getInt(userIndex);
            appendStr.append(userId).append("   ").append(name).append("   ").append(age).append(System.lineSeparator());
        } while (resultSet.goToNextRow() && queryCount < allowQueryMaxCount);
        resultSet.close();
        HiLog.info(LABEL_LOG, " queryCount : " + queryCount);
        HiLog.info(LABEL_LOG, " appendStr : " + appendStr.toString());
        getUITaskDispatcher().asyncDispatch(() -> {
            logText.setText("");
            logText.setText(appendStr.toString());
        });
    }

    private void update(Component component) {
        DataAbilityPredicates predicates = new DataAbilityPredicates();
        predicates.equalTo(Const.DB_COLUMN_USER_ID, 1);

        ValuesBucket valuesBucket = new ValuesBucket();
        valuesBucket.putString(Const.DB_COLUMN_NAME, "Tom_update");
        valuesBucket.putInteger(Const.DB_COLUMN_AGE, 0);
        try {
            databaseHelper.update(Uri.parse(Const.BASE_URI + Const.DATA_PATH), valuesBucket, predicates);
        } catch (DataAbilityRemoteException | IllegalStateException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "update: dataRemote exception|illegalStateException");
        }
    }

    private void batchInsert(Component component) {
        ValuesBucket[] values = new ValuesBucket[2];
        values[0] = new ValuesBucket();
        values[0].putString(Const.DB_COLUMN_NAME, getRandomName());
        values[0].putInteger(Const.DB_COLUMN_AGE, getRandomAge());
        values[1] = new ValuesBucket();
        values[1].putString(Const.DB_COLUMN_NAME, getRandomName());
        values[1].putInteger(Const.DB_COLUMN_AGE, getRandomAge());
        try {
            databaseHelper.batchInsert(Uri.parse(Const.BASE_URI + Const.DATA_PATH), values);
        } catch (DataAbilityRemoteException | IllegalStateException | NullPointerException exception) {
            HiLog.error(LABEL_LOG, "%{public}s",
                "query: dataRemote exception|illegalStateException|nullPointerException");
        }
    }

    private void readTextFile(Component component) {
        try {
            FileDescriptor fileDescriptor = databaseHelper.openFile(
                Uri.parse("dataability:///ohos.samples.userdata/document?userdataability.txt"), "r");
            if (fileDescriptor == null) {
                new ToastDialog(this).setText("No such file").show();
                return;
            }
            showText(fileDescriptor);
        } catch (DataAbilityRemoteException | FileNotFoundException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "readTextFile: dataAbilityRemoteException|fileNotFoundException");
        }
    }

    private void showText(FileDescriptor fileDescriptor) {
        try (FileInputStream fileInputStream = new FileInputStream(fileDescriptor);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream))) {
            String line;
            StringBuilder stringBuilder = new StringBuilder();
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
            logText.setText(stringBuilder.toString());
        } catch (IOException ioException) {
            HiLog.error(LABEL_LOG, "%{public}s", "showText: ioException");
        }
    }

    // test data
    private int getRandomAge() {
        return new SecureRandom().nextInt(20);
    }

    // test data
    private String getRandomName() {
        String[] names = {"Tom", "Jerry", "Bob", "Coco", "Sum", "Marry"};
        int index = new SecureRandom().nextInt(names.length);
        return names[index];
    }
}
