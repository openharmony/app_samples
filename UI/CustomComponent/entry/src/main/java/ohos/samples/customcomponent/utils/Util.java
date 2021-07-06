/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.customcomponent.utils;

import ohos.app.Context;
import ohos.global.resource.NotExistException;
import ohos.global.resource.Resource;
import ohos.global.resource.ResourceManager;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;
import ohos.media.image.common.PixelFormat;
import ohos.media.image.common.Rect;
import ohos.media.image.common.Size;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Optional;

/**
 * Util Tools
 *
 * @since 2021-05-08
 */
public class Util {
    private static final HiLogLabel TAG = new HiLogLabel(3, 0xD001100, "Utils");

    private Util() {
    }

    private static byte[] readResource(Resource resource) {
        final int bufferSize = 1024;
        final int ioEnd = -1;
        byte[] byteArray;
        byte[] buffer = new byte[bufferSize];
        try (ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            while (true) {
                int readLen = resource.read(buffer, 0, bufferSize);
                if (readLen == ioEnd) {
                    HiLog.error(TAG, "readResource finish");
                    byteArray = output.toByteArray();
                    break;
                }
                output.write(buffer, 0, readLen);
            }
        } catch (IOException e) {
            HiLog.debug(TAG, "readResource failed" + e.getLocalizedMessage());
            return new byte[0];
        }
        return byteArray;
    }

    /**
     * Creates is {@code PixelMap} object based on the image resource ID.
     * This method only loads local image resources. If the image file does not exist or the loading fails,
     * {@code null} is returned.
     *
     * @param resouceId Indicates the image resource ID.
     * @param slice Indicates the Context.
     * @return Returns the image.
     */
    public static Optional<PixelMap> createPixelMapByResId(int resouceId, Context slice) {
        ResourceManager manager = slice.getResourceManager();
        if (manager == null) {
            return Optional.empty();
        }
        try {
            try (Resource resource = manager.getResource(resouceId)) {
                if (resource == null) {
                    return Optional.empty();
                }
                ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
                srcOpts.formatHint = "image/png";
                ImageSource imageSource = ImageSource.create(readResource(resource), srcOpts);
                if (imageSource == null) {
                    return Optional.empty();
                }
                ImageSource.DecodingOptions decodingOptions = new ImageSource.DecodingOptions();
                decodingOptions.desiredSize = new Size(0, 0);
                decodingOptions.desiredRegion = new Rect(0, 0, 0, 0);
                decodingOptions.desiredPixelFormat = PixelFormat.ARGB_8888;

                return Optional.of(imageSource.createPixelmap(decodingOptions));
            }
        } catch (IOException | NotExistException e) {
            return Optional.empty();
        }
    }
}
