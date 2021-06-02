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

package ohos.samples.wlan;

import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.samples.wlan.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.bundle.IBundleManager;
import ohos.security.SystemPermission;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());
        requestPermissions();
    }

    private void requestPermissions() {
        if (verifySelfPermission(SystemPermission.LOCATION) != IBundleManager.PERMISSION_GRANTED) {
            HiLog.info(LABEL_LOG, "begin request permission:" + SystemPermission.LOCATION);
            requestPermissionsFromUser(new String[]{SystemPermission.LOCATION}, 0);
        } else {
            HiLog.info(LABEL_LOG, "the permission is ok,do not request");
        }
    }

    @Override
    public void onRequestPermissionsFromUserResult(int requestCode, String[] permissions, int[] grantResults) {
        HiLog.info(LABEL_LOG, "request Permission is response and requestCode is: " + requestCode);
        if (permissions == null || permissions.length == 0 || grantResults == null || grantResults.length == 0) {
            return;
        }
        for (int i = 0; i < permissions.length; i++) {
            HiLog.info(LABEL_LOG, "response permission is: " + permissions[i] + ", and result is: " + grantResults[i]);
        }
        if (requestCode == 0) {
            if (grantResults[0] != IBundleManager.PERMISSION_GRANTED) {
                HiLog.info(LABEL_LOG, "the permission is not allow by user");
                terminateAbility();
            }
        }
    }
}
