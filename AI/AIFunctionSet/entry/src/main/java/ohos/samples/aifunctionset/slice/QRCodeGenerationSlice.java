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

package ohos.samples.aifunctionset.slice;

import ohos.samples.aifunctionset.ResourceTable;
import ohos.samples.aifunctionset.utils.LogUtil;

import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.ai.cv.common.ConnectionCallback;
import ohos.ai.cv.common.VisionManager;
import ohos.ai.cv.qrcode.IBarcodeDetector;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;

/**
 * QR Code Generation Slice
 */
public class QRCodeGenerationSlice extends BaseSlice {
    private Image outImage;

    private IBarcodeDetector barcodeDetector;

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this)
            .parse(ResourceTable.Layout_qr_code_generation_slice, null, false);
        rootLayout.addComponent(currComponent);
        initEngine();
        initComponents();
    }

    private void initEngine() {
        VisionManager.init(this, connectionCallback);
    }

    private void initComponents() {
        outImage = (Image) findComponentById(ResourceTable.Id_out_image);
        Component startButton = findComponentById(ResourceTable.Id_start);
        startButton.setClickedListener(this::start);
    }

    private void start(Component component) {
        barcodeDetector = VisionManager.getBarcodeDetector(this);
        int length = 600;
        byte[] byteArray = new byte[length * length * 4];
        int result = barcodeDetector.detect("This is a TestCase of IBarcodeDetector", byteArray, length, length);
        showTips("Detect : " + (result == 0 ? "Succeeded " : "Failed code = " + result));
        if (result == 0) {
            ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
            srcOpts.formatHint = "image/png";
            ImageSource imageSource = ImageSource.create(byteArray, srcOpts);
            PixelMap pixelMap = imageSource.createPixelmap(null);
            outImage.setPixelMap(pixelMap);
        }
    }

    @Override
    public void setTitle() {
        aiTitle.setText("QRCode Generation");
    }

    private final ConnectionCallback connectionCallback = new ConnectionCallback() {
        @Override
        public void onServiceConnect() {
            LogUtil.info(getLocalClassName(), "Service connect succeeded");
        }

        @Override
        public void onServiceDisconnect() {
            LogUtil.info(getLocalClassName(), "Service disconnect succeeded");
        }
    };

    @Override
    protected void onStop() {
        super.onStop();
        if (barcodeDetector != null) {
            barcodeDetector.release();
        }
        VisionManager.destroy();
    }
}
