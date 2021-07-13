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

package ohos.samples.orm.model;

import ohos.data.orm.OrmObject;
import ohos.data.orm.annotation.Entity;
import ohos.data.orm.annotation.Index;
import ohos.data.orm.annotation.PrimaryKey;

/**
 * UserUpgrade
 *
 * @since 2021-06-15
 */
@Entity(tableName = "user", ignoredColumns = "ignoreColumn",
        indices = {@Index(value = {"firstName", "lastName"}, name = "name_index")})
public class UserUpgrade extends OrmObject {
    @PrimaryKey(autoGenerate = true)
    private int userId;

    private String firstName;

    private String lastName;

    private int age;

    private double balance;

    private int ignoreColumn;

    private long useTimestamp;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int id) {
        this.userId = id;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String name) {
        this.firstName = name;
    }

    public String getLastName() {
        return this.lastName;
    }

    public void setLastName(String name) {
        this.lastName = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int mAge) {
        this.age = mAge;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public int getIgnoreColumn() {
        return ignoreColumn;
    }

    public void setIgnoreColumn(int ignoreColumn) {
        this.ignoreColumn = ignoreColumn;
    }

    public long getUseTimestamp() {
        return useTimestamp;
    }

    public void setUseTimestamp(long useTimestamp) {
        this.useTimestamp = useTimestamp;
    }
}
