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

package ohos.samples.distributedsearch.utils;

import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.ability.DataAbilityRemoteException;
import ohos.app.Context;
import ohos.data.distributed.common.KvManagerConfig;
import ohos.data.distributed.common.KvManagerFactory;
import ohos.data.resultset.ResultSet;
import ohos.media.photokit.metadata.AVStorage;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.utils.net.Uri;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Distributed File manager
 */
public class DistributedFile extends Thread {
    private static final String TAG = DistributedFile.class.getSimpleName();

    public static final int FILE_TYPE_IMAGE = 0;
    public static final int FILE_TYPE_AUDIO = 1;
    public static final int FILE_TYPE_VIDEO = 2;
    public static final int FILE_TYPE_TEXT = 3;
    public static final int FILE_TYPE_FILE = 4;
    public static final int FILE_TYPE_UNKNOWN = 0xFF;

    private static final int CACHE_SIZE = 8 * 1024;
    private static final int END_OF_FILE = -1;

    private final String[] mImageType = {"jpg", "bmp", "jpeg", "png"};
    private final String[] mAudioType = {"mp3","wav", "flac"};
    private final String[] mVideoType = {"mp4","mjpeg"};
    private final String[] mTextType = {"xml","xlsx", "doc", "docx", "pdf", "txt"};

    private final Context mContext;
    private boolean isCheckResult = false;

    private final ArrayList<String> localList = new ArrayList<>();
    private final ArrayList<String> distributedList = new ArrayList<>();

    /**
     * create DistributedFile
     *
     * @param context the context
     */
    public DistributedFile(Context context) {
        mContext = context;
    }

    @Override
    public void run() {
        initDistributedFiles();
        getDistributedFiles();
        isCheckResult = true;
    }

    /**
     * check the list has been searched over
     *
     * @return true or false
     */
    public boolean hasCheckResult() {
        return isCheckResult;
    }

    /**
     * get the file list
     *
     * @param type file type
     * @return file list
     */
    public List<String> getFile(int type) {
        if (distributedList.size() > 0) {
            return getFileList(distributedList, type);
        } else {
            return getFileList(localList, type);
        }
    }

    private List<String> getFileList(List<String> array, int type) {
        if (type == FILE_TYPE_FILE || array.size() == 0) {
            return array;
        }

        ArrayList<String> list = new ArrayList<>();

        for (String filename : array) {
            if (isTypeFile(filename, type)) {
                list.add(filename);
            }
        }

        return list;
    }

    private boolean isTypeFile(String file, int type) {
        if (type == FILE_TYPE_FILE) {
            return true;
        }
        if (type == FILE_TYPE_IMAGE) {
            return isDestFile(file, mImageType);
        }
        if (type == FILE_TYPE_AUDIO) {
            return isDestFile(file, mAudioType);
        }
        if (type == FILE_TYPE_VIDEO) {
            return isDestFile(file, mVideoType);
        }
        if (type == FILE_TYPE_TEXT) {
            return isDestFile(file, mTextType);
        }

        return false;
    }

    private boolean isDestFile(String file, String[] des) {
        int idx = file.lastIndexOf('.');
        if (idx < 0) {
            return false;
        }
        String suffix = file.substring(idx + 1);

        for (String de : des) {
            if (de.equals(suffix)) {
                return true;
            }
        }

        return false;
    }

    private void initDistributedFiles() {
        searchFiles(AVStorage.Images.Media.EXTERNAL_DATA_ABILITY_URI);
        searchFiles(AVStorage.Audio.Media.EXTERNAL_DATA_ABILITY_URI);
        searchFiles(AVStorage.Video.Media.EXTERNAL_DATA_ABILITY_URI);
    }

