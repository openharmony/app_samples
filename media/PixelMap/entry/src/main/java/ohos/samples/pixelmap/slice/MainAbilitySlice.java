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

package ohos.samples.pixelmap.slice;

import ohos.samples.pixelmap.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.Text;
import ohos.agp.utils.Color;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.image.ImagePacker;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;
import ohos.media.image.common.PixelFormat;
import ohos.media.image.common.Position;
import ohos.media.image.common.PropertyKey;
import ohos.media.image.common.Rect;
import ohos.media.image.common.Size;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int CACHE_SIZE = 1024;

    private static final String RAW_IMAGE_PATH = "entry/resources/rawfile/test.png";

    private static final String RAW_IMAGE_PATH2 = "entry/resources/rawfile/test.jpg";

    private Image showFirstImage;

    private Image showSecondImage;

    private Text showResultText;

    private String pngCachePath;

    private String jpgCachePath;

    private String encodeOutPath;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
        initData();
    }

    private void initData() {
        pngCachePath = new File(getFilesDir(), "test.png").getPath();
        jpgCachePath = new File(getFilesDir(), "test.jpg").getPath();
        encodeOutPath = new File(getFilesDir(), "test_encode.jpg").getPath();
        writeToDisk(RAW_IMAGE_PATH, pngCachePath);
        writeToDisk(RAW_IMAGE_PATH2, jpgCachePath);
    }

    private void initComponents() {
        Component commonDecodeButton = findComponentById(ResourceTable.Id_common_decode_button);
        Component regionDecodeButton = findComponentById(ResourceTable.Id_region_decode_button);
        Component encodeButton = findComponentById(ResourceTable.Id_encode_button);
        Component editButton = findComponentById(ResourceTable.Id_edit_button);
        commonDecodeButton.setClickedListener(this::commonDecode);
        regionDecodeButton.setClickedListener(this::regionDecode);
        encodeButton.setClickedListener(this::encode);
        editButton.setClickedListener(this::edit);
        Component attributeButton = findComponentById(ResourceTable.Id_altitude_button);
        attributeButton.setClickedListener(this::attribute);
        showResultText = (Text) findComponentById(ResourceTable.Id_result_text);
        showFirstImage = (Image) findComponentById(ResourceTable.Id_test_image1);
        showSecondImage = (Image) findComponentById(ResourceTable.Id_test_image2);
    }

    private void commonDecode(Component component) {
        cleanComponents();
        ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
        srcOpts.formatHint = "image/png";
        String pathName = pngCachePath;
        ImageSource imageSource = ImageSource.create(pathName, srcOpts);

        PixelMap pixelMapNoOptions = imageSource.createPixelmap(null);
        showFirstImage.setPixelMap(pixelMapNoOptions);
        ImageSource.DecodingOptions decodingOpts = new ImageSource.DecodingOptions();
        decodingOpts.desiredSize = new Size(600, 300);
        decodingOpts.desiredRegion = new Rect(0, 0, 300, 150);
        PixelMap pixelMap = imageSource.createPixelmap(decodingOpts);
        showSecondImage.setPixelMap(pixelMap);
        imageSource.release();
        pixelMapNoOptions.release();
    }

    private void regionDecode(Component component) {
        cleanComponents();
        ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
        srcOpts.formatHint = "image/jpeg";
        ImageSource.IncrementalSourceOptions incOpts = new ImageSource.IncrementalSourceOptions();
        incOpts.opts = srcOpts;
        incOpts.mode = ImageSource.UpdateMode.INCREMENTAL_DATA;
        ImageSource imageSource = ImageSource.createIncrementalSource(incOpts);

        RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry(RAW_IMAGE_PATH);
        try (Resource resource = rawFileEntry.openRawFile()) {
            byte[] cache = new byte[CACHE_SIZE];
            int len = resource.read(cache);
            while (len != -1) {
                imageSource.updateData(cache, 0, len, false);
                if (len < CACHE_SIZE) {
                    imageSource.updateData(cache, 0, len, true);
                    ImageSource.DecodingOptions decodingOpts2 = new ImageSource.DecodingOptions();
                    PixelMap pixelmap = imageSource.createPixelmap(decodingOpts2);
                    showSecondImage.setPixelMap(pixelmap);
                    pixelmap.release();
                }
                len = resource.read(cache);
            }
        } catch (IOException e) {
            HiLog.info(LABEL_LOG, "%{public}s", "regionDecode IOException ");
        }
        imageSource.release();
    }

    private void encode(Component component) {
        cleanComponents();
        ImagePacker imagePacker = ImagePacker.create();
        ImagePacker.PackingOptions packingOptions = new ImagePacker.PackingOptions();
        packingOptions.quality = 90;
        try (FileOutputStream outputStream = new FileOutputStream(encodeOutPath)) {
            imagePacker.initializePacking(outputStream, packingOptions);
            ImageSource imageSource = ImageSource.create(pngCachePath, null);
            PixelMap pixelMap = imageSource.createPixelmap(null);
            boolean result = imagePacker.addImage(pixelMap);
            showResultText.setText(
                "Encode result : " + result + System.lineSeparator() + "OutputFilePath：" + encodeOutPath);
            imageSource.release();
            pixelMap.release();
        } catch (IOException e) {
            HiLog.info(LABEL_LOG, "%{public}s", "encode IOException ");
        }
        imagePacker.release();
    }

    private void attribute(Component component) {
        cleanComponents();
        ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
        srcOpts.formatHint = "image/jpeg";
        ImageSource imageSource = ImageSource.create(jpgCachePath, srcOpts);
        ImageSource.DecodingOptions decodingOpts = new ImageSource.DecodingOptions();
        PixelMap thumbnailPixelMap = imageSource.createThumbnailPixelmap(decodingOpts, false);
        String location = imageSource.getImagePropertyString(PropertyKey.Exif.SUBJECT_LOCATION);
        HiLog.info(LABEL_LOG, "%{public}s", "imageExif location : " + location);
        showResultText.setText("ImageSource attribute : createThumbnailPixelMap");
        showSecondImage.setPixelMap(thumbnailPixelMap);
        imageSource.release();
        thumbnailPixelMap.release();
    }

    private void edit(Component component) {
        cleanComponents();
        int colorsWidth = 600;
        int colorsHeight = 300;
        PixelMap.InitializationOptions initializationOptions = new PixelMap.InitializationOptions();
        initializationOptions.size = new Size(colorsWidth, colorsHeight);
        initializationOptions.pixelFormat = PixelFormat.ARGB_8888;
        initializationOptions.editable = true;
        int[] colors = new int[colorsWidth * colorsHeight];
        Arrays.fill(colors, Color.RED.getValue());
        PixelMap pixelMap = PixelMap.create(colors, initializationOptions);
        showFirstImage.setPixelMap(pixelMap);

        PixelMap pixelMap2 = PixelMap.create(pixelMap, initializationOptions);
        int color = pixelMap2.readPixel(new Position(1, 1));
        HiLog.info(LABEL_LOG, "%{public}s", "pixelMapEdit readPixel color ：" + color);
        pixelMap2.writePixel(new Position(100, 100), Color.BLACK.getValue());
        pixelMap2.writePixel(new Position(100, 101), Color.BLACK.getValue());
        pixelMap2.writePixel(new Position(101, 100), Color.BLACK.getValue());
        pixelMap2.writePixel(new Position(101, 101), Color.BLACK.getValue());

        int[] pixelArray = new int[500];
        Arrays.fill(pixelArray, Color.BLACK.getValue());
        Rect region = new Rect(0, 0, 20, 10);
        pixelMap2.writePixels(pixelArray, 0, 20, region);
        showSecondImage.setPixelMap(pixelMap2);

        long capacity = pixelMap.getPixelBytesCapacity();
        long bytesNumber = pixelMap.getPixelBytesNumber();
        int rowBytes = pixelMap.getBytesNumberPerRow();
        byte[] ninePatchData = pixelMap.getNinePatchChunk();

        showResultText.setText(
            "This pixelMap detail info :" + System.lineSeparator() + "capacity = " + capacity + System.lineSeparator()
                + "bytesNumber = " + bytesNumber + System.lineSeparator() + "rowBytes = " + rowBytes
                + System.lineSeparator() + "ninePatchData = " + Arrays.toString(ninePatchData) + System.lineSeparator());
        pixelMap.release();
        pixelMap2.release();
    }

    private void cleanComponents() {
        showResultText.setText("");
        showFirstImage.setPixelMap(null);
        showSecondImage.setPixelMap(null);
    }

    private void writeToDisk(String rawFilePathString, String targetFilePath) {
        File file = new File(targetFilePath);
        if (file.exists()) {
            return;
        }
        RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry(rawFilePathString);
        try (FileOutputStream output = new FileOutputStream(new File(targetFilePath))) {
            Resource resource = rawFileEntry.openRawFile();
            byte[] cache = new byte[CACHE_SIZE];
            int len = resource.read(cache);
            while (len != -1) {
                output.write(cache, 0, len);
                len = resource.read(cache);
            }
        } catch (IOException e) {
            HiLog.info(LABEL_LOG, "%{public}s", "writeEntryToFile IOException ");
        }
    }
}
