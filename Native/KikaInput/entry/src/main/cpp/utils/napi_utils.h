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

#include <napi/native_api.h>

#define GET_AND_THROW_LAST_ERROR(env)                                                            \
  do{                                                                                            \
    const napi_extended_error_info* errorInfo = nullptr;                                         \
     napi_get_last_error_info((env),&errorInfo);                                                 \
     bool isPending = false;                                                                     \
     napi_is_exception_pending((env),&isPending);                                                \
     if(!isPending && errorInfo ! = nullptr){                                                    \
     const char* errorMessage =                                                                  \
         errorInfo->error_message !=nullptr ? errorInfo->error_message : "empty error message";  \
      napi_throw_error((env),nullptr,errorMessage);                                              \
    }                                                                                            \
   }while(0)

#define NAPI_CALL_BASE(env, theCall, retVal) \
    do{                                      \
      if((theCall) != napi_ok ){             \
        GET_AND_THROW_LAST_ERROR((env));     \
        return retVal;                       \
     }                                       \
  }while(0)

#define NAPI_CALL(env,theCall) NAPI_CALL_BASE(env, theCall ,nullptr)

#define DECLARE_NAPI_FUNCTION(name, func)                                       \
   {                                                                            \
      (name), nullptr, (func), nullptr, nullptr, nullptr, napi_default, nullptr \
   }