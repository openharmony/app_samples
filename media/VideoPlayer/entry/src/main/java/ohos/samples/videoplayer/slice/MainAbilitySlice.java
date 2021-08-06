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

package ohos.samples.videoplayer.slice;

import ohos.agp.components.*;
import ohos.samples.videoplayer.ResourceTable;
import ohos.samples.videoplayer.utils.LogUtil;
import ohos.samples.videoplayer.utils.VideoElementManager;
import ohos.samples.videoplayer.utils.VideoPlayerPlugin;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.surfaceprovider.SurfaceProvider;
import ohos.agp.graphics.Surface;
import ohos.agp.graphics.SurfaceOps;
import ohos.media.common.sessioncore.AVElement;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private SurfaceProvider surfaceProvider;

    private Text titleText;

    private VideoPlayerPlugin videoPlayerPlugin;

    private ListContainer listContainer;

    private List<AVElement> avElements = new ArrayList<>();

    private Surface surface;

    private VideoElementsListItemProvider videoElementsListItemProvider;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        addSurfaceProvider();
        initPlayer();
        initComponents();
    }

    private void addSurfaceProvider() {
        surfaceProvider = new SurfaceProvider(this);

        if (surfaceProvider.getSurfaceOps().isPresent()) {
            surfaceProvider.getSurfaceOps().get().addCallback(new SurfaceCallBack());
            surfaceProvider.pinToZTop(true);
        }

        DirectionalLayout directionalLayout = (DirectionalLayout) findComponentById(ResourceTable.Id_directionalLayout);
        directionalLayout.addComponent(surfaceProvider);
    }

    private void initPlayer() {
        videoPlayerPlugin = new VideoPlayerPlugin(getApplicationContext());
    }

    private void initComponents() {
        titleText = (Text) findComponentById(ResourceTable.Id_videoTitle_text);
        Component refreshButton = findComponentById(ResourceTable.Id_refresh_list_button);
        Component playButton = findComponentById(ResourceTable.Id_play_button);
        Component pauseButton = findComponentById(ResourceTable.Id_pause_button);
        Component seekButton = findComponentById(ResourceTable.Id_seek_button);
        listContainer = (ListContainer) findComponentById(ResourceTable.Id_listContainer);

        playButton.setClickedListener((Component component) -> videoPlayerPlugin.startPlay());
        pauseButton.setClickedListener(component -> videoPlayerPlugin.pausePlay());
        seekButton.setClickedListener(component -> videoPlayerPlugin.seek());
        refreshButton.setClickedListener(component -> refreshList());
        listContainer.setItemClickedListener((listRoom, component, position, l) -> play(position));
        videoElementsListItemProvider = new VideoElementsListItemProvider();
    }

    private void play(int position) {
        AVElement item = avElements.get(position);
        String itemText = item.getAVDescription().getTitle().toString();
        titleText.setText(itemText);
        videoPlayerPlugin.startPlay(videoElementsListItemProvider.getItem(position), surface);
    }

    private void refreshList() {
        VideoElementManager videoElementManager = new VideoElementManager(getApplicationContext());
        avElements = videoElementManager.getAvElements();
        listContainer.setItemProvider(videoElementsListItemProvider);
    }

    @Override
    public void onStop() {
        videoPlayerPlugin.release();
        super.onStop();
    }

    /**
     * SurfaceCallBack
     */
    class SurfaceCallBack implements SurfaceOps.Callback {
        @Override
        public void surfaceCreated(SurfaceOps callbackSurfaceOps) {
            if (surfaceProvider.getSurfaceOps().isPresent()) {
                surface = surfaceProvider.getSurfaceOps().get().getSurface();
                LogUtil.info(TAG, "surface set");
            }
        }

        @Override
        public void surfaceChanged(SurfaceOps callbackSurfaceOps, int format, int width, int height) {
            LogUtil.info(TAG, "surface changed");
        }

        @Override
        public void surfaceDestroyed(SurfaceOps callbackSurfaceOps) {
            LogUtil.info(TAG, "surface destroyed");
        }
    }

    class VideoElementsListItemProvider extends BaseItemProvider {
        @Override
        public int getCount() {
            return avElements.size();
        }

        @Override
        public AVElement getItem(int position) {
            return avElements.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public Component getComponent(int position, Component component, ComponentContainer componentContainer) {
            AVElement item = avElements.get(position);
            if (component == null) {
                String itemText = item.getAVDescription().getTitle().toString();
                Text text = (Text) LayoutScatter.getInstance(MainAbilitySlice.this)
                        .parse(ResourceTable.Layout_list_item, null, false);
                text.setText(itemText);
                return text;
            } else {
                return component;
            }
        }
    }
}
