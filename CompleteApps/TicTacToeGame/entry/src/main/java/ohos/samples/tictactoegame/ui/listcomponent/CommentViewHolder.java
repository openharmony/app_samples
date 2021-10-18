/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.All rights reserved.
 * Licensed under the Apache License,Version 2.0 (the "License");
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

package ohos.samples.tictactoegame.ui.listcomponent;

import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.app.Context;

import java.util.HashMap;
import java.util.Map;

/**
 * CommentViewHolder
 */
public class CommentViewHolder {
    private final Component convertView;
    private final Map<Integer, Component> mViews = new HashMap<>();

    /**
     * CommentViewHolder
     *
     * @param convertView the component view
     */
    public CommentViewHolder(Component convertView) {
        this.convertView = convertView;
        convertView.setTag(this);
    }

    /**
     * CommentViewHolder
     *
     * @param context the context
     * @param convertView the component view
     * @param resource the resource id
     * @return CommentViewHolder
     */
    public static CommentViewHolder getCommentViewHolder(Context context, Component convertView, int resource) {
        if (convertView == null) {
            convertView = LayoutScatter.getInstance(context).parse(resource, null, false);
            return new CommentViewHolder(convertView);
        } else {
            return (CommentViewHolder) convertView.getTag();
        }
    }


    @SuppressWarnings("unchecked")
    private <T extends Component> T getView(int resId) {
        Component view = mViews.get(resId);
        if (view == null) {
            view = convertView.findComponentById(resId);
            mViews.put(resId, view);
        }
        return (T) view;
    }

    /**
     * getTextView
     *
     * @param resId the resource id
     * @return Text widget
     */
    public Text getTextView(int resId) {
        return getView(resId);
    }

    /**
     * getImageView
     *
     * @param resId the resource id
     * @return Image widget
     */
    public Image getImageView(int resId) {
        return getView(resId);
    }

    /**
     * getConvertView
     *
     * @return Component
     */
    public Component getConvertView() {
        return convertView;
    }
}
