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

package ohos.samples.distributedpictures.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.data.distributed.file.DistFile;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;
import ohos.media.image.SourceDataMalformedException;
import ohos.media.image.common.PixelFormat;
import ohos.media.image.common.Rect;
import ohos.media.image.common.Size;
import ohos.samples.distributedpictures.ResourceTable;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int CACHE_SIZE = 256 * 1024;

    private Image remoteImage;

    private String distributedFile;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        initDistributedFile();
    }

    private void initDistributedFile() {
        distributedFile = this.getDistributedDir().getPath() + "/icon.png";
        HiLog.info(LABEL_LOG, "%{public}s", "distributedFile :" + distributedFile);
    }

    private void initComponents() {
        remoteImage = (Image) findComponentById(ResourceTable.Id_remote_image);
        Component shareButton = findComponentById(ResourceTable.Id_save_to_distributed_dir);
        Component deleteButton = findComponentById(ResourceTable.Id_delete_distributed_dir);
        Component refreshButton = findComponentById(ResourceTable.Id_read_from_distributed_dir);
        shareButton.setClickedListener(component -> copyPicToDistributedDir());
        deleteButton.setClickedListener(component -> deleteDistributedDir());
        refreshButton.setClickedListener(component -> readToDistributedDir());
    }

    private void readToDistributedDir() {
        try {
            File file = new File(distributedFile);
            if (!file.exists()) {
                showTip(this, "No pictures exists in the distributedDir");
                remoteImage.setPixelMap(null);
                return;
            }
            ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
            ImageSource imageSource = ImageSource.create(distributedFile, srcOpts);
            ImageSource.DecodingOptions decodingOpts = new ImageSource.DecodingOptions();
            decodingOpts.desiredSize = new Size(0, 0);
            decodingOpts.desiredRegion = new Rect(0, 0, 0, 0);
            decodingOpts.desiredPixelFormat = PixelFormat.ARGB_8888;
            PixelMap pixelMap = imageSource.createPixelmap(decodingOpts);
            remoteImage.setPixelMap(pixelMap);
        } catch (SourceDataMalformedException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "readToDistributedDir SourceDataMalformedException ");
        }
    }

    private void deleteDistributedDir() {
        DistFile file = new DistFile(distributedFile);
        if (file.exists() && file.isFile()) {
            boolean result = file.delete();
            showTip(this, "delete :" + (result ? "success" : "fail"));
            remoteImage.setPixelMap(null);
        } else {
            showTip(this, "No pictures exists in the distributedDir");
        }
    }

    private void copyPicToDistributedDir() {
        writeToDistributedDir(distributedFile);
        File file = new File(distributedFile);
        if (file.exists()) {
            showTip(this, "shared success");
        }
    }

    private void showTip(Context context, String msg) {
        ToastDialog toastDialog = new ToastDialog(context);
        toastDialog.setAutoClosable(false);
        toastDialog.setContentText(msg);
        toastDialog.show();
    }

    private void writeToDistributedDir(String targetFilePath) {
        RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry("entry/resources/rawfile/icon.png");
        try (FileOutputStream output = new FileOutputStream(new File(targetFilePath))) {
            Resource resource = rawFileEntry.openRawFile();
            byte[] cache = new byte[CACHE_SIZE];
            int len = resource.read(cache);
            while (len != -1) {
                output.write(cache, 0, len);
                len = resource.read(cache);
            }
        } catch (IOException e) {
            HiLog.info(LABEL_LOG, "%{public}s", "writeToDisk IOException ");
        }
    }
}
