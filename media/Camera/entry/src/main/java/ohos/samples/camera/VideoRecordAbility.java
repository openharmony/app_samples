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

package ohos.samples.camera;

import static ohos.media.camera.device.Camera.FrameConfigType.FRAME_CONFIG_PREVIEW;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.Image;
import ohos.agp.components.surfaceprovider.SurfaceProvider;
import ohos.agp.graphics.Surface;
import ohos.agp.graphics.SurfaceOps;
import ohos.agp.window.dialog.ToastDialog;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.camera.CameraKit;
import ohos.media.camera.device.Camera;
import ohos.media.camera.device.CameraConfig;
import ohos.media.camera.device.CameraStateCallback;
import ohos.media.camera.device.FrameConfig;
import ohos.media.common.AudioProperty;
import ohos.media.common.Source;
import ohos.media.common.StorageProperty;
import ohos.media.common.VideoProperty;
import ohos.media.recorder.Recorder;
import ohos.multimodalinput.event.TouchEvent;

import java.io.File;

/**
 * VideoRecordAbility
 */
public class VideoRecordAbility extends Ability {
    private static final String TAG = VideoRecordAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private SurfaceProvider surfaceProvider;

    private Surface recorderSurface;

    private Surface previewSurface;

    private boolean isFrontCamera;

    private Camera cameraDevice;

    private Component buttonGroupLayout;

    private Recorder mediaRecorder;

    private ComponentContainer surfaceContainer;

    private CameraConfig.Builder cameraConfigBuilder;

    private boolean isRecording;

    private final Object lock = new Object();

