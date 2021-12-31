import router from '@system.router';

@Entry
@Component
struct transformExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true, true)
  private context: RenderingContext = new RenderingContext(this.settings)
  private Scroller = new Scroller()

  build() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
          Canvas(this.context)
            .width('100%').height('50%').backgroundColor('#00ffff')
          Flex({ justifyContent: FlexAlign.SpaceAround }) {
            Button('translate')
              .width(130).height(45)
              .onClick(() => {
                this.context.fillRect(190, 190, 200, 200);
                this.context.translate(290, 290)
                this.context.fillRect(190, 190, 200, 200);
              })
            Button('transform')
              .width(130).height(45)
              .onClick(() => {
                this.context.fillStyle = 'rgb(0,0,0)';
                this.context.fillRect(0, 0, 200, 200);
                this.context.transform(1, 0.5, -0.5, 1, 10, 10);
                this.context.fillStyle = 'rgb(255,0,0)';
                this.context.fillRect(0, 0, 200, 200);
                this.context.transform(1, 0.5, -0.5, 1, 10, 10);
                this.context.fillStyle = 'rgb(0,0,255)';
                this.context.fillRect(0, 0, 200, 200);
              })
            Button('setTransform')
              .width(130).height(45)
              .onClick(() => {
                this.context.fillStyle = 'rgb(0,0,255)';
                this.context.fillRect(200, 200, 200, 200);
                this.context.setTransform(1, 0.5, -0.5, 1, 10, 10);
              })
          }.margin({ top: 10 })

          Flex({ justifyContent: FlexAlign.SpaceAround }) {
            Button('rotate').width(130).height(45)
              .onClick(() => {
                this.context.rotate(45 * Math.PI / 180);
                this.context.fillRect(300, 100, 100, 100);
              })
            Button('back')
              .width(130).height(45).backgroundColor(Color.Orange)
              .onClick(() => {
                router.back()
              })
          }.margin({ top: 10 })

    }
  }
}