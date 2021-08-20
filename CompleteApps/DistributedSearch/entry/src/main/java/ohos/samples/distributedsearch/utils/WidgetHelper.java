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

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;

import ohos.agp.components.*;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.global.resource.NotExistException;
import ohos.global.resource.ResourceManager;
import ohos.global.resource.WrongTypeException;
import ohos.samples.distributedsearch.ResourceTable;

import java.io.IOException;

/**
 * The type Widget helper.
 *
 * @since 2021-04-27
 */
public class WidgetHelper {
    private static final String TAG = WidgetHelper.class.getSimpleName();

    private static final int ONE_SECOND = 1000;

    private WidgetHelper() {
    }

    /**
     * Show tips.
     *
     * @param context the context
     * @param msgId the msg id
     */
    public static void showTips(Context context, int msgId) {
        String msg = getStringByResourceId(context, msgId);
        showOneSecondTips(context, msg);
    }

    /**
     * Show tips.
     *
     * @param context the context
     * @param msg the msg
     * @param durationTime the duration time
     */
    public static void showTips(Context context, String msg, int durationTime) {
        Component rootView = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_widget_helper,
            null, false);
        Text text = (Text)rootView.findComponentById(ResourceTable.Id_helperText);
        text.setText(msg);

        ToastDialog toastDialog = new ToastDialog(context);
        toastDialog.setSize(MATCH_PARENT, MATCH_CONTENT);
        toastDialog.setDuration(durationTime);
        toastDialog.setAutoClosable(true);
        toastDialog.setTransparent(true);
        toastDialog.setAlignment(LayoutAlignment.CENTER);
        toastDialog.setComponent(rootView);
        toastDialog.show();
    }

    /**
     * Show one second tips.
     *
     * @param context the context
     * @param msg the msg
     */
    public static void showOneSecondTips(Context context, String msg) {
        showTips(context, msg, ONE_SECOND);
    }

    /**
     * Gets string by resource id.
     *
     * @param context the context
     * @param id the id
     * @return the string by resource id
     */
    public static String getStringByResourceId(Context context, int id) {
        if (context == null) {
            LogUtil.info(TAG, "Context is null, getString failed");
            return "";
        }
        ResourceManager resMgr = context.getResourceManager();
        if (resMgr == null) {
            LogUtil.info(TAG, "ResourceManager is null, getString failed");
            return "";
        }

        String value = "";
        try {
            value = resMgr.getElement(id).getString();
        } catch (NotExistException | WrongTypeException | IOException e) {
            LogUtil.info(TAG, "get string value from resource manager failed");
        }
        return value;
    }
}
