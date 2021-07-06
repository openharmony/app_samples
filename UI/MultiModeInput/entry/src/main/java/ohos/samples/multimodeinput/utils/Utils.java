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

package ohos.samples.multimodeinput.utils;

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

    private Utils (){
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
     * @param items string array
     * @param context Context
     */
    public void showDialogBox(String[] items, Context context) {
        listDialog = new ListDialog(context);
        listDialog.setAlignment(TextAlignment.CENTER);
        listDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        listDialog.setAutoClosable(true);
        listDialog.setItems(items);
        listDialog.show();
    }

    /**
     * distroyDialogBox
     */
    public void distroyDialogBox() {
        if (listDialog != null) {
            listDialog.destroy();
        }
    }
}
