/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.All rights reserved.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.distributedshoppingcart.been;

import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;

import java.util.ArrayList;
import java.util.List;

/**
 * ShoppingCartManage
 */
public class ShoppingCartManage {
    public static final String INTENT_TITLE = "intent_title";
    public static final String INTENT_CONTENT = "intent_content";
    public static final String INTENT_IMAGE = "intent_image";
    public static final String INTENT_IMAGE_DETAIL = "intent_image_detail";
    public static final String INTENT_OTHER_CONTENT = "intent_other_content";
    public static final String INTENT_PRICE = "intent_price";
    public static final String INTENT_PARAM = "intent_param";
    public static final String INTENT_PARAM2 = "intent_param2";
    public static final String INTENT_DISCOUNT = "intent_discount";

    public static List<ProductInfo> productInfoList = new ArrayList<>();
    public static List<ProductInfo> myShoppingCart = new ArrayList<>();
    public static List<ProductInfo> someOneShoppingCart = new ArrayList<>();
    public static String actionShoppingCart = "action.share";
    public static String devName = "";

    public static final String SUB_EVENT = "SUB_EVENT";
    public static final String ACTION_EVENT = "ACTION_EVENT";
    public static final String MEGER_EVENT = "meger";
    public static final String SHARE_EVENT = "share";
    public static final String TOTAL_MONEY = "TOTAL_MONEY";
    public static final String DISCOUNT_MONEY = "DISCOUNT_MONEY";
    public static final String NEED_PAY = "NEED_PAY";
    private static final List<DeviceInfo> DEVICES = new ArrayList<>();

    /**
     * getDevices
     *
     * @return the device info
     */
    public static List<DeviceInfo> getDevices() {
        if (DEVICES.size() > 0) {
            DEVICES.clear();
        }
        List<DeviceInfo> deviceInfos =
                DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ONLINE_DEVICE);
        DEVICES.addAll(deviceInfos);
        devName = deviceInfos.get(0).getDeviceName();
        return DEVICES;
    }

    /**
     * addProductInfo
     *
     * @param listInfo the product info list
     * @param info the product info
     */
    public static void addProductInfo(List<ProductInfo> listInfo,ProductInfo info) {
        if (info == null) {
            return;
        }
        if (listInfo.size() == 0) {
            listInfo.add(info);
            return;
        }
        for (int idx = 0; idx < listInfo.size(); idx++) {
            if (info.getTitle() != null && !info.getTitle().equals(listInfo.get(idx).getTitle())){
                listInfo.add(info);
                break;
            } else if (info.getTitle() != null && info.getTitle().equals(listInfo.get(idx).getTitle())) {
                int num = Integer.parseInt(listInfo.get(idx).getNum());
                num++;
                listInfo.get(idx).setNum(String.valueOf(num));
                break;
            }
        }
    }

    /**
     * addProductList
     *
     * @param desList the dest list
     * @param srcList the source list
     */
    public static void addProductList(List<ProductInfo> desList,List<ProductInfo> srcList) {
        if(desList.size() == 0) {
            desList.addAll(srcList);
            return;
        }
        for (ProductInfo productInfo : srcList) {
            addProductInfo(desList, productInfo);
        }
    }
}
