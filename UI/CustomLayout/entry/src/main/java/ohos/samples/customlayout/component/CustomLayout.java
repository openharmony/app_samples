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

package ohos.samples.customlayout.component;

import ohos.agp.components.AttrSet;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.app.Context;

import java.util.HashMap;
import java.util.Map;

/**
 * Custom layout
 *
 * @since 2021-07-03
 */
public class CustomLayout extends ComponentContainer
    implements ComponentContainer.EstimateSizeListener, ComponentContainer.ArrangeListener {
    private final Map<Integer, Position> axis = new HashMap<>();

    private int locationX;

    private int locationY;

    private int maxWidth;

    private int maxHeight;

    private int lastHeight;

    public CustomLayout(Context context, AttrSet attrSet) {
        super(context, attrSet);
        setEstimateSizeListener(this);
        setArrangeListener(this);
    }

    @Override
    public boolean onEstimateSize(int widthEstimatedConfig, int heightEstimatedConfig) {
        measureChildren(widthEstimatedConfig, heightEstimatedConfig);
        int width = EstimateSpec.getSize(widthEstimatedConfig);

        for (int idx = 0; idx < getChildCount(); idx++) {
            Component childView = getComponentAt(idx);
            addChild(childView, idx, width);
        }
        setEstimatedSize(EstimateSpec.getChildSizeWithMode(maxWidth, widthEstimatedConfig, 0),
            EstimateSpec.getChildSizeWithMode(maxHeight, heightEstimatedConfig, 0));
        return true;
    }

    private void measureChildren(int widthEstimatedConfig, int heightEstimatedConfig) {
        for (int idx = 0; idx < getChildCount(); idx++) {
            Component childView = getComponentAt(idx);
            if (childView != null) {
                measureChild(childView, widthEstimatedConfig, heightEstimatedConfig);
            }
        }
    }

    private void measureChild(Component child, int parentWidthMeasureSpec, int parentHeightMeasureSpec) {
        LayoutConfig lc = child.getLayoutConfig();
        int childWidthMeasureSpec =
            EstimateSpec.getChildSizeWithMode(lc.width, parentWidthMeasureSpec, EstimateSpec.UNCONSTRAINT);
        int childHeightMeasureSpec =
            EstimateSpec.getChildSizeWithMode(lc.height, parentHeightMeasureSpec, EstimateSpec.UNCONSTRAINT);
        child.estimateSize(childWidthMeasureSpec, childHeightMeasureSpec);
    }

    private void addChild(Component component, int id, int layoutWidth) {
        Position position = new Position();
        position.positionX = locationX + component.getMarginLeft();
        position.positionY = locationY + component.getMarginTop();
        position.width = component.getEstimatedWidth();
        position.height = component.getEstimatedHeight();
        if ((locationX + position.width) > layoutWidth) {
            locationX = 0;
            locationY += lastHeight;
            lastHeight = 0;
            position.positionX = locationX + component.getMarginLeft();
            position.positionY = locationY + component.getMarginTop();
        }
        axis.put(id, position);
        lastHeight = Math.max(lastHeight, position.height + component.getMarginBottom());
        locationX += position.width + component.getMarginRight();
        maxWidth = Math.max(maxWidth, position.positionX + position.width);
        maxHeight = Math.max(maxHeight, position.positionY + position.height);
    }

    @Override
    public boolean onArrange(int left, int top, int width, int height) {
        for (int idx = 0; idx < getChildCount(); idx++) {
            Component childView = getComponentAt(idx);
            Position position = axis.get(idx);
            if (position != null) {
                childView.arrange(position.positionX, position.positionY, position.width, position.height);
            }
        }
        return true;
    }

    /**
     * Layout
     *
     * @since 2021-05-08
     */
    private static class Position {
        int positionX = 0;

        int positionY = 0;

        int width = 0;

        int height = 0;
    }
}