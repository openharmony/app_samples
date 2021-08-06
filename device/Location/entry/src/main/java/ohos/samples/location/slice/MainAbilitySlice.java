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

package ohos.samples.location.slice;

import ohos.samples.location.MainAbility;
import ohos.samples.location.ResourceTable;
import ohos.samples.location.location.LocationBean;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.bundle.IBundleManager;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.location.GeoAddress;
import ohos.location.GeoConvert;
import ohos.location.Location;
import ohos.location.Locator;
import ohos.location.LocatorCallback;
import ohos.location.RequestParam;

import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int EVENT_ID = 0x12;

    private static final String PERM_LOCATION = "ohos.permission.LOCATION";

    private final LocatorResult locatorResult = new LocatorResult();

    private Context context;

    private Locator locator;

    private GeoConvert geoConvert;

    private List<GeoAddress> gaList;

    private LocationBean locationDetails;

    private Text geoAddressInfoText;

    private Text locationInfoText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ohos.samples.location.ResourceTable.Layout_main_ability_slice);
        initComponents();
        register(this);
    }

    private void initComponents() {
        Component startLocatingButton = findComponentById(ResourceTable.Id_start_locating);
        startLocatingButton.setClickedListener(component -> registerLocationEvent());
        Component stopLocatingButton = findComponentById(ResourceTable.Id_stop_locating);
        stopLocatingButton.setClickedListener(component -> unregisterLocationEvent());
        locationInfoText = (Text) findComponentById(ResourceTable.Id_location_info);
        geoAddressInfoText = (Text) findComponentById(ResourceTable.Id_geo_address_info);
    }

    private void notifyLocationChange(LocationBean locationDetails) {
        update(locationDetails);
    }

    private void update(LocationBean locationDetails) {
        locationInfoText.setText("");
        locationInfoText.append("Latitude : " + locationDetails.getLatitude() + System.lineSeparator());
        locationInfoText.append("Longitude : " + locationDetails.getLongitude() + System.lineSeparator());
        locationInfoText.append("Speed : " + locationDetails.getSpeed() + " m/s" + System.lineSeparator());
        locationInfoText.append("Direction : " + locationDetails.getDirection() + System.lineSeparator());
        locationInfoText.append("TimeStamp : " + locationDetails.getTime());

        geoAddressInfoText.setText("");
        geoAddressInfoText.append(
            "SubAdministrative : " + locationDetails.getSubAdministrative() + System.lineSeparator());
        geoAddressInfoText.append("RoadName : " + locationDetails.getRoadName() + System.lineSeparator());
        geoAddressInfoText.append("Locality : " + locationDetails.getLocality() + System.lineSeparator());
        geoAddressInfoText.append("Administrative : " + locationDetails.getAdministrative() + System.lineSeparator());
        geoAddressInfoText.append("CountryName : " + locationDetails.getCountryName());
    }

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            if (event.eventId == EVENT_ID) {
                notifyLocationChange(locationDetails);
            }
        }
    };

    private void register(Context ability) {
        context = ability;
        requestPermission();
    }

    private void registerLocationEvent() {
        if (hasPermissionGranted()) {
            int timeInterval = 0;
            int distanceInterval = 0;
            locator = new Locator(context);
            RequestParam requestParam = new RequestParam(RequestParam.PRIORITY_ACCURACY, timeInterval, distanceInterval);
            locator.startLocating(requestParam, locatorResult);
        }
    }

    private void unregisterLocationEvent() {
        if (locator != null) {
            locator.stopLocating(locatorResult);
        }
    }

    private boolean hasPermissionGranted() {
        return context.verifySelfPermission(PERM_LOCATION) == IBundleManager.PERMISSION_GRANTED;
    }

    private void requestPermission() {
        if (context.verifySelfPermission(PERM_LOCATION) != IBundleManager.PERMISSION_GRANTED) {
            context.requestPermissionsFromUser(new String[] {PERM_LOCATION}, 0);
        }
    }

    private class LocatorResult implements LocatorCallback {
        @Override
        public void onLocationReport(Location location) {
            HiLog.info(LABEL_LOG, "%{public}s",
                "onLocationReport : " + location.getLatitude() + "-" + location.getAltitude());
            setLocation(location);
        }

        @Override
        public void onStatusChanged(int statusCode) {
            HiLog.info(LABEL_LOG, "%{public}s", "MyLocatorCallback onStatusChanged : " + statusCode);
        }

        @Override
        public void onErrorReport(int errorCode) {
            HiLog.info(LABEL_LOG, "%{public}s", "MyLocatorCallback onErrorReport : " + errorCode);
        }
    }

    private void setLocation(Location location) {
        if (location != null) {
            Date date = new Date(location.getTimeStamp());
            locationDetails = new LocationBean();
            locationDetails.setTime(date.toString());
            locationDetails.setLatitude(location.getLatitude());
            locationDetails.setLongitude(location.getLongitude());
            locationDetails.setPrecision(location.getAccuracy());
            locationDetails.setSpeed(location.getSpeed());
            locationDetails.setDirection(location.getDirection());
            fillGeoInfo(locationDetails, location.getLatitude(), location.getLongitude());
            handler.sendEvent(EVENT_ID);
            gaList.clear();
        } else {
            HiLog.info(LABEL_LOG, "%{public}s", "EventNotifier or Location response is null");
            new ToastDialog(context).setText("EventNotifier or Location response is null").show();
        }
    }

    private void fillGeoInfo(LocationBean locationDetails, double geoLatitude, double geoLongitude) {
        if (geoConvert == null) {
            geoConvert = new GeoConvert();
        }
        if (geoConvert.isGeoAvailable()) {
            try {
                gaList = geoConvert.getAddressFromLocation(geoLatitude, geoLongitude, 1);
                if (!gaList.isEmpty()) {
                    GeoAddress geoAddress = gaList.get(0);
                    setGeo(locationDetails, geoAddress);
                }
            } catch (IllegalArgumentException | IOException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "fillGeoInfo exception");
            }
        }
    }

    private void setGeo(LocationBean locationDetails, GeoAddress geoAddress) {
        locationDetails.setRoadName(checkIfNullOrEmpty(geoAddress.getRoadName()));
        locationDetails.setLocality(checkIfNullOrEmpty(geoAddress.getLocality()));
        locationDetails.setSubAdministrative(checkIfNullOrEmpty(geoAddress.getSubAdministrativeArea()));
        locationDetails.setAdministrative(checkIfNullOrEmpty(geoAddress.getAdministrativeArea()));
        locationDetails.setCountryName(checkIfNullOrEmpty(geoAddress.getCountryName()));
    }

    private String checkIfNullOrEmpty(String value) {
        if (value == null || value.isEmpty()) {
            return "NA";
        }
        return value;
    }
}
