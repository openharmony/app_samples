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

#ifndef __SOFT_AP_H__
#define __SOFT_AP_H__

/**
 * @brief start ap mode.
 *
 * @since 1.0
 * @version 1.0
 *
 * @return 0 success, -1 failed
 */
int SoftApStart(const char *ap_name);

/**
 * @brief stop ap mode.
 *
 * @since 1.0
 * @version 1.0
 *
 */
void SoftApStop(void);

#endif  /* __SOFT_AP_H__ */
