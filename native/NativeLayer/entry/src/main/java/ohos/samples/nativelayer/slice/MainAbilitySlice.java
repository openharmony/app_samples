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

package ohos.samples.nativelayer.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.*;
import ohos.agp.components.surfaceprovider.SurfaceProvider;
import ohos.agp.graphics.Surface;
import ohos.agp.graphics.SurfaceOps;
import ohos.agp.render.Canvas;
import ohos.agp.render.Paint;
import ohos.agp.utils.Color;
import ohos.samples.nativelayer.ResourceTable;
import ohos.samples.nativelayer.utils.DialogUtils;
import ohos.samples.nativelayer.utils.HiLogUtils;

/**
 * MainAbilitySlice
 *
 * @since 2021-08-16
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    // Load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("nativelayer");
    }

    private MainAbilitySlice slice;
    private DependentLayout surfaceLayout;
    private Surface surface;
    private Text text;
    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_main);
        slice = new MainAbilitySlice();
        initComponents();
        addSurfaceProvider();
    }

    private void initComponents() {
        text = (Text) findComponentById(ResourceTable.Id_text);
        Button btnNativeLayer = (Button) findComponentById(ResourceTable.Id_getNativeLayer);
        Button btnSetNativeLayer = (Button) findComponentById(ResourceTable.Id_setNativeLayer);
        Button btnSetNativeLayerFormat = (Button) findComponentById(ResourceTable.Id_setNativeLayerFormat);
        surfaceLayout = (DependentLayout) findComponentById(ResourceTable.Id_surface_layout);

        btnNativeLayer.setClickedListener(this::getNativeLayerInfo);
        btnSetNativeLayer.setClickedListener(this::setNativeLayerInfo);
        btnSetNativeLayerFormat.setClickedListener(this::setNativeLayerFormat);
    }

    private void addSurfaceProvider() {
        SurfaceProvider surfaceProvider = new SurfaceProvider(this);
        surfaceProvider.pinToZTop(true);
        if (surfaceProvider.getSurfaceOps().isPresent()) {
            surfaceProvider.getSurfaceOps().get().addCallback(new SurfaceCallBack());
        }
        surfaceLayout.addComponent(surfaceProvider);
    }

    private void setNativeLayerFormat(Component component) {
        new DialogUtils().showNormalDialog(getContext(), DialogUtils.TYPE_SET_FORMAT, slice, surface);
    }

    private void setNativeLayerInfo(Component component) {
        HiLogUtils.info(TAG, "setNativeLayerInfo");
        new DialogUtils().showNormalDialog(getContext(), DialogUtils.TYPE_SET_WIDTH_AND_HEIGHT, slice, surface);
    }

    private void getNativeLayerInfo(Component component) {
        HiLogUtils.info(TAG, "getNativeLayerInfo,density=" + AttrHelper.getDensity(this));
        int width = slice.NativeLayerHandleGetWidthFromJNI(surface);
        int height = slice.NativeLayerHandleGetHeightFromJNI(surface);
        int format = slice.NativeLayerHandleGetFormatFromJNI(surface);
        text.setText(getString(ResourceTable.String_get_nativelayer_info_result) + "width:" + width + ", height:" + height + ", format:" + format);
    }

    private class SurfaceCallBack implements SurfaceOps.Callback {
        @Override
        public void surfaceCreated(SurfaceOps callbackSurfaceOps) {
            surface = callbackSurfaceOps.getSurface();
            Paint paint = new Paint();
            paint.setColor(Color.LTGRAY);
            paint.setStrokeWidth(30f);
            paint.setStyle(Paint.Style.STROKE_STYLE);
            Canvas canvas = surface.acquireCanvas();
            canvas.drawPaint(paint);
            paint.setColor(Color.YELLOW);
            canvas.drawCircle(500, 400, 150f, paint);
            paint.setColor(Color.RED);
            paint.setStrokeWidth(5f);
            paint.setTextSize(85);
            canvas.drawText(paint, "Hello World", 300, 700);
            surface.syncCanvasDrawCalls();
        }

        @Override
        public void surfaceChanged(SurfaceOps callbackSurfaceOps, int format, int width, int height) {
        }

        @Override
        public void surfaceDestroyed(SurfaceOps callbackSurfaceOps) {
        }
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public native int NativeLayerHandleGetWidthFromJNI(Surface surface);

    public native int NativeLayerHandleGetHeightFromJNI(Surface surface);

    public native int NativeLayerHandleGetFormatFromJNI(Surface surface);

    public native int NativeLayerHandleSetHeightWidthFromJNI(Surface surface, int width, int height);

    public native int NativeLayerHandleSetFormatFromJNI(Surface surface, int format);

}
