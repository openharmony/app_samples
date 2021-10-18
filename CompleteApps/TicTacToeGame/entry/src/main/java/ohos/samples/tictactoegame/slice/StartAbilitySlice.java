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

package ohos.samples.tictactoegame.slice;

import com.daimajia.ohosanimations.library.Techniques;
import com.daimajia.ohosanimations.library.YoYo;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Image;
import ohos.agp.components.RoundProgressBar;
import ohos.app.dispatcher.TaskDispatcher;
import ohos.bundle.ElementName;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.rpc.IRemoteObject;
import ohos.samples.tictactoegame.ResourceTable;
import ohos.samples.tictactoegame.connections.MyRemoteProxy;
import ohos.samples.tictactoegame.utils.DeviceUtils;
import ohos.samples.tictactoegame.utils.GameStatusUtils;
import ohos.samples.tictactoegame.utils.PkUtils;

import java.util.Timer;
import java.util.TimerTask;

/**
 * StartAbilitySlice
 */
public class StartAbilitySlice extends AbilitySlice {
    private static final int NOT_USE = 0;
    private static final int USE = 1;
    private static final int STATSUS_OFF = 0;
    private static final int STATSUS_ON = 1;
    private static final int IS_HOST = 1;
    private static final int IS_ADV = 2;
    private static final int IS_STOP = 3;
    private static final int COL_NUM = 3;
    private static final int ROW_NUM = 3;
    private static final int GAME_LOSE = 0;
    private static final int GAME_WIN = 1;
    private static final int GAME_DOGFALL = 2;

    private static final int GAME_COM_CLICK1 = 101;
    private static final int GAME_COM_CLICK9 = 109;
    private static final int GAME_COM_GAME_START = 110;

    private static final int GAME_DEFAULT_VALUE = 0;
    private static final int GAME_COM_IS_SLAVE = 301;
    private static final int GAME_COM_LOST = 401;
    private static final int GAME_COM_WIN = 402;
    private static final int GAME_COM_DOGFALL = 403;
    private static final int GAME_COM_EXIT = 404;
    private static final int GAME_COM_RESTART = 501;

    private static final int GAME_COUNT_TIME = 10;
    private static final int GAME_DELAY_LONG = 1000;
    private static final int GAME_DELAY_SHORT = 500;

    private static final int HALF_GRID = 5;

    private static final int BUTTON_IDX_0 = 0;
    private static final int BUTTON_IDX_1 = BUTTON_IDX_0 + 1;
    private static final int BUTTON_IDX_2 = BUTTON_IDX_1 + 1;
    private static final int BUTTON_IDX_3 = BUTTON_IDX_2 + 1;
    private static final int BUTTON_IDX_4 = BUTTON_IDX_3 + 1;
    private static final int BUTTON_IDX_5 = BUTTON_IDX_4 + 1;
    private static final int BUTTON_IDX_6 = BUTTON_IDX_5 + 1;
    private static final int BUTTON_IDX_7 = BUTTON_IDX_6 + 1;
    private static final int BUTTON_IDX_8 = BUTTON_IDX_7 + 1;

    private final static int[][] HOST = {{NOT_USE, NOT_USE, NOT_USE},
        {NOT_USE, NOT_USE, NOT_USE}, {NOT_USE, NOT_USE, NOT_USE}};
    private final static int[][] ADVERSARY = {{NOT_USE, NOT_USE, NOT_USE},
        {NOT_USE, NOT_USE, NOT_USE}, {NOT_USE, NOT_USE, NOT_USE}};

    private static boolean isButtonRefresh;
    private static boolean isButtonBack;
    private int pageStatus = STATSUS_OFF;
    private static int gameStatus = STATSUS_OFF;
    private static int playGame;

    private static Image image1;
    private static Image image2;
    private static Image image3;
    private static Image image4;
    private static Image image5;
    private static Image image6;
    private static Image image7;
    private static Image image8;
    private static Image image9;

    private static Image imageBack;
    private static Image imageRefresh;
    private static Image imageMe;

    private static int myImg;
    private static int advImg;
    private static int resetImg;
    private static MyRemoteProxy myProxy = null;

    private static boolean countDownSwitch;
    private static Timer timer = null;
    private static int midTime;
    private static TaskDispatcher myTaskDis;
    private static RoundProgressBar roPrbar;

    private final IAbilityConnection conn = new IAbilityConnection() {
        @Override
        public void onAbilityConnectDone(ElementName elementName, IRemoteObject remoteObject, int i) {
            myProxy = new MyRemoteProxy(remoteObject);
        }

        @Override
        public void onAbilityDisconnectDone(ElementName elementName, int i) {
        }
    };

