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

import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.Image;
import ohos.agp.components.LayoutScatter;
import ohos.agp.utils.LayoutAlignment;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.samples.tictactoegame.ResourceTable;

/**
 * Game Status Utils
 */
public class GameStatusUtils {
    private static final int DIS_FAILED = 0;
    private static final int DIS_WIN = 1;
    private static final int DIS_TIE = 3;

    private static final int SHOW_TIMES = 1000;

    /**
     * showTip
     *
     * @param context the context
     * @param durationTime show times
     * @param flag image type
     */
    public static void showTip(Context context, int durationTime, int flag) {
        DirectionalLayout toastLayout = (DirectionalLayout) LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_game_status, null, false);

        Image img = (Image) toastLayout.findComponentById(ResourceTable.Id_img_gameStatus);
        if (flag == DIS_FAILED) {
            img.setPixelMap(ResourceTable.Media_game_fail);
        }
        if (flag == DIS_WIN) {
            img.setPixelMap(ResourceTable.Media_game_win);
        }
        if (flag == DIS_TIE) {
            img.setPixelMap(ResourceTable.Media_game_tie);
        }
        new ToastDialog(context)
                .setContentCustomComponent(toastLayout)
                .setSize(DirectionalLayout.LayoutConfig.MATCH_CONTENT, DirectionalLayout.LayoutConfig.MATCH_CONTENT)
                .setAlignment(LayoutAlignment.CENTER)
                .setDuration(durationTime)
                .show();
    }

    /**
     * showWin
     *
     * @param context the context
     */
    public static void showWin(Context context) {
        showTip(context, SHOW_TIMES, DIS_WIN);
    }

    /**
     * showFaild
     *
     * @param context the context
     */
    public static void showFaild(Context context) {
        showTip(context, SHOW_TIMES, DIS_FAILED);
    }

    /**
     * showTie
     *
     * @param context the context
     */
    public static void showTie(Context context) {
        showTip(context, SHOW_TIMES, DIS_TIE);
    }
}

