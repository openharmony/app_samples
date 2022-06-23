/**
 * Copyright (c) 2009 The Android Open Source Project
 *
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

#include <js_native_api.h>
#include <js_native_api_types.h>
#include <napi/native_api.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <node_api.h>
#include <rawfile/raw_file_manager.h>
#include <rawfile/raw_file.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "../include/pinyinime.h"
#include "../include/sync.h"
#include "../include/userdict.h"
#include "../utils/napi_utils.h"
#include "js_native_api.h"
#include <hilog/log.h>

using namespace ime_pinyin;
#define RET_BUF_LEN 256


#define MAX_FILE_PATH_LEN 100

#define LOG_DOMAIN 0

#define LOG_TAG "kikaInput"

static char16 retbuf[RET_BUF_LEN];
static char16(*predict_buf)[kMaxPredictSize + 1] = NULL;
static size_t predict_len;

static Sync sync_worker;

static struct file_descriptor_offsets_t
{
    napi_value mClass;
    napi_value mDescriptor;
} gFileDescriptorOffsets;

static napi_value OpenDecoderFd(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "trigger openDecoderFd");
    size_t argsNum = 2;
    napi_value args[2] = { nullptr };
     napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    bool result = false;
    NativeResourceManager *manager = OH_ResourceManager_InitNativeResourceManager(env, args[0]);
    do {
        if (manager == nullptr) {
            OH_LOG_INFO(LOG_APP, "init resource manager failed");
            break;
        }
        RawFile * file = OH_ResourceManager_OpenRawFile(manager, "dict_pinyin.dat");
        if (file == nullptr) {
            OH_ResourceManager_ReleaseNativeResourceManager(manager);
            break;
        }
        RawFileDescriptor descriptor;
        if (OH_ResourceManager_GetRawFileDescriptor(file, descriptor)) {
            if (im_open_decoder_fd(descriptor.fd, descriptor.start, descriptor.length, "dict_pinyin.dat")) {
                result = true;
            }
        }
        OH_ResourceManager_ReleaseRawFileDescriptor(descriptor);
        OH_ResourceManager_CloseRawFile(file);
        OH_ResourceManager_ReleaseNativeResourceManager(manager);
    } while (0);
    napi_value res = nullptr;
    napi_get_boolean(env, result, &res);
    return res;
}

static napi_value SetMaxLens(napi_env env, napi_callback_info callback)
{
    size_t argsNum = 2;
    napi_value args[2] = { nullptr };
    napi_get_cb_info(env, callback, &argsNum, args, nullptr, nullptr);
    uint32_t maxSpsLen = 0;
    napi_get_value_uint32(env, args[0], &maxSpsLen);
    uint32_t maxHzsLen = 0;
    napi_get_value_uint32(env, args[1], &maxHzsLen);
    im_set_max_lens(static_cast < size_t > (maxSpsLen),
            static_cast <size_t> (maxHzsLen));
    napi_value result = nullptr;
    napi_get_undefined(env, &result);
    return result;
}

static napi_value CloseDecoder(napi_env env, napi_callback_info info)
{
    im_close_decoder();
    napi_value result = nullptr;
    napi_get_undefined(env, &result);
    return result;
}

static napi_value Search(napi_env env, napi_callback_info info)
{
    size_t argsNum = 2;
    napi_value args[2] = { nullptr };
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    int32_t pyLen = 0;
    napi_get_value_int32(env, args[1], &pyLen);
    char strBody[pyLen + 1];
    size_t strLen = 0;
    napi_valuetype type;
    napi_typeof(env,args[0],&type);
    napi_get_value_string_utf8(env,args[0],strBody,pyLen + 1,&strLen);
    int result = 0;
    if (strLen != 0) {
        result = im_search(strBody, pyLen);
    }
    napi_value res = nullptr;
    napi_create_int32(env, result, &res);
    return res;
}

static napi_value DelSearch(napi_env env, napi_callback_info info)
{
    size_t argsNum = 3;
    napi_value args[3] = { nullptr };
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    int32_t pos = 0;
    napi_get_value_int32(env, args[0], &pos);
    bool isPosInSplid = false;
    napi_get_value_bool(env, args[1], &isPosInSplid);
    bool clearFixedThisStep = false;
    const int currentIndex = 2;
    napi_get_value_bool(env, args[currentIndex], &clearFixedThisStep);
    int result = im_delsearch(pos, isPosInSplid, clearFixedThisStep);
    napi_value res = nullptr;
    napi_create_int32(env, result, &res);
    return res;
}

static napi_value ResetSearch(napi_env env, napi_callback_info info)
{
    im_reset_search();
    napi_value result = nullptr;
    napi_get_undefined(env, &result);
    return result;
}

static napi_value AddLetter(napi_env env, napi_callback_info info) {
    size_t argsNum = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    int target = 0;
    napi_get_value_int32(env, args[0], &target);
    int32_t candidate = im_add_letter((char)target);
    napi_value result = nullptr;
    napi_create_int32(env, candidate, &result);
    return result;
}

static napi_value GetPyStr(napi_env env, napi_callback_info info)
{
    size_t argsNum = 1;
    napi_value args[argsNum];
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    bool decoded = false;
    napi_get_value_bool(env, args[0], &decoded);
    size_t py_len;
    const char * py = im_get_sps_str(&py_len);  // py_len gets decoded length
    if (py == NULL) {
        napi_value result = nullptr;
        napi_get_undefined(env, &result);
        return result;
    }
    if (!decoded)
        py_len = strlen(py);

    const unsigned short * spl_start;
    size_t len;
    len = im_get_spl_start_pos(spl_start);

    size_t i;
    for (i = 0; i < py_len; i++)
        retbuf[i] = py[i];
    retbuf[i] = (char16)'\0';
    napi_value result = nullptr;
    napi_create_string_utf8(env, py, i, &result);
    return result;
}

static napi_value GetPyStrLen(napi_env env, napi_callback_info info)
{
    size_t argsNum = 1;
    napi_value args[argsNum];
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    bool decode = false;
    napi_get_value_bool(env, args[0], &decode);
    size_t pyLen;
    const char * py = im_get_sps_str(&pyLen);  // py_len gets decoded length
    if (py == NULL) {
        napi_value result = nullptr;
        napi_get_undefined(env, &result);
        return result;
    }
    if (!decode)
        pyLen = strlen(py);
    napi_value result = nullptr;
    napi_create_uint32(env, pyLen, &result);
    return result;
}

static napi_value GetSplStart(napi_env env, napi_callback_info callback)
{
    const unsigned short * spl_start;
    size_t len;

    // There will be len + 1 elements in the buffer when len > 0.
    len = im_get_spl_start_pos(spl_start);

    napi_value arr = nullptr;
    napi_create_array_with_length(env, len + 2, &arr);
    napi_value arrLen = nullptr;
    napi_create_uint32(env, len, &arrLen);
    napi_set_element(env, arr, 0, arrLen);
    for (size_t i = 0; i <= len; i++) {
        napi_value current = nullptr;
        napi_create_uint32(env, spl_start[i], &current);
        napi_set_element(env, arr, i + 1, current);
    }

    return arr;
}

static void Utf16leToUtf8(char16_t* value, size_t sourceLen, char *ret, size_t &len)
{
    if (value == nullptr) {
        return;
    }
    char16_t * p = value;
    if (value[0] == 0xFEFF) {
        p += 1; //带有bom标记，后移
        sourceLen -= 1;
    }

    // 开始转换
    len = sourceLen * 3;
    if (len > RET_BUF_LEN) {
        return;
    }

    char16_t u16char;
    size_t index = 0;
    for (size_t i = 0; i < len; ++i) {
        // 这里假设是在小端序下(大端序不适用)
        u16char = p[i];

        // 1字节表示部分
        if (u16char < 0x0080) {
            // u16char <= 0x007f
            // U- 0000 0000 ~ 0000 07ff : 0xxx xxxx
            ret[index] = ((char)(u16char & 0x00FF));  // 取低8bit
            index++;
            continue;
        }
        // 2 字节能表示部分
        if (u16char >= 0x0080 && u16char <= 0x07FF) {
            // * U-00000080 - U-000007FF:  110xxxxx 10xxxxxx
            ret[index] = ((char)(((u16char >> 6) & 0x1F) | 0xC0));
            index++;
            ret[index] = ((char)((u16char & 0x3F) | 0x80));
            index++;
            continue;
        }
        // 代理项对部分(4字节表示)
        if (u16char >= 0xD800 && u16char <= 0xDBFF) {
            // * U-00010000 - U-001FFFFF: 1111 0xxx 10xxxxxx 10xxxxxx 10xxxxxx
            uint32_t highSur = u16char;
            uint32_t lowSur = p[++i];
            // 从代理项对到UNICODE代码点转换
            // 1、从高代理项减去0xD800，获取有效10bit
            // 2、从高代理项减去0xDC00，获取有效10bit
            // 3、加上0x10000，获取UNICODE代码点值
            uint32_t codePoint = highSur - 0xD800;
            codePoint <<= 10;
            codePoint |= lowSur - 0xDC00;
            codePoint += 0x10000;
            // 转为4字节UTF8编码表示
            ret[index] = ((char)((codePoint >> 18) | 0xF0));
            index++;
            ret[index] = ((char)(((codePoint >> 12) & 0x3F) | 0x80));
            index++;
            ret[index] = ((char)(((codePoint >> 06) & 0x3F) | 0x80));
            index++;
            ret[index] = ((char)((codePoint & 0x3F) | 0x80));
            index++;
            continue;
        }
        // 3 字节表示部分
        // * U-0000E000 - U-0000FFFF:  1110xxxx 10xxxxxx 10xxxxxx
        ret[index] = ((char)(((u16char >> 12) & 0x0F) | 0xE0));
        index++;
        ret[index] = ((char)(((u16char >> 6) & 0x3F) | 0x80));
        index++;
        ret[index] = ((char)((u16char & 0x3F) | 0x80));
        index++;
        continue;
    }
}

static napi_value GetChoice(napi_env env, napi_callback_info info)
{
    napi_value resStr = nullptr;
    size_t argsNum = 1;
    napi_value args[argsNum];
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    uint32_t candidateId = 0;
    napi_get_value_uint32(env, args[0], &candidateId);
    if (im_get_candidate(candidateId, (unsigned short *)retbuf, RET_BUF_LEN)) {
        char16_t * targetBuf = (char16_t *)((uint16_t*)retbuf);
        size_t sourceLen = RET_BUF_LEN;
        char targetVal[RET_BUF_LEN];
        size_t targetLen = 0;
        Utf16leToUtf8(targetBuf, utf16_strlen(retbuf),targetVal,targetLen);
        napi_create_string_utf8(env, targetVal, targetLen, &resStr);
    } else {
        napi_get_undefined(env, &resStr);
    }
    return resStr;
}

static napi_value Choose(napi_env env, napi_callback_info info)
{
    size_t argsNum = 1;
    napi_value args[argsNum];
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    uint32_t chooseId = 0;
    napi_get_value_uint32(env, args[0], &chooseId);
    int index = im_choose(chooseId);
    napi_value result = nullptr;
    napi_create_int32(env, index, &result);
    return result;
}

static napi_value CancelLastChoice(napi_env env, napi_callback_info info)
{
    int index = im_cancel_last_choice();
    napi_value result = nullptr;
    napi_create_int32(env, index, &result);
    return result;
}

static napi_value GetFixedLen(napi_env env, napi_callback_info info)
{
    uint32_t len = im_get_fixed_len();
    napi_value result = nullptr;
    napi_create_uint32(env, len, &result);
    return result;
}

static napi_value CancelInput(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    if (im_cancel_input()) {
        napi_get_boolean(env, true, &result);
    } else {
        napi_get_boolean(env, false, &result);
    }
    return result;
}

static napi_value FlushCache(napi_env env, napi_callback_info info)
{
    im_flush_cache();
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}

static napi_value GetPredictsNum(napi_env env, napi_callback_info callback)
{
    size_t argsNum = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, callback, &argsNum, args, nullptr, nullptr);
    uint32_t length = 0;
    napi_get_array_length(env, args[0], &length);
    char16 fixed_ptr[MAX_FILE_PATH_LEN];
    for (int i = 0; i < length; i++) {
        napi_value current = nullptr;
        napi_get_element(env, args[0],i, &current);
        napi_get_value_uint32(env, current, (uint32_t *)(&fixed_ptr[i]));
    }
    char16 fixed_buf[kMaxPredictSize + 1];
    uint32_t start = 0;
    if (length > kMaxPredictSize) {
        start += length - kMaxPredictSize;
        length = kMaxPredictSize;
    }
    utf16_strncpy(fixed_buf, ((char16 *)fixed_ptr) + start, length);
    fixed_buf[length] = (char16)'\0';

    predict_len = im_get_predicts(fixed_buf, predict_buf);
    napi_value result = nullptr;
    napi_create_uint32(env, predict_len, &result);
    return result;
}

static napi_value GetPredictItem(napi_env env, napi_callback_info callback)
{
    size_t argsNum = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, callback, &argsNum, args, nullptr, nullptr);
    uint32_t predict_no = 0;
    napi_get_value_uint32(env, args[0], &predict_no);
    napi_value retStr = nullptr;
    if (predict_no < 0 || (size_t)predict_no >= predict_len) {
        napi_get_undefined(env, &retStr);
    } else {
        char16_t * targetBuf = (char16_t *)((uint16_t*)predict_buf[predict_no]);
        size_t sourceLen = RET_BUF_LEN;
        char targetVal[RET_BUF_LEN];
        size_t targetLen = 0;
        Utf16leToUtf8(targetBuf, utf16_strlen((unsigned short *)predict_buf[predict_no]), targetVal, targetLen);
        napi_create_string_utf8(env, targetVal, targetLen, &retStr);
    }
    return retStr;
}

static napi_value BeginSync(napi_env env, napi_callback_info info)
{
    size_t argsNum = 1;
    napi_value args[1] = { nullptr };
   napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    char fileName[MAX_FILE_PATH_LEN];
    size_t fileNameLen = 0;
//    NAPI_CALL(env,napi_get_value_string_utf8(env, args[0], fileName, MAX_FILE_PATH_LEN, &fileNameLen));
   napi_get_value_string_utf8(env, args[0], fileName, MAX_FILE_PATH_LEN, &fileNameLen);

    bool syncRes = false;
    if (true == sync_worker.begin((const char *)fileName)) {
        syncRes = true;
    }
    napi_value result = nullptr;
    napi_get_boolean(env, syncRes, &result);
    return result;
}

static napi_value FinishSync(napi_env env, napi_callback_info info)
{
    sync_worker.finish();
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}

static napi_value GetCapacitySync(napi_env env, napi_callback_info info)
{
    int count = sync_worker.get_capacity();
    napi_value result = nullptr;
    napi_create_int32(env, count, &result);
    return result;
}

static napi_value PutLemmasSync(napi_env env, napi_callback_info info)
{
    char lemms[MAX_FILE_PATH_LEN];
    size_t argsNum = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argsNum, args, nullptr, nullptr);
    size_t len = 0;
    napi_get_value_string_utf8(env, args[0], lemms, MAX_FILE_PATH_LEN, &len);

    int added = sync_worker.put_lemmas((unsigned short *)lemms, len);
    napi_value result = nullptr;
    napi_create_int32(env, added, &result);
    return result;
}

static napi_value GetLemmasSync(napi_env env, napi_callback_info info)
{
    int len = sync_worker.get_lemmas(retbuf, RET_BUF_LEN);
    if (len == 0) {
        napi_value result = nullptr;
        napi_get_undefined(env, &result);
        return result;
    }
    napi_value result = nullptr;
    napi_create_string_utf8(env, (char *)retbuf, len, &result);
    return result;
}

static napi_value GetLastCountSync(napi_env env, napi_callback_info info)
{
    int count = sync_worker.get_last_got_count();
    napi_value result = nullptr;
    napi_create_int32(env, count, &result);
    return result;
}

static napi_value GetTotalCountSync(napi_env env, napi_callback_info info)
{
    int count = sync_worker.get_total_count();
    napi_value result = nullptr;
    napi_create_int32(env, count, &result);
    return result;
}

static napi_value ClearLastGotSync(napi_env env, napi_callback_info info)
{
    sync_worker.clear_last_got();
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}

/*
 * Register several native methods for pinyinIme
 */
