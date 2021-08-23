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

package ohos.samples.distributedshoppingcart.utils;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.samples.distributedshoppingcart.ResourceTable;

/**
 * MegerDialog
 */
public class MegerDialog {
    private static final int DIALOG_WIDTH = 840;
    private static final int DIALOG_HEIGHT = 660;

    private CommonDialog commonDialog;
    private final String text;
    private final String textTitle;

    /**
     * MegerDialog
     *
     * @param context the context
     * @param title the title msg
     * @param text the text msg
     * @param listener the listener event
     */
    public MegerDialog(Context context,String title,String text ,SelectResultListener listener) {
        this.textTitle = title;
        this.text = text;
        initView(context,listener);
    }

    /**
     * SelectResultListener
     */
    public interface SelectResultListener {
        /**
         * callBack
         */
        void callBack();
    }

    private void initView(Context context,SelectResultListener listener) {
        commonDialog = new CommonDialog(context);
        commonDialog.setAlignment(LayoutAlignment.CENTER);
        commonDialog.setSize(DIALOG_WIDTH, DIALOG_HEIGHT);
        commonDialog.setAutoClosable(true);
        Component dialogLayout = LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_share_meger_dialog, null, false);
        commonDialog.setContentCustomComponent(dialogLayout);
        ((Text)dialogLayout.findComponentById(ResourceTable.Id_text_meger_tips)).setText(text);
        ((Text)dialogLayout.findComponentById(ResourceTable.Id_text_meger)).setText(textTitle);
        dialogLayout.findComponentById(ResourceTable.Id_share_meger_dialog).setClickedListener(
            component -> commonDialog.hide());
        dialogLayout.findComponentById(ResourceTable.Id_text_meger_cancel).setClickedListener(
            component -> commonDialog.hide());
        dialogLayout.findComponentById(ResourceTable.Id_share_meger_icon_cancel).setClickedListener(
            component -> commonDialog.hide());
        dialogLayout.findComponentById(ResourceTable.Id_text_meger_sure).setClickedListener(component -> {
            listener.callBack();
            commonDialog.hide();
        });
    }

    /**
     * show the dialog
     */
    public void show() {
        commonDialog.show();
    }
}
