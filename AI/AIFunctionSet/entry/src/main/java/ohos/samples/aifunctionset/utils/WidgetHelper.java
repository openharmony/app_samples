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

package ohos.samples.aifunctionset.utils;

import ohos.app.Context;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;

import java.io.IOException;

/**
 * Widget helper
 *
 */
public final class WidgetHelper {
    /**
     * Rawfile to PixelMap
     *
     * @param context app context
     * @param path copy file's path
     * @return PixelMap pixelMap
     */
    public static PixelMap getPixelMapFromRaw(Context context, String path) {
        try {
            RawFileEntry rawFileEntry = context.getResourceManager().getRawFileEntry(path);
            Resource resource = rawFileEntry.openRawFile();
            ImageSource imageSource = ImageSource.create(resource, new ImageSource.SourceOptions());
            return imageSource.createPixelmap(null);
        } catch (IOException e) {
            LogUtil.error("getPixelMapFromRaw", "IOException :" + e.toString());
        }
        return null;
    }
}
