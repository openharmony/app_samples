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

package ohos.samples.audio.slice;

import static ohos.media.audio.SoundPlayer.SoundType.KEYPRESS_STANDARD;
import static ohos.media.audio.ToneDescriptor.ToneType.DTMF_6;

import ohos.samples.audio.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.audio.AudioManager;
import ohos.media.audio.SoundPlayer;

/**
 * ShortSoundPlayerSlice
 *
 * @since 2020-12-22
 */
public class ShortSoundPlayerSlice extends AbilitySlice implements SoundPlayer.OnCreateCompleteListener {
    private static final String TAG = ShortSoundPlayerSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int TONE_SOUND_DURATION = 800;

    private SoundPlayer soundPlayer;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_short_sound_player_slice_layout);
        initComponents();
    }

    private void initComponents() {
        Component toneButton = findComponentById(ResourceTable.Id_tone_button);
        Component systemButton = findComponentById(ResourceTable.Id_system_button);
        Component musicPlayButton = findComponentById(ResourceTable.Id_music_button);

        toneButton.setClickedListener(component -> playToneSound());
        systemButton.setClickedListener(component -> playSystemSound());
        musicPlayButton.setClickedListener(this::playMusicSound);
    }

    private void playMusicSound(Component component) {
        releaseSoundPlayer();
        soundPlayer = new SoundPlayer(AudioManager.AudioVolumeType.STREAM_MUSIC.getValue());
        soundPlayer.createSound(getFilesDir() + "/sample.mp3");
        soundPlayer.setOnCreateCompleteListener(this);
    }

    @Override
    public void onCreateComplete(SoundPlayer soundPlayer, int cacheId, int status) {
        HiLog.info(LABEL_LOG, "%{public}s", "on create complete");
        if (status == 0) {
            int result = soundPlayer.play(cacheId);
            soundPlayer.setLoop(result, 2);
            soundPlayer.setPlaySpeedRate(result, 1.0f);
        }
    }

    private void playToneSound() {
        SoundPlayer toneSoundPlayer = new SoundPlayer();
        SoundPlayer.AudioVolumes audioVolumes = new SoundPlayer.AudioVolumes();
        toneSoundPlayer.createSound(DTMF_6, TONE_SOUND_DURATION);
        audioVolumes.setCentralVolume(1.0f);
        audioVolumes.setSubwooferVolume(1.0f);
        toneSoundPlayer.play();
    }

    private void playSystemSound() {
        SoundPlayer systemSoundPlayer = new SoundPlayer(getBundleName());
        systemSoundPlayer.playSound(KEYPRESS_STANDARD, 1.0f);
    }

    @Override
    protected void onStop() {
        releaseSoundPlayer();
    }

    private void releaseSoundPlayer() {
        if (soundPlayer != null) {
            soundPlayer.release();
        }
    }
}
