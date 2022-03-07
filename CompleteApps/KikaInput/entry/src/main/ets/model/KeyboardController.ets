import {GetHardKeyValue} from './HardKeyUtils.ets'
import inputMethodEngine from '@ohos.inputMethodEngine'
import display from '@ohos.display'
import prompt from '@system.prompt';
import windowManager from '@ohos.window'
import featureAbility from '@ohos.ability.featureAbility'
import screen from '@ohos.screen'

let windowWidth: number = 0
let windowHeight: number = 0
let InputMethodEngine = inputMethodEngine.getInputMethodEngine();
let isDebug = false;

export class KeyboardController {
  private TAG: string= 'KeyboardController-';
  mContext
  WINDOW_TYPE_INPUT_METHOD_FLOAT= 2105
  windowName = 'imeWindow';
  isSpecialKeyPress = false;
  isKeyboardShow = false;
  inputHandle= InputHandler.getInstance();
  mKeyboardDelegate;
  constructor(context) {
    this.inputHandle.addLog('constructor')
    this.mContext = context;
  }

  public onCreate(): void {
    this.inputHandle.addLog('onCreate')
    this.initWindow();
    this.registerListener()
  }

  public onDestroy(): void {
    this.inputHandle.addLog('onDestroy')
    this.unRegisterListener();
    featureAbility.terminateSelf();
  }

  private initWindow(): void {
    this.inputHandle.addLog('initWindow')

    display.getDefaultDisplay().then(dis => {
      this.inputHandle.addLog("initWindow-oncall display");
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 getDefaultDisplay1 wnd : ' + dis);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.id : ' + dis.id);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.name : ' + dis.name);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.alive : ' + dis.alive);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.state : ' + dis.state);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.refreshRate : ' + dis.refreshRate);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.rotation : ' + dis.rotation);
      //      this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.densityDPI : ' + dis.densityDPI);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.densityPixels : ' + dis.densityPixels);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.scaledDensity : ' + dis.scaledDensity);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.xDPI : ' + dis.xDPI);
      //            this.inputHandle.addLog('jsunittest getDefaultDisplay1 displayInfo.yDPI : ' + dis.yDPI);
      var dWidth = dis.width;
      var dHeight = dis.height;
      var navigationbar_height = dHeight * 0.07;
      var keyHeightRate = 0.47;
      var keyHeight = dHeight * keyHeightRate;
      this.inputHandle.addLog("initWindow-dWidth = " + dWidth + ";dHeight = " + dHeight + ";keyboard height = " + keyHeight + ";navibar height = " + navigationbar_height);

      windowWidth = dWidth;
      windowHeight = keyHeight;

