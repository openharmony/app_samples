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

package ohos.samples.accessibilityservice.service;

import ohos.accessibility.AccessibilityEventInfo;
import ohos.accessibility.ability.AccessibilityInfo;
import ohos.accessibility.ability.AccessibleAbility;
import ohos.agp.window.dialog.ToastDialog;
import ohos.global.resource.Element;
import ohos.global.resource.NotExistException;
import ohos.global.resource.WrongTypeException;
import ohos.multimodalinput.event.KeyEvent;
import ohos.samples.accessibilityservice.ResourceTable;
import ohos.samples.accessibilityservice.slice.KeyPressEventSlice;
import ohos.samples.accessibilityservice.tts.TtsManager;
import ohos.samples.accessibilityservice.utils.LogUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Optional;

/**
 * MyAccessibilityService
 *
 * @since 2021-07-23
 */
public class MyAccessibilityService extends AccessibleAbility {
    private static final String TAG = MyAccessibilityService.class.getSimpleName();

    private static final String BUNDLE_NAME = "ohos.samples.accessibilityservice";

    private static boolean isNeedCustomVolumeKey = false;

    private boolean isInSpecialApp = false;

    @Override
    public void onAccessibilityEvent(AccessibilityEventInfo accessibilityEventInfo) {
        int eventType = accessibilityEventInfo.getAccessibilityEventType();
        int windowType = accessibilityEventInfo.getWindowChangeTypes();
        LogUtils.info(TAG, "onAccessibilityEvent,enventType=" + eventType + "windowType" + windowType);
        if (AccessibilityEventInfo.TYPE_VIEW_CLICKED_EVENT == eventType) {
            LogUtils.info(TAG, "type view clicked");
            ArrayList<CharSequence> contentList = accessibilityEventInfo.getContentList();
            try {
                Element element = getContext().getResourceManager()
                        .getElement(ResourceTable.String_string_button_perform_click);
                String string = element.getString();
                for (CharSequence content : contentList) {
                    LogUtils.info(TAG, "type view clicked,content:" + content.toString() + ",string:" + string);
                    if (content.toString().equals(string)) {
                        LogUtils.info(TAG, "type view clicked,content:equals");
                        TtsManager.getInstance().speakText(content.toString(), null);
                        performCommonAction(AccessibleAbility.GLOBAL_ACTION_HOME);
                    }
                }
            } catch (IOException | NotExistException | WrongTypeException e) {
                LogUtils.error(TAG, "type view clicked,Exception:" + e.getMessage());
            }
        }
        switch (windowType) {
            case AccessibilityEventInfo.WINDOWS_CHANGE_ADDED:
                Optional<AccessibilityInfo> accessibilityInfo = getRootAccessibilityInfo();
                String bundleName = accessibilityInfo.get().getBundleName().toString();
                LogUtils.info(TAG, "WINDOWS_CHANGE_ADDED:" + bundleName);
                if (bundleName.equals(BUNDLE_NAME) && !isInSpecialApp) {
                    isInSpecialApp = true;
                    LogUtils.info(TAG, "You are in the " + bundleName);
                    runUIThread(() -> new ToastDialog(getContext()).setText("You are in the " + BUNDLE_NAME).show());
                }
                break;
            case AccessibilityEventInfo.WINDOWS_CHANGE_REMOVED:
                Optional<AccessibilityInfo> accessibilityInfo1 = getRootAccessibilityInfo();
                LogUtils.info(TAG, "WINDOWS_CHANGE_REMOVED");
                if (!accessibilityInfo1.get().getBundleName().equals(BUNDLE_NAME)) {
                    isInSpecialApp = false;
                }
                break;
            default:
                break;
        }
    }

    public static void setNeedCustomVolumeKey(boolean needCustomVolumeKey) {
        isNeedCustomVolumeKey = needCustomVolumeKey;
    }

    @Override
    public void onInterrupt() {
    }

    private void runUIThread(Runnable runnable) {
        getUITaskDispatcher().asyncDispatch(runnable);
    }

    @Override
    protected void onAbilityConnected() {
        LogUtils.info(TAG, "onAbilityConnected");
    }

    @Override
    protected boolean onKeyPressEvent(KeyEvent keyEvent) {
        LogUtils.info(TAG, "onKeyPressEvent,isNeedCustomVolumeKey:" + isNeedCustomVolumeKey);
        if (isNeedCustomVolumeKey) {
            if (keyEvent.getKeyCode() == KeyEvent.KEY_VOLUME_DOWN || keyEvent.getKeyCode() == KeyEvent.KEY_VOLUME_UP) {
                if (keyEvent.getKeyCode() == KeyEvent.KEY_VOLUME_DOWN && keyEvent.isKeyDown()) {
                    runUIThread(KeyPressEventSlice::scrollDown);
                }
                if (keyEvent.getKeyCode() == KeyEvent.KEY_VOLUME_UP && keyEvent.isKeyDown()) {
                    runUIThread(KeyPressEventSlice::scrollUp);
                }
                return true;
            }
        }
        return super.onKeyPressEvent(keyEvent);
    }
}
