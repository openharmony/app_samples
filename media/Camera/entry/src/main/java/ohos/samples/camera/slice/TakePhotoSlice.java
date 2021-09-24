package ohos.samples.camera.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.Image;
import ohos.agp.components.surfaceprovider.SurfaceProvider;
import ohos.agp.graphics.Surface;
import ohos.agp.graphics.SurfaceOps;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.media.camera.CameraKit;
import ohos.media.camera.device.*;
import ohos.media.image.ImageReceiver;
import ohos.media.image.common.ImageFormat;
import ohos.samples.camera.ResourceTable;
import ohos.samples.camera.TakePhotoAbility;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static ohos.media.camera.device.Camera.FrameConfigType.FRAME_CONFIG_PICTURE;
import static ohos.media.camera.device.Camera.FrameConfigType.FRAME_CONFIG_PREVIEW;

public class TakePhotoSlice extends AbilitySlice {
    private static final String TAG = TakePhotoAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int SCREEN_WIDTH = 1080;

    private static final int SCREEN_HEIGHT = 1920;

    private static final int IMAGE_RCV_CAPACITY = 9;

    private SurfaceProvider surfaceProvider;

    private ImageReceiver imageReceiver;

    private boolean isFrontCamera;

    private Surface previewSurface;

    private Camera cameraDevice;

    private Component buttonGroupLayout;

    private ComponentContainer surfaceContainer;

