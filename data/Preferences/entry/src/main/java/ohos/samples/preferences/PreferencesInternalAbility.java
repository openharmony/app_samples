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

package ohos.samples.preferences;

import ohos.samples.preferences.entities.ColorEntry;
import ohos.samples.preferences.entities.LoginEntry;
import ohos.samples.preferences.entities.SplashEntry;
import ohos.samples.preferences.utils.Constants;
import ohos.samples.preferences.utils.LogUtil;

import ohos.ace.ability.AceAbility;
import ohos.ace.ability.AceInternalAbility;
import ohos.app.AbilityContext;
import ohos.data.DatabaseHelper;
import ohos.data.preferences.Preferences;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;
import ohos.utils.zson.ZSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Internal Ability
 */
public class PreferencesInternalAbility extends AceInternalAbility {
    private static final String TAG = "PreferencesInternalAbility";

    private static PreferencesInternalAbility instance;

    private static final String BUNDLE_NAME = "ohos.samples.preferences";

    private static final String ABILITY_NAME = "PreferencesInternalAbility";

    private static final int ERROR = -1;

    private static final int SUCCESS = 0;

    private static final int CHECK_LOGIN_STATUS = 1001;

    private static final int SUBSCRIBE = 1002;

    private static final int GET_BACKGROUND_COLOR = 1003;

    private static final int SAVE_LOGIN_STATUS = 1004;

    private static final int SAVE_BACKGROUND_COLOR = 1005;

    private static final int CLEAR_PREFERENCES = 1006;

    private static final int GET_SPLASH_STATE = 1007;

    private static final int SAVE_SPLASH_STATE = 1008;

    private AbilityContext mContext;

    private Preferences preferences;

    /**
     * bundleName,abilityName
     */
    public PreferencesInternalAbility() {
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
        switch (code) {
            case CHECK_LOGIN_STATUS:
                checkLoginStatus(reply);
                break;
            case SUBSCRIBE:
                subscribe(reply, option);
                break;
            case GET_BACKGROUND_COLOR:
                getBackgroundColor(reply);
                break;
            case SAVE_LOGIN_STATUS:
                saveLogin(data, reply);
                break;
            case SAVE_BACKGROUND_COLOR:
                saveBgColor(data, reply);
                break;
            case CLEAR_PREFERENCES:
                clearPreferences(reply);
                break;
            case GET_SPLASH_STATE:
                getSplashState(reply);
                break;
            case SAVE_SPLASH_STATE:
                saveSplashState(data, reply);
                break;
            default:
                reply.writeString("service not defined");
                return false;
        }
        return true;
    }

    private void saveSplashState(MessageParcel data, MessageParcel reply) {
        SplashEntry entry = ZSONObject.stringToClass(data.readString(), SplashEntry.class);
        saveSplashShowState(entry.getCheckState());
        Map<String, Object> saveResult = new HashMap<>();
        saveResult.put(Constants.CODE, SUCCESS);
        saveResult.put(Constants.DATA, Constants.SUCCESS);
        reply.writeString(ZSONObject.toZSONString(saveResult));
    }

    private void getSplashState(MessageParcel reply) {
        Map<String, Object> clearResult = new HashMap<>();
        clearResult.put(Constants.CODE, SUCCESS);
        clearResult.put(Constants.DATA, getSplashStateFromPref());
        reply.writeString(ZSONObject.toZSONString(clearResult));
    }

    private void clearPreferences(MessageParcel reply) {
        clear();
        Map<String, Object> clearResult = new HashMap<>();
        clearResult.put(Constants.CODE, SUCCESS);
        clearResult.put(Constants.DATA, getBackgroundColorFromPref());
        reply.writeString(ZSONObject.toZSONString(clearResult));
    }

    private void checkLoginStatus(MessageParcel reply) {
        Map<String, Object> loginResult = new HashMap<>();
        loginResult.put(Constants.CODE, SUCCESS);
        loginResult.put(Constants.DATA, getLoginStatus());
        reply.writeString(ZSONObject.toZSONString(loginResult));
    }

    private void getBackgroundColor(MessageParcel reply) {
        Map<String, Object> bgResult = new HashMap<>();
        bgResult.put(Constants.CODE, SUCCESS);
        bgResult.put(Constants.DATA, getBackgroundColorFromPref());
        reply.writeString(ZSONObject.toZSONString(bgResult));
    }

