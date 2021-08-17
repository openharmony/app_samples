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

package ohos.samples.uicomponents;

import ohos.samples.uicomponents.utils.Constants;
import ohos.samples.uicomponents.utils.LogUtil;

import ohos.ace.ability.AceAbility;
import ohos.ace.ability.AceInternalAbility;
import ohos.batterymanager.BatteryInfo;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.CommonEventSupport;
import ohos.event.commonevent.MatchingSkills;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;

/**
 * Internal Ability
 */
public class BatteryInternalAbility extends AceInternalAbility {
    private static final String TAG = BatteryInternalAbility.class.getSimpleName();

    private static final int DEFAULT_TYPE = 0;

    private static volatile BatteryInternalAbility instance;

    private static final String BUNDLE_NAME = "ohos.samples.uicomponents";

    private static final String ABILITY_NAME = "BatteryInternalAbility";

    private CommonEventSubscriber subscriber;

    private BatteryInternalAbility() {
        super(BUNDLE_NAME, ABILITY_NAME);
    }

    /**
     * Business execution
     *
     * @param code Request Code.
     * @param data Receives MessageParcel object.
     * @param reply The MessageParcel object is returned.
     * @param option Indicates whether the operation is synchronous or asynchronous.
     * @return If the operation is successful, true is returned. Otherwise, false is returned.
     */
    public boolean remoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option) {
        String result = data.readString();
        LogUtil.info(TAG, " code = " + code + ", result = " + result);
        switch (code) {
            case Constants.BATTERY_LEVEL_NOT_AVAILABLE:
                reply.writeString(getBatteryInfo());
                break;
            case Constants.BATTERY_SUBSCRIBE_FAILURE:
                subscribeEvent(data, reply, option);
                break;
            case Constants.BATTERY_UNSUBSCRIBE_FAILURE:
                unSubscribeBatteryEvent(reply);
                break;
            default:
                reply.writeString("service not defined");
                return false;
        }
        return true;
    }

    private void subscribeEvent(MessageParcel data, MessageParcel reply, MessageOption option) {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(CommonEventSupport.COMMON_EVENT_BATTERY_CHANGED);
        IRemoteObject notifier = data.readRemoteObject();
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        subscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                replyMsg(notifier);
            }
        };
        if (option.getFlags() == MessageOption.TF_SYNC) {
            reply.writeString("subscribe common event success");
        }
        try {
            CommonEventManager.subscribeCommonEvent(subscriber);
            reply.writeString(" subscribe common event success");
        } catch (RemoteException e) {
            LogUtil.error(TAG, "RemoteException in subscribeNotificationEvents!");
        }
    }

    private void replyMsg(IRemoteObject notifier) {
        MessageParcel notifyData = MessageParcel.obtain();
        notifyData.writeString("{\"msg\":\"" + getBatteryInfo() + "\"}");
        try {
            notifier.sendRequest(DEFAULT_TYPE, notifyData, MessageParcel.obtain(), new MessageOption());
        } catch (RemoteException exception) {
            LogUtil.info(TAG, "replyMsg RemoteException ");
        } finally {
            notifyData.reclaim();
        }
    }

    private String getBatteryInfo() {
        StringBuilder stringBuilder = new StringBuilder();
        boolean isCharging = getChargingStatus();
        double batteryValue = getBatteryLevel();
        stringBuilder.append(batteryValue).append(" % Battery Left").append(System.lineSeparator())
            .append("isCharging: ")
            .append(isCharging);
        return stringBuilder.toString();
    }

    private void unSubscribeBatteryEvent(MessageParcel reply) {
        try {
            CommonEventManager.unsubscribeCommonEvent(subscriber);
            reply.writeString("Unsubscribe common event success!");
        } catch (RemoteException | IllegalArgumentException exception) {
            reply.writeString("Battery Unsubscribe failed!");
            LogUtil.error(TAG, "Battery Unsubscribe failed!");
        }
        subscriber = null;
    }

    private int getBatteryLevel() {
        BatteryInfo batteryInfo = new BatteryInfo();
        return batteryInfo.getCapacity();
    }

    private boolean getChargingStatus() {
        BatteryInfo batteryInfo = new BatteryInfo();
        BatteryInfo.BatteryChargeState batteryStatus = batteryInfo.getChargingStatus();
        return (batteryStatus == BatteryInfo.BatteryChargeState.ENABLE
            || batteryStatus == BatteryInfo.BatteryChargeState.FULL);
    }

    public static BatteryInternalAbility getInstance() {
        if (instance == null) {
            synchronized (BatteryInternalAbility.class) {
                if (instance == null) {
                    instance = new BatteryInternalAbility();
                }
            }
        }
        return instance;
    }

    /**
     * init Internal ability
     *
     * @param ability The AceAbility Object of Invocation
     */
    public void register(AceAbility ability) {
        AceInternalAbilityHandler abilityHandler = (code, data, reply, option) -> {
            LogUtil.debug(TAG, "onRemoteRequest received request");
            return remoteRequest(code, data, reply, option);
        };
        this.setInternalAbilityHandler(abilityHandler, ability);
    }

    /**
     * Internal ability release
     *
     * @param ability The AceAbility Object of Invocation
     */
    public void deRegister(AceAbility ability) {
        this.setInternalAbilityHandler(null, ability);
    }
}
