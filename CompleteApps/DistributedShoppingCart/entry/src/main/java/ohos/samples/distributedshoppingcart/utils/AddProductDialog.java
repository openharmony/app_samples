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
 * AddProductDialog
 */
public class AddProductDialog {
    private static final int DIALOG_WIDTH = 480;
    private static final int DIALOG_HEIGHT = 450;
    private static final int TIME_SHOW = 300;

    private CommonDialog commonDialog;
    private final String text;

    /**
     * AddProductDialog
     *
     * @param context the context
     * @param text the text msg
     */
    public AddProductDialog(Context context,String text) {
        this.text = text;
        initView(context);
    }

    private void initView(Context context) {
        commonDialog = new CommonDialog(context);
        commonDialog.setAlignment(LayoutAlignment.CENTER);
        commonDialog.setSize(DIALOG_WIDTH, DIALOG_HEIGHT);
        commonDialog.setAutoClosable(true);
        commonDialog.setDuration(TIME_SHOW);
        Component dialogLayout = LayoutScatter.getInstance(context)
            .parse(ResourceTable.Layout_add_product_dialog, null, false);
        commonDialog.setContentCustomComponent(dialogLayout);
        ((Text)dialogLayout.findComponentById(ResourceTable.Id_text_tips)).setText(text);
        dialogLayout.findComponentById(ResourceTable.Id_add_product_success).setClickedListener(
            component -> commonDialog.hide());
    }

    /**
     * show dialog
     */
    public void show() {
        commonDialog.show();
    }
}
