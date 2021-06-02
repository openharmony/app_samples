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

package ohos.samples.distributedmusicplayer.slice;

import ohos.samples.distributedmusicplayer.ResourceTable;
import ohos.samples.distributedmusicplayer.utils.LogUtil;
import ohos.samples.distributedmusicplayer.utils.PlayerManager;
import ohos.samples.distributedmusicplayer.utils.PlayerStateListener;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityContinuation;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.agp.components.Component;
import ohos.agp.components.Image;
import ohos.agp.components.Slider;
import ohos.agp.components.Text;

import java.lang.ref.WeakReference;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * main ability slice
 */
public class MainAbilitySlice extends AbilitySlice implements PlayerStateListener, IAbilityContinuation {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final String KEY_CURRENT_TIME = "main_ability_slice_current_time";

    private static final String KEY_POSITION = "main_ability_slice_position";

    private static final String KEY_PLAY_STATE = "main_ability_slice_play_state";

    private static final String URI1 = "resources/rawfile/Technology.mp3";

    private static final String URI2 = "resources/rawfile/Homey.mp3";

    private String[] musics = {URI1, URI2};

    private int[] posters = {ResourceTable.Media_album, ResourceTable.Media_album2};

    private PlayerManager playerManager;

    private Text musicNameText;

    private Text currentTimeText;

    private Text totalTimeText;

    private Slider slider;

    private Image musicPlayButton;

    private int currentPos = 0;

    private String currentUri;

    private boolean isInteractionPlay;

    private int currentTime;

    private boolean isPlaying;

    private Image musicPosters;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
        initMedia();
        updateUI();
        remotePlay();
    }

    private void initMedia() {
        currentUri = musics[currentPos];
        playerManager = new PlayerManager(getApplicationContext(), currentUri);
        WeakReference<PlayerStateListener> playerStateListener = new WeakReference<>(this);
        playerManager.setPlayerStateListener(playerStateListener.get());
        playerManager.init();
    }

    private void initComponents() {
        musicNameText = (Text) findComponentById(ResourceTable.Id_music_name);
        currentTimeText = (Text) findComponentById(ResourceTable.Id_play_progress_time);
        totalTimeText = (Text) findComponentById(ResourceTable.Id_play_total_time);
        slider = (Slider) findComponentById(ResourceTable.Id_play_progress_bar);
        musicPosters = (Image) findComponentById(ResourceTable.Id_music_posters);

        musicPlayButton = (Image) findComponentById(ResourceTable.Id_music_play_btn);
        findComponentById(ResourceTable.Id_remote_play).setClickedListener(component -> continueAbility());
        findComponentById(ResourceTable.Id_music_play_prev_btn).setClickedListener(this::prevMusic);
        findComponentById(ResourceTable.Id_music_play_next_btn).setClickedListener(this::nextMusic);

        musicPlayButton.setClickedListener(this::playOrPauseMusic);
        slider.setValueChangedListener(new ValueChangedListenerImpl());
    }

    private void updateUI() {
        musicPosters.setPixelMap(posters[currentPos]);
        currentTimeText.setText(getTime(currentTime));
        totalTimeText.setText(getTime(playerManager.getTotalTime()));
        slider.setMaxValue(playerManager.getTotalTime());
        slider.setProgressValue(currentTime);
    }

    private void nextMusic(Component component) {
        currentPos = currentPos == 0 ? 1 : 0;
        currentUri = musics[currentPos];
        playerManager.switchMusic(currentUri);
    }

    private void playOrPauseMusic(Component component) {
        playOrPause();
    }

    private void prevMusic(Component component) {
        currentPos = currentPos == 0 ? 1 : 0;
        currentUri = musics[currentPos];
        playerManager.switchMusic(currentUri);
    }

    private void remotePlay() {
        if (isInteractionPlay) {
            playerManager.rewindTo(currentTime);
            if (!isPlaying) {
                return;
            }
            playerManager.play();
        }
    }

    private void playOrPause() {
        if (playerManager.isPlaying()) {
            playerManager.pause();
            return;
        }
        playerManager.play();
    }

    @Override
    protected void onInactive() {
        super.onInactive();
        playerManager.pause();
    }

    @Override
    protected void onStop() {
        super.onStop();
        playerManager.releasePlayer();
    }

    @Override
    public void onPlaySuccess(int totalTime) {
        musicPlayButton.setPixelMap(ResourceTable.Media_ic_himusic_pause);
        this.totalTimeText.setText(getTime(totalTime));
        slider.setMaxValue(totalTime);
        musicPosters.setPixelMap(posters[currentPos]);
    }

    @Override
    public void onPauseSuccess() {
        musicPlayButton.setPixelMap(ResourceTable.Media_ic_himusic_play);
    }

    @Override
    public void onUriSet(String name) {
        musicNameText.setText(name);
    }

    @Override
    public void onPositionChange(int currentTime) {
        LogUtil.info(TAG, "onPositionChange currentTime = " + currentTime);
        this.currentTime = currentTime;
        this.currentTimeText.setText(getTime(currentTime));
        slider.setProgressValue(currentTime);
    }

    @Override
    public void onMusicFinished() {
        currentPos = currentPos == 0 ? 1 : 0;
        currentUri = musics[currentPos];
        playerManager.switchMusic(currentUri);
    }

    @Override
    public boolean onStartContinuation() {
        return true;
    }

    @Override
    public boolean onSaveData(IntentParams intentParams) {
        intentParams.setParam(KEY_CURRENT_TIME, currentTime);
        intentParams.setParam(KEY_POSITION, currentPos);
        intentParams.setParam(KEY_PLAY_STATE, String.valueOf(playerManager.isPlaying()));
        LogUtil.info(TAG, "onSaveData:" + currentTime);
        return true;
    }

    @Override
    public boolean onRestoreData(IntentParams intentParams) {
        if (!(intentParams.getParam(KEY_POSITION) instanceof Integer)) {
            return false;
        }
        if (!(intentParams.getParam(KEY_CURRENT_TIME) instanceof Integer)) {
            return false;
        }
        if (!(intentParams.getParam(KEY_PLAY_STATE) instanceof String)) {
            return false;
        }
        currentPos = (int) intentParams.getParam(KEY_POSITION);
        currentTime = (int) intentParams.getParam(KEY_CURRENT_TIME);
        Object object = intentParams.getParam(KEY_PLAY_STATE);
        if (object instanceof String) {
            isPlaying = Boolean.parseBoolean((String) object);
        }
        isInteractionPlay = true;
        LogUtil.info(TAG, "onRestoreData:" + currentTime);
        return true;
    }

    @Override
    public void onCompleteContinuation(int i) {
        terminate();
    }

    private class ValueChangedListenerImpl implements Slider.ValueChangedListener {
        @Override
        public void onProgressUpdated(Slider slider, int progress, boolean fromUser) {
            currentTime = progress;
        }

        @Override
        public void onTouchStart(Slider slider) {
            LogUtil.debug(TAG, "onTouchStart");
        }

        @Override
        public void onTouchEnd(Slider slider) {
            playerManager.rewindTo(currentTime);
            currentTimeText.setText(getTime(currentTime));
        }
    }

    private String getTime(int time) {
        Date date = new Date(time);
        DateFormat dateFormat = new SimpleDateFormat("mm:ss");
        return dateFormat.format(date);
    }
}
