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

package ohos.samples.compass.slice;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Image;
import ohos.agp.components.Text;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.samples.compass.ResourceTable;
import ohos.sensor.agent.CategoryOrientationAgent;
import ohos.sensor.bean.CategoryOrientation;
import ohos.sensor.data.CategoryOrientationData;
import ohos.sensor.listener.ICategoryOrientationDataCallback;

import java.util.Locale;

/**
 * the Main page
 */
public class PageAbilitySlice extends AbilitySlice {
    private static final String TAG = PageAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final long SAMPLING_INTERVAL_NANOSECONDS = 500000000L;

    private static final String FORMAT_DEGREE = "%.2f";

    private static final float DEFLECTION_FLAG = -1.0f;

    private CategoryOrientationAgent categoryOrientationAgent;

    private Image compassImg;

    private Text compassAngleText;

    private float degree;

    private ICategoryOrientationDataCallback categoryOrientationDataCallback;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            compassAngleText.setText(getRotation(degree));
            compassImg.setRotation(DEFLECTION_FLAG * degree);
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_page_ability_slice);
        compassImg = (Image) findComponentById(ResourceTable.Id_compass_icon_img);
        compassAngleText = (Text) findComponentById(ResourceTable.Id_compass_angle_text);
        categoryOrientationAgent = new CategoryOrientationAgent();
        CategoryOrientation categoryOrientation = categoryOrientationAgent.getSingleSensor(
            CategoryOrientation.SENSOR_TYPE_ORIENTATION);
        categoryOrientationDataCallback = new ICategoryOrientationDataCallback() {
            @Override
            public void onSensorDataModified(CategoryOrientationData categoryOrientationData) {
                degree = categoryOrientationData.getValues()[0];
                handler.sendEvent(0);
            }

            @Override
            public void onAccuracyDataModified(CategoryOrientation categoryOrientation, int i) {
                // Called when sensor accuracy data changes.
                // This method is called by the application layer to process the accuracy data of the sensors.
                HiLog.info(LABEL_LOG, "%{public}s", "onAccuracyDataModified");
            }

            @Override
            public void onCommandCompleted(CategoryOrientation categoryOrientation) {
                // Called when the sensor completes command execution.
                // This method is called by the application layer to process the command execution result of the sensor.
                HiLog.info(LABEL_LOG, "%{public}s", "onCommandCompleted");
            }
        };
        categoryOrientationAgent.setSensorDataCallback(categoryOrientationDataCallback, categoryOrientation,
            SAMPLING_INTERVAL_NANOSECONDS);
    }

    private String getRotation(float degree) {
        if (degree >= 0 && degree <= 22.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " N";
        } else if (degree > 22.5 && degree <= 67.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " NE";
        } else if (degree > 67.5 && degree <= 112.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " E";
        } else if (degree > 112.5 && degree <= 157.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " SE";
        } else if (degree > 157.5 && degree <= 202.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " S";
        } else if (degree > 202.5 && degree <= 247.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " SW";
        } else if (degree > 247.5 && degree <= 282.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " W";
        } else if (degree > 282.5 && degree <= 337.5) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " NW";
        } else if (degree > 337.5 && degree <= 360.0) {
            return String.format(Locale.ENGLISH, FORMAT_DEGREE, degree) + " N";
        } else {
            return "/";
        }
    }

    @Override
    protected void onStop() {
        HiLog.info(LABEL_LOG, "%{public}s", "onStop start");
        super.onStop();
        categoryOrientationAgent.releaseSensorDataCallback(categoryOrientationDataCallback);
        handler.removeAllEvent();
        HiLog.info(LABEL_LOG, "%{public}s", "onStop end");
    }
}
