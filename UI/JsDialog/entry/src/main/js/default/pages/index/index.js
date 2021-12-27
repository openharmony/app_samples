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

export default {
    data: {
        listItem: [],
        showTips: true,
        name: '',
        phone: '17700000000',
        num: 0,
        deleteItem: null
    },
    onclick: function () {
        this.name = this.$t('strings.contact') + this.num
        this.$element('showDialog').show();
    },
    showDeleteDialog: function (object) {
        console.info('delete:' + JSON.stringify(object))
        this.deleteItem = object
        this.$element('deleteDialog').show();
    },
    cancelDeleteDialog: function () {
        this.deleteItem = null
        this.$element('deleteDialog').close();
    },
    cancelDialog: function () {
        this.$element('showDialog').close();
    },
    onConfirm: function () {
        this.num += 1
        this.listItem.push({
            'name': this.name, 'phone': this.phone
        })
        this.showTips = false
        this.$element('showDialog').close();
    },
    onDeleteSure: function () {
        var index = this.listItem.indexOf(this.deleteItem)
        console.info('index=' + index)
        this.listItem.splice(index, 1)
        if (this.listItem.length === 0) {
            this.num = 0
            this.showTips = true
        }
        this.$element('deleteDialog').close();
    }
}



