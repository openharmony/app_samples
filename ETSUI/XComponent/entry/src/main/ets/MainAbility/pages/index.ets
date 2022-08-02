import nativerender from "libnativerender.so";
import { ContextType } from "../common/Constants"

const nativePageLifecycle = nativerender.getContext(ContextType.JSPAGE_LIFECYCLE);

@Entry
@Component
struct Index {
  private context = null;
  aboutToAppear() {
    console.log('[LIFECYCLE-Index] aboutToAppear');
    nativePageLifecycle.aboutToAppear();
  }
  aboutToDisappear() {
    console.log('[LIFECYCLE-Index] aboutToDisappear');
    nativePageLifecycle.aboutToDisappear();
  }

  onPageShow() {
    console.log('[LIFECYCLE-Page] onPageShow');
    nativePageLifecycle.onPageShow();
  }

  onPageHide() {
    console.log('[LIFECYCLE-Page] onPageHide');
    nativePageLifecycle.onPageHide();
  }
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('ChangeColor')
        .onClick(() => {
          if (this.context) {
            this.context.changeColor();
          }
        })
        .width(200)
        .height(80)
      Button('ChangeShape')
        .onClick(() => {
          if (this.context) {
            this.context.changeShape();
          }
        })
        .width(200)
        .height(80)

      XComponent({ id: 'xcomponentId', type: 'texture', libraryname: 'nativerender'})
        .onLoad((context) => {
          this.context = context;
        })
        .onDestroy(() => {
        })
    }
    .width('100%')
    .height('100%')
  }
}
