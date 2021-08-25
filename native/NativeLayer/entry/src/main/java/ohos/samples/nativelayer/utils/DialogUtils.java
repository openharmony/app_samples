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

package ohos.samples.nativelayer.utils;

import ohos.agp.components.*;
import ohos.agp.graphics.Surface;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.samples.nativelayer.ResourceTable;
import ohos.samples.nativelayer.slice.MainAbilitySlice;

/**
 * DialogUtils
 *
 * @since 2021-08-16
 */
public class DialogUtils {
    private static final String TAG = DialogUtils.class.getSimpleName();
    public static final int TYPE_SET_WIDTH_AND_HEIGHT = 1;
    public static final int TYPE_SET_FORMAT = 2;

    private CommonDialog mDialog;

    /**
     * showNormalDialog
     * @param context Context
     * @param type int
     * @param slice MainAbilitySlice
     * @param surface Surface
     */
    public void showNormalDialog(Context context, int type, MainAbilitySlice slice, Surface surface) {
        Component component = LayoutScatter.getInstance(context).parse(ResourceTable.Layout_dailog_set_native_info, null, true);
        Text title = (Text) component.findComponentById(ResourceTable.Id_dialog_title);
        Component btnSubmit = component.findComponentById(ResourceTable.Id_submit);
        Component btnCancel = component.findComponentById(ResourceTable.Id_cancel);
        TextField widthText = (TextField) component.findComponentById(ResourceTable.Id_input_width);
        Component widthComponent = component.findComponentById(ResourceTable.Id_width_component);
        Component heightComponent = component.findComponentById(ResourceTable.Id_height_component);
        Component formatComponent = component.findComponentById(ResourceTable.Id_format_component);
        TextField heightText = (TextField) component.findComponentById(ResourceTable.Id_input_height);
        TextField formatText = (TextField) component.findComponentById(ResourceTable.Id_input_format);
        if (type == TYPE_SET_WIDTH_AND_HEIGHT) {
            title.setText(ResourceTable.String_set_native_layer_info);
            formatComponent.setVisibility(Component.HIDE);
            widthComponent.setVisibility(Component.VISIBLE);
            heightComponent.setVisibility(Component.VISIBLE);
        } else {
            title.setText(ResourceTable.String_set_native_layer_format);
            formatComponent.setVisibility(Component.VISIBLE);
            widthComponent.setVisibility(Component.HIDE);
            heightComponent.setVisibility(Component.HIDE);
        }
        btnSubmit.setClickedListener((Component comp) -> {
            if (type == TYPE_SET_WIDTH_AND_HEIGHT) {
                if (!widthText.getText().isEmpty() && !heightText.getText().isEmpty()) {
                    try {
                        int width = Integer.parseInt(widthText.getText());
                        int height = Integer.parseInt(heightText.getText());
                        slice.NativeLayerHandleSetHeightWidthFromJNI(surface, width, height);
                        surface.syncCanvasDrawCalls();
                        dismissDialog();
                    } catch (NumberFormatException e) {
                        HiLogUtils.error(TAG, "input type error");
                        showToast(context, "Only supports int type input");
                    }
                } else {
                    showToast(context, "width and height is not null");
                }
            } else {
                if (!formatText.getText().isEmpty()) {
                    try {
                        int format = Integer.parseInt(formatText.getText());
                        slice.NativeLayerHandleSetFormatFromJNI(surface, format);
                        surface.syncCanvasDrawCalls();
                        dismissDialog();
                    } catch (NumberFormatException e) {
                        HiLogUtils.error(TAG, "input type error");
                        showToast(context, "Only supports int type input");
                    }
                } else {
                    showToast(context, "format need input");
                }
            }
        });
        btnCancel.setClickedListener((Component comp) -> dismissDialog());
        CommonDialog dialog = new CommonDialog(context);
        mDialog = dialog;
        dialog.setContentCustomComponent(component);
        dialog.setAlignment(LayoutAlignment.CENTER);
        dialog.setTransparent(true);
        dialog.show();
    }

    /**
     * showToast
     * @param context Context
     * @param message String
     */
    public void showToast(Context context, String message) {
        ToastDialog dialog = new ToastDialog(context).setText(message).setAlignment(LayoutAlignment.CENTER);
        dialog.show();
    }

    /**
     * dismissDialog
     */
    public void dismissDialog() {
        if (mDialog != null) {
            mDialog.destroy();
        }
    }
}
