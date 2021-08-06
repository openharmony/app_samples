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

package ohos.samples.networkmanagement.slice;

import ohos.samples.networkmanagement.ResourceTable;
import ohos.samples.networkmanagement.utils.ThreadPoolUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.Text;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;
import ohos.net.HttpResponseCache;

import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

/**
 * HttpCacheSlice
 */
public class HttpCacheSlice extends AbilitySlice {
    private static final String TAG = HttpCacheSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private Text inputText;

    private Image image;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_http_cache_slice);

        initComponents();
        initCache();
    }

    private void initComponents() {
        inputText = (Text) findComponentById(ResourceTable.Id_input_text);
        Component startButton = findComponentById(ResourceTable.Id_start_button);
        image = (Image) findComponentById(ResourceTable.Id_image);
        startButton.setClickedListener(this::startRequest);
    }

    private void initCache() {
        File httpCacheDir = new File(this.getCacheDir(), "http");
        long httpCacheSize = 10 * 1024 * 1024;
        try {
            HttpResponseCache.install(httpCacheDir, httpCacheSize);
        } catch (IOException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "initCache IOException");
        }
    }

    private void startRequest(Component component) {
        ThreadPoolUtil.submit(() -> {
            try {
                URL url = new URL(inputText.getText());
                URLConnection urlConnection = url.openConnection();
                if (urlConnection instanceof HttpURLConnection) {
                    HttpURLConnection connection = (HttpURLConnection)urlConnection;
                    connection.connect();
                    if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                        ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
                        ImageSource imageSource = ImageSource.create(connection.getInputStream(), srcOpts);
                        PixelMap pixelMap = imageSource.createPixelmap(null);
                        getUITaskDispatcher().syncDispatch(() -> image.setPixelMap(pixelMap));
                    }
                    connection.disconnect();
                }
            } catch (IOException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "initCache IOException");
            }
        });
    }

    @Override
    protected void onStop() {
        super.onStop();

        HttpResponseCache cache = HttpResponseCache.getInstalled();
        if (cache != null) {
            try {
                cache.flush();
            } catch (IOException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "onStop IOException");
            }
        }
        image.setPixelMap(null);
    }
}
