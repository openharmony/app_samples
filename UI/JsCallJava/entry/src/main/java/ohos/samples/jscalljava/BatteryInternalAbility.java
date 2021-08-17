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

package ohos.samples.jscalljava;

import ohos.ace.ability.AceInternalAbility;
import ohos.batterymanager.BatteryInfo;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.CommonEventSupport;
import ohos.event.commonevent.MatchingSkills;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;

/**
 * Internal Ability
 */
public class BatteryInternalAbility extends AceInternalAbility {
    private static final int BATTERY_LEVEL_NOT_AVAILABLE = 1001;

    private static final int BATTERY_SUBSCRIBE_FAILURE = 1002;

    private static final int BATTERY_UNSUBSCRIBE_FAILURE = 1003;

    private static final String TAG = BatteryInternalAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int DEFAULT_TYPE = 0;

    private static BatteryInternalAbility instance;

    private static final String BUNDLE_NAME = "ohos.samples.jscalljava";

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
    public boolean onRemoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option) {
        switch (code) {
            case BATTERY_LEVEL_NOT_AVAILABLE:
                reply.writeString(getBatteryInfo());
                break;
            case BATTERY_SUBSCRIBE_FAILURE:
                subscribeEvent(data, reply, option);
                break;
            case BATTERY_UNSUBSCRIBE_FAILURE:
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
            HiLog.info(LABEL_LOG, "%{public}s", "RemoteException in subscribeNotificationEvents!");
        }
    }

    private void replyMsg(IRemoteObject notifier) {
        MessageParcel notifyData = MessageParcel.obtain();
        notifyData.writeString("{\"msg\":\"" + getBatteryInfo() + "\"}");
        try {
            notifier.sendRequest(DEFAULT_TYPE, notifyData, MessageParcel.obtain(), new MessageOption());
        } catch (RemoteException exception) {
            HiLog.info(LABEL_LOG, "%{public}s", "replyMsg RemoteException !");
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
            HiLog.info(LABEL_LOG, "%{public}s", "Battery Unsubscribe failed!");
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

    /**
     * BatteryInternalAbility
     *
     * @return If the instance is NULL, Get new instance. Otherwise, instance is returned.
     */
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
     */
    public void register() {
        this.setInternalAbilityHandler(this::onRemoteRequest);
    }

    /**
     * Internal ability release
     */
    public void deregister() {
        this.setInternalAbilityHandler(null);
    }
}
