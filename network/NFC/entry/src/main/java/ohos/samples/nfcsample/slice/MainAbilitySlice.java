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

package ohos.samples.nfcsample.slice;

import ohos.samples.nfcsample.ResourceTable;
import ohos.samples.nfcsample.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.CommonEventSupport;
import ohos.event.commonevent.MatchingSkills;
import ohos.nfc.NfcController;
import ohos.rpc.RemoteException;

/**
 * MainAbilitySlice extends AbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private Text nfcStateText;

    private NfcController nfcController;

    private CommonEventSubscriber nfcEventSubscriber;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        initEvent();
        subscribe();
    }

    private void initComponents() {
        nfcStateText = (Text) findComponentById(ResourceTable.Id_nfc_state_text);
    }

    private void initEvent() {
        nfcController = NfcController.getInstance(this);
        onNfcStateChange(nfcController.getNfcState());
    }

    @Override
    protected void onStop() {
        super.onStop();
        unsubscribe();
    }

    private void onNfcStateChange(int stateCode) {
        switch (stateCode) {
            case NfcController.STATE_OFF: {
                nfcStateText.setText("NFC_DISABLED");
                break;
            }
            case NfcController.STATE_ON: {
                nfcStateText.setText("NFC_ENABLED");
                break;
            }
            case NfcController.STATE_TURNING_ON: {
                nfcStateText.setText("NFC_TURNING_ON");
                break;
            }
            case NfcController.STATE_TURNING_OFF: {
                nfcStateText.setText("NFC_TURNING_OFF");
                break;
            }
            default:
                break;
        }
    }

    private void subscribe() {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(CommonEventSupport.COMMON_EVENT_NFC_ACTION_ADAPTER_STATE_CHANGED);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        nfcEventSubscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                if (NfcController.STATE_CHANGED.equals(commonEventData.getIntent().getAction())) {
                    onNfcStateChange(nfcController.getNfcState());
                }
            }
        };
        try {
            CommonEventManager.subscribeCommonEvent(nfcEventSubscriber);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "exception occurs when invoking subscribeCommonEvent");
        }
    }

    private void unsubscribe() {
        try {
            CommonEventManager.unsubscribeCommonEvent(nfcEventSubscriber);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "exception occurs when invoking unsubscribeCommonEvent");
        }
    }
}
