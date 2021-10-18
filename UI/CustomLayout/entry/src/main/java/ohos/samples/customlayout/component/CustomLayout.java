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
    private final Map<Integer, Layout> axis = new HashMap<>();

    private int locationX = 0;

    private int locationY = 0;

    private int maxWidth = 0;

    private int maxHeight = 0;

    private int lastHeight = 0;

    public CustomLayout(Context context, AttrSet attrSet) {
        super(context, attrSet);
        setEstimateSizeListener(this);
        setArrangeListener(this);
    }

    @Override
    public boolean onEstimateSize(int widthEstimatedConfig, int heightEstimatedConfig) {
        invalidateValues();
        measureChildren(widthEstimatedConfig, heightEstimatedConfig);
        for (int idx = 0; idx < getChildCount(); idx++) {
            Component childView = getComponentAt(idx);
            addChild(childView, idx, EstimateSpec.getSize(widthEstimatedConfig));
        }
        measureSelf(widthEstimatedConfig, heightEstimatedConfig);
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

    private void measureChild(Component childView, int widthEstimatedConfig, int heightEstimatedConfig) {
        LayoutConfig lc = childView.getLayoutConfig();
        int childWidthMeasureSpec;
        int childHeightMeasureSpec;

        if (lc.width == LayoutConfig.MATCH_CONTENT) {
            childWidthMeasureSpec = EstimateSpec.getSizeWithMode(lc.width, EstimateSpec.NOT_EXCEED);
        } else if (lc.width == LayoutConfig.MATCH_PARENT) {
            int parentWidth = EstimateSpec.getSize(widthEstimatedConfig);
            int childWidth = parentWidth - childView.getMarginLeft() - childView.getMarginRight();
            childWidthMeasureSpec = EstimateSpec.getSizeWithMode(childWidth, EstimateSpec.PRECISE);
        } else {
            childWidthMeasureSpec = EstimateSpec.getSizeWithMode(lc.width, EstimateSpec.PRECISE);
        }

        if (lc.height == LayoutConfig.MATCH_CONTENT) {
            childHeightMeasureSpec = EstimateSpec.getSizeWithMode(lc.height, EstimateSpec.NOT_EXCEED);
        } else if (lc.height == LayoutConfig.MATCH_PARENT) {
            int parentHeight = EstimateSpec.getSize(heightEstimatedConfig);
            int childHeight = parentHeight - childView.getMarginTop() - childView.getMarginBottom();
            childHeightMeasureSpec = EstimateSpec.getSizeWithMode(childHeight, EstimateSpec.PRECISE);
        } else {
            childHeightMeasureSpec = EstimateSpec.getSizeWithMode(lc.height, EstimateSpec.PRECISE);
        }
        childView.estimateSize(childWidthMeasureSpec, childHeightMeasureSpec);
    }

    private void measureSelf(int widthEstimatedConfig, int heightEstimatedConfig) {
        int widthSpace = EstimateSpec.getMode(widthEstimatedConfig);
        int heightSpace = EstimateSpec.getMode(heightEstimatedConfig);
        int widthConfig = 0;
        switch (widthSpace) {
            case EstimateSpec.UNCONSTRAINT:
            case EstimateSpec.PRECISE:
                int width = EstimateSpec.getSize(widthEstimatedConfig);
                widthConfig = EstimateSpec.getSizeWithMode(width, EstimateSpec.PRECISE);
                break;
            case EstimateSpec.NOT_EXCEED:
                widthConfig = EstimateSpec.getSizeWithMode(maxWidth, EstimateSpec.PRECISE);
                break;
            default:
                break;
        }

        int heightConfig = 0;
        switch (heightSpace) {
            case EstimateSpec.UNCONSTRAINT:
            case EstimateSpec.PRECISE:
                int height = EstimateSpec.getSize(heightEstimatedConfig);
                heightConfig = EstimateSpec.getSizeWithMode(height, EstimateSpec.PRECISE);
                break;
            case EstimateSpec.NOT_EXCEED:
                heightConfig = EstimateSpec.getSizeWithMode(maxHeight, EstimateSpec.PRECISE);
                break;
            default:
                break;
        }
        setEstimatedSize(widthConfig, heightConfig);
    }

    private void addChild(Component component, int id, int layoutWidth) {
        Layout layout = new Layout();
        layout.positionX = locationX + component.getMarginLeft();
        layout.positionY = locationY + component.getMarginTop();
        layout.width = component.getEstimatedWidth();
        layout.height = component.getEstimatedHeight();
        if ((locationX + layout.width) > layoutWidth) {
            locationX = 0;
            locationY += lastHeight;
            lastHeight = 0;
            layout.positionX = locationX + component.getMarginLeft();
            layout.positionY = locationY + component.getMarginTop();
        }
        axis.put(id, layout);
        lastHeight = Math.max(lastHeight, layout.height + component.getMarginBottom());
        locationX += layout.width + component.getMarginRight();
        maxWidth = Math.max(maxWidth, layout.positionX + layout.width);
        maxHeight = Math.max(maxHeight, layout.positionY + layout.height);
    }

    @Override
    public boolean onArrange(int left, int top, int width, int height) {
        for (int idx = 0; idx < getChildCount(); idx++) {
            Component childView = getComponentAt(idx);
            Layout position = axis.get(idx);
            if (position != null) {
                childView.arrange(position.positionX, position.positionY, position.width, position.height);
            }
        }
        return true;
    }

    private void invalidateValues() {
        locationX = 0;
        locationY = 0;
        maxWidth = 0;
        maxHeight = 0;
        axis.clear();
    }

    /**
     * Layout
     *
     * @since 2021-05-08
     */
    private static class Layout {
        int positionX = 0;

        int positionY = 0;

        int width = 0;

        int height = 0;
    }
}