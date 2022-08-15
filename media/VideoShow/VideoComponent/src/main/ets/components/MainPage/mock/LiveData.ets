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

import { LiveInfoDataModel } from '../model/LiveDataModel'

export const liveData: Array<LiveInfoDataModel> = [
  { "uri": $rawfile('video_1.mp4'),
    "name": $r("app.string.first_author"),
    "peopleNum": "520",
    "commentList": [
      {
        "name": $r("app.string.first_one_name"),
        "comment": $r("app.string.first_one_comment")
      },
      {
        "name": $r("app.string.first_two_name"),
        "comment": $r("app.string.first_two_comment")
      },
      {
        "name": $r("app.string.first_three_name"),
        "comment": $r("app.string.first_three_comment")
      },
      {
        "name": $r("app.string.first_four_name"),
        "comment": $r("app.string.first_four_comment")
      },
      {
        "name": $r("app.string.first_five_name"),
        "comment": $r("app.string.first_five_comment")
      }
    ]
  },
  {
    "uri": $rawfile('video_2.mp4'),
    "name": $r("app.string.two_author"),
    "peopleNum": "360",
    "commentList": [
      {
        "name": $r("app.string.first_one_name"),
        "comment": $r("app.string.first_one_comment")
      },
      {
        "name": $r("app.string.first_two_name"),
        "comment": $r("app.string.first_two_comment")
      },
      {
        "name": $r("app.string.first_three_name"),
        "comment": $r("app.string.first_three_comment")
      },
      {
        "name": $r("app.string.first_four_name"),
        "comment": $r("app.string.first_four_comment")
      },
      {
        "name": $r("app.string.first_five_name"),
        "comment": $r("app.string.first_five_comment")
      }
    ]
  },
  { "uri": $rawfile('video_3.mp4'),
    "name": $r("app.string.three_author"),
    "peopleNum": "777",
    "commentList": [
      {
        "name": $r("app.string.first_one_name"),
        "comment": $r("app.string.first_one_comment")
      },
      {
        "name": $r("app.string.first_two_name"),
        "comment": $r("app.string.first_two_comment")
      },
      {
        "name": $r("app.string.first_three_name"),
        "comment": $r("app.string.first_three_comment")
      },
      {
        "name": $r("app.string.first_four_name"),
        "comment": $r("app.string.first_four_comment")
      },
      {
        "name": $r("app.string.first_five_name"),
        "comment": $r("app.string.first_five_comment")
      }
    ]
  }
]