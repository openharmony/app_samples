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
import ohos.samples.aifunctionset.utils.WidgetHelper;

import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.TextField;
import ohos.ai.cv.common.ConnectionCallback;
import ohos.ai.cv.common.VisionConfiguration;
import ohos.ai.cv.common.VisionImage;
import ohos.ai.cv.common.VisionManager;
import ohos.ai.cv.text.ITextDetector;
import ohos.ai.cv.text.Text;
import ohos.ai.cv.text.TextConfiguration;
import ohos.media.image.PixelMap;

/**
 * Text Recognition Slice
 */
public class TextRecognitionSlice extends BaseSlice {
    private static final String IMAGE_PATH = "entry/resources/rawfile/text_recognition.png";

    private TextField outText;

    private ITextDetector textDetector;

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this).parse(ResourceTable.Layout_text_recognition_slice, null, false);
        rootLayout.addComponent(currComponent);
        initComponents();
        initEngine();
    }

    private void initComponents() {
        Image originalImage = (Image) findComponentById(ResourceTable.Id_image);
        outText = (TextField) findComponentById(ResourceTable.Id_out_text);
        Component startButton = findComponentById(ResourceTable.Id_start);
        startButton.setClickedListener(this::doSuperResolution);
        originalImage.setPixelMap(WidgetHelper.getPixelMapFromRaw(this, IMAGE_PATH));
    }

    private void initEngine() {
        int result = VisionManager.init(this, connectionCallback);
        LogUtil.info(getLocalClassName(), "VisionManager.init result code : " + result);
    }

    private void doSuperResolution(Component component) {
        textDetector = VisionManager.getTextDetector(this);
        TextConfiguration.Builder builder = new TextConfiguration.Builder();
        builder.setProcessMode(VisionConfiguration.MODE_IN);
        builder.setLanguage(TextConfiguration.ENGLISH);
        TextConfiguration config = builder.build();

        textDetector.setVisionConfiguration(config);
        PixelMap pixelMap = WidgetHelper.getPixelMapFromRaw(this, IMAGE_PATH);
        VisionImage image = VisionImage.fromPixelMap(pixelMap);
        Text text = new Text();
        int result = textDetector.detect(image, text, null);
        showTips("Text Detect : " + (result == 0 ? "Succeeded " : "Failed code = " + result));
        this.outText.setText("Result:" + System.lineSeparator() + text.getValue());
    }

    @Override
    public void setTitle() {
        aiTitle.setText("Text Recognition");
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
        if (textDetector != null) {
            textDetector.release();
        }
        VisionManager.destroy();
    }
}
