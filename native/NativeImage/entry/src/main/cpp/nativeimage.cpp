/**************************************************************
 Copyright (c) 2021 Huawei Device Co., Ltd.
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 **************************************************************/

#include <jni.h>
#include <string>
#include <malloc.h>
#include <multimedia/image/image_pixel_map.h>

jstring formatString(JNIEnv* env, std::string string) {
    int len = string.size();
    jchar res[len];
    for (int i = 0; i < len; i++) {
        res[i] = (jchar)string[i];
    }
    return env->NewString(res, len);
}

extern "C"
JNIEXPORT jstring JNICALL
Java_ohos_samples_nativeimage_slice_MainAbilitySlice_GetImageInfoFromJNI(JNIEnv* env, jobject obj, jobject pixelMapObject) {
    std::string resultString = "";
    OhosPixelMapInfo imageInfo;
    int resultCode = GetImageInfo(env, pixelMapObject, imageInfo);
    if (resultCode == 0) {
        resultString.append("{\"height\":\"").append(std::to_string(imageInfo.height)).append("\"")
        .append(",\"width\":\"").append(std::to_string(imageInfo.width)).append("\"")
        .append(",\"rowSize\":\"").append(std::to_string(imageInfo.rowSize)).append("\"")
        .append(",\"pixelFormat\":\"").append(std::to_string(imageInfo.pixelFormat)).append("\"}");
        return formatString(env,resultString);
    } else {
        resultString.append("Failed");
    }
    return formatString(env,resultString);
}


extern "C"
JNIEXPORT jint JNICALL
Java_ohos_samples_nativeimage_slice_MainAbilitySlice_AccessPixelsFromJNI(JNIEnv* env, jobject obj, jobject pixelMapObject, jlong PixelBytesNumber) {
    void* bytes = malloc(PixelBytesNumber);
    return AccessPixels(env, pixelMapObject, &bytes);
}

extern "C"
JNIEXPORT jint JNICALL
Java_ohos_samples_nativeimage_slice_MainAbilitySlice_UnAccessPixelsFromJNI(JNIEnv* env, jobject obj, jobject pixelMapObject) {
    return UnAccessPixels(env, pixelMapObject);
}