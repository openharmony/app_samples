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
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.dispatcher.task.TaskPriority;
import ohos.media.audio.AudioCapturer;
import ohos.media.audio.AudioCapturerCallback;
import ohos.media.audio.AudioCapturerConfig;
import ohos.media.audio.AudioCapturerInfo;
import ohos.media.audio.AudioDeviceDescriptor;
import ohos.media.audio.AudioManager;
import ohos.media.audio.AudioStreamInfo;
import ohos.samples.audio.utils.HiLogUtils;
import ohos.samples.audio.utils.ShellUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * AudioRecorderSlice
 */
public class AudioRecorderSlice extends AbilitySlice {
    private static final String TAG = AudioRecorderSlice.class.getName();

    private static final int SAMPLE_RATE = 44100;

    private static final int BUFFER_SIZE = 1024;

    private Button recordButton;

    private AudioManager audioManager = new AudioManager();

    private AudioCapturer audioCapturer;

    private File file = null;

    private boolean isRecording = false;

    private Text pathText;

    private final AudioCapturerCallback callback = new AudioCapturerCallback() {
        @Override
        public void onCapturerConfigChanged(List<AudioCapturerConfig> configs) {
            HiLogUtils.info(TAG, "on capturer config changed");
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_audio_recorder_slice_layout);
        initComponents();
        initRecord();
    }

    private void initComponents() {
        recordButton = (Button) findComponentById(ResourceTable.Id_main_start_recoding);
        pathText = (Text) findComponentById(ResourceTable.Id_path_text);
        recordButton.setClickedListener((Component component)->{
            if (isRecording && audioCapturer != null) {
                stopRecord();
                return;
            }
            startRecord();
        });
    }

    private void initRecord() {
        audioManager.registerAudioCapturerCallback(callback);
        AudioDeviceDescriptor[] devices = AudioManager.getDevices(AudioDeviceDescriptor.DeviceFlag.INPUT_DEVICES_FLAG);
        AudioDeviceDescriptor currentAudioType = devices[0];
        AudioCapturerInfo.AudioInputSource source = AudioCapturerInfo.AudioInputSource.AUDIO_INPUT_SOURCE_MIC;
        AudioStreamInfo audioStreamInfo = new AudioStreamInfo.Builder().audioStreamFlag(
                AudioStreamInfo.AudioStreamFlag.AUDIO_STREAM_FLAG_AUDIBILITY_ENFORCED)
                .encodingFormat(AudioStreamInfo.EncodingFormat.ENCODING_PCM_16BIT)
                .channelMask(AudioStreamInfo.ChannelMask.CHANNEL_IN_STEREO)
                .streamUsage(AudioStreamInfo.StreamUsage.STREAM_USAGE_MEDIA)
                .sampleRate(SAMPLE_RATE)
                .build();
        AudioCapturerInfo audioCapturerInfo = new AudioCapturerInfo.Builder().audioStreamInfo(audioStreamInfo)
                .audioInputSource(source)
                .build();
        audioCapturer = new AudioCapturer(audioCapturerInfo, currentAudioType);
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (audioCapturer != null) {
            audioCapturer.stop();
            audioCapturer.release();
        }
        audioManager.unregisterAudioCapturerCallback(callback);
        audioManager = null;
    }

    private void stopRecord() {
        if (audioCapturer.stop()) {
            isRecording = false;
            recordButton.setText("Start");
            showTips("Stop record");
            pathText.setText("Path:" + getFilesDir() + File.separator + "record.pcm");
            String wavPath = getFilesDir() + File.separator + "record.wav";
            ShellUtils.tranPcmToWavFile(file, wavPath);
            pathText.setText("Path:" + getFilesDir() + File.separator + "record.wav");
        }
    }

    private void startRecord() {
        if (audioCapturer.start()) {
            isRecording = true;
            recordButton.setText("Stop");
            showTips("Start record");
            runRecord();
        }
    }

    private void runRecord(){
        getGlobalTaskDispatcher(TaskPriority.DEFAULT).asyncDispatch(() -> {
            file = new File(getFilesDir() + File.separator + "record.pcm");
            try (FileOutputStream outputStream = new FileOutputStream(file)) {
                byte[] bytes = new byte[BUFFER_SIZE];
                while (audioCapturer.read(bytes, 0, bytes.length) != -1) {
                    outputStream.write(bytes);
                    bytes = new byte[BUFFER_SIZE];
                    outputStream.flush();
                }
            } catch (IOException exception) {
                HiLogUtils.error(TAG, "record exception," + exception.getMessage());
            }
        });
    }

    private void showTips(String message) {
        new ToastDialog(this).setText(message).show();
    }
}
