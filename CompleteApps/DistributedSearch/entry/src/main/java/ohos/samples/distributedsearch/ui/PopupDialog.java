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

package ohos.samples.distributedsearch.ui;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.samples.distributedsearch.ResourceTable;
import ohos.samples.distributedsearch.utils.LogUtil;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;

/**
 * PopupDialog
 */
public class PopupDialog extends CommonDialog {
    private static final String TAG = "PopupDialog";
    private static final int CORNER_RADIUS = 40;
    private final Context mContext;

    /**
     * create PopupDialog
     *
     * @param context the context
     */
    public PopupDialog(Context context) {
        super(context);
        mContext = context;
    }

    @Override
    protected void onCreate() {
        super.onCreate();
        Component rootView =
                LayoutScatter.getInstance(mContext).parse(ResourceTable.Layout_dialog_delete, null, false);
        configChoiceButton(rootView);
        configStyle(rootView);
    }

    private void configChoiceButton(Component rootView) {
        LogUtil.info(TAG, "begin to configChoiceButton");
        Text operateYes = (Text) rootView.findComponentById(ResourceTable.Id_operate_yes);
        operateYes.setClickedListener(component -> {
            destroy();
        });
        Text operateNo = (Text) rootView.findComponentById(ResourceTable.Id_operate_no);
        operateNo.setClickedListener(component -> destroy());
    }

    private void configStyle(Component rootView) {
        LogUtil.info(TAG, "begin to configStyle");
        setSize(MATCH_PARENT, MATCH_CONTENT);
        setAlignment(LayoutAlignment.CENTER);
        setCornerRadius(CORNER_RADIUS);
        setAutoClosable(true);
        setContentCustomComponent(rootView);
        setTransparent(true);
    }
}
