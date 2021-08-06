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
import ohos.net.NetHandle;
import ohos.net.NetManager;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/**
 * Socket Client Slice
 */
public class SocketClientSlice extends AbilitySlice {
    private static final String TAG = SocketClientSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int PORT = 8888;

    private Text inputText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_socket_client_slice);

        initComponents();
    }

    private void initComponents() {
        Component startButton = findComponentById(ResourceTable.Id_start_button);
        inputText = (Text) findComponentById(ResourceTable.Id_input_text);
        startButton.setClickedListener(this::netRequest);
    }

    private void netRequest(Component component) {
        ThreadPoolUtil.submit(() -> {
            NetManager netManager = NetManager.getInstance(null);
            if (!netManager.hasDefaultNet()) {
                return;
            }
            try (DatagramSocket socket = new DatagramSocket()) {
                NetHandle netHandle = netManager.getDefaultNet();
                InetAddress address = netHandle.getByName(inputText.getText());
                netHandle.bindSocket(socket);
                byte[] buffer = "I'm from Client".getBytes();
                DatagramPacket request = new DatagramPacket(buffer, buffer.length, address, PORT);
                socket.send(request);
            } catch (IOException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "netRequest IOException");
            }
        });
    }
}
