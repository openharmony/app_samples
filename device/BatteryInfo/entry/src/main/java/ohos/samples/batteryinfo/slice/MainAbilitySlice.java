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

package ohos.samples.batteryinfo.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Text;
import ohos.batterymanager.BatteryInfo;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.CommonEventSupport;
import ohos.event.commonevent.MatchingSkills;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;
import ohos.samples.batteryinfo.ResourceTable;

import java.util.Locale;

/**
 * Main AbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String TEMPLATE = "batteryCapacity: %d%%" + System.lineSeparator() + "isCharging: %b"
        + System.lineSeparator() + "healthState: %s" + System.lineSeparator() + "pluggedType: %s";

    private Text batteryInfoText;

    private CommonEventSubscriber commonEventSubscriber;

    private boolean isSubscribedBatteryChange;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
    }

    private void initComponents() {
        batteryInfoText = (Text) findComponentById(ResourceTable.Id_battery_level_result);
        findComponentById(ResourceTable.Id_get_battery_level)
                .setClickedListener(listener -> batteryInfoText.setText(getBatteryInfo()));
        Button subscribeBatteryChange = (Button) findComponentById(ResourceTable.Id_subscribe_battery_level_change);
        subscribeBatteryChange.setClickedListener(listener -> {
            if (!isSubscribedBatteryChange) {
                subscribeBatteryChange();
                isSubscribedBatteryChange = true;
            }
        });
    }

    @Override
    public void onStop() {
        super.onStop();
        unsubscribeBatteryChange();
    }

    private void subscribeBatteryChange() {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(CommonEventSupport.COMMON_EVENT_BATTERY_CHANGED);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);

        commonEventSubscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                batteryInfoText.setText(getBatteryInfo());
            }
        };
        try {
            CommonEventManager.subscribeCommonEvent(commonEventSubscriber);
        } catch (RemoteException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "Subscribe error!");
        }
    }

    private void unsubscribeBatteryChange() {
        if (commonEventSubscriber == null) {
            return;
        }
        try {
            CommonEventManager.unsubscribeCommonEvent(commonEventSubscriber);
        } catch (RemoteException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "unsubscribe error!");
        }
    }

    private String getBatteryInfo() {
        BatteryInfo batteryInfo = new BatteryInfo();
        int batteryCapacity = batteryInfo.getCapacity();
        BatteryInfo.BatteryHealthState healthState = batteryInfo.getHealthStatus();
        BatteryInfo.BatteryPluggedType pluggedType = batteryInfo.getPluggedType();
        BatteryInfo.BatteryChargeState chargeState = batteryInfo.getChargingStatus();
        boolean isCharging = chargeState == BatteryInfo.BatteryChargeState.ENABLE
            || chargeState == BatteryInfo.BatteryChargeState.FULL;
        return String.format(Locale.ENGLISH, TEMPLATE, batteryCapacity, isCharging, healthState, pluggedType);
    }
}