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
export function GetHardKeyValue(keyCode, isShiftKeyPress, isChinese) {
  let keyList = {
    2000: "0",
    2001: "1",
    2002: "2",
    2003: "3",
    2004: "4",
    2005: "5",
    2006: "6",
    2007: "7",
    2008: "8",
    2009: "9",
    2012: "KEYCODE_DPAD_UP",
    2013: "KEYCODE_DPAD_DOWN",
    2014: "KEYCODE_DPAD_LEFT",
    2015: "KEYCODE_DPAD_RIGHT",
    2016: "KEYCODE_DPAD_CENTER",

    2017: "a",
    2018: "b",
    2019: "c",
    2020: "d",
    2021: "e",
    2022: "f",
    2023: "g",
    2024: "h",
    2025: "i",
    2026: "j",
    2027: "k",
    2028: "l",
    2029: "m",
    2030: "n",
    2031: "o",
    2032: "p",
    2033: "q",
    2034: "r",
    2035: "s",
    2036: "t",
    2037: "u",
    2038: "v",
    2039: "w",
    2040: "x",
    2041: "y",
    2042: "z",

    2056: isChinese ? "·" : "`",
    2043: isChinese ? "," : ",",
    2044: isChinese ? "。" : ".",
    2064: isChinese ? "、" : "/",
    2062: isChinese ? "；" : ";",
    2063: isChinese ? "‘" : "'",
    2059: isChinese ? "【" : "[",
    2060: isChinese ? "】" : "]",
    2061: isChinese ? "、" : "\\",
    2057: isChinese ? "-" : "-",
    2058: isChinese ? "=" : "=",

    2050: "KEYCODE_SPACE",
    2054: "KEYCODE_ENTER",
    2055: "KEYCODE_DEL",
    2071: "KEYCODE_FORWARD_DEL",
    2074: "KEYCODE_CAPS_LOCK",
    2047: "KEYCODE_SHIFT_LEFT"
  };

  let keyListWithShift = {
    2000: isChinese ? "）" : ")",
    2001: isChinese ? "！" : "!",
    2002: isChinese ? "@" : "@",
    2003: isChinese ? "#" : "#",
    2004: isChinese ? "￥" : "$",
    2005: isChinese ? "%" : "%",
    2006: isChinese ? "……" : "^",
    2007: isChinese ? "&" : "&",
    2008: isChinese ? "*" : "*",
    2009: isChinese ? "（" : "(",

    2017: "A",
    2018: "B",
    2019: "C",
    2020: "D",
    2021: "E",
    2022: "F",
    2023: "G",
    2024: "H",
    2025: "I",
    2026: "J",
    2027: "K",
    2028: "L",
    2029: "M",
    2030: "N",
    2031: "O",
    2032: "P",
    2033: "Q",
    2034: "R",
    2035: "S",
    2036: "T",
    2037: "U",
    2038: "V",
    2039: "W",
    2040: "X",
    2041: "Y",
    2042: "Z",

    2056: isChinese ? "~" : "~",
    2043: isChinese ? "《" : "<",
    2044: isChinese ? "》" : ">",
    2064: isChinese ? "？" : "?",
    2062: isChinese ? "：" : ":",
    2063: isChinese ? "“" : "\"",
    2059: isChinese ? "{" : "{",
    2060: isChinese ? "}" : "}",
    2061: isChinese ? "|" : "|",
    2057: isChinese ? "——" : "_",
    2058: isChinese ? "+" : "+",
  }

  if (isShiftKeyPress && keyList.hasOwnProperty(keyCode)) {
    return keyListWithShift[keyCode];
  } else if (keyList.hasOwnProperty(keyCode)) {
    return keyList[keyCode];
  }
  return "";
}