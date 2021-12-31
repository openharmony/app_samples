import router from '@system.router';

@Entry
@Component
struct BitmapExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true, true)
  private context: RenderingContext = new RenderingContext(this.settings)
  private img: ImageBitmap = new ImageBitmap("/common/images/icon.png")

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('90%').height('40%').backgroundColor('#00ffff')
        .onReady(() => {
          this.context.imageSmoothingEnabled = false
          this.context.drawImage(this.img, 0, 100, 400,400)
        })
      Button('back')
        .width(130)
        .height(45)
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        })
        .margin({ top: 10 })
    }.width('100%').height('100%')
  }
}