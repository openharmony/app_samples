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

package ohos.samples.distributedsearch.provider;

/**
 * FileItemViewHolder file item view
 */
public class FileItemViewHolder {
    private String filename;
    private String devicename;
    private int iconId;
    private String filepath;

    /**
     * create FileItemViewHolder
     *
     * @param filename file name
     * @param devicename device name
     * @param icon icon id
     */
    public FileItemViewHolder(String filename, String devicename, int icon) {
        this.iconId = icon;
        this.filename = filename;
        this.devicename = devicename;
    }

    /**
     * create FileItemViewHolder
     *
     * @param filename file name
     * @param filepath file path
     * @param devicename device name
     * @param icon icon id
     */
    public FileItemViewHolder(String filename, String filepath, String devicename, int icon) {
        this.iconId = icon;
        this.filename = filename;
        this.devicename = devicename;
        this.filepath = filepath;
    }

    public void setFilename(String name) {
        filename = name;
    }

    public String getFilename() {
        return filename;
    }

    public void setDevicename(String device) {
        devicename = device;
    }

    public String getDevicename() {
        return devicename;
    }

    public void setIconId(int icon) {
        iconId = icon;
    }

    public int getIconId() {
        return iconId;
    }

    public void setFilepath(String path) {
        filepath = path;
    }

    public String getFilepath() {
        return filepath;
    }
}
