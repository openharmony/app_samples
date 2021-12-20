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

import notify from '@ohos.notification';

function getNotificationContentBasic(mWantAgent) {
  let notificationRequest = {
    id: 1,
    slotType: notify.SlotType.CONTENT_INFORMATION,
    content: {
      contentType: notify.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: 'notification title', // 通知标题
        text: 'notification text', // 通知内容
        additionalText: 'notification additionalText', //通知次要内容，是对通知内容的补充
      }
    },
    actionButtons: [
      {
        title: 'button',
        wantAgent: mWantAgent
      }
    ]
  }
  return notificationRequest
}

function getNotificationContentLongText(mWantAgent) {
  let notificationRequest = {
    id: 2,
    slotType: notify.SlotType.CONTENT_INFORMATION,
    content: {
      contentType: notify.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
      longText: {
        title: 'notification title',
        text: 'notification text',
        additionalText: 'notification additionalText', //通知次要内容，是对通知内容的补充
        longText: 'notification long text', // 通知的长文本
        briefText: 'notification briefText', // 通知概要内容，是对通知内容的总结
        expandedTitle: 'notification expandedTitle', // 通知展开时的标题
      }
    },
    wantAgent: mWantAgent
  }
  return notificationRequest
}

function getNotificationContentMultiline(mWantAgent) {
  let notificationRequest = {
    id: 3,
    slotType: notify.SlotType.CONTENT_INFORMATION,
    content: {
      contentType: notify.ContentType.NOTIFICATION_CONTENT_MULTILINE,
      multiLine: {
        title: 'notification title',
        text: 'notification text',
        additionalText: 'notification additionalText', //通知次要内容，是对通知内容的补充
        briefText: 'notification briefText',
        longTitle: 'notification long title',
        lines: ['line1', 'line2', 'line3']
      }
    },
    wantAgent: mWantAgent
  }
  return notificationRequest
}

export function getNotificationRequest(contentType, mWantAgent) {
  console.info('[notification]getNotificationRequest contentType=' + contentType)
  let notificationRequest
  switch (contentType) {
    case 0:
      notificationRequest = getNotificationContentBasic(mWantAgent)
      break
    case 1:
      notificationRequest = getNotificationContentLongText(mWantAgent)
      break
    case 2:
      notificationRequest = getNotificationContentMultiline(mWantAgent)
      break
    default:
      break
  }
  return notificationRequest
}

export function getNotificationId(contentType) {
  console.info('[notification]getNotificationId contentType=' + contentType)
  let notificationId = 1
  switch (contentType) {
    case 0:
      notificationId = 1
      break
    case 1:
      notificationId = 2
      break
    case 2:
      notificationId = 3
      break
    default:
      break
  }
  return notificationId
}