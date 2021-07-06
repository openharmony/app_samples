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

import ohos.samples.audio.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.audio.AudioInterrupt;
import ohos.media.audio.AudioManager;
import ohos.media.audio.AudioRenderer;
import ohos.media.audio.AudioRendererInfo;
import ohos.media.audio.AudioStreamInfo;
import ohos.media.codec.Codec;
import ohos.media.common.BufferInfo;
import ohos.media.common.Source;

import java.nio.ByteBuffer;

/**
 * PlayerSlice
 */
public class PlayerSlice extends AbilitySlice {
    private static final String TAG = PlayerSlice.class.getName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int SAMPLE_RATE = 44100;

    private static final int BUFFER_SIZE = 1024;

    private AudioRenderer audioRenderer;

    private Codec codec;

    private boolean isPlaying;

    private Button playButton;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_player_slice_layout);
        initComponents();
        initAudioRenderer();
    }

    private void initComponents() {
        playButton = (Button) findComponentById(ResourceTable.Id_playButton);
        playButton.setClickedListener(component -> play());
    }

    private void initAudioRenderer() {
        AudioStreamInfo audioStreamInfo = new AudioStreamInfo.Builder().sampleRate(SAMPLE_RATE)
            .audioStreamFlag(AudioStreamInfo.AudioStreamFlag.AUDIO_STREAM_FLAG_MAY_DUCK)
            .encodingFormat(AudioStreamInfo.EncodingFormat.ENCODING_PCM_16BIT)
            .channelMask(AudioStreamInfo.ChannelMask.CHANNEL_OUT_STEREO)
            .streamUsage(AudioStreamInfo.StreamUsage.STREAM_USAGE_MEDIA)
            .build();
        AudioRendererInfo audioRendererInfo = new AudioRendererInfo.Builder().audioStreamInfo(audioStreamInfo)
            .audioStreamOutputFlag(AudioRendererInfo.AudioStreamOutputFlag.AUDIO_STREAM_OUTPUT_FLAG_DIRECT_PCM)
            .bufferSizeInBytes(BUFFER_SIZE)
            .isOffload(false)
            .sessionID(AudioRendererInfo.SESSION_ID_UNSPECIFIED)
            .build();
        audioRenderer = new AudioRenderer(audioRendererInfo, AudioRenderer.PlayMode.MODE_STREAM);
        audioRenderer.setVolume(1.0f);
        audioRenderer.setSpeed(1.0f);
        setPlayCallback(audioStreamInfo);
    }

    private void play() {
        if (isPlaying) {
            audioRenderer.pause();
            isPlaying = false;
            playButton.setText("Play");
        } else {
            audioRenderer.start();
            decoderAudio();
            isPlaying = true;
            playButton.setText("Pause");
        }
    }

    private void setPlayCallback(AudioStreamInfo streamInfo) {
        AudioInterrupt audioInterrupt = new AudioInterrupt();
        AudioManager audioManager = new AudioManager();
        audioInterrupt.setStreamInfo(streamInfo);
        audioInterrupt.setInterruptListener((type, hint) -> {
            if (type == AudioInterrupt.INTERRUPT_TYPE_BEGIN && hint == AudioInterrupt.INTERRUPT_HINT_PAUSE) {
                HiLog.info(LABEL_LOG, "%{public}s", "sound paused");
            } else if (type == AudioInterrupt.INTERRUPT_TYPE_BEGIN && hint == AudioInterrupt.INTERRUPT_HINT_STOP) {
                HiLog.info(LABEL_LOG, "%{public}s", "sound stopped");
            } else if (type == AudioInterrupt.INTERRUPT_TYPE_END && (hint == AudioInterrupt.INTERRUPT_HINT_RESUME)) {
                HiLog.info(LABEL_LOG, "%{public}s", "sound resumed");
            } else {
                HiLog.info(LABEL_LOG, "%{public}s", "unknown state");
            }
        });
        audioManager.activateAudioInterrupt(audioInterrupt);
    }

    private void decoderAudio() {
        if (codec == null) {
            codec = Codec.createDecoder();
        } else {
            codec.stop();
        }

        Source source = new Source(getFilesDir() + "/sample.mp3");
        codec.setSource(source, null);
        codec.registerCodecListener(new Codec.ICodecListener() {
            @Override
            public void onReadBuffer(ByteBuffer outputBuffer, BufferInfo bufferInfo, int trackId) {
                audioRenderer.write(outputBuffer, bufferInfo.size);
            }

            @Override
            public void onError(int errorCode, int act, int trackId) {
                HiLog.error(LABEL_LOG, "%{public}s", "codec registerCodecListener error");
            }
        });
        codec.start();
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (codec != null) {
            codec.stop();
        }
        if (audioRenderer != null) {
            audioRenderer.release();
        }
    }
}