      this.inputHandle.addLog(typeof (this.mContext))
      this.inputHandle.addLog('initWindow-window = ' + typeof (windowManager))
      windowManager.create(this.mContext, this.windowName, this.WINDOW_TYPE_INPUT_METHOD_FLOAT).then((win) => {
        win.setWindowMode(102).then(() => {
          win.resetSize(dWidth, keyHeight).then(() => {
            win.moveTo(0, dHeight - keyHeight - navigationbar_height).then(() => {
              win.loadContent('pages/service/pages/index').then(() => {
                this.inputHandle.addLog('loadContent finished')
                //                this.showWindow()
              })
            })
          })
        })
      })
    });
  }

  private resizeWindow() {
    this.inputHandle.addLog('resizeWindow');

    display.getDefaultDisplay().then(dis => {
      this.inputHandle.addLog("resizeWindow-oncall display");

      var dWidth = dis.width;
      var dHeight = dis.height;
      var navigationbar_height = dHeight * 0.07; //todo:有些产品导航栏高度为0，默认为0.07
      var keyHeightRate = 0.47;
      var keyHeight = dHeight * keyHeightRate;
      this.inputHandle.addLog("resizeWindow-dWidth = " + dWidth + ";dHeight = " + dHeight + ";keyboard height = " + keyHeight + ";navibar height = " + navigationbar_height);

      windowWidth = dWidth;
      windowHeight = keyHeight;

      windowManager.find(this.windowName).then((win) => {
        win.resetSize(dWidth, keyHeight).then(() => {
          win.moveTo(0, dHeight - keyHeight - navigationbar_height).then(() => {
            this.inputHandle.addLog('resizeWindow-moveTo success');
          })
        })
      })
    });
  }

  private registerListener(): void {
    this.inputHandle.addLog('registerListener')

    screen.on('change', (screenEvent) => {
      this.inputHandle.addLog('screenChangeEvent');
      this.resizeWindow()
    });
    InputMethodEngine.on('inputStart', (kbController, textInputClient) => {
      this.inputHandle.addLog('keyboard inputStart');
      this.inputHandle.onInputStart(kbController, textInputClient);
    })
    InputMethodEngine.on('inputStop', (imeId) => {
      this.inputHandle.addLog('keyboard inputStop: ' + JSON.stringify(imeId));
      if (imeId == "com.example.kikakeyboardjs/ServiceExtAbility") {
        this.onDestroy();
      }
    });
    InputMethodEngine.on('keyboardShow', (err) => {
      this.inputHandle.addLog('keyboard show');
      this.showWindow()
    });

    InputMethodEngine.on('keyboardHide', (err) => {
      this.inputHandle.addLog('keyboard hide');
      this.hideWindow();
    });

    this.mKeyboardDelegate = inputMethodEngine.createKeyboardDelegate();

    this.mKeyboardDelegate.on('keyDown', (keyEvent) => {
      this.inputHandle.addLog('OnKeyDown: code = ' + keyEvent.keyCode);

      if (this.isKeyboardShow) {
        this.inputHandle.hideKeyboardSelf();
      }

      if (this.isSpecialKeyPress) {
        return false;
      }

      var keyCode = keyEvent.keyCode;

      var keyValue = GetHardKeyValue(keyCode);
      if (keyValue == "") {
        this.inputHandle.addLog('OnKeyDown: unknown keyCode');
        this.isSpecialKeyPress = true;
        return false;
      }
      return true;
    });

    this.mKeyboardDelegate.on('keyUp', (keyEvent) => {
      this.inputHandle.addLog('OnKeyUp: code = ' + keyEvent.keyCode);
      var keyCode = keyEvent.keyCode;
      var keyValue = GetHardKeyValue(keyCode);

      if (this.isSpecialKeyPress) {
        if (keyValue == "") {
          this.isSpecialKeyPress = false;
        }
        return false;
      }

      switch (keyValue) {
        case "KEYCODE_DPAD_UP":
        {
          inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_UP);
          if (isDebug) {
            this.inputHandle.refreshInfo();
          }
          break;
        }
        case "KEYCODE_DPAD_DOWN":
        {
          inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_DOWN);
          if (isDebug) {
            this.inputHandle.refreshInfo();
          }
          break;
        }
        case "KEYCODE_DPAD_LEFT":
        {
          inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_LEFT);
          if (isDebug) {
            this.inputHandle.refreshInfo();
          }
          break;
        }
        case "KEYCODE_DPAD_RIGHT":
        {
          inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_RIGHT);
          if (isDebug) {
            this.inputHandle.refreshInfo();
          }
          break;
        }
        case "KEYCODE_FORWARD_DEL":
        {
          this.inputHandle.deleteForward(1);
          break;
        }
        case "KEYCODE_DEL":
        {
          this.inputHandle.deleteBackward(1);
          break;
        }
        default:
          {
            this.inputHandle.insertText(keyValue);
            break;
          }
      }

      return true;
    });

    if (isDebug) {
      this.mKeyboardDelegate.on('cursorContextChange', (x, y, height) => {
        this.inputHandle.setCursorInfo('cursorInfo：(' + x + ',' + y + '), h = ' + height);
      });

      this.mKeyboardDelegate.on('selectionChange', (oldBegin, oldEnd, newBegin, newEnd) => {
        this.inputHandle.setSelectInfo('selectInfo: from(' + oldBegin + ',' + oldEnd + ') to (' + newBegin + ',' + newEnd + ')');
      });

      this.mKeyboardDelegate.on('textChange', (text) => {
        this.inputHandle.setTextInfo('textInfo: ' + text);
      });
    }
  }

  private unRegisterListener(): void{
    this.inputHandle.addLog('unRegisterListener')
    InputMethodEngine.off('inputStop');

    InputMethodEngine.off('keyboardShow');

    InputMethodEngine.off('keyboardHide');

    this.mKeyboardDelegate.off('keyDown');

    this.mKeyboardDelegate.off('keyUp');

    if (isDebug) {
      this.mKeyboardDelegate.off('cursorContextChange');

      this.mKeyboardDelegate.off('selectionChange');

      this.mKeyboardDelegate.off('textChange');
    }
  }

  private showWindow() {
    this.inputHandle.addLog('showWindow');
    windowManager.find(this.windowName).then((win) => {
      win.show().then(() => {
        this.inputHandle.addLog('showWindow finish');
        this.isKeyboardShow = true;
      })
    })
  }

  private hideWindow() {
    this.inputHandle.addLog('hideWindow');
    windowManager.find(this.windowName).then((win) => {
      win.hide().then(() => {
        this.isKeyboardShow = false;
        this.inputHandle.addLog('hideWindow finish');
      })
    })
  }
}

