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

package ohos.samples.jsfacard;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.FormBindingData;
import ohos.aafwk.ability.FormException;
import ohos.aafwk.content.Intent;
import ohos.data.DatabaseHelper;
import ohos.data.orm.OrmContext;
import ohos.data.orm.OrmPredicates;
import ohos.event.notification.NotificationRequest;
import ohos.samples.jsfacard.database.Form;
import ohos.samples.jsfacard.database.FormDatabase;
import ohos.samples.jsfacard.utils.DatabaseUtils;
import ohos.samples.jsfacard.utils.DateUtils;
import ohos.samples.jsfacard.utils.LogUtils;
import ohos.utils.zson.ZSONObject;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * TimerAbility
 *
 * @since 2021-08-20
 */
public class TimerAbility extends Ability {
    private static final String TAG = TimerAbility.class.getName();

    private static final long UPDATE_PERIOD = 1000L;

    private static final int NOTICE_ID = 1005;

    private OrmContext connect;

    private final DatabaseHelper helper = new DatabaseHelper(this);

    @Override
    public void onStart(Intent intent) {
        LogUtils.info(TAG, "TimerAbility::onStart");
        connect = helper.getOrmContext("FormDatabase", "FormDatabase.db", FormDatabase.class);
        startTimer();
        super.onStart(intent);
    }

    private void startTimer() {
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                updateForms();
                notice();
            }
        }, 0, UPDATE_PERIOD);
    }

    private void updateForms() {
        OrmPredicates ormPredicates = new OrmPredicates(Form.class);
        List<Form> formList = connect.query(ormPredicates);
        if (formList.size() <= 0) {
            return;
        }
        for (Form form : formList) {
            Long updateFormId = form.getFormId();
            ZSONObject zsonObject = DateUtils.getZsonObject();
            LogUtils.info(TAG, "updateForm FormException " + zsonObject);
            try {
                updateForm(updateFormId, new FormBindingData(zsonObject));
            } catch (FormException e) {
                DatabaseUtils.deleteFormData(form.getFormId(), connect);
                LogUtils.info(TAG, "updateForm FormException " + e.getMessage());
            }
        }
    }

    private void notice() {
        NotificationRequest request = new NotificationRequest(NOTICE_ID);
        request.setAlertOneTime(true);
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setText(DateUtils.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(content);
        request.setContent(notificationContent);
        keepBackgroundRunning(NOTICE_ID, request);
    }

    @Override
    public void onBackground() {
        LogUtils.info(TAG, "TimerAbility::onBackground");
        super.onBackground();
    }

    @Override
    public void onStop() {
        LogUtils.info(TAG, "TimerAbility::onStop");
        super.onStop();
    }
}