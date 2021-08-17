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

package ohos.samples.progress.slice;

import ohos.samples.progress.ResourceTable;
import ohos.samples.progress.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ProgressBar;
import ohos.agp.components.Slider;
import ohos.agp.components.Text;
import ohos.agp.utils.Color;
import ohos.agp.window.dialog.ToastDialog;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;

import java.util.Timer;
import java.util.TimerTask;

/**
 * MainAbilitySlice extends AbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements Slider.ValueChangedListener {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();
    private static final int EVENT_ID = 0x12;
    private static final int DELAY_TIME = 1000;
    private static final int PERIOD = 1000;
    private Slider currentSlider;
    private Slider maxSlider;
    private Slider speedSlider;
    private Text currentText;
    private Text maxText;
    private Text speedText;
    private ProgressBar progressBar;
    private TimerTask timerTask;
    private Timer timer;
    private int frequencyValue;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            if (event.eventId == EVENT_ID) {
                progressBar.setProgressValue(progressBar.getProgress() + frequencyValue);
                if (progressBar.getProgress() >= maxSlider.getProgress()) {
                    finishTask();
                    new ToastDialog(MainAbilitySlice.this).setText("Progress Finish").show();
                }
            }
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        currentSlider = (Slider) findComponentById(ResourceTable.Id_current_value_slider);
        currentText = (Text) findComponentById(ResourceTable.Id_current_value_text);
        maxSlider = (Slider) findComponentById(ResourceTable.Id_max_value_slider);
        maxText = (Text) findComponentById(ResourceTable.Id_max_value_text);
        speedSlider = (Slider) findComponentById(ResourceTable.Id_speed_value_slider);
        speedText = (Text) findComponentById(ResourceTable.Id_speed_value_text);
        Component startProgressButton = findComponentById(ResourceTable.Id_start_progress_button);
        progressBar = (ProgressBar) findComponentById(ResourceTable.Id_progressbar);
        currentSlider.setValueChangedListener(this);
        maxSlider.setValueChangedListener(this);
        speedSlider.setValueChangedListener(this);
        progressBar.setProgressColor(Color.RED);
        startProgressButton.setClickedListener(component -> startProgress());
    }

    private void startProgress() {
        if (currentSlider.getProgress() > maxSlider.getProgress()) {
            new ToastDialog(this).setText("Error:Max < current").show();
            return;
        }
        frequencyValue = (maxSlider.getProgress() - currentSlider.getProgress())
                / (speedSlider.getProgress());
        progressBar.setProgressValue(currentSlider.getProgress());
        finishTask();
        startTask();
    }

    private void startTask() {
        timerTask = new TimerTask() {
            @Override
            public void run() {
                handler.sendEvent(EVENT_ID);
            }
        };
        timer = new Timer();
        timer.schedule(timerTask, DELAY_TIME, PERIOD);
    }

    private void finishTask() {
        if (timer != null && timerTask != null) {
            timer.cancel();
            timer = null;
            timerTask = null;
        }
    }

    @Override
    public void onProgressUpdated(Slider slider, int position, boolean isUpdated) {
        switch (slider.getId()) {
            case ResourceTable.Id_current_value_slider: {
                progressBar.setProgressValue(position);
                currentText.setText(String.valueOf(currentSlider.getProgress()));
                break;
            }
            case ResourceTable.Id_max_value_slider: {
                maxText.setText(String.valueOf(maxSlider.getProgress()));
                progressBar.setMaxValue(position);
                break;
            }
            case ResourceTable.Id_speed_value_slider: {
                speedText.setText(String.valueOf(speedSlider.getProgress()));
                break;
            }
            default:
                break;
        }
    }

    @Override
    public void onTouchStart(Slider slider) {
        LogUtil.debug(TAG, "Slider Touch Start");
    }

    @Override
    public void onTouchEnd(Slider slider) {
        LogUtil.debug(TAG, "Slider Touch End");
    }
}
