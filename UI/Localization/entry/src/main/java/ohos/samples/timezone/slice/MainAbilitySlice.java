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

package ohos.samples.timezone.slice;

import ohos.samples.timezone.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;
import ohos.global.icu.text.SimpleDateFormat;
import ohos.global.icu.util.TimeZone;

import java.util.Locale;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private Text countryText;

    private Text timeDateText;

    private Text timeZoneText;

    private Text languageText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
        setCountryText();
        setTimeDateText();
        setTimeZoneText();
        setLanguageText();
    }

    private void initComponents() {
        countryText = (Text) findComponentById(ResourceTable.Id_country_text);
        timeDateText = (Text) findComponentById(ResourceTable.Id_time_text);
        timeZoneText = (Text) findComponentById(ResourceTable.Id_timezone_text);
        languageText = (Text) findComponentById(ResourceTable.Id_language_text);
    }

    private void setCountryText() {
        countryText.setText(Locale.getDefault().getDisplayCountry());
    }

    private void setTimeDateText() {
        long currentTime = System.currentTimeMillis();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat();
        simpleDateFormat.setTimeZone(TimeZone.getTimeZone(TimeZone.getDefault().getID()));
        String string = simpleDateFormat.format(currentTime);
        timeDateText.setText(string);
    }

    private void setTimeZoneText() {
        timeZoneText.setText(TimeZone.getDefault().getDisplayName(Locale.getDefault()));
    }

    private void setLanguageText() {
        languageText.setText(Locale.getDefault().getDisplayLanguage());
    }
}