    private final EventHandler eventHandler = new EventHandler(EventRunner.current()) {
    };

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
        if (surfaceProvider.getSurfaceOps().isPresent()) {
            surfaceProvider.getSurfaceOps().get().addCallback(new SurfaceCallBack());
        }
        surfaceContainer.addComponent(surfaceProvider);
    }

    private void initComponents() {
        buttonGroupLayout = findComponentById(ResourceTable.Id_directionalLayout);
        surfaceContainer = (ComponentContainer) findComponentById(ResourceTable.Id_surface_container);
        Image takePhotoImage = (Image) findComponentById(ResourceTable.Id_tack_picture_btn);
        Image exitImage = (Image) findComponentById(ResourceTable.Id_exit);
        Image switchCameraImage = (Image) findComponentById(ResourceTable.Id_switch_camera_btn);
        exitImage.setClickedListener(component -> terminateAbility());
        takePhotoImage.setClickedListener(this::takeSingleCapture);
        takePhotoImage.setLongClickedListener(this::takeMultiCapture);
        switchCameraImage.setClickedListener(this::switchCamera);
    }

    private void openCamera() {
        imageReceiver = ImageReceiver.create(SCREEN_WIDTH, SCREEN_HEIGHT, ImageFormat.JPEG, IMAGE_RCV_CAPACITY);
        imageReceiver.setImageArrivalListener(this::saveImage);
        CameraKit cameraKit = CameraKit.getInstance(getApplicationContext());
        String[] cameraList = cameraKit.getCameraIds();
        String cameraId = "";
        for (String logicalCameraId : cameraList) {
            int faceType = cameraKit.getCameraInfo(logicalCameraId).getFacingType();
            switch (faceType) {
                case CameraInfo.FacingType.CAMERA_FACING_FRONT:
                    if (isFrontCamera) {
                        cameraId = logicalCameraId;
                    }
                    break;
                case CameraInfo.FacingType.CAMERA_FACING_BACK:
                    if (!isFrontCamera) {
                        cameraId = logicalCameraId;
                    }
                    break;
                case CameraInfo.FacingType.CAMERA_FACING_OTHERS:
                default:
                    break;
            }
        }
        if (cameraId != null && !cameraId.isEmpty()) {
            CameraStateCallbackImpl cameraStateCallback = new CameraStateCallbackImpl();
            cameraKit.createCamera(cameraId, cameraStateCallback, eventHandler);
        }
    }

    private void saveImage(ImageReceiver receiver) {
        File saveFile = new File(getFilesDir(), "IMG_" + System.currentTimeMillis() + ".jpg");
        ohos.media.image.Image image = receiver.readNextImage();
        ohos.media.image.Image.Component component = image.getComponent(ImageFormat.ComponentType.JPEG);
        byte[] bytes = new byte[component.remaining()];
        component.read(bytes);
        try (FileOutputStream output = new FileOutputStream(saveFile)) {
            output.write(bytes);
            output.flush();
            String msg = "Take photo succeed";
            showTips(this, msg);
        } catch (IOException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "saveImage IOException");
        }
    }

    private void takeSingleCapture(Component component) {
        if (cameraDevice == null || imageReceiver == null) {
            return;
        }
        FrameConfig.Builder framePictureConfigBuilder = cameraDevice.getFrameConfigBuilder(FRAME_CONFIG_PICTURE);
        framePictureConfigBuilder.addSurface(imageReceiver.getRecevingSurface());
        FrameConfig pictureFrameConfig = framePictureConfigBuilder.build();
        cameraDevice.triggerSingleCapture(pictureFrameConfig);
    }

    private void takeMultiCapture(Component component) {
        FrameConfig.Builder framePictureConfigBuilder = cameraDevice.getFrameConfigBuilder(FRAME_CONFIG_PICTURE);
        framePictureConfigBuilder.addSurface(imageReceiver.getRecevingSurface());
        List<FrameConfig> frameConfigs = new ArrayList<>();
        FrameConfig firstFrameConfig = framePictureConfigBuilder.build();
        frameConfigs.add(firstFrameConfig);
        FrameConfig secondFrameConfig = framePictureConfigBuilder.build();
        frameConfigs.add(secondFrameConfig);
        cameraDevice.triggerMultiCapture(frameConfigs);
    }

    private void switchCamera(Component component) {
        isFrontCamera = !isFrontCamera;
        if (cameraDevice != null) {
            cameraDevice.release();
        }
        updateComponentVisible(false);
        openCamera();
    }

    private class CameraStateCallbackImpl extends CameraStateCallback {
        CameraStateCallbackImpl() {
        }

        @Override
        public void onCreated(Camera camera) {
            if (surfaceProvider.getSurfaceOps().isPresent()) {
                previewSurface = surfaceProvider.getSurfaceOps().get().getSurface();
            }
            if (previewSurface == null) {
                HiLog.error(LABEL_LOG, "%{public}s", "Create camera filed, preview surface is null");
                return;
            }
            CameraConfig.Builder cameraConfigBuilder = camera.getCameraConfigBuilder();
            cameraConfigBuilder.addSurface(previewSurface);
            cameraConfigBuilder.addSurface(imageReceiver.getRecevingSurface());
            camera.configure(cameraConfigBuilder.build());
            cameraDevice = camera;
            updateComponentVisible(true);
        }

        @Override
        public void onConfigured(Camera camera) {
            FrameConfig.Builder framePreviewConfigBuilder = camera.getFrameConfigBuilder(FRAME_CONFIG_PREVIEW);
            framePreviewConfigBuilder.addSurface(previewSurface);
            camera.triggerLoopingCapture(framePreviewConfigBuilder.build());
        }
    }

    private void updateComponentVisible(boolean isVisible) {
        buttonGroupLayout.setVisibility(isVisible ? Component.VISIBLE : Component.INVISIBLE);
    }

    private class SurfaceCallBack implements SurfaceOps.Callback {
        @Override
        public void surfaceCreated(SurfaceOps callbackSurfaceOps) {
            if (callbackSurfaceOps != null) {
                callbackSurfaceOps.setFixedSize(SCREEN_HEIGHT, SCREEN_WIDTH);
            }
            eventHandler.postTask(TakePhotoSlice.this::openCamera, 200);
        }

        @Override
        public void surfaceChanged(SurfaceOps callbackSurfaceOps, int format, int width, int height) {
        }

        @Override
        public void surfaceDestroyed(SurfaceOps callbackSurfaceOps) {
        }
    }

    private void showTips(Context context, String msg) {
        getUITaskDispatcher().asyncDispatch(() -> new ToastDialog(context).setText(msg).show());
    }

    private void releaseCamera() {
        if (cameraDevice != null) {
            cameraDevice.release();
        }

        if (imageReceiver != null) {
            imageReceiver.release();
        }
    }

    @Override
    protected void onStop() {
        releaseCamera();
    }
}
