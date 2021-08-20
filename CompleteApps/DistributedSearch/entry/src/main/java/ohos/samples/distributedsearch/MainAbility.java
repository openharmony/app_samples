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

package ohos.samples.distributedsearch;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.bundle.IBundleManager;
import ohos.samples.distributedsearch.slice.MainAbilitySlice;
import ohos.security.SystemPermission;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());

        requestPermissions();
    }

    private void requestPermissions() {
        String[] permissions = {
            SystemPermission.DISTRIBUTED_DATASYNC,
            SystemPermission.READ_USER_STORAGE,
            SystemPermission.WRITE_USER_STORAGE
        };
        List<String> permissionsToProcess = new ArrayList<>();
        for (String permission : permissions) {
            if (verifySelfPermission(permission) != IBundleManager.PERMISSION_GRANTED
                    && canRequestPermission(permission)) {
                permissionsToProcess.add(permission);
            }
        }
        requestPermissionsFromUser(permissionsToProcess.toArray(new String[0]), 0);
    }
}
