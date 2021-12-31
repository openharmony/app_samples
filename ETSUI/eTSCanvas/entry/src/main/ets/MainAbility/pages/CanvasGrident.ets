import router from '@system.router';

@Entry
@Component
struct GradientExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true, true);
  private context: RenderingContext = new RenderingContext(this.settings);
  private gra: CanvasGradient = new CanvasGradient();

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .width('100%')
        .height('40%')
        .backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('createLinearGradient').width(130).height(45)
          .onClick(() => {
            var grad = this.context.createLinearGradient(400, 0, 700, 400)
            grad.addColorStop(0.0, 'red');
            grad.addColorStop(0.5, 'white');
            grad.addColorStop(1.0, 'green');
            this.context.fillStyle = grad;
            this.context.fillRect(450, 0, 400, 400);
          })
        Button('createRadialGradient').width(130).height(45)
          .onClick(() => {
            var grad = this.context.createRadialGradient(200, 200, 100, 200, 200, 150)
            grad.addColorStop(0.0, 'red');
            grad.addColorStop(0.5, 'white');
            grad.addColorStop(1.0, 'green');
            this.context.fillStyle = grad;
            this.context.fillRect(0, 0, 400, 400);
          })
      }.margin({ top: 20 })

      Button('back')
        .width(130)
        .height(45)
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        })
        .margin({ top: 10 })
    }
  }
}