export class InputHandler {
  private static instance: InputHandler;
  private mKbController;
  private mTextInputClient;
  private mEditorAttribute;
  private cursorInfo;
  private selectInfo;
  private textInfo;
  private inputInfo;
  private constructor() {

  }

  public static getInstance() {
    if (globalThis.instance == null) {
      globalThis.instance = new InputHandler();
    }
    return globalThis.instance;
  }

  public onInputStart(kbController, textInputClient) {
    globalThis.mKbController = kbController;
    globalThis.mTextInputClient = textInputClient;
    globalThis.mEditorAttribute = globalThis.mTextInputClient.getEditorAttribute();
    this.addLog("onInputStart mEditorAttribute = " + globalThis.mEditorAttribute);
    this.setInputInfo("EditorInfo：enterKeyType = " + globalThis.mEditorAttribute.enterKeyType + ";inputPattern = " + globalThis.mEditorAttribute.inputPattern);
  }

  public hideKeyboardSelf() {
    this.addLog('hideKeyboardSelf')
    globalThis.mKbController.hideKeyboard();
  }

  public sendKeyFunction() {
    this.addLog('sendKeyFunction')
    globalThis.mTextInputClient.sendKeyFunction(globalThis.mEditorAttribute.enterKeyType);
  }

  public deleteBackward(length: number) {
    this.addLog('deleteBackward')
    globalThis.mTextInputClient.deleteBackward(length);
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public deleteForward(length: number) {
    this.addLog('deleteForward')
    globalThis.mTextInputClient.deleteForward(length);
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public insertText(text: string) {
    this.addLog('insertText')
    globalThis.mTextInputClient.insertText(text);
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public addLog(message): void {
    console.info("kikaInput-js: " + message)
  }

  public setCursorInfo(info) {
    globalThis.cursorInfo = info;
    this.addLog("setCursorInfo info = " + info);
  }

  public setSelectInfo(info) {
    globalThis.selectInfo = info;
    this.addLog("setSelectInfo info = " + info);
  }

  public setTextInfo(info) {
    globalThis.textInfo = info;
    this.addLog("setTextInfo info = " + info);
  }

  public setInputInfo(info) {
    globalThis.inputInfo = info;
    this.addLog("setInputInfo info = " + info);
  }

  public refreshInfo() {
    this.addLog('refreshInfo');
    var showText = '';
    this.addLog('refreshInfo1');
    showText += 'five chars: before：[' + globalThis.mTextInputClient.getForward(5) + '];after：[' + globalThis.mTextInputClient.getBackward(5) + ']\n';
    this.addLog('refreshInfo2');
    showText += globalThis.cursorInfo + "\n";
    this.addLog('refreshInfo3');
    showText += globalThis.selectInfo + "\n";
    this.addLog('refreshInfo4');
    showText += globalThis.textInfo + "\n";
    this.addLog('refreshInfo5');
    showText += globalThis.inputInfo;
    this.addLog('refreshInfo6');
    AppStorage.Set<string>('showLog', showText);
    this.addLog('refreshInfo7');
    this.addLog('result is = ' + showText);
  }
}