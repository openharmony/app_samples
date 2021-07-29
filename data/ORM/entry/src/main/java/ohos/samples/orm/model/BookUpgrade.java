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
import ohos.data.orm.annotation.Column;
import ohos.data.orm.annotation.Entity;
import ohos.data.orm.annotation.ForeignKey;
import ohos.data.orm.annotation.PrimaryKey;

import static ohos.data.orm.annotation.ForeignKey.CASCADE;

/**
 * BookUpgrade
 *
 * @since 2021-06-15
 */
@Entity(tableName = "Book", foreignKeys = {
        @ForeignKey(name = "BookUser", parentEntity = UserUpgrade.class, parentColumns = "userId", childColumns = "user_id",
                onDelete = CASCADE)})
public class BookUpgrade extends OrmObject {
    @PrimaryKey(autoGenerate = true)
    private Integer id;

    @Column(name = "Name", index = true)
    private String name;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "addColumn12")
    private int addColumn12;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setAddColumn12(int addColumn12) {
        this.addColumn12 = addColumn12;
    }

    public int getAddColumn12() {
        return this.addColumn12;
    }
}