    private void searchFiles(Uri uri) {
        DataAbilityHelper helper = DataAbilityHelper.creator(mContext);

        String[] projections = new String[]{AVStorage.AVBaseColumns.ID,
            AVStorage.AVBaseColumns.DISPLAY_NAME, AVStorage.AVBaseColumns.DATA};
        try {
            ResultSet resultSet = helper.query(uri, projections, null);
            if (resultSet == null) {
                LogUtil.info(TAG, "resultSet == null");
                return;
            }

            while (resultSet.goToNextRow()) {
                int mediaId = resultSet.getInt(resultSet.getColumnIndexForName(AVStorage.AVBaseColumns.ID));
                String fullPath = resultSet.getString(resultSet.getColumnIndexForName(AVStorage.AVBaseColumns.DATA));
                String fileName = fullPath.substring(fullPath.lastIndexOf(File.separator) + 1);
                Uri tmpUri = Uri.appendEncodedPathToUri(uri, "" + mediaId);
                writeToDistributedDir(mContext, helper, fileName, tmpUri);
                localList.add(fileName);
            }
        } catch (DataAbilityRemoteException e) {
            LogUtil.error(TAG, "query Files failed.");
        }
    }

    private void writeToDistributedDir(Context context, DataAbilityHelper helper, String fileName, Uri uri) {
        if (context.getDistributedDir() == null) {
            WidgetHelper.showOneSecondTips(context, context.getString(ResourceTable.String_distributed_exception_info));
            return;
        }

        String deviceName = KvManagerFactory.getInstance()
                .createKvManager(new KvManagerConfig(context))
                .getLocalDeviceInfo().getName();
        String uniqueFileName = deviceName + "+" + fileName;
        String distributedFilePath = context.getDistributedDir().getPath() + '/' + uniqueFileName;

        writeFile(distributedFilePath, helper, uri);
    }

    private void writeFile(String filename, DataAbilityHelper helper, Uri uri) {
        InputStream inputStream = null;
        OutputStream outputStream = null;

        try {
            FileDescriptor fileDescriptor = helper.openFile(uri, "r");
            File file = new File(filename);
            inputStream = new FileInputStream(fileDescriptor);
            outputStream = new FileOutputStream(file);

            byte[] buffer = new byte[CACHE_SIZE];
            int count;
            while ((count = inputStream.read(buffer)) != END_OF_FILE) {
                outputStream.write(buffer, 0, count);
            }
        } catch (DataAbilityRemoteException | IOException e) {
            LogUtil.error(TAG, "writeToDistributedDir exception : " + e);
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                LogUtil.error(TAG, "close stream io exception");
            }
        }
    }

    private void getDistributedFiles() {
        if (mContext.getDistributedDir() == null) {
            WidgetHelper.showOneSecondTips(mContext, mContext.getString(ResourceTable.String_distributed_exception_info));
            return;
        }
        File file = new File(mContext.getDistributedDir().getPath());
        File[] files = file.listFiles();
        if (files == null) {
            LogUtil.error(TAG, "no distributed files!");
            return;
        }

        for (File eachFile : files) {
            distributedList.add(eachFile.getPath());
        }
    }

    /**
     * check file type
     *
     * @param filename file name
     * @return file type
     */
    public int checkFileType(String filename) {
        if (isDestFile(filename, mImageType)) {
            return FILE_TYPE_IMAGE;
        }
        if (isDestFile(filename, mAudioType)) {
            return FILE_TYPE_AUDIO;
        }
        if (isDestFile(filename, mVideoType)) {
            return FILE_TYPE_VIDEO;
        }
        if (isDestFile(filename, mTextType)) {
            return FILE_TYPE_TEXT;
        }

        return FILE_TYPE_UNKNOWN;
    }

    /**
     * Check wether is the local device
     * params:  context: ability context
     *          info device name or id
     *          type: info type, 0 -- name, 1 -- id
     * @return true or false.
     */
    public static boolean isLocalDevice(Context context, String info, int type) {
        String result;
        if (type == 0) {
            result = KvManagerFactory.getInstance()
                    .createKvManager(new KvManagerConfig(context))
                    .getLocalDeviceInfo().getName();
        } else if (type == 1) {
            result = KvManagerFactory.getInstance()
                    .createKvManager(new KvManagerConfig(context))
                    .getLocalDeviceInfo().getId();
        } else {
            return false;
        }
        LogUtil.info(TAG, "info : "+info+",result : "+result);
        return info.equals(result);
    }
}
