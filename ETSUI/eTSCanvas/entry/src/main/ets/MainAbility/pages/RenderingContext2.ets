import router from '@system.router';

@Entry
@Component
struct RenderingExample {
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
        .width('100%').height('50%').backgroundColor('#00ffff')
        .onReady(() => {
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('arcTo').width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.arcTo(150, 50, 250, 150, 250);
            this.context.lineWidth = 3;
            this.context.stroke();
            this.context.restore();
          })
        Button('bezierCurveTo').width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.beginPath();
            this.context.moveTo(600, 200);
            this.context.bezierCurveTo(620, 450, 800, 450, 800, 200);
            this.context.stroke();
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('ellipse').width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.beginPath();
            this.context.lineWidth = 3;
            this.context.ellipse(500, 300, 100, 50, Math.PI * 0.25, Math.PI * 0.5, Math.PI, 1)
            this.context.stroke();
            this.context.restore();
          })
        Button('rect').width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.rect(300, 250, 100, 100);
            this.context.fill();
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('createPattern').width(130).height(45)
          .onClick(() => {
            this.context.save();
            var pattern = this.context.createPattern(this.img, 'repeat');
            this.context.fillStyle = pattern;
            this.context.fillRect(70, 200, 200, 200);
            this.context.restore();
          })
        Button('lineDashOffset')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.arc(350, 170, 80, 0, 6.28);
            this.context.setLineDash([10, 20]);
            this.context.lineWidth = 3;
            this.context.stroke();
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('shadowOffsetY')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.shadowBlur = 30;
            this.context.shadowOffsetY = 20;
            this.context.shadowColor = 'rgb(0,0,0)'
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(100, 500, 150, 150);
            this.context.restore();
          })
        Button('shadowOffsetX')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.shadowBlur = 30;
            this.context.shadowOffsetX = 20;
            this.context.shadowColor = 'rgb(0,0,0)'
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(400, 500, 150, 150);
            this.context.restore();
          })
      }.margin({ top: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('shadowBlur')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.context.shadowBlur = 30;
            this.context.shadowColor = 'rgb(0,0,0)'
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(700, 500, 150, 150);
            this.context.restore();
          })
        Button('scale').width(130).height(45)
          .onClick(() => {
            this.context.strokeRect(10, 10, 25, 25);
            this.context.scale(2, 2);
            this.context.strokeRect(10, 10, 25, 25);
          })
      }.margin({ top: 10 })

      Button('back')
        .width(130).height(45).backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        }).margin({top:10})
    }.width('100%').height('100%')
  }
}