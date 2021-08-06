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
import ohos.ai.cv.common.ConnectionCallback;
import ohos.ai.cv.common.ImageResult;
import ohos.ai.cv.common.VisionConfiguration;
import ohos.ai.cv.common.VisionImage;
import ohos.ai.cv.common.VisionManager;
import ohos.ai.cv.docrefine.DocCoordinates;
import ohos.ai.cv.docrefine.DocRefineConfiguration;
import ohos.ai.cv.docrefine.IDocRefine;
import ohos.media.image.PixelMap;

/**
 * Document Correction Slice
 */
public class DocumentCorrectionSlice extends BaseSlice {
    private static final String IMAGE_PATH = "entry/resources/rawfile/doc_check.png";

    private Image outImage;

    private IDocRefine docRefine;

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this)
            .parse(ResourceTable.Layout_document_correction_slice, null, false);
        rootLayout.addComponent(currComponent);
        initComponents();
        initEngine();
    }

    private void initComponents() {
        Image originalImage = (Image) findComponentById(ResourceTable.Id_image);
        outImage = (Image) findComponentById(ResourceTable.Id_out_image);
        Component startButton = findComponentById(ResourceTable.Id_start);
        startButton.setClickedListener(this::doSuperResolution);
        originalImage.setPixelMap(WidgetHelper.getPixelMapFromRaw(this, IMAGE_PATH));
    }

    private void initEngine() {
        int result = VisionManager.init(this, connectionCallback);
        LogUtil.info(getLocalClassName(), "VisionManager.init result code : " + result);
    }

    private void doSuperResolution(Component component) {
        docRefine = VisionManager.getDocRefine(this);
        PixelMap pixelMap = WidgetHelper.getPixelMapFromRaw(this, IMAGE_PATH);

        VisionImage image = VisionImage.fromPixelMap(pixelMap);
        DocRefineConfiguration.Builder builder = new DocRefineConfiguration.Builder();
        builder.setProcessMode(VisionConfiguration.MODE_IN);
        DocRefineConfiguration configuration = builder.build();
        docRefine.setVisionConfiguration(configuration);
        ImageResult imageResult = new ImageResult();

        DocCoordinates docCoordinates = new DocCoordinates();
        docRefine.docDetect(image, docCoordinates, null);
        int result = docRefine.docRefine(image, docCoordinates, imageResult, null);
        showTips("DocDetect : " + (result == 0 ? "Succeeded " : "Failed code = " + result));
        outImage.setPixelMap(imageResult.getPixelMap());
    }

    @Override
    public void setTitle() {
        aiTitle.setText("Document Correction");
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
        if (docRefine != null) {
            docRefine.release();
        }
        VisionManager.destroy();
    }
}
