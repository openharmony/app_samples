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

import ohos.agp.components.*;
import ohos.samples.audioplayer.utils.LogUtil;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.bundle.ElementName;
import ohos.bundle.IBundleManager;
import ohos.media.common.AVMetadata;
import ohos.media.common.sessioncore.AVConnectionCallback;
import ohos.media.common.sessioncore.AVControllerCallback;
import ohos.media.common.sessioncore.AVElement;
import ohos.media.common.sessioncore.AVPlaybackState;
import ohos.media.common.sessioncore.AVQueueElement;
import ohos.media.common.sessioncore.AVSubscriptionCallback;
import ohos.media.sessioncore.AVBrowser;
import ohos.media.sessioncore.AVController;
import ohos.security.SystemPermission;
import ohos.utils.PacMap;
import ohos.utils.net.Uri;

import java.util.ArrayList;
import java.util.List;

/**
 * The client of the player, that implements a AVBrowser.
 */
public class AVPlayClient extends Ability {
    private static final String TAG = AVPlayClient.class.getSimpleName();

    // provide the main client function of media framework
    private AVBrowser avBrowser;

    // provide the operations by the avBrowser
    private AVController avController;

    private Button playButton;

    private Button previousButton;

    private Button nextButton;

    private Text titleText;

    private Text progressText;

    private Text totalTimeText;

    // the media list got from the service
    private List<AVElement> avElementList = new ArrayList<>();

    private AVElementItemProvider avElementsListItemProvider;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        LogUtil.info(TAG, "onStart");
        super.setUIContent(ResourceTable.Layout_main_play_layout);

        // bind the handler for all the components
        previousButton = (Button) findComponentById(ResourceTable.Id_to_previous_button);
        previousButton.setClickedListener(component -> handlerPrevEvent());
        nextButton = (Button) findComponentById(ResourceTable.Id_to_next_button);
        nextButton.setClickedListener(component -> handlerNextEvent());
        playButton = (Button) findComponentById(ResourceTable.Id_play_button);
        playButton.setClickedListener(component -> handlerPlayEvent());

        titleText = (Text) findComponentById(ResourceTable.Id_audio_title);
        progressText = (Text) findComponentById(ResourceTable.Id_audio_progress);
        totalTimeText = (Text) findComponentById(ResourceTable.Id_audio_total_time);
        ListContainer avElementsListContainer = (ListContainer) findComponentById(ResourceTable.Id_play_list);

