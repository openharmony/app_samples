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
export class ImageList {
  Img: Resource
  value: string

  constructor(Img: Resource, value: string) {
    this.Img = Img
    this.value = value
  }
}

export function obtainImgVertical(): Array<Array<ImageList>> {

  let list =
    [
      [
        {
          Img: $r('app.media.ic_cal_delete_c'), value: 'C'
        },
        {
          Img: $r('app.media.ic_cal_devide'), value: '/'
        },
        {
          Img: $r('app.media.ic_cal_multiply'), value: '*'
        },

      ],
      [
        {
          Img: $r('app.media.ic_cal_seven'), value: '7'
        },
        {
          Img: $r('app.media.ic_cal_eight'), value: '8'
        },
        {
          Img: $r('app.media.ic_cal_nine'), value: '9'
        }
      ],
      [
        {
          Img: $r('app.media.ic_cal_four'), value: '4'
        },
        {
          Img: $r('app.media.ic_cal_five'), value: '5'
        },
        {
          Img: $r('app.media.ic_cal_six'), value: '6'
        }
      ],
      [
        {
          Img: $r('app.media.ic_cal_one'), value: '1'
        },
        {
          Img: $r('app.media.ic_cal_two'), value: '2'
        },
        {
          Img: $r('app.media.ic_cal_three'), value: '3'
        }
      ],
      [
        {
          Img: $r('app.media.ic_cal_percent'), value: '%'
        },
        {
          Img: $r('app.media.ic_cal_zero_short'), value: '0'
        },
        {
          Img: $r('app.media.ic_cal_point'), value: '.'
        }
      ]
    ]
  return list
}

export function obtainImgV(): Array<ImageList> {
  let list =
    [
      {
        Img: $r('app.media.ic_cal_delete'), value: ''
      },
      {
        Img: $r('app.media.ic_cal_minus'), value: '-'
      },
      {
        Img: $r('app.media.ic_cal_plus'), value: '+'
      },
      {
        Img: $r('app.media.ic_cal_equal'), value: '='
      }
    ]
  return list
}


export function obtainImgLevel(): Array<Array<ImageList>> {
  let list = [
    [
      {
        Img: $r('app.media.ic_cal_seven'), value: '7'
      },
      {
        Img: $r('app.media.ic_cal_eight'), value: '8'
      },
      {
        Img: $r('app.media.ic_cal_nine'), value: '9'
      },
      {
        Img: $r('app.media.ic_cal_devide'), value: '/'
      }
    ],
    [
      {
        Img: $r('app.media.ic_cal_four'), value: '4'
      },
      {
        Img: $r('app.media.ic_cal_five'), value: '5'
      },
      {
        Img: $r('app.media.ic_cal_six'), value: '6'
      },
      {
        Img: $r('app.media.ic_cal_multiply'), value: '*'
      }
    ],
    [
      {
        Img: $r('app.media.ic_cal_one'), value: '1'
      },
      {
        Img: $r('app.media.ic_cal_two'), value: '2'
      },
      {
        Img: $r('app.media.ic_cal_three'), value: '3'
      },
      {
        Img: $r('app.media.ic_cal_minus'), value: '-'
      }
    ]
  ]
  return list
}

export function obtainImg(): Array<ImageList> {
  let list = [
    {
      Img: $r('app.media.ic_cal_delete'), value: ''
    },
    {
      Img: $r('app.media.ic_cal_delete_c'), value: 'C'
    },
    {
      Img: $r('app.media.ic_cal_equal'), value: '='
    }
  ]
  return list
}

export function obtainImgL(): Array<ImageList> {
  let list = [
    {
      Img: $r('app.media.ic_cal_zero'), value: '0'
    },
    {
      Img: $r('app.media.ic_cal_point'), value: '.'
    },
    {
      Img: $r('app.media.ic_cal_plus'), value: '+'
    }
  ]
  return list
}