    private void saveLogin(MessageParcel data, MessageParcel reply) {
        LoginEntry entry = ZSONObject.stringToClass(data.readString(), LoginEntry.class);
        saveLoginStatus(entry.getLoginState());
        Map<String, Object> saveResult = new HashMap<>();
        saveResult.put(Constants.CODE, getLoginStatus() == 1 ? SUCCESS : ERROR);
        saveResult.put(Constants.DATA, getLoginStatus());
        reply.writeString(ZSONObject.toZSONString(saveResult));
    }

    private void subscribe(MessageParcel reply, MessageOption option) {
        Map<String, Object> subscribeResult = new HashMap<>();
        subscribeResult.put(Constants.CODE, SUCCESS);
        subscribeResult.put(Constants.DATA, Constants.SUCCESS);
        if (option.getFlags() == MessageOption.TF_SYNC) {
            reply.writeString(ZSONObject.toZSONString(subscribeResult));
        } else {
            MessageParcel msgData = MessageParcel.obtain();
            boolean writeResult = msgData.writeString(ZSONObject.toZSONString(subscribeResult));
            if (!writeResult) {
                LogUtil.info(TAG, "writeResult : " + writeResult);
                msgData.reclaim();
                return;
            }
            MessageParcel messageParcel = MessageParcel.obtain();
            IRemoteObject remoteReply = reply.readRemoteObject();
            try {
                remoteReply.sendRequest(0, msgData, messageParcel, new MessageOption());
            } catch (RemoteException e) {
                LogUtil.error(TAG, "subscribe error ! ");
            } finally {
                msgData.reclaim();
                messageParcel.reclaim();
            }
        }
    }

    private void saveBgColor(MessageParcel data, MessageParcel reply) {
        ColorEntry colorEntry = ZSONObject.stringToClass(data.readString(), ColorEntry.class);
        saveBackgroundColorInPref(colorEntry.getAppliedColor());
        Map<String, Object> colorResult = new HashMap<>();
        colorResult.put(Constants.CODE, getBackgroundColorFromPref() != null ? SUCCESS : ERROR);
        colorResult.put(Constants.DATA, getBackgroundColorFromPref());
        reply.writeString(ZSONObject.toZSONString(colorResult));
    }

    private Preferences getPreferences() {
        if (preferences == null) {
            DatabaseHelper databaseHelper = new DatabaseHelper(mContext);
            preferences = databaseHelper.getPreferences(Constants.APP_PREFERENCE_NAME);
        }
        return preferences;
    }

    private void saveBackgroundColorInPref(String backgroundColor) {
        getPreferences().putString(Constants.APP_BACKGROUND_COLOR, backgroundColor);
        getPreferences().flush();
    }

    private String getBackgroundColorFromPref() {
        return getPreferences().getString(Constants.APP_BACKGROUND_COLOR, Constants.APP_DEFAULT_BACKGROUND_COLOR);
    }

    private void saveLoginStatus(int loginState) {
        getPreferences().putInt(Constants.LOGIN_STATUS, loginState);
        getPreferences().flush();
    }

    private int getLoginStatus() {
        return getPreferences().getInt(Constants.LOGIN_STATUS, 0);
    }

    private void saveSplashShowState(int checkState) {
        getPreferences().putInt(Constants.SPLASH_STATE, checkState);
        getPreferences().flush();
    }

    private int getSplashStateFromPref() {
        return getPreferences().getInt(Constants.SPLASH_STATE, 0);
    }

    private void clear() {
        getPreferences().clear();
        getPreferences().flush();
    }

    /**
     * Internal ability registration.
     *
     * @param abilityContext context
     */
    public static void register(AceAbility abilityContext) {
        instance = new PreferencesInternalAbility();
        instance.onRegister(abilityContext);
    }

    private void onRegister(AceAbility abilityContext) {
        this.mContext = abilityContext;
        AceInternalAbilityHandler abilityHandler = (code, data, reply, option) -> {
            LogUtil.debug(TAG, "onRemoteRequest received request");
            return remoteRequest(code, data, reply, option);
        };
        this.setInternalAbilityHandler(abilityHandler, abilityContext);
    }

    /**
     * Internal ability deregistration.
     *
     * @param ability The AceAbility Object of Invocation
     */
    public static void deRegister(AceAbility ability) {
        instance.onDeRegister(ability);
    }

    private void onDeRegister(AceAbility ability) {
        mContext = null;
        this.setInternalAbilityHandler(null, ability);
    }
}
