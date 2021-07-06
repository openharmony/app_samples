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

package ohos.samples.delegator.slice;

import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.ability.delegation.AbilityDelegatorRegistry;
import ohos.aafwk.ability.delegation.IAbilityDelegator;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.components.TextField;
import ohos.bundle.ElementName;
import ohos.samples.delegator.FirstAbility;
import ohos.samples.delegator.MainAbility;
import ohos.samples.delegator.ResourceTable;
import ohos.samples.delegator.SecondAbility;

/**
 * MainAbilitySliceTest
 *
 * @since 2021-05-17
 */
public class MainAbilitySliceTest {
    private static final String BUNDLE_NAME = "ohos.samples.delegator";

    private static final String SEND_MESSAGE_MAIN = "I am from MainAbility.";

    private static final String SEND_MESSAGE_SECOND = "I am from SecondAbility.";

    private static IAbilityDelegator abilityDelegator;

    private static Intent intentMainAbility = new Intent();

    /**
     * Global Variable Initialization
     */
    @BeforeClass
    public static void setUp() {
        abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        ElementName elementNameMain = new ElementName();
        elementNameMain.setBundleName(BUNDLE_NAME);
        elementNameMain.setAbilityName("MainAbility");
        intentMainAbility.setElement(elementNameMain);
    }

    /**
     * Initialization State
     */
    @Before
    public void jumpBack() {
        abilityDelegator.startAbilitySync(intentMainAbility);
    }

