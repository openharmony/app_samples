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
#include <harea.h>
#include <native_layer.h>
#include <native_layer_jni.h>

extern "C"
JNIEXPORT jint JNICALL Java_ohos_samples_nativelayer_slice_MainAbilitySlice_NativeLayerHandleGetWidthFromJNI(JNIEnv* env, jobject obj,jobject surface){
    return NativeLayerHandle(GetNativeLayer(env,surface),GET_WIDTH);
}

extern "C"
JNIEXPORT jint JNICALL Java_ohos_samples_nativelayer_slice_MainAbilitySlice_NativeLayerHandleGetHeightFromJNI(JNIEnv* env, jobject obj,jobject surface){
    return NativeLayerHandle(GetNativeLayer(env,surface),GET_HEIGHT);
}

extern "C"
JNIEXPORT jint JNICALL Java_ohos_samples_nativelayer_slice_MainAbilitySlice_NativeLayerHandleGetFormatFromJNI(JNIEnv* env, jobject obj,jobject surface){
    return NativeLayerHandle(GetNativeLayer(env,surface),GET_FORMAT);
}

extern "C"
JNIEXPORT jint JNICALL Java_ohos_samples_nativelayer_slice_MainAbilitySlice_NativeLayerHandleSetHeightWidthFromJNI(JNIEnv* env, jobject obj,jobject surface,jint width,jint height){
    return NativeLayerHandle(GetNativeLayer(env,surface),SET_WIDTH_AND_HEIGHT,width,height);
}

extern "C"
JNIEXPORT jint JNICALL Java_ohos_samples_nativelayer_slice_MainAbilitySlice_NativeLayerHandleSetFormatFromJNI(JNIEnv* env, jobject obj,jobject surface,jint format){
    return NativeLayerHandle(GetNativeLayer(env,surface),SET_FORMAT,format);
}