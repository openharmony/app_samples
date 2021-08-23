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

package ohos.samples.tictactoegame.utils;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.Text;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.app.Context;
import ohos.samples.tictactoegame.ResourceTable;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;
import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_PARENT;

/**
 * GameRulesUtils
 */
public class GameRulesUtils extends CommonDialog {
    private static final int RADIO_SIZE = 10;

    private final Context mContext;

    /**
     * create GameRulesUtils
     *
     * @param context the context
     */
    public GameRulesUtils(Context context) {
        super(context);
        this.mContext = context;
    }

    @Override
    protected void onCreate() {
        super.onCreate();
        Component rootView = LayoutScatter.getInstance(mContext).parse(ResourceTable.Layout_dialog_game_rule,
            null, false);
        Text operateYes = (Text) rootView.findComponentById(ResourceTable.Id_rule_yes);
        operateYes.setClickedListener(component -> hide());
        setSize(MATCH_PARENT, MATCH_CONTENT);
        setAlignment(LayoutAlignment.BOTTOM);
        setCornerRadius(RADIO_SIZE);
        setAutoClosable(true);
        setContentCustomComponent(rootView);
        setTransparent(true);
    }
}
