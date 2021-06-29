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

package ohos.samples.permissionapp;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.bundle.IBundleManager;
import ohos.samples.permissionapp.slice.MainAbilitySlice;
import ohos.samples.permissionapp.utils.LogUtil;

import java.util.Arrays;

/**
 * Main Ability
 */
public class MainAbility extends Ability {
    private static final String TAG = MainAbility.class.getSimpleName();

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());
    }

    @Override
    public void onRequestPermissionsFromUserResult(int requestCode, java.lang.String[] permissions,
        int[] grantResults) {
        if (permissions == null || permissions.length == 0 || grantResults == null || grantResults.length == 0) {
            return;
        }
        LogUtil.debug(TAG,
            "requestCode: " + requestCode + ", permissions:" + Arrays.toString(permissions) + ", grantResults: "
                + Arrays.toString(grantResults));

        if (grantResults[0] == IBundleManager.PERMISSION_GRANTED) {
            showTips(this, "Permission granted");
        } else {
            showTips(this, "Permission denied");
        }
    }

    private void showTips(Context context, String message) {
        new ToastDialog(context).setText(message).show();
    }
}
