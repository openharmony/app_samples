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

package ohos.samples.dialog.slice;

import static ohos.agp.components.ComponentContainer.LayoutConfig.MATCH_CONTENT;

import ohos.samples.dialog.ResourceTable;
import ohos.samples.dialog.custom.CustomDialog;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.components.element.ElementScatter;
import ohos.agp.utils.TextAlignment;
import ohos.agp.window.dialog.CommonDialog;
import ohos.agp.window.dialog.IDialog;
import ohos.agp.window.dialog.ListDialog;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    /**
     * DIALOG_BOX_CORNER_RADIUS
     */
    public static final float DIALOG_BOX_CORNER_RADIUS = 36.0f;
    /**
     * DIALOG_BOX_WIDTH
     */
    public static final int DIALOG_BOX_WIDTH = 984;
    private Text resultText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        Component commonDialogButton = findComponentById(ResourceTable.Id_common_dialog);
        Component listDialogButton = findComponentById(ResourceTable.Id_list_dialog);
        Component multiSelectDialogButton = findComponentById(ResourceTable.Id_multiselect_dialog);
        Component customDialogButton = findComponentById(ResourceTable.Id_custom_dialog);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);

        commonDialogButton.setClickedListener(component -> showCommonDialog());
        listDialogButton.setClickedListener(component -> showListDialog());
        multiSelectDialogButton.setClickedListener(component -> showMultiSelectDialog());
        customDialogButton.setClickedListener(component -> showCustomDialog());
    }

    private void showCommonDialog() {
        CommonDialog commonDialog = new CommonDialog(this);
        commonDialog.setTitleText("This Is Common Dialog");
        commonDialog.setContentText("Hello common dialog");
        commonDialog.setCornerRadius(DIALOG_BOX_CORNER_RADIUS);
        commonDialog.setAlignment(TextAlignment.CENTER);
        commonDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        commonDialog.setAutoClosable(true);
        commonDialog.setButton(IDialog.BUTTON1, "Yes", (iDialog, var) -> {
            resultText.setText("You Clicked Yes Button");
            iDialog.destroy();
        });
        commonDialog.setButton(IDialog.BUTTON2, "No", (iDialog, var) -> {
            resultText.setText("You Clicked No Button");
            iDialog.destroy();
        });
        commonDialog.show();
    }

    private void showListDialog() {
        String[] items = new String[]{"item 1", "item 2", "item 3"};
        ListDialog listDialog = new ListDialog(this);
        listDialog.setAlignment(TextAlignment.CENTER);
        listDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        listDialog.setTitleText("This Is List Dialog");
        listDialog.setAutoClosable(true);
        listDialog.setItems(items);
        listDialog.setOnSingleSelectListener((iDialog, index) -> {
            resultText.setText(items[index]);
            iDialog.destroy();
        });
        listDialog.show();
    }

    private void showMultiSelectDialog() {
        String[] itemsString = new String[]{"item 1", "item 2", "item 3", "item 4"};
        boolean[] areSelected = new boolean[]{false, false, false, false};
        List<String> selectedItems = new ArrayList<>();
        ListDialog listDialog = new ListDialog(this);
        listDialog.setTitleText("This Is MultiSelect Dialog");
        listDialog.setAlignment(TextAlignment.CENTER);
        listDialog.setSize(DIALOG_BOX_WIDTH, MATCH_CONTENT);
        listDialog.setAutoClosable(true);
        listDialog.setMultiSelectItems(itemsString, areSelected);
        listDialog.setOnMultiSelectListener((iDialog, index, isSelected) ->
                multiSelect(itemsString[index], selectedItems, listDialog.getItemComponent(index)));
        listDialog.setDialogListener(() -> {
            resultText.setText("");
            for (String selectedItem : selectedItems) {
                resultText.append(selectedItem);
            }
            return false;
        });
        listDialog.show();
    }

    private void multiSelect(String string, List<String> selectedItems, Component itemComponent) {
        if (selectedItems.contains(string)) {
            selectedItems.remove(string);
            itemComponent.setBackground(ElementScatter.getInstance(this)
                    .parse(ResourceTable.Graphic_multi_unselected_background));
        } else {
            selectedItems.add(string);
            itemComponent.setBackground(ElementScatter.getInstance(this)
                    .parse(ResourceTable.Graphic_multi_selected_background));
        }
    }

    private void showCustomDialog() {
        CustomDialog customDialog = new CustomDialog(this);
        customDialog.setTitle("This Is Custom Dialog");
        customDialog.setAutoClosable(true);
        customDialog.setOnConfirmListener(string -> {
            resultText.setText(string);
            customDialog.destroy();
        });
        customDialog.show();
    }
}
