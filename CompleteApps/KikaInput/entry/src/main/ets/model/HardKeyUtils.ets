export function GetHardKeyValue(keyCode) {
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
    2055: "KEYCODE_FORWARD_DEL",
    2071: "KEYCODE_DEL",
  };

  if (keyList.hasOwnProperty(keyCode)) {
    return keyList[keyCode];
  }
  return "";
}