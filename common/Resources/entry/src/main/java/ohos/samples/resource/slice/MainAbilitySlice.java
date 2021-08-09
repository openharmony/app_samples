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

package ohos.samples.resource.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.global.resource.Element;
import ohos.global.resource.NotExistException;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.global.resource.WrongTypeException;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.samples.resource.ResourceTable;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String RAW_FILE = "entry/resources/rawfile/text.txt";

    private Text resourcesText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        Component btnResource = findComponentById(ResourceTable.Id_btn_resource);
        resourcesText = (Text) findComponentById(ResourceTable.Id_resourece_text);
        btnResource.setClickedListener(component -> getResources());
    }

    private void getResources() {
        resourcesText.setText(" ");
        try {
            Element elementBoolean = getResourceManager().getElement(ResourceTable.Boolean_boolean_1);
            boolean booleans = elementBoolean.getBoolean();
            HiLog.info(LABEL_LOG, "%{public}s", String.valueOf(booleans));
            Element elementColor = getResourceManager().getElement(ResourceTable.Color_red);
            String colors = Integer.toHexString(elementColor.getColor());
            HiLog.info(LABEL_LOG, "%{public}s", colors);
            Element elementFloat = getResourceManager().getElement(ResourceTable.Float_float_1);
            float floats = elementFloat.getFloat();
            HiLog.info(LABEL_LOG, "%{public}s", String.valueOf(floats));
            Element elementIntarray = getResourceManager().getElement(ResourceTable.Intarray_intarray_1);
            String intArray = Arrays.toString(elementIntarray.getIntArray());
            HiLog.info(LABEL_LOG, "%{public}s", intArray);
            Element elementInteger = getResourceManager().getElement(ResourceTable.Integer_integer_1);
            int integer = elementInteger.getInteger();
            HiLog.info(LABEL_LOG, "%{public}s", String.valueOf(integer));
            Element elementPlural = getResourceManager().getElement(ResourceTable.Plural_eat_apple);
            String pluralString = Arrays.toString(elementPlural.getStringArray());
            HiLog.info(LABEL_LOG, "%{public}s", pluralString);
            Element elementStrarray = getResourceManager().getElement(ResourceTable.Strarray_size);
            String stringArray = Arrays.toString(elementStrarray.getStringArray());
            HiLog.info(LABEL_LOG, "%{public}s", stringArray);
            RawFileEntry rawFileEntry = getResourceManager().getRawFileEntry(RAW_FILE);
            StringBuilder builder = new StringBuilder();
            Resource resource = rawFileEntry.openRawFile();
            byte[] bytes = new byte[resource.available()];
            String appends = null;
            while ((resource.read(bytes)) != -1) {
                appends = (builder.append(new String(bytes, StandardCharsets.UTF_8))).toString();
            }
            HiLog.info(LABEL_LOG, "%{public}s", appends);
            resourcesText.setText(
                "boolean :" + booleans + System.lineSeparator() + "colors :" + colors + System.lineSeparator()
                    + "floats :" + floats + System.lineSeparator() + "intArray :" + intArray + System.lineSeparator()
                    + "integer :" + integer + System.lineSeparator() + "plural :" + pluralString
                    + System.lineSeparator() + "stringArray :" + stringArray + System.lineSeparator() + "textfile :"
                    + appends);
        } catch (IOException | NotExistException | WrongTypeException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "File exception");
        }
    }
}
