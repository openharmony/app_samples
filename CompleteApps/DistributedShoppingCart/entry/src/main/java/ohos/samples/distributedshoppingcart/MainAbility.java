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

package ohos.samples.distributedshoppingcart;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.window.service.WindowManager;
import ohos.bundle.IBundleManager;
import ohos.samples.distributedshoppingcart.slice.MainAbilitySlice;
import ohos.samples.distributedshoppingcart.slice.MegerShoppingCartSlice;
import ohos.samples.distributedshoppingcart.slice.ShareShoppingCartSlice;

/**
 * MainAbility
 */
public class MainAbility extends Ability {
    private static final String PERMISSION_DATA_SYNC = "ohos.permission.DISTRIBUTED_DATASYNC";
    private static final int MY_PERMISSION_REQUEST_CODE = 1;

    @Override
    public void onStart(Intent intent) {
        this.getWindow().addFlags(WindowManager.LayoutConfig.MARK_ALLOW_LAYOUT_OVERSCAN);
        this.getWindow().addFlags(WindowManager.LayoutConfig.MARK_FULL_SCREEN);

        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());

        addActionRoute("action.share", ShareShoppingCartSlice.class.getName());
        addActionRoute("action.meger", MegerShoppingCartSlice.class.getName());

        if (verifySelfPermission(PERMISSION_DATA_SYNC) != IBundleManager.PERMISSION_GRANTED) {
            if (canRequestPermission(PERMISSION_DATA_SYNC)) {
                requestPermissionsFromUser(new String[]{PERMISSION_DATA_SYNC}, MY_PERMISSION_REQUEST_CODE);
            }
        }
    }
}
