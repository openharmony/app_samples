/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
#include "napi/native_api.h"
#include "common/plugin_common.h"
#include <js_native_api_types.h>
#include <node_api.h>
#include <sstream>
#include <string.h>
#include <thread>
#include "uv.h"
#include "chess.h"

int Max(int nums[4]) // 获取最大数
{
    int max = nums[0];
    for (int i = 1; i < 4; i++) {
        if (nums[i] > max)
        {
            max = nums[i];
        }
    }
    return max;
}

int GetMaxNumDirection(int nums[4]) // 获取最大连子数的方向
{
    int max = nums[0];
    int direction = 1;
    for (int i = 1; i < 4; i++) {
        if (nums[i] > max)
        {
            max = nums[i];
            direction = i + 1;
        }
    }
    return direction;
}

void ClearData() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            chessBoard[i][j] = 0;
        }
    }
    result[0] = NO_WIN;
    result[1] = SIZE + 1;
    result[2] = SIZE + 1;
    aiCoiledNum = 0;
}

// 获取水平方向连子数
int GetNumHorizontal(int x, int y, int chessType) {
    int total = 0;
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (y - a1 < 0) {
            break;
        }
        if(chessBoard[x][y - a1] != chessType) {
            break;
        }
        total++;
    }
    if (total >= WIN_NUM) {
        return total;
    }
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (y + a1 >= SIZE) {
            break;
        }
        if(chessBoard[x][y + a1] != chessType) {
            break;
        }
        total++;
    }
    return total;
}

// 获取垂直方向连子数
int GetNumVertical(int x, int y, int chessType) {
    int total = 0;
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x - a1 < 0) {
            break;
        }
        if(chessBoard[x - a1][y] != chessType) {
            break;
        }
        total++;
    }
    if (total >= WIN_NUM) {
        return total;
    }
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x + a1 >= SIZE) {
            break;
        }
        if(chessBoard[x + a1][y] != chessType) {
            break;
        }
        total++;
    }
    return total;
}

// 获取左斜线方向连子数
int GetNumLeftSlash(int x, int y, int chessType)
{
    int total = 0;
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x - a1 < 0 || y - a1 < 0) {
            break;
        }
        if(chessBoard[x - a1][y - a1] != chessType) {
            break;
        }
        total++;
    }
    if (total >= WIN_NUM) {
        return total;
    }
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x + a1 >= SIZE || y + a1 >= SIZE) {
            break;
        }
        if(chessBoard[x + a1][y + a1] != chessType) {
            break;
        }
        total++;
    }
    return total;
}

// 获取右斜线方向连子数
int GetNumRightSlash(int x, int y, int chessType) {
    int total = 0;
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x - a1 < 0 || y + a1 >= SIZE) {
            break;
        }
        if(chessBoard[x - a1][y + a1] != chessType) {
            break;
        }
        total++;
    }
    if (total >= WIN_NUM) {
        return total;
    }
    for (int a1 = 1; a1 < WIN_NUM; a1++) {
        if (x + a1 >= SIZE || y - a1 < 0) {
            break;
        }
        if(chessBoard[x + a1][y - a1] != chessType) {
            break;
        }
        total++;
    }
    return total;
}

// 将int数值转为char放进char数组的指定位置
void PutInt2Char(char * charData, int beginIndex, int endIndex, int intValue) {
    if (intValue < 10) { // 当int数值《10时,char数组第一个位置值为0转换为char，第二个位置是int数值转换为char
        charData[beginIndex] = '0';
        charData[endIndex] = intValue + '0';
    } else { // 当int数值>=10时,char数组第一个位置值为1转换为char，第二个位置是int数值减10后的数值转换为char
        charData[beginIndex] = 1 + '0';
        charData[endIndex] = (intValue - 10) + '0';
    }
}

