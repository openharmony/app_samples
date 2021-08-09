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

package ohos.samples.dataability;

import ohos.samples.dataability.utils.Const;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.content.Intent;
import ohos.data.DatabaseHelper;
import ohos.data.dataability.DataAbilityPredicates;
import ohos.data.dataability.DataAbilityUtils;
import ohos.data.rdb.RdbOpenCallback;
import ohos.data.rdb.RdbPredicates;
import ohos.data.rdb.RdbStore;
import ohos.data.rdb.StoreConfig;
import ohos.data.rdb.ValuesBucket;
import ohos.data.resultset.ResultSet;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.MessageParcel;
import ohos.utils.net.Uri;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * FileDataAbility
 */
public class UserDataAbility extends Ability {
    private static final String TAG = UserDataAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final StoreConfig config = StoreConfig.newDefaultConfig(Const.DB_NAME);

    private RdbStore rdbStore;

    private final RdbOpenCallback rdbOpenCallback = new RdbOpenCallback() {
        @Override
        public void onCreate(RdbStore store) {
            store.executeSql(
                "create table if not exists " + Const.DB_TAB_NAME + " (userId integer primary key autoincrement, "
                    + Const.DB_COLUMN_NAME + " text not null, " + Const.DB_COLUMN_AGE + " integer)");
            HiLog.info(LABEL_LOG, "%{public}s", "create a  new database");
        }

        @Override
        public void onUpgrade(RdbStore store, int oldVersion, int newVersion) {
            HiLog.info(LABEL_LOG, "%{public}s", "DataBase upgrade");
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        DatabaseHelper databaseHelper = new DatabaseHelper(this);
        rdbStore = databaseHelper.getRdbStore(config, 1, rdbOpenCallback, null);
    }

    @Override
    public int insert(Uri uri, ValuesBucket value) {
        String path = uri.getLastPath();
        if (!"person".equals(path)) {
            HiLog.info(LABEL_LOG, "%{public}s", "DataAbility insert path is not matched");
            return -1;
        }

        ValuesBucket values = new ValuesBucket();
        values.putString(Const.DB_COLUMN_NAME, value.getString(Const.DB_COLUMN_NAME));
        values.putInteger(Const.DB_COLUMN_AGE, value.getInteger(Const.DB_COLUMN_AGE));
        int index = (int) rdbStore.insert(Const.DB_TAB_NAME, values);
        DataAbilityHelper.creator(this).notifyChange(uri);
        return index;
    }

    @Override
    public int delete(Uri uri, DataAbilityPredicates predicates) {
        RdbPredicates rdbPredicates = DataAbilityUtils.createRdbPredicates(predicates, Const.DB_TAB_NAME);
        int index = rdbStore.delete(rdbPredicates);
        HiLog.info(LABEL_LOG, "%{public}s", "delete");
        DataAbilityHelper.creator(this).notifyChange(uri);
        return index;
    }

    @Override
    public int update(Uri uri, ValuesBucket value, DataAbilityPredicates predicates) {
        RdbPredicates rdbPredicates = DataAbilityUtils.createRdbPredicates(predicates, Const.DB_TAB_NAME);
        int index = rdbStore.update(value, rdbPredicates);
        HiLog.info(LABEL_LOG, "%{public}s", "update");
        DataAbilityHelper.creator(this).notifyChange(uri);
        return index;
    }

    @Override
    public ResultSet query(Uri uri, String[] columns, DataAbilityPredicates predicates) {
        RdbPredicates rdbPredicates = DataAbilityUtils.createRdbPredicates(predicates, Const.DB_TAB_NAME);
        return rdbStore.query(rdbPredicates, columns);
    }

    @Override
    public FileDescriptor openFile(Uri uri, String mode) {
        File file = new File(getFilesDir(), uri.getDecodedQuery());
        if (!"rw".equals(mode)) {
            boolean result = file.setReadOnly();
            HiLog.info(LABEL_LOG, "%{public}s", "setReadOnly result: " + result);
        }
        FileDescriptor fileDescriptor = null;
        try (FileInputStream fileInputStream = new FileInputStream(file)) {
            fileDescriptor = fileInputStream.getFD();
            return MessageParcel.dupFileDescriptor(fileDescriptor);
        } catch (IOException ioException) {
            HiLog.error(LABEL_LOG, "%{public}s", "openFile: ioException");
        }
        return fileDescriptor;
    }
}
