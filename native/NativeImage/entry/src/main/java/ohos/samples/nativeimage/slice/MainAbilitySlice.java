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

package ohos.samples.nativeimage.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.*;
import ohos.media.image.PixelMap;
import ohos.samples.nativeimage.ResourceTable;
import ohos.samples.nativeimage.utils.HiLogUtils;

/**
 * MainAbilitySlice
 *
 * @since 2021-08-16
 */
public class MainAbilitySlice extends AbilitySlice {
    // Load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("nativeimage");
    }

    private static final String TAG = MainAbilitySlice.class.getSimpleName();
    private static final int OHOS_IMAGE_RESULT_SUCCESS = 0;
    private static final int OHOS_IMAGE_RESULT_BAD_PARAMETER = -1;
    private static final int OHOS_IMAGE_RESULT_JNI_EXCEPTION = -2;

    private Text resultText;
    private PixelMap pixelMap;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        initComponents();
    }

    private void initComponents() {
        Image image = (Image) findComponentById(ResourceTable.Id_image);
        Button btnAccessPixels = (Button) findComponentById(ResourceTable.Id_access_pixels);
        Button btnGetImageInfo = (Button) findComponentById(ResourceTable.Id_get_image_info);
        Button btnUnAccessPixels = (Button) findComponentById(ResourceTable.Id_unaccess_pixels);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);

        pixelMap = image.getPixelMap();
        btnAccessPixels.setClickedListener(this::accessPixels);
        btnGetImageInfo.setClickedListener(this::getImageInfo);
        btnUnAccessPixels.setClickedListener(this::unAccessPixels);
    }

    private void getImageInfo(Component component) {
        String result = GetImageInfoFromJNI(pixelMap);
        resultText.setText(getString(ResourceTable.String_get_image_info) + ": " + result);
        HiLogUtils.info(TAG, getString(ResourceTable.String_get_image_info) + ": " + result);
    }

    private void unAccessPixels(Component component) {
        int result = UnAccessPixelsFromJNI(pixelMap);
        formatResult(getString(ResourceTable.String_unaccess_pixels), result);
        pixelMap.release();
    }

    private void accessPixels(Component component) {
        int result = AccessPixelsFromJNI(pixelMap, pixelMap.getPixelBytesNumber());
        formatResult(getString(ResourceTable.String_access_pixels), result);
    }

    private void formatResult(String str, int result) {
        StringBuilder string = new StringBuilder(str);
        switch (result) {
            case OHOS_IMAGE_RESULT_SUCCESS:
                string.append(getString(ResourceTable.String_result_succeed));
                HiLogUtils.info(TAG, string.toString());
                break;
            case OHOS_IMAGE_RESULT_BAD_PARAMETER:
                string.append(getString(ResourceTable.String_result_bad_parameter));
                HiLogUtils.error(TAG, string.toString());
                break;
            case OHOS_IMAGE_RESULT_JNI_EXCEPTION:
                string.append(getString(ResourceTable.String_result_jni_exception));
                HiLogUtils.error(TAG, string.toString());
                break;
        }
        resultText.setText(string.toString());
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    public void onStop() {
        super.onStop();
        if(!pixelMap.isReleased()){
            pixelMap.release();
        }
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public native String GetImageInfoFromJNI(PixelMap pixelMapObject);

    public native int AccessPixelsFromJNI(PixelMap pixelMapObject, long pixelBytesNumber);

    public native int UnAccessPixelsFromJNI(PixelMap pixelMapObject);
}
