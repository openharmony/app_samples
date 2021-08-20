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

package ohos.samples.distributedsearch.provider;

import ohos.agp.components.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * The type Comment view holder.
 *
 * @since 2021-04-27
 */
public class ComponentViewHolder {
    /**
     * Layout
     */
    private Component componentView;

    /**
     * Subcomponents in componentview
     */
    private final Map<Integer, Component> childComponentMap = new HashMap<>();

    /**
     * Instantiates a new Component view holder.
     */
    public ComponentViewHolder() {
    }

    /**
     * Instantiates a new Component view holder.
     *
     * @param componentView the component view
     */
    public ComponentViewHolder(Component componentView) {
        this.componentView = componentView;
        componentView.setTag(this);
    }

    public Component getComponentView() {
        return componentView;
    }

    /**
     * Obtain the corresponding component according to the resource ID
     *
     * @param resId resId
     * @return Component
     */
    public Component getChildComponent(int resId) {
        Component view = childComponentMap.get(resId);
        if (view == null) {
            view = componentView.findComponentById(resId);
            childComponentMap.put(resId, view);
        }
        return view;
    }
}
