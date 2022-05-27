import deviceInfo from '@ohos.deviceInfo'

const deviceType = deviceInfo.deviceType

export default class StyleConfiguration {
  static getInputStyle() {
    if (deviceType == 'default') {
      return {
        basicButtonWidth: $r("app.float.rk_basic_button_width"),
        basicButtonHeight: $r("app.float.rk_basic_button_height"),
        featurePicSize: $r("app.float.rk_feature_picSize"),
        switchButtonWidth: $r("app.float.rk_switch_button_width"),
        returnPicSize: $r("app.float.rk_return_picSize"),
        returnButtonWidthType_1: $r("app.float.rk_return_button_widthType_1"),
        returnButtonWidthType_2: $r("app.float.rk_return_button_widthType_2"),
        spaceButtonWidth_1: $r("app.float.rk_space_button_width_1"),
        spaceButtonWidth_2: $r("app.float.rk_space_button_width_2"),
        paddingTop: $r("app.float.rk_padding_top"),
        paddingLeftRight: $r("app.float.rk_padding_left_right"),
        downMenuHeight: $r("app.float.rk_downMenu_height"),
        downMenuPicWidth: $r("app.float.rk_downMenu_pic_width"),
        downMenuPicHeight: $r("app.float.rk_downMenu_pic_height"),
        downMenuWidth: $r("app.float.rk_downMenu_width"),
        litterNumberFontSize: $r("app.float.rk_litter_number_fontSize"),
        en_fontSize: $r("app.float.rk_en_fontSize"),
        switchNumberFontSize: $r("app.float.rk_switch_number_fontSize"),
        number1234ontFSize: $r("app.float.rk_number_1234_fontSize"),
        keyboardHeight: $r("app.float.rk_keyboard_height")
      }
    } else {
      return {
        basicButtonWidth: $r("app.float.basic_button_width"),
        basicButtonHeight: $r("app.float.basic_button_height"),
        featurePicSize: $r("app.float.feature_picSize"),
        switchButtonWidth: $r("app.float.switch_button_width"),
        returnPicSize: $r("app.float.return_picSize"),
        returnButtonWidthType_1: $r("app.float.return_button_widthType_1"),
        returnButtonWidthType_2: $r("app.float.return_button_widthType_2"),
        spaceButtonWidth_1: $r("app.float.space_button_width_1"),
        spaceButtonWidth_2: $r("app.float.space_button_width_2"),
        paddingTop: $r("app.float.padding_top"),
        paddingLeftRight: $r("app.float.padding_left_right"),
        downMenuHeight: $r("app.float.downMenu_height"),
        downMenuPicWidth: $r("app.float.downMenu_pic_width"),
        downMenuPicHeight: $r("app.float.downMenu_pic_height"),
        downMenuWidth: $r("app.float.downMenu_width"),
        litterNumberFontSize: $r("app.float.litter_number_fontSize"),
        en_fontSize: $r("app.float.en_fontSize"),
        switchNumberFontSize: $r("app.float.switch_number_fontSize"),
        number1234ontFSize: $r("app.float.number_1234_fontSize"),
        keyboardHeight: $r("app.float.keyboard_height")
      }
    }
  }
}