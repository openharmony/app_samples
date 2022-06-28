/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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

import prompt from '@ohos.prompt';
import hiAppEvent from '@ohos.hiAppEvent';

export default {
  data: {
    Text: ''
  },

  appEvent: function () {
    hiAppEvent.write("test_event", hiAppEvent.EventType.STATISTIC, {
      "int_data": 100, "str_data": "strValue"
    }, (err, value) => {
      if (err) {
        console.error(`failed to write event because ${err.code}`);
        this.Text = this.$t('strings.write_failed') + JSON.stringify(err)
        return;
      }

      prompt.showToast({
        message: "success to write event"
      });
      this.Text = this.$t('strings.write_success');
      console.log(`success to write event: ${value}`);
    });
  },

  switchChange(e) {
    if (e.checked) {
      hiAppEvent.configure({
        disable: e.checked
      });
      this.Text = this.$t('strings.appDisabled');
    } else {
      hiAppEvent.configure({
        disable: e.checked
      });
      this.Text = this.$t('strings.appAble')
    }
  }
}