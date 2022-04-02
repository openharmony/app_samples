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

#include <stdint.h>

#include "plugin_render.h"
#include "plugin_common.h"
#include "plugin_manager.h"

#ifdef __cplusplus
extern "C" {
#endif

std::unordered_map<std::string, PluginRender*> PluginRender::instance_;

OH_NativeXComponent_Callback PluginRender::callback_;

void OnSurfaceCreatedCB(OH_NativeXComponent* component, void* window)
{
    LOGD("OnSurfaceCreatedCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceCreated(component, window);
}

void OnSurfaceChangedCB(OH_NativeXComponent* component, void* window)
{
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceChanged(component, window);
}

void OnSurfaceDestroyedCB(OH_NativeXComponent* component, void* window)
{
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceDestroyed(component, window);
}

void DispatchTouchEventCB(OH_NativeXComponent* component, void* window)
{
    LOGD("DispatchTouchEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->DispatchTouchEvent(component, window);

}

PluginRender::PluginRender(std::string& id) : id_(id), component_(nullptr)
{
    eglCore_ = new EGLCore(id);
    auto renderCallback = PluginRender::GetNXComponentCallback();
    renderCallback->OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback->OnSurfaceChanged = OnSurfaceChangedCB;
    renderCallback->OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    renderCallback->DispatchTouchEvent = DispatchTouchEventCB;
}

PluginRender* PluginRender::GetInstance(std::string& id)
{
    if (instance_.find(id) == instance_.end()) {
        PluginRender*  instance = new PluginRender(id);
        instance_[id] = instance;
        return instance;
    } else {
        return instance_[id];
    }
}

OH_NativeXComponent_Callback* PluginRender::GetNXComponentCallback()
{
    return &PluginRender::callback_;
}

void PluginRender::SetNativeXComponent(OH_NativeXComponent* component)
{
    component_ = component;
    OH_NativeXComponent_RegisterCallback(component_, &PluginRender::callback_);
}

void PluginRender::OnSurfaceCreated(OH_NativeXComponent* component, void* window)
{
    LOGD("PluginRender::OnSurfaceCreated");
    int32_t ret=OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        eglCore_->GLContextInit(window, width_, height_);
    }
}

void PluginRender::OnSurfaceChanged(OH_NativeXComponent* component, void* window)
{
}

void PluginRender::OnSurfaceDestroyed(OH_NativeXComponent* component, void* window)
{
}

void PluginRender::DispatchTouchEvent(OH_NativeXComponent* component, void* window)
{
    int32_t ret = OH_NativeXComponent_GetTouchEvent(component, window, &touchEvent_);

    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        LOGD("Touch Info : x = %{public}f, y = %{public}f screenx = %{public}f, screeny = %{public}f", touchEvent_.x, touchEvent_.y, touchEvent_.screenX, touchEvent_.screenY);
        for (int i=0;i<touchEvent_.numPoints;i++) {
            LOGE("Touch Info : dots[%{public}d] id %{public}d x = %{public}f, y = %{public}f", i, touchEvent_.touchPoints[i].id, touchEvent_.touchPoints[i].x, touchEvent_.touchPoints[i].y);
            LOGE("Touch Info : screenx = %{public}f, screeny = %{public}f", touchEvent_.touchPoints[i].screenX, touchEvent_.touchPoints[i].screenY);
            LOGE("vtimeStamp = %{public}llu, isPressed = %{public}d", touchEvent_.touchPoints[i].timeStamp, touchEvent_.touchPoints[i].isPressed);
        }
    } else {
        LOGE("Touch fail");
    }

}

napi_value PluginRender::Export(napi_env env, napi_value exports)
{
    LOGE("PluginRender::Export");
    // Register JS API
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("changeShape", PluginRender::NapiChangeShape),
        DECLARE_NAPI_FUNCTION("drawTriangle", PluginRender::NapiDrawTriangle),
        DECLARE_NAPI_FUNCTION("changeColor", PluginRender::NapiChangeColor),
    };
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));
    return exports;
}

napi_value PluginRender::NapiChangeShape(napi_env env, napi_callback_info info)
{
    LOGD("NapiChangeShape");
    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    // napi_value thisArg;
    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    };

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void**>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return nullptr;
    }

    std::string id(idStr);
    PluginRender* instance = PluginRender::GetInstance(id);
    if (instance) {
        instance->eglCore_->ChangeShape();
    }
    return nullptr;
}

napi_value PluginRender::NapiDrawTriangle(napi_env env, napi_callback_info info)
{
    LOGD("NapiDrawTriangle");
    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    // napi_value thisArg;
    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    };

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void**>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return nullptr;
    }

    std::string id(idStr);
    PluginRender* instance = PluginRender::GetInstance(id);
    if (instance) {
        instance->eglCore_->DrawTriangle();
    }
    return nullptr;
}

napi_value PluginRender::NapiChangeColor(napi_env env, napi_callback_info info)
{
    LOGD("NapiChangeColor");
    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    // napi_value thisArg;
    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void**>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return nullptr;
    }

    std::string id(idStr);
    PluginRender* instance = PluginRender::GetInstance(id);
    if (instance) {
        instance->eglCore_->ChangeColor();
    }
    return nullptr;
}

#ifdef __cplusplus
}
#endif