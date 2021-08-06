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

package ohos.samples.audio;

import ohos.samples.audio.slice.MainAbilitySlice;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.bundle.IBundleManager;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.security.SystemPermission;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * Mainability
 */
public class MainAbility extends Ability {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setMainRoute(MainAbilitySlice.class.getName());
        requestPermission();
    }

    private void requestPermission() {
        String[] permissions = {
            SystemPermission.WRITE_USER_STORAGE, SystemPermission.MICROPHONE
        };

        requestPermissionsFromUser(Arrays.stream(permissions)
                .filter(permission -> verifySelfPermission(permission) != IBundleManager.PERMISSION_GRANTED).toArray(String[]::new), 0);
    }

    @Override
    public void onRequestPermissionsFromUserResult(int requestCode, String[] permissions, int[] grantResults) {
        if (permissions == null || permissions.length == 0 || grantResults == null || grantResults.length == 0) {
            return;
        }
        if (requestCode == 0) {
            if (grantResults[0] == IBundleManager.PERMISSION_GRANTED) {
                writeToDisk();
            }else {
                terminateAbility();
            }
        }
    }

    private void writeToDisk() {
        String rawFilePath = "entry/resources/rawfile/sample.mp3";
        String externalFilePath = getFilesDir() + "/sample.mp3";
        File file = new File(externalFilePath);
        if (file.exists()) {
            return;
        }
        RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry(rawFilePath);
        try (FileOutputStream outputStream = new FileOutputStream(new File(externalFilePath))) {
            Resource resource = rawFileEntry.openRawFile();
            byte[] cache = new byte[1024];
            int len = resource.read(cache);
            while (len != -1) {
                outputStream.write(cache, 0, len);
                len = resource.read(cache);
            }
        } catch (IOException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "writeToDisk: IOException");
        }
    }
}