        avElementsListItemProvider = new AVElementItemProvider();
        avElementsListContainer.setItemProvider(avElementsListItemProvider);
        Component jumpComponent = findComponentById(ResourceTable.Id_jump_to_next_page_button);
        jumpComponent.setClickedListener(component -> jumpOnline());
        // init the avBrowser and connect the browser service
        ElementName elementName = new ElementName("", AVPlayService.class.getPackage().getName(),
            AVPlayService.class.getName());
        avBrowser = new AVBrowser(this, elementName, avConnectionCallback, null);
        connectService();
    }

    private void jumpOnline() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withBundleName(
            OnlinePlayClient.class.getPackage().getName()).withAbilityName(OnlinePlayClient.class.getName()).build();
        intent.setOperation(operation);
        startAbility(intent);
    }

    @Override
    protected void onStop() {
        LogUtil.info(TAG, "onStop");
        super.onStop();
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withBundleName(AVPlayService.class.getPackage().getName())
            .withAbilityName(AVPlayService.class.getName())
            .build();
        intent.setOperation(operation);
        stopAbility(intent);

        if (avBrowser != null && avBrowser.isConnected()) {
            avBrowser.disconnect();
        }
    }

    /**
     * create the list of audios
     */
    class AVElementItemProvider extends BaseItemProvider {
        @Override
        public int getCount() {
            return avElementList.size();
        }

        @Override
        public Object getItem(int position) {
            return avElementList.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
            final AVElement item = avElementList.get(position);
            if (component == null && item != null) {
                String itemText = item.getAVDescription().getTitle().toString();
                Text text = (Text) LayoutScatter.getInstance(AVPlayClient.this)
                    .parse(ResourceTable.Layout_list_item, null, false);
                text.setText(itemText);
                return text;
            } else {
                return component;
            }
        }
    }

    private final AVConnectionCallback avConnectionCallback = new AVConnectionCallback() {
        @Override
        public void onConnected() {
            LogUtil.info(TAG + "-AVConnectionCallback", "onConnected");
            // before subscribe, first to unsubscribe, it's necessary.
            avBrowser.unsubscribeByParentMediaId(AVPlayService.PARENT_MEDIA_ID_1);
            // onLoadAVElementList() on service will be called if subscribed.
            avBrowser.subscribeByParentMediaId(AVPlayService.PARENT_MEDIA_ID_1, avSubscriptionCallback);
        }

        @Override
        public void onDisconnected() {
            LogUtil.warn(TAG + "-AVConnectionCallback", "onDisconnected");
        }

        @Override
        public void onConnectFailed() {
            LogUtil.error(TAG + "-AVConnectionCallback", "onConnectionFailed");
        }
    };

    private final AVControllerCallback avControllerCallback = new AVControllerCallback() {
        @Override
        public void onAVMetadataChanged(AVMetadata metadata) {
            // this will be called with avSession.setAVMetadata() called on service.
            super.onAVMetadataChanged(metadata);
            LogUtil.info(TAG + "-AVControllerCallback", "onAVMetadataChanged");
            titleText.setText(metadata.getString(AVMetadata.AVTextKey.TITLE));
            totalTimeText.setText(String.valueOf(metadata.getLong(AVMetadata.AVLongKey.DURATION) / 1000));
        }

        @Override
        public void onAVPlaybackStateChanged(AVPlaybackState playbackState) {
            // this will be called with avSession.setAVPlaybackState() called on service.
            super.onAVPlaybackStateChanged(playbackState);
            LogUtil.info(TAG + "-AVControllerCallback", "onAVPlaybackStateChanged");
            switch (playbackState.getAVPlaybackState()) {
                case AVPlaybackState.PLAYBACK_STATE_NONE:
                case AVPlaybackState.PLAYBACK_STATE_PAUSED: {
                    playButton.setText(ResourceTable.String_play);
                    break;
                }
                case AVPlaybackState.PLAYBACK_STATE_PLAYING: {
                    playButton.setText(ResourceTable.String_pause);
                    progressText.setText(String.valueOf(playbackState.getCurrentPosition() / 1000));
                    break;
                }
                default:
                    break;
            }
        }

        @Override
        public void onAVQueueChanged(List<AVQueueElement> queue) {
            // this will be called with avSession.setAVQueue() called on service.
            super.onAVQueueChanged(queue);
            LogUtil.info(TAG + "-AVControllerCallback", "onAVQueueChanged");
        }

        @Override
        public void onAVSessionEvent(String event, PacMap extras) {
            // this will be called with avSession.sendAVSessionEvent() called on service.
            super.onAVSessionEvent(event, extras);
            LogUtil.info(TAG + "-AVControllerCallback", "onAVSessionEvent");
        }

        @Override
        public void onAVSessionDestroyed() {
            // this will be called with avSession.release() called on service.
            super.onAVSessionDestroyed();
            LogUtil.info(TAG + "-AVControllerCallback", "onAVSessionDestroyed");
        }

        @Override
        public void onAVQueueTitleChanged(CharSequence title) {
            // this will be called with avSession.setAVQueueTitle() called on service.
            super.onAVQueueTitleChanged(title);
            LogUtil.info(TAG + "-AVControllerCallback", "onAVQueueTitleChanged");
        }

        @Override
        public void onOptionsChanged(PacMap extras) {
            // this will be called with avSession.setOptions() called on service.
            super.onOptionsChanged(extras);
            LogUtil.info(TAG + "-AVControllerCallback", "onOptionsChanged");
        }
    };

    private final AVSubscriptionCallback avSubscriptionCallback = new AVSubscriptionCallback() {
        @Override
        public void onAVElementListLoaded(String parentId, List<AVElement> children) {
            // this will be called with onLoadAVElementList() called on service.
            super.onAVElementListLoaded(parentId, children);
            LogUtil.info(TAG + "-AVSubscriptionCallback", "onAVElementListLoaded, parentId=" + parentId);
            if (parentId.equals(AVPlayService.PARENT_MEDIA_ID_1) && children != null && children.size() > 0) {
                if (children.size() > 0) {
                    avElementList = children;
                    avElementsListItemProvider.notifyDataChanged();
                    if (avController == null) {
                        avController = new AVController(AVPlayClient.this, avBrowser.getAVToken());
                        avController.setAVControllerCallback(avControllerCallback);
                    }
                    previousButton.setEnabled(true);
                    nextButton.setEnabled(true);
                    playButton.setEnabled(true);
                }
            }
        }

        @Override
        public void onAVElementListLoaded(String parentId, List<AVElement> children, PacMap options) {
            super.onAVElementListLoaded(parentId, children, options);
            LogUtil.info(TAG + "-AVSubscriptionCallback", "onAVElementListLoaded");
        }

        @Override
        public void onError(String parentId) {
            super.onError(parentId);
            LogUtil.error(TAG + "-AVSubscriptionCallback", "onError");
        }

        @Override
        public void onError(String parentMediaId, PacMap options) {
            super.onError(parentMediaId, options);
        }
    };

    // to play the next audio in the avElements list
    private void handlerNextEvent() {
        LogUtil.info(TAG, "handlerNextEvent：" + avController.getAVPlaybackState());
        avController.getPlayControls().playNext();
    }

    // to play the previous audio in the avElements list
    private void handlerPrevEvent() {
        LogUtil.info(TAG, "handlerPrevEvent：" + avController.getAVPlaybackState());
        avController.getPlayControls().playPrevious();
    }

    // to play or pause the audio in the avElements list
    private void handlerPlayEvent() {
        LogUtil.info(TAG, "handlerPlayEvent：" + avController.getAVPlaybackState());
        switch (avController.getAVPlaybackState().getAVPlaybackState()) {
            case AVPlaybackState.PLAYBACK_STATE_NONE: {
                if (avElementList.size() > 0) {
                    Uri mediaUri = avElementList.get(0).getAVDescription().getMediaUri();
                    avController.getPlayControls().playByUri(mediaUri, new PacMap());
                }
                break;
            }
            case AVPlaybackState.PLAYBACK_STATE_PLAYING: {
                avController.getPlayControls().pause();
                break;
            }
            case AVPlaybackState.PLAYBACK_STATE_PAUSED: {
                avController.getPlayControls().play();
                break;
            }
            default:
                break;
        }
    }

    private void connectService() {
        if (verifySelfPermission(SystemPermission.READ_USER_STORAGE) == IBundleManager.PERMISSION_GRANTED) {
            connectToBrowserService();
        } else {
            requestPermissionsFromUser(new String[] {SystemPermission.READ_USER_STORAGE}, 0);
        }
    }

    @Override
    public void onRequestPermissionsFromUserResult(int requestCode, String[] permissions, int[] grantResults) {
        if (permissions == null || permissions.length == 0 || grantResults == null || grantResults.length == 0) {
            return;
        }
        if (requestCode == 0) {
            if (grantResults[0] == IBundleManager.PERMISSION_DENIED) {
                terminateAbility();
            } else {
                connectToBrowserService();
            }
        }
    }

    private void connectToBrowserService() {
        try {
            if (!avBrowser.isConnected()) {
                avBrowser.connect();
            }
        } catch (IllegalStateException exception) {
            LogUtil.error(TAG, "connect to browser service repeat");
        }
    }
}
