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

package ohos.samples.orm.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.data.DatabaseHelper;
import ohos.data.orm.OrmContext;
import ohos.data.orm.OrmMigration;
import ohos.data.orm.OrmObjectObserver;
import ohos.data.orm.OrmPredicates;
import ohos.data.preferences.Preferences;
import ohos.data.rdb.RdbException;
import ohos.data.rdb.RdbStore;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.samples.orm.ResourceTable;
import ohos.samples.orm.model.BookStore;
import ohos.samples.orm.model.BookStoreUpgrade;
import ohos.samples.orm.model.User;
import ohos.samples.orm.model.UserUpgrade;
import ohos.samples.orm.model.BookUpgrade;

import java.io.File;
import java.security.SecureRandom;
import java.util.List;

/**
 * OrmContextSlice
 *
 * @since 2021-06-15
 */
public class OrmContextSlice extends AbilitySlice {
    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, "OrmContextSlice");

    private Text logText;

    private DatabaseHelper helper;

    private Preferences preferences;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);

        initComponents();
        initRegisters();
    }

    private void initComponents() {
        Component componentText = findComponentById(ResourceTable.Id_log_text);
        if (componentText instanceof Text) {
            logText = (Text) componentText;
        }
        Component upgradeButton = findComponentById(ResourceTable.Id_upgrade_button);
        upgradeButton.setClickedListener(this::upgrade);
        findComponentById(ResourceTable.Id_insert_button).setClickedListener(this::insert);
        findComponentById(ResourceTable.Id_update_button).setClickedListener(this::update);
        findComponentById(ResourceTable.Id_delete_button).setClickedListener(this::delete);
        findComponentById(ResourceTable.Id_query_button).setClickedListener(this::query);
        findComponentById(ResourceTable.Id_backupDB_button).setClickedListener(this::backup);
        findComponentById(ResourceTable.Id_deleteDB_button).setClickedListener(this::deleteRdbStore);
        findComponentById(ResourceTable.Id_restoreDB_button).setClickedListener(this::restore);
        helper = new DatabaseHelper(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        unRegisters();
    }

    private void initRegisters() {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        ormContext.registerEntityObserver("user", entityOrmObjectObserver);
        ormContext.registerStoreObserver("OrmTestDB", storeOrmObjectObserver);
        ormContext.close();
    }

    private void unRegisters() {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        ormContext.unregisterEntityObserver("user", entityOrmObjectObserver);
        ormContext.unregisterStoreObserver("OrmTestDB", storeOrmObjectObserver);
        ormContext.unregisterContextObserver(ormContext, contextOrmObjectObserver);
        ormContext.close();
    }

    private void insert(Component component) {
        User user = new User();
        user.setFirstName(getRandomFirstName());
        user.setLastName("San");
        user.setAge(29);
        user.setBalance(100.51);
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        if (ormContext.insert(user)) {
            logText.setText("insert success");
        } else {
            logText.setText("insert fail");
        }
        ormContext.registerContextObserver(ormContext, contextOrmObjectObserver);
        ormContext.flush();
        ormContext.close();
    }

    private void delete(Component component) {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        OrmPredicates predicates = ormContext.where(User.class);
        predicates.equalTo("age", 29);
        List<User> users = ormContext.query(predicates);
        if (users.size() == 0) {
            logText.setText("no data not delete");
            return;
        }
        User user = users.get(0);
        if (ormContext.delete(user)) {
            logText.setText("delete success");
        } else {
            logText.setText("delete fail");
        }
        ormContext.flush();
        ormContext.close();
    }

    private void update(Component component) {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        OrmPredicates predicates = ormContext.where(User.class);
        predicates.equalTo("age", 29);
        List<User> users = ormContext.query(predicates);
        if (users.size() == 0) {
            new ToastDialog(this).setText("no data not update").show();
            return;
        }
        User user = users.get(0);
        ormContext.registerObjectObserver(user, objectOrmObjectObserver);
        user.setFirstName("Li");
        if (ormContext.update(user)) {
            logText.setText("update success");
        } else {
            logText.setText("update fail");
        }
        ormContext.flush();
        ormContext.close();
        ormContext.unregisterObjectObserver(user, objectOrmObjectObserver);
    }

    private void query(Component component) {
        logText.setText("");
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        OrmPredicates query = ormContext.where(User.class).equalTo("lastName", "San");
        List<User> users = ormContext.query(query);
        ormContext.flush();
        ormContext.close();
        if (users.size() == 0) {
            logText.append("lastName为San：无");
            return;
        }
        for (User user : users) {
            logText.append("lastName为San：" + user.getFirstName() + user.getLastName() + " ");
        }
    }

    private void restore(Component component) {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        File file = new File(getDatabaseDir() + "/backup/OrmTestDBBackup.db");
        if (!file.exists()) {
            logText.setText("restore the database first");
            return;
        }
        if (ormContext.restore("OrmTestDBBackup.db")) {
            logText.setText("restoreDB success");
        } else {
            logText.setText("restoreDB fail");
        }
        ormContext.flush();
        ormContext.close();
    }

    private void deleteRdbStore(Component component) {
        if (helper.deleteRdbStore("OrmTestDB.db")) {
            logText.setText("deleteDB success");
        } else {
            logText.setText("deleteDB fail");
        }
    }

    private void backup(Component component) {
        OrmContext ormContext = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStore.class);
        if (ormContext.backup("OrmTestDBBackup.db")) {
            HiLog.info(LABEL_LOG, "Path: " + getDatabaseDir());
            logText.setText("backup success");
        } else {
            logText.setText("backup fail");
        }
        ormContext.flush();
        ormContext.close();
    }

    private Preferences getPreferences() {
        if (preferences == null) {
            DatabaseHelper databaseHelper = new DatabaseHelper(getApplicationContext());
            preferences = databaseHelper.getPreferences("app_preference.xml");
        }
        return preferences;
    }

    private void upgrade(Component component) {
        logText.setText("");
        String isUpgrade = getPreferences().getString("upgrade", "fail");
        if (isUpgrade.equals("success")) {
            logText.setText("upgraded");
        } else {
            testOrmMigration();
        }
    }

    /**
     * test Orm upgrade
     */
    public void testOrmMigration() {
        OrmContext context = helper.getOrmContext("OrmTestDB", "OrmTestDB.db", BookStoreUpgrade.class,
                new TestOrmMigration32(),
                new TestOrmMigration23(),
                new TestOrmMigration12(),
                new TestOrmMigration21());

        UserUpgrade userUpgrade = new UserUpgrade();
        userUpgrade.setAge(41);
        userUpgrade.setBalance(3.44);
        boolean isSuccess = context.insert(userUpgrade);
        HiLog.info(LABEL_LOG, "UserUpgrade insert " + isSuccess);
        BookUpgrade bookUpgrade = new BookUpgrade();
        bookUpgrade.setId(101);
        bookUpgrade.setAddColumn12(8);
        bookUpgrade.setName("OrmTestDBBook");
        isSuccess = context.insert(bookUpgrade);
        HiLog.info(LABEL_LOG, "BookUpgrade insert " + isSuccess);
        context.flush();
        OrmPredicates predicates = context.where(BookUpgrade.class).equalTo("name", "OrmTestDBBook");
        List<BookUpgrade> bookUpgradeList = context.query(predicates);
        int id = bookUpgradeList.get(0).getId();
        HiLog.info(LABEL_LOG, "bookUpgradeList.get(0).getId() =" + id);
        context.close();
        logText.setText("upgrade success");
        getPreferences().putString("upgrade", "success");
    }

    private static class TestOrmMigration12 extends OrmMigration {
        public TestOrmMigration12() {
            super(1, 2);
        }

        @Override
        public void onMigrate(RdbStore store) {
            try {
                HiLog.info(LABEL_LOG, "DataBase Version 1->2 onMigrate called");
                store.executeSql("ALTER TABLE `Book` ADD COLUMN `addColumn12` INTEGER");
            }
            catch (RdbException e) {
                HiLog.error(LABEL_LOG, "TestOrmMigration12.onMigrate exception, %{public}s", e.getMessage());
            }
        }
    }

    private static class TestOrmMigration21 extends OrmMigration {
        public TestOrmMigration21() {
            super(2, 1);
        }

        @Override
        public void onMigrate(RdbStore store) {
            HiLog.info(LABEL_LOG, "DataBase Version 2->1 onMigrate called");
            store.executeSql("DROP TABLE IF EXISTS `Book`");
            store.executeSql("CREATE TABLE IF NOT EXISTS `Book` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT , "
                    + "`user_id` INTEGER  NOT NULL, `useTimestamp` INTEGER, FOREIGN KEY (`user_id`) "
                    + "REFERENCES `user` (`userId`) ON UPDATE NO ACTION ON DELETE CASCADE)");
            store.executeSql("CREATE INDEX `index_Book_name` ON `Book` (`name`)");
        }
    }

    private static class TestOrmMigration23 extends OrmMigration {
        public TestOrmMigration23() {
            super(2, 3);
        }

        @Override
        public void onMigrate(RdbStore store) {
            HiLog.info(LABEL_LOG, "DataBase Version 2->3 onMigrate called");
        }
    }

    private static class TestOrmMigration32 extends OrmMigration {
        public TestOrmMigration32() {
            super(3, 2);
        }

        @Override
        public void onMigrate(RdbStore store) {
            HiLog.info(LABEL_LOG, "DataBase Version 3->2 onMigrate called");
            store.executeSql("ALTER TABLE `BookUpgrade` RENAME TO `Book`");
        }
    }

    private final OrmObjectObserver entityOrmObjectObserver = (changeContext, subAllChange) ->
            HiLog.info(LABEL_LOG, "onChange Entity " +
                    " ,insert row=" + subAllChange.getInsertedList().size() +
                    " ,delete row=" + subAllChange.getDeletedList().size() +
                    " ,update row=" + subAllChange.getUpdatedList().size());

    private final OrmObjectObserver storeOrmObjectObserver = (changeContext, subAllChange) ->
            HiLog.info(LABEL_LOG, "onChange Store");

    private final OrmObjectObserver contextOrmObjectObserver = (changeContext, subAllChange) ->
            HiLog.info(LABEL_LOG, "onChange Context");

    private final OrmObjectObserver objectOrmObjectObserver = (changeContext, subAllChange) ->
            HiLog.info(LABEL_LOG, "onChange Object");

    private String getRandomFirstName() {
        String[] names = {"Zhang", "Ma", "Li", "Zhao", "Sun", "Guo"};
        int index = new SecureRandom().nextInt(names.length);
        return names[index];
    }
}
