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

package ohos.samples.audioplayer.model;

import ohos.samples.audioplayer.utils.LogUtil;

import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.ability.DataAbilityRemoteException;
import ohos.app.Context;
import ohos.data.resultset.ResultSet;
import ohos.media.common.AVDescription;
import ohos.media.common.AVMetadata;
import ohos.media.common.sessioncore.AVElement;
import ohos.media.photokit.metadata.AVStorage;
import ohos.utils.PacMap;
import ohos.utils.net.Uri;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * This class is used to prepare audio files for applications.
 */
public class AVElementManager {
    private static final String TAG = AVElementManager.class.getSimpleName();

    private final List<AVElement> avElements = new ArrayList<>();

    private AVElement current;

    /**
     * The construction method of this class
     *
     * @param context Context
     */
    public AVElementManager(Context context) {
        loadFromMediaLibrary(context);
    }

    private void loadFromMediaLibrary(Context context) {
        Uri remoteUri = AVStorage.Audio.Media.EXTERNAL_DATA_ABILITY_URI;
        DataAbilityHelper helper = DataAbilityHelper.creator(context, remoteUri, false);
        try {
            ResultSet resultSet = helper.query(remoteUri, null, null);
            LogUtil.info(TAG, "The result size: " + resultSet.getRowCount());
            processResult(resultSet);
            resultSet.close();
        } catch (DataAbilityRemoteException e) {
            LogUtil.error(TAG, "Query system media failed.");
        } finally {
            helper.release();
        }
    }

    private void processResult(ResultSet resultSet) {
        while (resultSet.goToNextRow()) {
            String path = resultSet.getString(resultSet.getColumnIndexForName(AVStorage.AVBaseColumns.DATA));
            String title = resultSet.getString(resultSet.getColumnIndexForName(AVStorage.AVBaseColumns.TITLE));
            long duration = resultSet.getInt(resultSet.getColumnIndexForName(AVStorage.AVBaseColumns.DURATION));
            LogUtil.info(TAG, "Add new video file: " + path);
            PacMap pacMap = new PacMap();
            pacMap.putLongValue(AVMetadata.AVLongKey.DURATION, duration);
            AVDescription bean = new AVDescription.Builder().setTitle(title)
                    .setIMediaUri(Uri.parse(path))
                    .setMediaId(path)
                    .setExtras(pacMap)
                    .build();
            avElements.add(new AVElement(bean, AVElement.AVELEMENT_FLAG_PLAYABLE));
        }
        setDefaultAVElement();
    }

    private void setDefaultAVElement() {
        if (avElements.size() > 0) {
            current = avElements.get(0);
        }
    }

    /**
     * get the list of avElements
     *
     * @return avElements the list of avElements
     */
    public List<AVElement> getAvQueueElements() {
        return avElements;
    }

    /**
     * set the current AVElement by uri
     *
     * @param uri uri of item
     * @return true if set success, else false
     */
    public boolean setCurrentAVElement(Uri uri) {
        for (AVElement element : avElements) {
            if (element.getAVDescription().getMediaUri().toString().equals(uri.toString())) {
                current = element;
                return true;
            }
        }
        setDefaultAVElement();
        return false;
    }

    /**
     * get the current AVElement
     *
     * @return AVElement the current AVElement
     */
    public AVElement getCurrentAVElement() {
        return current;
    }

    /**
     * get the next AVElement
     *
     * @return AVElement the next AVElement
     */
    public Optional<AVElement> getNextAVElement() {
        for (int i = 0; i < avElements.size(); i++) {
            if (avElements.get(i).equals(current)) {
                int index = i + 1;
                current = avElements.get(index < avElements.size() ? index : 0);
                return Optional.of(current);
            }
        }
        setDefaultAVElement();
        return Optional.of(current);
    }

    /**
     * get the previous AVElement
     *
     * @return AVElement the previous AVElement
     */
    public Optional<AVElement> getPreviousAVElement() {
        for (int i = 0; i < avElements.size(); i++) {
            if (avElements.get(i).equals(current)) {
                int index = i - 1;
                current = avElements.get(index >= 0 ? index : avElements.size() - 1);
                return Optional.of(current);
            }
        }
        setDefaultAVElement();
        return Optional.of(current);
    }
}
