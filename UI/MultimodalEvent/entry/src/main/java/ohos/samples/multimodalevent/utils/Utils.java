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

package ohos.samples.multimodalevent.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import ohos.agp.utils.TextAlignment;
import ohos.agp.window.dialog.ListDialog;
import ohos.app.Context;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;

/**
 * Utils
 *
 * @since 2021-06-08
 */
public class Utils {
    private static final int DIALOG_BOX_WIDTH = 985;

    /**
     * listDialog ListDialog
     */
    private ListDialog listDialog;

    private static Utils instance;

    private Utils() {
    }

    public static synchronized Utils getInstance() {
        if (instance == null) {
            instance = new Utils();
        }
        return instance;
    }

    /**
     * showDialogBox
     *
     * @param message       string
     * @param context Context
     */
    public void showDialogBox(String message, Context context) {
        listDialog = new ListDialog(context);
        listDialog.setAlignment(TextAlignment.CENTER);
        listDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        listDialog.setAutoClosable(true);
        String[] items = new String[]{
                message, "Current Time：" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                Locale.getDefault()).format(new Date().getTime())
        };
        listDialog.setItems(items);
        listDialog.show();
    }

    /**
     * showDialogBox
     */
    public void distroyDialogBox() {
        if (listDialog != null) {
            listDialog.destroy();
        }
    }
}