EXTERN_C_START
static napi_value ExportInputMethod(napi_env env, napi_value exports)
{
    //    HILOG_INFO(LOG_APP, "register the chinese engine method:);
    napi_property_descriptor properties[] = {
    // DECLARE_NAPI_FUNCTION("openDecoder", OpenDecoder),
        DECLARE_NAPI_FUNCTION("openDecoderFd", OpenDecoderFd),
        DECLARE_NAPI_FUNCTION("setMaxLens", SetMaxLens),
        DECLARE_NAPI_FUNCTION("closeDecoder", CloseDecoder),
        DECLARE_NAPI_FUNCTION("search", Search),
        DECLARE_NAPI_FUNCTION("delSearch", DelSearch),
        DECLARE_NAPI_FUNCTION("resetSearch", ResetSearch),
        DECLARE_NAPI_FUNCTION("addLetter", AddLetter),
        DECLARE_NAPI_FUNCTION("getPyStr", GetPyStr),
        DECLARE_NAPI_FUNCTION("getPyStrLen", GetPyStrLen),
        DECLARE_NAPI_FUNCTION("getSplStart", GetSplStart),
        DECLARE_NAPI_FUNCTION("getChoice", GetChoice),
        DECLARE_NAPI_FUNCTION("choose", Choose),
        DECLARE_NAPI_FUNCTION("cancelLastChoice", CancelLastChoice),
        DECLARE_NAPI_FUNCTION("getFixedLen", GetFixedLen),
        DECLARE_NAPI_FUNCTION("getPredictsNum", GetPredictsNum),
        DECLARE_NAPI_FUNCTION("getFixedLen", GetFixedLen),
        DECLARE_NAPI_FUNCTION("getPredictItem", GetPredictItem),
        DECLARE_NAPI_FUNCTION("cancelInput", CancelInput),
        DECLARE_NAPI_FUNCTION("flushCache", FlushCache),
        DECLARE_NAPI_FUNCTION("beginSync", BeginSync),
        DECLARE_NAPI_FUNCTION("finishSync", FinishSync),
        DECLARE_NAPI_FUNCTION("putLemmasSync", PutLemmasSync),
        DECLARE_NAPI_FUNCTION("getLastCountSync", GetLastCountSync),
        DECLARE_NAPI_FUNCTION("getTotalCountSync", GetTotalCountSync),
        DECLARE_NAPI_FUNCTION("getCapacitySync", GetCapacitySync),
        DECLARE_NAPI_FUNCTION("clearLastGotSync", ClearLastGotSync)
    };
//    NAPI_CALL(env,napi_define_properties(env, exports, sizeof(properties)/ sizeof(properties[0]), properties));
    napi_define_properties(env, exports, sizeof(properties)/ sizeof(properties[0]), properties);

    return exports;
}
EXTERN_C_END

static napi_module inputAppModule = {
.nm_version = 1,
.nm_flags = 0,
.nm_filename = nullptr,
.nm_register_func = ExportInputMethod,
.nm_modname = "libpinyinime",
.nm_priv = ((void *)0),
.reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterModule(void)
{
     napi_module_register(&inputAppModule);
}