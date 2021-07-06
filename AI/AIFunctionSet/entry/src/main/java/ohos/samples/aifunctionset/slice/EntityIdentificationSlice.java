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

package ohos.samples.aifunctionset.slice;

import ohos.samples.aifunctionset.ResourceTable;

import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.TextField;
import ohos.ai.nlu.NluClient;
import ohos.ai.nlu.NluRequestType;
import ohos.ai.nlu.ResponseResult;
import ohos.utils.zson.ZSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Entity Identification Slice
 */
public class EntityIdentificationSlice extends BaseSlice {
    private TextField inputText;

    private TextField outText;

    private boolean initEngineResult;

    @Override
    public void initLayout() {
        currComponent = LayoutScatter.getInstance(this)
            .parse(ResourceTable.Layout_word_segmentation_slice, null, false);
        rootLayout.addComponent(currComponent);
        initEngine();
        initComponents();
    }

    private void initEngine() {
        NluClient.getInstance().init(this, result -> initEngineResult = true, true);
    }

    private void initComponents() {
        inputText = (TextField) findComponentById(ResourceTable.Id_input_text);
        outText = (TextField) findComponentById(ResourceTable.Id_out_text);
        Component startButton = findComponentById(ResourceTable.Id_start_parse);
        startButton.setClickedListener(this::start);
        inputText.setText("I like the beach.");
    }

    private void start(Component component) {
        Map<String, Object> map = new HashMap<>();
        map.put("text", inputText.getText());
        String requestJson = ZSONObject.toZSONString(map);
        if (initEngineResult) {
            ResponseResult responseResult = NluClient.getInstance()
                .getEntity(requestJson, NluRequestType.REQUEST_TYPE_LOCAL);
            if (responseResult != null) {
                String result = responseResult.getResponseResult();
                outText.setText("Result:" + System.lineSeparator() + result);
            }
        }
    }

    @Override
    public void setTitle() {
        aiTitle.setText("Entity Identification");
    }

    @Override
    protected void onStop() {
        super.onStop();
        NluClient.getInstance().destroy(this);
    }
}
