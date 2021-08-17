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
import ohos.agp.render.Arc;
import ohos.agp.render.Canvas;
import ohos.agp.render.Paint;
import ohos.agp.render.PixelMapHolder;
import ohos.agp.utils.Color;
import ohos.agp.utils.Point;
import ohos.agp.utils.RectFloat;
import ohos.app.Context;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.image.PixelMap;
import ohos.media.image.common.Size;
import ohos.multimodalinput.event.MmiPoint;
import ohos.multimodalinput.event.TouchEvent;
import ohos.samples.customcomponent.ResourceTable;
import ohos.samples.customcomponent.utils.Util;

import java.util.Optional;

/**
 * CustomControlBar
 *
 * @since 2021-05-08
 */
public class CustomControlBar extends Component implements Component.DrawTask, Component.EstimateSizeListener,
        Component.TouchEventListener {
    private static final String TAG = CustomComponent.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final float CIRCLE_ANGLE = 360.0f;

    private static final int DEF_UNFILL_COLOR = 0xFF808080;

    private static final int DEF_FILL_COLOR = 0xFF1E90FF;

    private static final int COUNT = 10;

    private static final int SPLIT_SIZE = 15;

    private static final int CIRCLE_WIDTH = 60;

    private static final int MARGIN = 50;

    private static final int TWO = 2;

    private static final int ANGLE = 90;

    private static final double ROUNDING = 0.4;

    private static final double NUM_TWO = 2.0;

    private static final float NUM_ONE = 1.0f;

    private Color unFillColor;

    private Color fillColor;

    private final Paint paint;

    private int currentCount;

    private RectFloat centerRectFloat;

    private PixelMap image;

    private Point centerPoint;

    /**
     * customcontrolbar
     *
     * @param context Indicates the Context
     * @param attrSet attrset
     */
    public CustomControlBar(Context context, AttrSet attrSet) {
        super(context, attrSet);
        paint = new Paint();
        initData();
        setEstimateSizeListener(this);
        setTouchEventListener(this);
        addDrawTask(this);
    }

    private void initData() {
        unFillColor = new Color(DEF_UNFILL_COLOR);
        fillColor = new Color(DEF_FILL_COLOR);
        currentCount = TWO;
        centerRectFloat = new RectFloat();
        Optional<PixelMap> optional = Util.createPixelMapByResId(ResourceTable.Media_icon, getContext());
        optional.ifPresent(pixelMap -> image = pixelMap);
    }

    @Override
    public void onDraw(Component component, Canvas canvas) {
        HiLog.info(LABEL_LOG, "onDraw");
        paint.setAntiAlias(true);
        paint.setStrokeWidth(CIRCLE_WIDTH);
        paint.setStrokeCap(Paint.StrokeCap.ROUND_CAP);
        paint.setStyle(Paint.Style.STROKE_STYLE);

        int width = getWidth();
        int center = width / TWO;
        centerPoint = new Point(center, center);
        int radius = center - CIRCLE_WIDTH / TWO - MARGIN;
        drawCount(canvas, center, radius);

        int inRadius = center - CIRCLE_WIDTH;
        double length = inRadius - Math.sqrt(TWO) * NUM_ONE / TWO * inRadius;
        centerRectFloat.left = (float) (length + CIRCLE_WIDTH);
        centerRectFloat.top = (float) (length + CIRCLE_WIDTH);
        centerRectFloat.bottom = (float) (centerRectFloat.left + Math.sqrt(TWO) * inRadius);
        centerRectFloat.right = (float) (centerRectFloat.left + Math.sqrt(TWO) * inRadius);

        Size imageSize = image.getImageInfo().size;
        if (imageSize.width < Math.sqrt(TWO) * inRadius) {
            centerRectFloat.left =
                (float) (centerRectFloat.left + Math.sqrt(TWO) * inRadius * NUM_ONE / TWO
                        - imageSize.width * NUM_ONE / TWO);
            centerRectFloat.top =
                (float) (centerRectFloat.top + Math.sqrt(TWO) * inRadius * NUM_ONE / TWO
                        - imageSize.height * NUM_ONE / TWO);
            centerRectFloat.right = centerRectFloat.left + imageSize.width;
            centerRectFloat.bottom = centerRectFloat.top + imageSize.height;
        }
        canvas.drawPixelMapHolderRect(new PixelMapHolder(image), centerRectFloat, paint);
    }

    private void drawCount(Canvas canvas, int center, int radius) {
        float itemSize = (CIRCLE_ANGLE - COUNT * SPLIT_SIZE) / COUNT;

        RectFloat oval = new RectFloat(center - radius, center - radius, center + radius,
                center + radius);

        paint.setColor(unFillColor);
        for (int i = 0; i < COUNT; i++) {
            Arc arc = new Arc((i * (itemSize + SPLIT_SIZE)) - ANGLE, itemSize, false);
            canvas.drawArc(oval, arc, paint);
        }

        paint.setColor(fillColor);
        for (int i = 0; i < currentCount; i++) {
            Arc arc = new Arc((i * (itemSize + SPLIT_SIZE)) - ANGLE, itemSize, false);
            canvas.drawArc(oval, arc, paint);
        }
    }

    @Override
    public boolean onEstimateSize(int widthEstimateConfig, int heightEstimateConfig) {
        int width = Component.EstimateSpec.getSize(widthEstimateConfig);
        int height = Component.EstimateSpec.getSize(heightEstimateConfig);
        setEstimatedSize(
                Component.EstimateSpec.getChildSizeWithMode(width, height, Component.EstimateSpec.PRECISE),
                Component.EstimateSpec.getChildSizeWithMode(width, height, Component.EstimateSpec.PRECISE)
        );
        return true;
    }

    @Override
    public boolean onTouchEvent(Component component, TouchEvent touchEvent) {
        switch (touchEvent.getAction()) {
            case TouchEvent.PRIMARY_POINT_DOWN:
            case TouchEvent.POINT_MOVE: {
                MmiPoint absPoint = touchEvent.getPointerPosition(touchEvent.getIndex());
                Point point =
                    new Point(absPoint.getX() - getContentPositionX(), absPoint.getY() - getContentPositionY());
                double angle = calcRotationAngleInDegrees(centerPoint, point) * TWO;
                if (angle > CIRCLE_ANGLE) {
                    angle -= CIRCLE_ANGLE;
                }
                double number = angle / (CIRCLE_ANGLE / COUNT);
                if ((number - (int) number) > ROUNDING) {
                    currentCount = (int) number + 1;
                } else {
                    currentCount = (int) number;
                }
                invalidate();
                break;
            }
            default:
                break;
        }
        return false;
    }

    private double calcRotationAngleInDegrees(Point centerPt, Point targetPt) {
        double theta = Math.atan2(targetPt.getPointYToInt()
                - centerPt.getPointYToInt(), targetPt.getPointXToInt() - centerPt.getPointXToInt());
        theta += Math.PI / NUM_TWO;
        double angle = Math.toDegrees(theta);
        if (angle < 0) {
            angle += CIRCLE_ANGLE;
        }
        return angle;
    }
}
