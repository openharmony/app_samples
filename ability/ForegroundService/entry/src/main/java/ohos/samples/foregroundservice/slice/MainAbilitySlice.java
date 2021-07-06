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

package ohos.samples.foregroundservice.slice;

import static ohos.samples.foregroundservice.ServiceAbility.PAUSE_STATE;
import static ohos.samples.foregroundservice.ServiceAbility.PLAY_STATE;
import static ohos.samples.foregroundservice.ServiceAbility.STOP_STATE;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.bundle.ElementName;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;
import ohos.samples.foregroundservice.ResourceTable;
import ohos.samples.foregroundservice.ServiceAbility;

/**
 * MainAbilitySlice
 *
 * @since 2021-05-08
 */
public class MainAbilitySlice extends AbilitySlice {
    /**
     * Event Action Name
     */
    public static final String EVENT_ACTION = "ohos.samples.forgroundservice";

    private static final String BUNDLE_NAME = "ohos.samples.foregroundservice";

    private static final String ABILITY_NAME = "ohos.samples.foregroundservice.ServiceAbility";

    private static final String TAG = "MainAbilitySlice";

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int DEFAULT_STATE = -1;

    private Button startPlay;

    private Button pausePlay;

    private Button stopPlay;

    private ServiceAbility.MusicRemoteObject musicRemoteObject;

    private MyCommonEventSubscriber subscriber;

    private int lastState = DEFAULT_STATE;

    private final IAbilityConnection connection = new IAbilityConnection() {
        @Override
        public void onAbilityConnectDone(ElementName elementName, IRemoteObject remoteObject, int i) {
            if (remoteObject instanceof ServiceAbility.MusicRemoteObject) {
                musicRemoteObject = (ServiceAbility.MusicRemoteObject) remoteObject;
            }
        }

        @Override
        public void onAbilityDisconnectDone(ElementName elementName, int i) {
            HiLog.info(LABEL_LOG, "onAbilityDisconnectDone.");
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initView();
        initEventListener();
        initSubscribeEvent();
        startService();
    }

    private void startService() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder()
                .withDeviceId("")
                .withBundleName(BUNDLE_NAME)
                .withAbilityName(ABILITY_NAME)
                .build();
        intent.setOperation(operation);
        startAbility(intent);
        connectAbility(intent, connection);
    }

    @Override
    protected void onStop() {
        super.onStop();
        try {
            CommonEventManager.unsubscribeCommonEvent(subscriber);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "Exception occurred during unsubscribeCommonEvent invocation.");
        }
        disconnectAbility(connection);
    }

    private void initEventListener() {
        startPlay.setClickedListener(component -> musicRemoteObject.startPlay());
        pausePlay.setClickedListener(component -> musicRemoteObject.pausePlay());
        stopPlay.setClickedListener(component -> musicRemoteObject.stopPlay());
    }

    private void initView() {
        Component startPlayComponent = findComponentById(ResourceTable.Id_start);
        if (startPlayComponent instanceof Button) {
            startPlay = (Button) startPlayComponent;
        }
        Component pausePlayComponent = findComponentById(ResourceTable.Id_pause);
        if (pausePlayComponent instanceof Button) {
            pausePlay = (Button) pausePlayComponent;
        }
        Component stopPlayComponent = findComponentById(ResourceTable.Id_stop);
        if (stopPlayComponent instanceof Button) {
            stopPlay = (Button) stopPlayComponent;
        }
    }

    private void initSubscribeEvent() {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(EVENT_ACTION);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        subscriber = new MyCommonEventSubscriber(subscribeInfo);
        try {
            CommonEventManager.subscribeCommonEvent(subscriber);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "Exception occurred during subscribeCommonEvent invocation.");
        }
    }

    private void setState(int state) {
        switch (state) {
            case PAUSE_STATE: {
                handleButtonState(PAUSE_STATE);
                pausePlay.setText(ResourceTable.String_resume_play);
                break;
            }
            case PLAY_STATE: {
                handleButtonState(PLAY_STATE);
                break;
            }
            case STOP_STATE: {
                handleButtonState(STOP_STATE);
                pausePlay.setText(ResourceTable.String_pause_play);
                break;
            }
            default:
        }
        if (state == PLAY_STATE && lastState == PAUSE_STATE) {
            pausePlay.setText(ResourceTable.String_pause_play);
        }
        lastState = state;
    }

    private void handleButtonState(int status) {
        if ( status != STOP_STATE) {
            startPlay.setEnabled(false);
            pausePlay.setEnabled(true);
            stopPlay.setEnabled(true);
        } else {
            startPlay.setEnabled(true);
            pausePlay.setEnabled(false);
            stopPlay.setEnabled(false);
        }
    }

    /**
     * CommonEventSubscriber Implementation
     *
     * @since 2021-05-08
     */
    class MyCommonEventSubscriber extends CommonEventSubscriber {
        MyCommonEventSubscriber(CommonEventSubscribeInfo info) {
            super(info);
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            Intent intent = commonEventData.getIntent();
            int state = intent.getIntParam("state", DEFAULT_STATE);
            if (state != DEFAULT_STATE) {
                setState(state);
            }
        }
    }
}