    private EventHandler eventHandler = new EventHandler(EventRunner.current()) { };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_camera_slice);

        initComponents();
        initSurface();
    }

    private void initSurface() {
        getWindow().setTransparent(true);
        DirectionalLayout.LayoutConfig params = new DirectionalLayout.LayoutConfig(
            ComponentContainer.LayoutConfig.MATCH_PARENT, ComponentContainer.LayoutConfig.MATCH_PARENT);
        surfaceProvider = new SurfaceProvider(this);
        surfaceProvider.setLayoutConfig(params);
        surfaceProvider.pinToZTop(false);
        surfaceProvider.getSurfaceOps().get().addCallback(new SurfaceCallBack());
        surfaceContainer.addComponent(surfaceProvider);
    }

    private void initComponents() {
        buttonGroupLayout = findComponentById(ResourceTable.Id_directionalLayout);
        surfaceContainer = (ComponentContainer) findComponentById(ResourceTable.Id_surface_container);
        Image videoRecord = (Image) findComponentById(ResourceTable.Id_tack_picture_btn);
        Image exitImage = (Image) findComponentById(ResourceTable.Id_exit);
        Image switchCameraImage = (Image) findComponentById(ResourceTable.Id_switch_camera_btn);
        exitImage.setClickedListener(component -> terminateAbility());
        switchCameraImage.setClickedListener(this::switchCamera);

        videoRecord.setLongClickedListener(component -> {
            startRecord();
            isRecording = true;
            videoRecord.setPixelMap(ResourceTable.Media_ic_camera_video_press);
        });

        videoRecord.setTouchEventListener((component, touchEvent) -> {
            if (touchEvent != null && touchEvent.getAction() == TouchEvent.PRIMARY_POINT_UP && isRecording) {
                stopRecord();
                isRecording = false;
                videoRecord.setPixelMap(ResourceTable.Media_ic_camera_video_ready);
            }
            return true;
        });
    }

    private void initMediaRecorder() {
        mediaRecorder = new Recorder();
        VideoProperty.Builder videoPropertyBuilder = new VideoProperty.Builder();
        videoPropertyBuilder.setRecorderBitRate(10000000);
        videoPropertyBuilder.setRecorderDegrees(90);
        videoPropertyBuilder.setRecorderFps(30);
        videoPropertyBuilder.setRecorderHeight(Math.min(1440, 720));
        videoPropertyBuilder.setRecorderWidth(Math.max(1440, 720));
        videoPropertyBuilder.setRecorderVideoEncoder(Recorder.VideoEncoder.H264);
        videoPropertyBuilder.setRecorderRate(30);

        Source source = new Source();
        source.setRecorderAudioSource(Recorder.AudioSource.MIC);
        source.setRecorderVideoSource(Recorder.VideoSource.SURFACE);
        mediaRecorder.setSource(source);
        mediaRecorder.setOutputFormat(Recorder.OutputFormat.MPEG_4);
        File file = new File(getFilesDir(), "VID_" + System.currentTimeMillis() + ".mp4");
        StorageProperty.Builder storagePropertyBuilder = new StorageProperty.Builder();
        storagePropertyBuilder.setRecorderFile(file);
        mediaRecorder.setStorageProperty(storagePropertyBuilder.build());

        AudioProperty.Builder audioPropertyBuilder = new AudioProperty.Builder();
        audioPropertyBuilder.setRecorderAudioEncoder(Recorder.AudioEncoder.AAC);
        mediaRecorder.setAudioProperty(audioPropertyBuilder.build());
        mediaRecorder.setVideoProperty(videoPropertyBuilder.build());
        mediaRecorder.prepare();
    }

    private void openCamera() {
        CameraKit cameraKit = CameraKit.getInstance(getApplicationContext());
        String[] cameraList = cameraKit.getCameraIds();
        String cameraId = cameraList.length > 1 && isFrontCamera ? cameraList[1] : cameraList[0];
        CameraStateCallbackImpl cameraStateCallback = new CameraStateCallbackImpl();
        cameraKit.createCamera(cameraId, cameraStateCallback, eventHandler);
    }

    private void switchCamera(Component component) {
        isFrontCamera = !isFrontCamera;
        updateComponentVisible(false);
        openCamera();
    }

    private class CameraStateCallbackImpl extends CameraStateCallback {
        CameraStateCallbackImpl() {
        }

        @Override
        public void onCreated(Camera camera) {
            previewSurface = surfaceProvider.getSurfaceOps().get().getSurface();
            if (previewSurface == null) {
                HiLog.error(LABEL_LOG, "%{public}s", "Create camera filed, preview surface is null");
                return;
            }
            cameraConfigBuilder = camera.getCameraConfigBuilder();
            cameraConfigBuilder.addSurface(previewSurface);
            camera.configure(cameraConfigBuilder.build());
            cameraDevice = camera;
            updateComponentVisible(true);
        }

        @Override
        public void onConfigured(Camera camera) {
            FrameConfig.Builder frameConfigBuilder = camera.getFrameConfigBuilder(FRAME_CONFIG_PREVIEW);
            frameConfigBuilder.addSurface(previewSurface);
            if (isRecording && recorderSurface != null) {
                frameConfigBuilder.addSurface(recorderSurface);
            }
            camera.triggerLoopingCapture(frameConfigBuilder.build());
            if (isRecording) {
                eventHandler.postTask(() -> mediaRecorder.start());
            }
        }
    }

    private void startRecord() {
        if (cameraDevice == null) {
            HiLog.error(LABEL_LOG, "%{public}s", "startRecord failed, parameters is illegal");
            return;
        }
        synchronized (lock) {
            initMediaRecorder();
            recorderSurface = mediaRecorder.getVideoSurface();
            cameraConfigBuilder = cameraDevice.getCameraConfigBuilder();
            try {
                cameraConfigBuilder.addSurface(previewSurface);
                if (recorderSurface != null) {
                    cameraConfigBuilder.addSurface(recorderSurface);
                }
                cameraDevice.configure(cameraConfigBuilder.build());
            } catch (IllegalStateException | IllegalArgumentException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "startRecord IllegalStateException | IllegalArgumentException");
            }
        }
        new ToastDialog(this).setText("Recording").show();
    }

    private void stopRecord() {
        synchronized (lock) {
            try {
                eventHandler.postTask(() -> mediaRecorder.stop());
                if (cameraDevice == null || cameraDevice.getCameraConfigBuilder() == null) {
                    HiLog.error(LABEL_LOG, "%{public}s", "StopRecord cameraDevice or getCameraConfigBuilder is null");
                    return;
                }
                cameraConfigBuilder = cameraDevice.getCameraConfigBuilder();
                cameraConfigBuilder.addSurface(previewSurface);
                cameraConfigBuilder.removeSurface(recorderSurface);
                cameraDevice.configure(cameraConfigBuilder.build());
            } catch (IllegalStateException | IllegalArgumentException exception) {
                HiLog.error(LABEL_LOG, "%{public}s", "stopRecord occur exception");
            }
        }
        new ToastDialog(this).setText("video saved").show();
    }

    private void updateComponentVisible(boolean isVisible) {
        buttonGroupLayout.setVisibility(isVisible ? Component.VISIBLE : Component.INVISIBLE);
    }

    private class SurfaceCallBack implements SurfaceOps.Callback {
        @Override
        public void surfaceCreated(SurfaceOps callbackSurfaceOps) {
            openCamera();
        }

        @Override
        public void surfaceChanged(SurfaceOps callbackSurfaceOps, int format, int width, int height) {
        }

        @Override
        public void surfaceDestroyed(SurfaceOps callbackSurfaceOps) {
        }
    }

    private void releaseCamera() {
        if (cameraDevice != null) {
            cameraDevice.release();
        }
    }

    @Override
    protected void onStop() {
        releaseCamera();
    }
}
