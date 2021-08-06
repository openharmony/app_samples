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

package ohos.samples.networkmanagement.slice;

import ohos.samples.networkmanagement.ResourceTable;
import ohos.samples.networkmanagement.utils.ThreadPoolUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.net.DataFlowStatistics;
import ohos.net.HttpResponseCache;
import ohos.net.NetHandle;
import ohos.net.NetManager;
import ohos.net.NetStatusCallback;
import ohos.rpc.RemoteException;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

/**
 * NetRequestSlice
 */
public class NetRequestSlice extends AbilitySlice {
    private static final String TAG = NetRequestSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private long rx;

    private long tx;

    private Text inputText;

    private Text outText;

    private NetManager netManager;

    private Text statisticsText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_net_request_slice);

        initComponents();
    }

    private void initComponents() {
        Component startButton = findComponentById(ResourceTable.Id_start_button);
        inputText = (Text) findComponentById(ResourceTable.Id_input_text);
        outText = (Text) findComponentById(ResourceTable.Id_out_text);
        statisticsText = (Text) findComponentById(ResourceTable.Id_statistics_text);
        startButton.setClickedListener(this::netRequest);
    }

    private void netRequest(Component component) {
        netManager = NetManager.getInstance(null);
        if (!netManager.hasDefaultNet()) {
            return;
        }
        ThreadPoolUtil.submit(() -> {
            NetHandle netHandle = netManager.getDefaultNet();
            netManager.addDefaultNetStatusCallback(callback);
            HttpURLConnection connection = null;
            try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                String urlString = inputText.getText();
                URL url = new URL(urlString);
                URLConnection urlConnection = netHandle.openConnection(url, java.net.Proxy.NO_PROXY);
                if (urlConnection instanceof HttpURLConnection) {
                    connection = (HttpURLConnection) urlConnection;
                }
                connection.setRequestMethod("GET");
                connection.connect();
                trafficDataStatistics(false);
                try (InputStream inputStream = urlConnection.getInputStream()) {
                    byte[] cache = new byte[2 * 1024];
                    int len = inputStream.read(cache);
                    while (len != -1) {
                        outputStream.write(cache, 0, len);
                        len = inputStream.read(cache);
                    }
                } catch (IOException e) {
                    HiLog.error(LABEL_LOG, "%{public}s", "netRequest inner IOException");
                }
                String result = new String(outputStream.toByteArray());
                getUITaskDispatcher().asyncDispatch(() -> outText.setText(result));
                trafficDataStatistics(true);
                HttpResponseCache.getInstalled().flush();
            } catch (IOException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "netRequest IOException");
            }
        });
    }

    private final NetStatusCallback callback = new NetStatusCallback() {
        @Override
        public void onAvailable(NetHandle handle) {
            HiLog.info(LABEL_LOG, "%{public}s", "NetStatusCallback onAvailable");
        }

        @Override
        public void onBlockedStatusChanged(NetHandle handle, boolean blocked) {
            HiLog.info(LABEL_LOG, "%{public}s", "NetStatusCallback onBlockedStatusChanged");
        }
    };

    private void trafficDataStatistics(boolean isStart) {
        int uid = 0;
        try {
            uid = getBundleManager().getUidByBundleName(getBundleName(), 0);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "trafficDataStatistics RemoteException");
        }
        if (isStart) {
            rx = DataFlowStatistics.getUidRxBytes(uid);
            tx = DataFlowStatistics.getUidTxBytes(uid);
        } else {
            rx = DataFlowStatistics.getUidRxBytes(uid) - rx;
            tx = DataFlowStatistics.getUidTxBytes(uid) - tx;
            getUITaskDispatcher().asyncDispatch(() -> statisticsText.setText(
                "TrafficDataStatistics:" + System.lineSeparator() + "Uplink traffic:" + rx + System.lineSeparator()
                    + "Downstream traffic:" + tx));
        }
    }
}
