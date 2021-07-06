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

package ohos.samples.customcomponent.modle;

import ohos.agp.components.AttrSet;
import ohos.agp.components.Component;
import ohos.agp.render.Canvas;
import ohos.agp.render.Paint;
import ohos.agp.utils.Color;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.multimodalinput.event.TouchEvent;

/**
 * CustomComponent
 *
 * @since 2021-05-08
 */
public class CustomComponent extends Component implements Component.EstimateSizeListener, Component.DrawTask,
        Component.TouchEventListener {
    private static final String TAG = CustomComponent.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final float CIRCLE_STROKE_WIDTH = 100f;

    private static final float Y = 500;

    private static final float RADIUS = 300;

    private float pointX;

    private Paint circlePaint;

    private boolean isDiscoloration = false;

    /**
     * customcomponent
     *
     * @param context Indicates the Context
     * @param attrSet attrset
     */
    public CustomComponent(Context context, AttrSet attrSet) {
        super(context, attrSet);
        setEstimateSizeListener(this);
        setTouchEventListener(this);
        initPaint();
        addDrawTask(this);
    }

    @Override
    public boolean onEstimateSize(int widthEstimateConfig, int heightEstimateConfig) {
        int width = Component.EstimateSpec.getSize(widthEstimateConfig);
        int height = Component.EstimateSpec.getSize(heightEstimateConfig);
        setEstimatedSize(Component.EstimateSpec.getChildSizeWithMode(width, height, EstimateSpec.NOT_EXCEED),
                Component.EstimateSpec.getChildSizeWithMode(width, height, EstimateSpec.NOT_EXCEED));
        pointX = width;
        return true;
    }

    private void initPaint() {
        circlePaint = new Paint();
        circlePaint.setColor(Color.YELLOW);
        circlePaint.setStrokeWidth(CIRCLE_STROKE_WIDTH);
        circlePaint.setStyle(Paint.Style.STROKE_STYLE);
    }

    @Override
    public void onDraw(Component component, Canvas canvas) {
        canvas.drawCircle(pointX / 2, Y, RADIUS, circlePaint);
    }

    @Override
    public boolean onTouchEvent(Component component, TouchEvent touchEvent) {
        HiLog.info(LABEL_LOG, "onTouchEvent");
        if (touchEvent.getAction() == TouchEvent.PRIMARY_POINT_DOWN) {
            if (!isDiscoloration) {
                circlePaint.setColor(Color.GREEN);
            } else {
                circlePaint.setColor(Color.YELLOW);
            }
            invalidate();
            isDiscoloration = !isDiscoloration;
        }
        return false;
    }
}
