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

package ohos.samples.audioplayer;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Text;
import ohos.media.common.Source;
import ohos.media.player.Player;
import ohos.samples.audioplayer.utils.LogUtil;
import ohos.samples.audioplayer.utils.ThreadPoolManager;


/**
 * OtherWayToPlay class
 */
public class OnlinePlayClient extends Ability {
    private static final String TAG = OnlinePlayClient.class.getSimpleName();

    private static final String WEB_PATH = "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/"
            + "cae-legoup-video-target/93be3d88-9fc2-4fbd-bd14-833bca731ca7.mp4";

    private Player player;

    private Button playButton;

    private Runnable playRunnable;

    private boolean isPrepared;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_online_play_layout);

        initMedia();
    }

    private void initMedia() {
        player = new Player(getApplicationContext());
        playRunnable = new PlayRunnable();
        ThreadPoolManager.getInstance().execute(playRunnable);
    }

    @Override
    protected void onActive() {
        super.onActive();

        Text uriText = (Text) findComponentById(ResourceTable.Id_input_uri);
        playButton = (Button) findComponentById(ResourceTable.Id_play_button);
        uriText.setText(WEB_PATH);
        playButton.setClickedListener(component -> playOrPause());
    }

    private void playOrPause() {
        if (player == null) {
            LogUtil.warn(TAG, "player is null.");
            return;
        }

        if (player.isNowPlaying()) {
            pause();
            return;
        }
        play();
    }

    private void pause() {
        player.pause();
        playButton.setText(ResourceTable.String_play);
    }

    private void play() {
        if (!isPrepared) {
            LogUtil.warn(TAG, "prepare failed");
            return;
        }
        if (!player.play()) {
            LogUtil.warn(TAG, "play failed");
            return;
        }
        playButton.setText(ResourceTable.String_pause);
    }

    private class PlayRunnable implements Runnable {
        @Override
        public void run() {
            Source source = new Source(WEB_PATH);
            if (!player.setSource(source)) {
                LogUtil.warn(TAG, "uri is invalid");
                return;
            }
            isPrepared = player.prepare();
        }
    }

    @Override
    protected void onInactive() {
        super.onInactive();
        pause();
    }

    @Override
    protected void onStop() {
        super.onStop();
        release();
    }

    private void release() {
        if (player != null) {
            player.stop();
            player.release();
        }
        ThreadPoolManager.getInstance().cancel(playRunnable);
    }
}