    /**
     * MainAbility StartAbility  Test
     */
    @Test
    public void startAbility() {
        Ability mainAbility = abilityDelegator.getCurrentTopAbility();
        String mainAbilityName = mainAbility.getAbilityName();
        Assert.assertEquals(MainAbility.class.getSimpleName(), mainAbilityName);
        Component editMainTextComponent = mainAbility.findComponentById(ResourceTable.Id_text_editMain);
        if ( editMainTextComponent instanceof TextField) {
            TextField editMainText = (TextField) editMainTextComponent;
            Assert.assertNotNull("editMainText Text is null", editMainText);
            abilityDelegator.runOnUIThreadSync(() -> {
                editMainText.setText(SEND_MESSAGE_MAIN);
            });
        }
        Component startAbilityComment = mainAbility.findComponentById(ResourceTable.Id_button_startAbility);
        if (startAbilityComment instanceof Button) {
            Button startAbility = (Button) startAbilityComment;
            Assert.assertNotNull("startAbility button is null", startAbility);
            boolean okStartAbility = abilityDelegator.triggerClickEvent(mainAbility, startAbility);
            Assert.assertTrue("startAbility FirstAbility failed", okStartAbility);
        }
        // Wait Until The FirstAbility Startup Is Complete
        synchronized (abilityDelegator) {
            try {
                abilityDelegator.wait(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        toFirstAbility();
    }

    private void toFirstAbility() {
        Ability firstAbility = abilityDelegator.getCurrentTopAbility();
        String firstAbilityName = firstAbility.getAbilityName();
        Assert.assertEquals(FirstAbility.class.getSimpleName(), firstAbilityName);
        Component firstTextComponent = firstAbility.findComponentById(ResourceTable.Id_text_main_to_first);
        if (firstTextComponent instanceof Text) {
            Text firstText = (Text) firstTextComponent;
            Assert.assertNotNull("toFirstText Text is null", firstText);
            Assert.assertEquals(SEND_MESSAGE_MAIN, firstText.getText());
        }
        Component setResultComponent = firstAbility.findComponentById(ResourceTable.Id_button_first_to_main);
        if (setResultComponent instanceof Button) {
            Button setResult = (Button) setResultComponent;
            Assert.assertNotNull("setResult button is null", setResult);
            boolean okReturnAbility = abilityDelegator.triggerClickEvent(firstAbility, setResult);
            Assert.assertTrue("returnAbility MainAbility failed", okReturnAbility);
        }
        // Waiting For FirstAbility To Return Completion
        synchronized (abilityDelegator) {
            try {
                abilityDelegator.wait(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        Ability mainAbility = abilityDelegator.getCurrentTopAbility();
        String mainAbilityName = mainAbility.getAbilityName();
        Assert.assertEquals(MainAbility.class.getSimpleName(), mainAbilityName);
    }

    /**
     * MainAbility StartAbilityForResult  Test
     */
    @Test
    public void startAbilityForResult() {
        Ability mainAbility = abilityDelegator.getCurrentTopAbility();
        String mainAbilityName = mainAbility.getAbilityName();
        Assert.assertEquals(MainAbility.class.getSimpleName(), mainAbilityName);
        Component editMainTextComponent = mainAbility.findComponentById(ResourceTable.Id_text_editMain);
        if ( editMainTextComponent instanceof TextField) {
            TextField editMainText = (TextField) editMainTextComponent;
            Assert.assertNotNull("editMainText Text is null", editMainText);
            abilityDelegator.runOnUIThreadSync(() -> {
                editMainText.setText(SEND_MESSAGE_MAIN);
            });
        }
        Component startAbilityForResultComment =
                mainAbility.findComponentById(ResourceTable.Id_button_startAbilityForResult);
        if (startAbilityForResultComment instanceof Button) {
            Button startAbilityForResult = (Button) startAbilityForResultComment;
            Assert.assertNotNull("startAbilityForResult button is null", startAbilityForResult);
            boolean okStartAbilityForResult = abilityDelegator.triggerClickEvent(mainAbility, startAbilityForResult);
            Assert.assertTrue("startAbilityForResult SecondAbility failed", okStartAbilityForResult);
        }
        // Wait Until The SecondAbility Startup Is Complete
        synchronized (abilityDelegator) {
            try {
                abilityDelegator.wait(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        toSecondAbility();
    }

    private void toSecondAbility() {
        Ability secondAbility = abilityDelegator.getCurrentTopAbility();
        String secondAbilityName = secondAbility.getAbilityName();
        Assert.assertEquals(SecondAbility.class.getSimpleName(), secondAbilityName);
        Component secondTextComponent = secondAbility.findComponentById(ResourceTable.Id_text_main_to_second);
        if (secondTextComponent instanceof Text) {
            Text secondText = (Text) secondTextComponent;
            Assert.assertNotNull("toSecondText Text is null", secondText);
            Assert.assertEquals(SEND_MESSAGE_MAIN, secondText.getText());
        }
        Component editSecondTextComponent = secondAbility.findComponentById(ResourceTable.Id_text_editSecond);
        if (editSecondTextComponent instanceof TextField) {
            TextField editSecondText = (TextField) editSecondTextComponent;
            Assert.assertNotNull("editSecondText Text is null", editSecondText);
            abilityDelegator.runOnUIThreadSync(() -> {
                editSecondText.setText(SEND_MESSAGE_SECOND);
            });
        }
        Component setResultComponent = secondAbility.findComponentById(ResourceTable.Id_button_second_to_main);
        if (setResultComponent instanceof Button) {
            Button setResult = (Button) setResultComponent;
            Assert.assertNotNull("setResult button is null", setResult);
            boolean okReturnAbility = abilityDelegator.triggerClickEvent(secondAbility, setResult);
            Assert.assertTrue("returnAbility MainAbility failed", okReturnAbility);
        }
        // Waiting For SecondAbility To Return Completion
        synchronized (abilityDelegator) {
            try {
                abilityDelegator.wait(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        Ability mainAbility = abilityDelegator.getCurrentTopAbility();
        String mainAbilityName = mainAbility.getAbilityName();
        Assert.assertEquals(MainAbility.class.getSimpleName(), mainAbilityName);
        Component mainTextComponent = mainAbility.findComponentById(ResourceTable.Id_text_displayText);
        if (mainTextComponent instanceof Text) {
            Text mainText = (Text) mainTextComponent;
            Assert.assertNotNull("mainText Text is null", mainText);
            Assert.assertEquals(SEND_MESSAGE_SECOND, mainText.getText());
        }
    }
}