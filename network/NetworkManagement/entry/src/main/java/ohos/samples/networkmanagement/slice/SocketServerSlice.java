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
import ohos.wifi.WifiDevice;
import ohos.wifi.WifiLinkedInfo;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Optional;

/**
 * Socket Server Slice
 */
public class SocketServerSlice extends AbilitySlice {
    private static final String TAG = SocketServerSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int PORT = 8888;

    private Text outText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_socket_server_slice);

        initComponents();
    }

    private void initComponents() {
        Component startButton = findComponentById(ResourceTable.Id_start_button);
        Text inputText = (Text) findComponentById(ResourceTable.Id_input_text);
        outText = (Text) findComponentById(ResourceTable.Id_out_text);
        startButton.setClickedListener(this::startServer);
        inputText.setText("Current device IP:" + System.lineSeparator() + getLocationIpAddress());
    }

    private void startServer(Component component) {
        ThreadPoolUtil.submit(() -> {
            try (DatagramSocket socket = new DatagramSocket(PORT)) {
                DatagramPacket packet = new DatagramPacket(new byte[255], 255);
                //noinspection InfiniteLoopStatement
                while (true) {
                    socket.receive(packet);
                    getUITaskDispatcher().syncDispatch(() -> outText.setText(
                        "Receive a message from :" + packet.getAddress().getHostAddress() + System.lineSeparator()
                            + " on port " + packet.getPort() + System.lineSeparator() + "message :" + new String(
                            packet.getData()).substring(0, packet.getLength())));
                    packet.setLength(255);
                    Thread.sleep(1000);
                }
            } catch (IOException | InterruptedException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "StartServer  IOException | InterruptedException");
            }
        });
    }

    private String getLocationIpAddress() {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        Optional<WifiLinkedInfo> linkedInfo = wifiDevice.getLinkedInfo();
        int ip = linkedInfo.get().getIpAddress();
        return (ip & 0xFF) + "." + ((ip >> 8) & 0xFF) + "." + ((ip >> 16) & 0xFF) + "." + (ip >> 24 & 0xFF);
    }
}