    private void buttonClick(Image imageButton, int idx) {
        int row = idx / ROW_NUM;
        int column = idx % COL_NUM;

        if (myProxy == null) {
            return;
        }

        if ((HOST[row][column] != NOT_USE) || (ADVERSARY[row][column] != NOT_USE)) {
            return;
        }

        if ((gameStatus == STATSUS_ON) && (playGame == IS_HOST)) {
            HOST[row][column] = USE;
            myProxy.sendCmd(GAME_COM_CLICK1 + idx);
            imgUiGenOpe();
            imageButton.setPixelMap(myImg);
        }
    }

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_ability_start);

        myTaskDis = getUITaskDispatcher();
        resetImg = ResourceTable.Media_littleBK;
        PkUtils.showTip(StartAbilitySlice.this);

        preInit();
        imageMe = (Image) findComponentById(ResourceTable.Id_img_me);
        Image imageDv = (Image) findComponentById(ResourceTable.Id_img_dv);

        int recParam = intent.getIntParam("data",GAME_DEFAULT_VALUE);
        if (recParam == GAME_COM_IS_SLAVE) {
            imageMe.setPixelMap(ResourceTable.Media_user_fork_me);
            imageDv.setPixelMap(ResourceTable.Media_user_circled_huawei);
            if (pageStatus == STATSUS_OFF) {
                pageStatus = STATSUS_ON;
                gameStatus = STATSUS_ON;

                myImg = ResourceTable.Media_fork;
                advImg = ResourceTable.Media_circled;
                playGame = IS_ADV;
            }
        } else {
            imageMe.setPixelMap(ResourceTable.Media_user_circled_me);
            imageDv.setPixelMap(ResourceTable.Media_user_fork_huawei);
            String recParamUser = intent.getStringParam("user");
            if (recParamUser != null) {
                pageStatus = STATSUS_ON;
                gameStatus = STATSUS_ON;
                myImg = ResourceTable.Media_circled;
                advImg = ResourceTable.Media_fork;
                playGame = IS_HOST;

                countDownSwitch = true;
                midTime = GAME_COUNT_TIME;
                gameTimer();
            }
        }
        initView();
        initListener();
        resetImg();
    }

    private void initView() {
        String deviceId = DeviceUtils.getDeviceId();
        if (deviceId != null) {
            Intent connectPaIntent = new Intent();
            Operation op1 = new Intent.OperationBuilder()
                    .withDeviceId(deviceId)
                    .withBundleName(getBundleName())
                    .withAbilityName("ohos.samples.tictactoegame.RemoteServiceAbility")
                    .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
                    .build();
            connectPaIntent.setOperation(op1);
            connectAbility(connectPaIntent, conn);
        }

        imageBack = (Image) findComponentById(ResourceTable.Id_img_back);
        imageBack.setPixelMap(ResourceTable.Media_icon_back_dont_set);
        imageBack.setClickedListener(componet -> {
            if (isButtonBack) {
                isButtonRefresh = false;
                countDownSwitch = false;
                Intent intent1 = new Intent();
                present(new MainAbilitySlice(),intent1);
            }
        });
        imageRefresh = (Image) findComponentById(ResourceTable.Id_img_refresh);
        imageRefresh.setPixelMap(ResourceTable.Media_icon_refresh_dont_set);
        imageRefresh.setClickedListener(component -> {
            if (isButtonRefresh) {
                reSetStart();
                myProxy.sendCmd(GAME_COM_RESTART);
                PkUtils.showTip(StartAbilitySlice.this);
                playGame = IS_HOST;
                isButtonRefresh = false;
                countDownSwitch = true;
                midTime = GAME_COUNT_TIME;
                gameTimer();
            }
        });
    }

    private void initListener() {
        image1 = (Image) findComponentById(ResourceTable.Id_img1);
        image1.setClickedListener(componet ->buttonClick(image1, BUTTON_IDX_0));

        image2 = (Image) findComponentById(ResourceTable.Id_img2);
        image2.setClickedListener(componet ->buttonClick(image2, BUTTON_IDX_1));

        image3 = (Image) findComponentById(ResourceTable.Id_img3);
        image3.setClickedListener(componet ->buttonClick(image3, BUTTON_IDX_2));

        image4 = (Image) findComponentById(ResourceTable.Id_img4);
        image4.setClickedListener(componet ->buttonClick(image4, BUTTON_IDX_3));

        image5 = (Image) findComponentById(ResourceTable.Id_img5);
        image5.setClickedListener(componet ->buttonClick(image5, BUTTON_IDX_4));

        image6 = (Image) findComponentById(ResourceTable.Id_img6);
        image6.setClickedListener(componet ->buttonClick(image6, BUTTON_IDX_5));

        image7 = (Image) findComponentById(ResourceTable.Id_img7);
        image7.setClickedListener(componet ->buttonClick(image7, BUTTON_IDX_6));

        image8 = (Image) findComponentById(ResourceTable.Id_img8);
        image8.setClickedListener(componet ->buttonClick(image8, BUTTON_IDX_7));

        image9 = (Image) findComponentById(ResourceTable.Id_img9);
        image9.setClickedListener(componet ->buttonClick(image9, BUTTON_IDX_8));
    }

    private static void runImg(Image useImage) {
        YoYo.with(Techniques.Swing)
                .duration(GAME_DELAY_LONG)
                .delay(GAME_DELAY_SHORT)
                .playOn(useImage);
    }

    private void preInit() {
        isButtonBack = false;
        isButtonRefresh = false;
        countDownSwitch = false;
        timer = null;

        pageStatus = STATSUS_OFF;
        gameStatus = STATSUS_OFF;
        for (int row = 0; row < ROW_NUM; row++) {
            for (int col = 0; col < COL_NUM; col++) {
                HOST[row][col] = NOT_USE;
                ADVERSARY[row][col] = NOT_USE;
            }
        }
        cleanCheckerboard(HOST);
        cleanCheckerboard(ADVERSARY);
        roPrbar = (RoundProgressBar)findComponentById(ResourceTable.Id_round_progress_bar);
        roPrbar.setProgressValue(0);
        roPrbar.setProgressHintText("0");
    }

    private static void gameOver() {
        playGame = IS_STOP;
        countDownSwitch = false;
        if (timer != null) {
            timer.cancel();
        }
        isButtonBack = true;
    }

    private void imgUiGenOpe() {
        playGame = IS_ADV;
        countDownSwitch = false;
        timer.cancel();

        isButtonBack = false;
        int ret = drudge();
        if (ret == GAME_WIN) {
            myProxy.sendCmd(GAME_COM_LOST);
            GameStatusUtils.showWin(this);
            isButtonBack = true;
            imageBack.setPixelMap(ResourceTable.Media_icon_back);
            playGame = IS_STOP;
        } else if (ret == GAME_DOGFALL) {
            myProxy.sendCmd(GAME_COM_DOGFALL);
            GameStatusUtils.showTie(this);
            isButtonBack = true;
            imageBack.setPixelMap(ResourceTable.Media_icon_back);
        }
        myProxy.sendCmd(GAME_COM_GAME_START);
    }

    private static void backEventGenOpe() {
        isButtonRefresh = false;
        isButtonBack = false;
        countDownSwitch = true;
        playGame = IS_HOST;
        gameStatus = STATSUS_OFF;
        midTime = GAME_COUNT_TIME;
        gameTimer();
    }

    private static final EventRunner EVENT_RUNNER = EventRunner.current();
    private static final EventHandler EVENT_HANDLER = new EventHandler(EVENT_RUNNER) {
        private void dealButtonClick(int idx) {
            int row = idx / ROW_NUM;
            int column = idx % COL_NUM;
            Image[] imageButton = {image1, image2, image3, image4, image5, image6, image7, image8, image9};

            imageButton[idx].setPixelMap(advImg);
            ADVERSARY[row][column] = USE;
            backEventGenOpe();
        }

        @Override
        protected void processEvent(InnerEvent event) {
            super.processEvent(event);

            if (event.eventId >= GAME_COM_CLICK1 && event.eventId <= GAME_COM_CLICK9) {
                dealButtonClick(event.eventId - GAME_COM_CLICK1);
                return;
            }

            switch (event.eventId) {
                case GAME_COM_GAME_START:
                    gameStatus = STATSUS_ON;
                    break;
                case GAME_COM_RESTART:
                    if (isButtonBack) {
                        reSetStart();
                        PkUtils.showTip(StartAbilitySlice.image1.getContext());
                    }
                    imageBack.setPixelMap(ResourceTable.Media_icon_back_dont_set);
                    playGame = IS_ADV;
                    break;
                case GAME_COM_LOST:
                    GameStatusUtils.showFaild(StartAbilitySlice.image1.getContext());
                    isButtonRefresh = true;
                    imageRefresh.setPixelMap(ResourceTable.Media_icon_refresh);
                    isButtonBack = true;
                    imageBack.setPixelMap(ResourceTable.Media_icon_back);
                    gameOver();
                    break;
                case GAME_COM_WIN:
                    GameStatusUtils.showWin(StartAbilitySlice.image1.getContext());
                    isButtonBack = true;
                    imageBack.setPixelMap(ResourceTable.Media_icon_back);
                    gameOver();
                    break;
                case GAME_COM_EXIT:
                    countDownSwitch = true;
                    break;
                case GAME_COM_DOGFALL:
                    isButtonRefresh = true;
                    imageRefresh.setPixelMap(ResourceTable.Media_icon_refresh);
                    isButtonBack = true;
                    imageBack.setPixelMap(ResourceTable.Media_icon_back);
                    GameStatusUtils.showTie(StartAbilitySlice.image1.getContext());
                    gameOver();
                    break;
                default:
            }
        }
    };

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    public static EventHandler getHandler() {
        return EVENT_HANDLER;
    }

    private static void resetImg() {
        image1.setPixelMap(resetImg);
        image2.setPixelMap(resetImg);
        image3.setPixelMap(resetImg);
        image4.setPixelMap(resetImg);
        image5.setPixelMap(resetImg);
        image6.setPixelMap(resetImg);
        image7.setPixelMap(resetImg);
        image8.setPixelMap(resetImg);
        image9.setPixelMap(resetImg);
    }

    private static void reSetStart() {
        isButtonBack = false;
        resetImg();
        cleanCheckerboard(HOST);
        cleanCheckerboard(ADVERSARY);
        imageRefresh.setPixelMap(ResourceTable.Media_icon_refresh_dont_set);
        imageBack.setPixelMap(ResourceTable.Media_icon_back_dont_set);
        gameStatus = STATSUS_ON;
    }

    private int drudge() {
        for (int i = 0; i < ROW_NUM; i++) {
            if (HOST[i][BUTTON_IDX_0] == USE && HOST[i][BUTTON_IDX_1] == USE &&
                HOST[i][BUTTON_IDX_2] == USE) {
                return GAME_WIN;
            }
        }
        for (int i = 0; i < COL_NUM; i++) {
            if (HOST[BUTTON_IDX_0][i] == USE && HOST[BUTTON_IDX_1][i] == USE &&
                HOST[BUTTON_IDX_2][i] == USE) {
                return GAME_WIN;
            }
        }
        if (HOST[BUTTON_IDX_0][BUTTON_IDX_0] == USE && HOST[BUTTON_IDX_1][BUTTON_IDX_1] == USE &&
            HOST[BUTTON_IDX_2][BUTTON_IDX_2] == USE) {
            return GAME_WIN;
        }
        if (HOST[BUTTON_IDX_0][BUTTON_IDX_2] == USE && HOST[BUTTON_IDX_1][BUTTON_IDX_1] == USE &&
            HOST[BUTTON_IDX_2][BUTTON_IDX_0] == USE) {
            return GAME_WIN;
        }

        int useCount = 0;
        for (int horl = 0; horl < ROW_NUM; horl++) {
            for (int verl = 0; verl < COL_NUM; verl++) {
                if (HOST[horl][verl] == USE) {
                    useCount++;
                }
            }
        }
        if (useCount < HALF_GRID) {
            return GAME_LOSE;
        } else {
            return GAME_DOGFALL;
        }
    }

    private static void cleanCheckerboard(int[][] array) {
        for (int horl = 0; horl < ROW_NUM; horl++) {
            for (int verl = 0; verl < COL_NUM; verl++) {
                array[horl][verl] = NOT_USE;
            }
        }
    }

    private static void gameTimer() {
        timer = new Timer();
        timer.schedule(new TimerTask() {
            public void run() {
                midTime--;
                if (!countDownSwitch) {
                    myTaskDis.asyncDispatch(()-> roPrbar.setProgressValue(0));
                    timer.cancel();
                    return;
                }
                if (midTime >= 0) {
                    runImg(imageMe);
                    myTaskDis.asyncDispatch(()-> {
                        roPrbar.setProgressValue(midTime);
                        String sTime = String.valueOf(midTime);
                        roPrbar.setProgressHintText(sTime);
                    });
                } else {
                    timer.cancel();
                    myTaskDis.asyncDispatch(() -> {
                        GameStatusUtils.showFaild(StartAbilitySlice.image1.getContext());
                        isButtonRefresh = true;
                        imageRefresh.setPixelMap(ResourceTable.Media_icon_refresh);
                        isButtonBack = true;
                        imageBack.setPixelMap(ResourceTable.Media_icon_back);
                        gameOver();
                        if (myProxy != null) {
                            myProxy.sendCmd(GAME_COM_WIN);
                        }
                    });
                }
            }
        }, 0, GAME_DELAY_LONG);
    }
}
