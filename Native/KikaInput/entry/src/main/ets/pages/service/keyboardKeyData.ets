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
export interface keySourceListType {
  title?: string,
  content: string,
  upperContent?: string,
  keyValue?: string
}

export interface sourceListType {
  content: string,
  chineseContent?: string
}

export interface keyNineNumType {
  content: string
}

export interface keycharacterType {
  title?: string
}

export interface keyNineChinaType {
  title: string,
  content: string
}

export let keySourceListData: keySourceListType[] = [
  {
    title: "1",
    content: "q",
    upperContent: "Q"
  },
  {
    title: "2",
    content: "w",
    upperContent: "W"
  },
  {
    title: "3",
    content: "e",
    upperContent: "E"
  },
  {
    title: "4",
    content: "r",
    upperContent: "R"
  },
  {
    title: "5",
    content: "t",
    upperContent: "T"
  },
  {
    title: "6",
    content: "y",
    upperContent: "Y"
  },
  {
    title: "7",
    content: "u",
    upperContent: "U"
  },
  {
    title: "8",
    content: "i",
    upperContent: "I"
  },
  {
    title: "9",
    content: "o",
    upperContent: "O"
  },
  {
    title: "0",
    content: "p",
    upperContent: "P"
  },
  {
    title: String.fromCharCode(33),
    content: "a",
    upperContent: "A"
  },
  {
    title: "@",
    content: "s",
    upperContent: "S"
  },
  {
    title: String.fromCharCode(35),
    content: "d",
    upperContent: "D"
  },
  {
    title: "$",
    content: "f",
    upperContent: "F"
  },
  {
    title: "%",
    content: "g",
    upperContent: "G"
  },
  {
    title: "&",
    content: "h",
    upperContent: "H"
  },
  {
    title: "*",
    content: "j",
    upperContent: "J"
  },
  {
    title: "(",
    content: "k",
    upperContent: "K"
  },
  {
    title: ")",
    content: "l",
    upperContent: "L"
  },
  {
    title: String.fromCharCode(39),
    content: "z",
    upperContent: "Z"
  },
  {
    title: '/',
    content: "x",
    upperContent: "X"
  },
  {
    title: String.fromCharCode(175),
    content: "c",
    upperContent: "C"
  },
  {
    title: String.fromCharCode(95),
    content: "v",
    upperContent: "V"
  },
  {
    title: String.fromCharCode(58),
    content: "b",
    upperContent: "B"
  },
  {
    title: String.fromCharCode(59),
    content: "n",
    upperContent: "N"
  },
  {
    title: '?',
    content: "m",
    upperContent: "M"
  },
]

export let numberSourceListData: sourceListType[] = [
  {
    content: '1'
  },
  {
    content: '2'
  },
  {
    content: '3'
  },
  {
    content: '4'
  },
  {
    content: '5'
  },
  {
    content: '6'
  },
  {
    content: '7'
  },
  {
    content: '8'
  },
  {
    content: '9'
  },
  {
    content: '0'
  },
  {
    content: '!',
    chineseContent: '！'
  },
  {
    content: '@'
  },
  {
    content: '#'
  },
  {
    content: '$',
    chineseContent: '￥'
  },
  {
    content: '%'
  },
  {
    content: '&'
  },
  {
    content: '*'
  },
  {
    content: '(',
    chineseContent: '（'
  },
  {
    content: ')',
    chineseContent: '）'
  },
  {
    content: "'",
    chineseContent: "’"
  },
  {
    content: '/'
  },
  {
    content: '-'
  },
  {
    content: "_",
    chineseContent: "——"
  },
  {
    content: ":",
    chineseContent: "："
  },
  {
    content: ";",
    chineseContent: "；"
  },
  {
    content: "?",
    chineseContent: "？"
  },
  {
    content: "~",
  },
]

export let symbolSourceListData: sourceListType[] = [
  {
    content: '~'
  },
  {
    content: '`'
  },
  {
    content: '|'
  },
  {
    content: '\u2022'
  },
  {
    content: '\u221A'
  },
  {
    content: '\u03A0'
  },
  {
    content: '\u00F7'
  },
  {
    content: '\u00D7'
  },
  {
    content: String.fromCharCode(182)
  },
  {
    content: '\u2206'
  },
  {
    content: String.fromCharCode(163)
  },
  {
    content: '\u20ac'
  },
  {
    content: String.fromCharCode(165)
  },
  {
    content: String.fromCharCode(162)
  },
  {
    content: String.fromCharCode(94)
  },
  {
    content: '\u00B0'
  },
  {
    content: '='
  },
  {
    content: String.fromCharCode(123)
  },
  {
    content: String.fromCharCode(125)
  },
  {
    content: String.fromCharCode(44)
  },
  {
    content: String.fromCharCode(92)
  },
  {
    content: String.fromCharCode(169)
  },
  {
    content: String.fromCharCode(174)
  },
  {
    content: '\u2122'
  },
  {
    content: '\u2105'
  },
  {
    content: '['
  },
  {
    content: ']'
  },
]
// 九键数字
export let keyNineNumData: keyNineNumType[] = [
  {
    content: '1'
  },
  {
    content: '2'
  },
  {
    content: '3'
  },
  {
    content: '4'
  },
  {
    content: '5'
  },
  {
    content: '6'
  },
  {
    content: '7'
  },
  {
    content: '8'
  },
  {
    content: '9'
  },
  {
    content: '0'
  },
]
// 九键数组符号
export let keycharactersData: keycharacterType[] = [
  {
    title: '@'
  },
  {
    title: '.'
  },
  {
    title: '+'
  },
  {
    title: '-'
  },
]
// 九键拼音
export let keyNineChinaData: keyNineChinaType[] = [
  {
    title: '分词',
    content: '1'
  },
  {
    title: 'ABC',
    content: '2'
  },
  {
    title: 'DEF',
    content: '3'
  },
  {
    title: 'GHI',
    content: '4'
  },
  {
    title: 'JKL',
    content: '5'
  },
  {
    title: 'MNO',
    content: '6'
  },
  {
    title: 'PQRS',
    content: '7'
  },
  {
    title: 'TUV',
    content: '8'
  },
  {
    title: 'WXYZ',
    content: '9'
  },
]