void AIPlay()
{
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (chessBoard[i][j] != 0)
                continue;
            LOGD("判断四个方向连子");
            int numHorizontal = GetNumHorizontal(i, j, AI_CHESS);
            int numVertical = GetNumVertical(i, j, AI_CHESS);
            int numLeftSlash = GetNumLeftSlash(i, j, AI_CHESS);
            int numRightSlash = GetNumRightSlash(i, j, AI_CHESS);
            int nums[4] = { numHorizontal, numVertical, numLeftSlash, numRightSlash };
            int maxNum = Max(nums);

            if (maxNum >= WIN_NUM - 1) {
                LOGD("AI已获胜");
                chessBoard[i][j] = AI_CHESS;
                result[0] = AI_WIN;
                result[1] = i;
                result[2] = j;
                return;
            }
        }
    }
    LOGD("判断对手是否有大于三子的情况");
    for (int i = 0; i < SIZE; i++) {  //判断对手是否有大于三子的情况
        for (int j = 0; j < SIZE; j++) {
            if (chessBoard[i][j] == USER_CHESS || chessBoard[i][j] == AI_CHESS)
                continue;
            int numHorizontal = GetNumHorizontal(i, j, USER_CHESS);
            int numVertical = GetNumVertical(i, j, USER_CHESS);
            int numLeftSlash = GetNumLeftSlash(i, j, USER_CHESS);
            int numRightSlash = GetNumRightSlash(i, j, USER_CHESS);
            int nums[4] = { numHorizontal, numVertical, numLeftSlash, numRightSlash };
            int maxNum = Max(nums);
            int direction = GetMaxNumDirection(nums); //获取哪个方向上连子最多，1表示水平线，2代表竖直线，3代表左斜线，4代表右斜线
            if (maxNum == 3) { //对手已经三子，此时要分情况,有边界的三子不用堵，没有边界的三子需要堵
                LOGD("对手已经三子，此时要分情况,有边界的三子不用堵，没有边界的三子需要堵");
                if (direction == 1) {  //水平线有三子
                    LOGD("水平线有三子");
                    int num;
                    int numDirection1 = 0;
                    for (num = 1; num <= 3; num++) {
                        if (j - num < 0) {
                            break;
                        }
                        if (chessBoard[i][j - num] != USER_CHESS) {
                            break;
                        }
                        numDirection1++;
                    }
                    if (numDirection1 == 3) {
                        if (j - num - 1 >= 0) {
                            if (chessBoard[i][j - num - 1] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = 0;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    } else if (numDirection1 == 2) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection1 == 1) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection1 == 0) {
                        if (j + num < SIZE) {
                            if (chessBoard[i][j + num + 1] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                } //水平线三子情况判断结束
                else if (direction == 2) { //竖直线有三子的情况
                    LOGD("竖直线有三子的情况");
                    int num;
                    int numDirection2 = 0;
                    for (num = 1; num <= 3; num++) {
                        if (i - num < 0) {
                            break;
                        }
                        if (chessBoard[i - num][j] != USER_CHESS) {
                            break;
                        }
                        numDirection2++;
                    }
                    if (numDirection2 == 3) {
                        if (i - num - 1 >= 0) {
                            if (chessBoard[i - num - 1][j] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                    else if (numDirection2 == 2) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    } else if (numDirection2 == 1) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection2 == 0) {
                        if (i + num < SIZE - 1) {
                            if (chessBoard[i + num + 1][j] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                }  //竖直线有三子情况判断结束
                else if (direction == 3) { //左斜线有三子的情况
                    LOGD("左斜线有三子的情况");
                    int num;
                    int numDirection3 = 0;
                    for (num = 1; num <= 3; num++) {
                        if (i - num < 0 || j - num < 0) {
                            break;
                        }
                        if (chessBoard[i - num][j - num] != USER_CHESS) {
                            break;
                        }
                        numDirection3++;
                    }
                    if (numDirection3 == 3) {
                        if (i - num - 1 >= 0 && j - num - 1 >= 0) {
                            if (chessBoard[i - num - 1][j - num - 1] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                    else if (numDirection3 == 2) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection3 == 1) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection3 == 0) {
                        if (i + num < SIZE - 1 && j + num < SIZE - 1) {
                            if (chessBoard[i + num + 1][j + num + 1] == NO_CHESS) {
                                chessBoard[i][j] = 2;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                }  //左斜线三子情况判断结束
                else if (direction == 4) { //判断右斜线有三子的情况
                    LOGD("判断右斜线有三子的情况");
                    int num;
                    int numDirection4 = 0;
                    for (num = 1; num <= 3; num++) {
                        if (i - num < 0 || j + num >SIZE - 1) {
                            break;
                        }
                        if (chessBoard[i - num][j + num] == USER_CHESS) {
                            break;
                        }
                        numDirection4++;
                    }

                    if (numDirection4 == 3) {
                        if (i - num - 1 >= 0 && j + num + 1 <= SIZE - 1) {
                            if (chessBoard[i - num - 1][j + num + 1] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }

                    else if (numDirection4 == 2) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection4 == 1) {
                        chessBoard[i][j] = AI_CHESS;
                        result[0] = NO_WIN;
                        result[1] = i;
                        result[2] = j;
                        return;
                    }
                    else if (numDirection4 == 0) {
                        if (i + num < SIZE - 1 && j - num >
                            0)
                        {
                            if (chessBoard[i + num + 1][j - num - 1] == NO_CHESS) {
                                chessBoard[i][j] = AI_CHESS;
                                result[0] = NO_WIN;
                                result[1] = i;
                                result[2] = j;
                                return;
                            }
                        }
                    }
                } //右斜线三子情况判断结束
            }  //对手有三子的情况结束
            else if (maxNum == WIN_NUM - 1 || maxNum == WIN_NUM) {   //对手有四子或五子，一定要堵
                LOGD("对手有四子或五子，一定要堵");
                chessBoard[i][j] = AI_CHESS;
                result[0] = NO_WIN;
                result[1] = i;
                result[2] = j;
                return;
            }
        }
    }

    int totalNum = 0;
    int emptyNum = 0;
    //判断对手连子情况结束，开始连自己五子
    LOGD("判断对手连子情况结束，开始连自己五子");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (chessBoard[i][j] == AI_CHESS) {
                totalNum++;
            }
            if (chessBoard[i][j] == NO_CHESS) {
                emptyNum++;
            }
        }
    }

    if (emptyNum == 0) { // 没有位置了
        result[0] = NO_WIN;
        result[1] = SIZE + 1;
        result[2] = SIZE + 1;
        return;
    }

    if (totalNum == 0) {
        LOGD("第一次落子");
        chessBoard[7][7] = AI_CHESS;
        result[0] = NO_WIN;
        result[1] = 7;
        result[2] = 7;
        return;
    }

    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (chessBoard[i][j] != NO_CHESS)
                continue;
            int numHorizontal = GetNumHorizontal(i, j, AI_CHESS);
            int numVertical = GetNumVertical(i, j, AI_CHESS);
            int numLeftSlash = GetNumLeftSlash(i, j, AI_CHESS);
            int numRightSlash = GetNumRightSlash(i, j, AI_CHESS);
            int nums[4] = { numHorizontal, numVertical, numLeftSlash, numRightSlash };
            int maxNum = Max(nums);
            if (maxNum > aiCoiledNum) {
                chessBoard[i][j] = AI_CHESS;
                result[0] = NO_WIN;
                result[1] = i;
                result[2] = j;
                aiCoiledNum = maxNum;
                return;
            } else if (maxNum >= 1) {
                result[0] = NO_WIN;
                result[1] = i;
                result[2] = j;
            }
        }
    }
    chessBoard[result[1]][result[2]] = AI_CHESS;
}

static napi_value Put(napi_env env, napi_callback_info info) {
    napi_status status;
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_valuetype valuetype;
    status = napi_typeof(env, args[0], &valuetype);
    if (status != napi_ok) {
        return nullptr;
    }
    if (valuetype != napi_number) {
        napi_throw_type_error(env, NULL, "Wrong arguments");
        return nullptr;
    }
    status = napi_typeof(env, args[1], &valuetype);
    if (status != napi_ok) {
        return nullptr;
    }
    if (valuetype != napi_number) {
        napi_throw_type_error(env, NULL, "Wrong arguments");
        return nullptr;
    }

    int x1;
    napi_get_value_int32(env, args[0], &x1);
    int y1;
    napi_get_value_int32(env, args[1], &y1);

    chessBoard[x1][y1] = USER_CHESS;

    int result = 0;
    //判断同一直线上位置是否有五子
    int numHorizontal = GetNumHorizontal(x1, y1, USER_CHESS);
    if (numHorizontal >= WIN_NUM - 1) {
        LOGD("PUT 获胜");
        ClearData();
        result = USER_WIN; //获胜
        napi_value returnValue = nullptr;
        napi_create_int32(env, result, &returnValue);
        return returnValue;
    }
    //判断同一竖线上位置是否有五子
    int numVertical = GetNumVertical(x1, y1, USER_CHESS);
    if (numVertical >= WIN_NUM - 1) {
        LOGD("PUT 获胜");
        ClearData();
        result = USER_WIN; //获胜
        napi_value returnValue = nullptr;
        napi_create_int32(env, result, &returnValue);
        return returnValue;
    }
    //判断左斜线是否有五子
    int numLeftSlash = GetNumLeftSlash(x1, y1, USER_CHESS);
    if (numLeftSlash >= WIN_NUM - 1) {
        LOGD("PUT 获胜");
        ClearData();
        result = USER_WIN; //获胜
        napi_value returnValue = nullptr;
        napi_create_int32(env, result, &returnValue);
        return returnValue;
    }
    //判断右斜线是否有五子;
    int numRightSlash = GetNumRightSlash(x1, y1, USER_CHESS);
    if (numRightSlash >= WIN_NUM - 1) {
        LOGD("PUT 获胜");
        ClearData();
        result = USER_WIN; //获胜
        napi_value returnValue = nullptr;
        napi_create_int32(env, result, &returnValue);
        return returnValue;
    }
    napi_value returnValue = nullptr;
    napi_create_int32(env, result, &returnValue);
    return returnValue;
}

struct CallbackContext {
    napi_env env = nullptr;
    napi_ref callbackRef = nullptr;
    int status = -1;
    napi_async_work worker = nullptr;
    char retData[7] = { '0', ',', '0', '0', ',', '0', '0' };
};

static napi_value Deal(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = { 0 };
    napi_value thisVar = nullptr;
    void * data = nullptr;
    napi_get_cb_info(env, info, &argc, argv, &thisVar, &data);

    // 获取第一个入参，即需要后续触发的回调函数
    napi_valuetype valueType = napi_undefined;
    napi_typeof(env, argv[0], &valueType);
    if (valueType != napi_function) {
        return nullptr;
    }
    // CallbackContext是自己定义的一个类，用于保存执行过程中的数据
    CallbackContext * asyncContext = new CallbackContext();
    asyncContext->env = env;
    napi_create_reference(env, argv[0], 1, &asyncContext->callbackRef);

    napi_value resultData = nullptr;
    napi_get_undefined(env, &resultData);

    napi_value resource = nullptr;
    napi_create_string_utf8(env, "NativeAPI", NAPI_AUTO_LENGTH, &resource);
    napi_create_async_work(env, nullptr, resource,
            // 回调1：此回调由napi异步执行，里面就是需要异步执行的业务逻辑。由于是异步线程执行，所以不要在此通过napi接口操作JS对象。
            [](napi_env env, void * data) {
                LOGD("async_work 1");
                CallbackContext * asyncContext1 = (CallbackContext *)data;
                asyncContext1->status = 0;
                AIPlay();
                asyncContext1->retData[0] = result[0] + '0';
                PutInt2Char(asyncContext1->retData, 2, 3, result[1]);
                PutInt2Char(asyncContext1->retData, 5, 6, result[2]);
                if (result[0] == 2) {
                    ClearData();
                }
                asyncContext1->status = 1;
            },
            // 回调2：此回调在上述异步回调执行完后执行，此时回到了JS线程来回调开发者传入的回调
            [](napi_env env, napi_status status, void * data) {
                LOGD("async_work 2");
                CallbackContext * asyncContext2 = (CallbackContext *)data;
                if (asyncContext2->status == 1) {
                    napi_value result = nullptr;
                    napi_get_undefined(env, &result);
                    napi_value callback = nullptr;
                    napi_get_reference_value(asyncContext2->env, asyncContext2->callbackRef, &callback);
                    napi_value retArg;
                    napi_create_string_utf8(asyncContext2->env, asyncContext2->retData, 7, &retArg);
                    napi_value ret;
                    napi_call_function(asyncContext2->env, nullptr, callback, 1, &retArg, &ret);
                    napi_delete_reference(env, asyncContext2->callbackRef);
                    napi_delete_async_work(env, asyncContext2->worker);
                }
            },
            (void *)asyncContext, &asyncContext->worker);
    napi_queue_async_work(env, asyncContext->worker);
    return resultData;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = { { "deal", nullptr, Deal, nullptr, nullptr, nullptr, napi_default, nullptr },
    { "put", nullptr, Put, nullptr, nullptr, nullptr, napi_default, nullptr } };

    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "libcard",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterModule(void)
{
napi_module_register(& demoModule);
}