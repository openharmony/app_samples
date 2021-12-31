import router from '@system.router';

@Entry
@Component
struct AllRenderingExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true, true)
  private context: RenderingContext = new RenderingContext(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context).width('100%').height(300).backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('strokeStyle')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.lineWidth = 7;
            this.context.strokeStyle = '#0000ff'
            this.context.strokeRect(390, 350, 240, 200)
          })
        Button('lineCap')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 6;
            this.context.beginPath();
            this.context.lineCap = 'round';
            this.context.moveTo(400, 150);
            this.context.lineTo(600, 150);
            this.context.stroke();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('globalAlpha')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(450, 200, 50, 50);
            this.context.globalAlpha = 0.4;
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(500, 250, 50, 50);
            this.context.save();
          })
        Button('textAlign')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 3;
            this.context.moveTo(140, 300);
            this.context.lineTo(140, 580);
            this.context.stroke();
            this.context.font = '50px sans-serif';
            this.context.textAlign = 'start'
            this.context.fillText('start', 140, 320)
            this.context.textAlign = 'end'
            this.context.fillText('end', 140, 370);
            this.context.textAlign = 'left'
            this.context.fillText('left', 140, 420);
            this.context.textAlign = 'center'
            this.context.fillText('center', 140, 500);
            this.context.textAlign = 'right'
            this.context.fillText('right', 140, 570);
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('lineJoin')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.beginPath();
            this.context.lineWidth = 6;
            this.context.lineJoin = 'miter';
            this.context.moveTo(440, 40);
            this.context.lineTo(580, 80);
            this.context.lineTo(440, 110);
            this.context.stroke();
            this.context.save();
          })
        Button('miterLimit')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.lineWidth = 6;
            this.context.lineJoin = 'miter';
            this.context.miterLimit = 3;
            this.context.moveTo(650, 400);
            this.context.lineTo(740, 420);
            this.context.lineTo(650, 440);
            this.context.stroke();
            this.context.save();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('globalCompositeOperation')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(400, 400, 70, 70);
            this.context.globalCompositeOperation = 'source-over'
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(430, 430, 70, 70);

            this.context.fillStyle = 'rgb(255,0,0)';
            this.context.fillRect(500, 400, 70, 70);
            this.context.globalCompositeOperation = 'destination-over'
            this.context.fillStyle = 'rgb(0,0,255)';
            this.context.fillRect(530, 430, 70, 70);
            this.context.save();
          })
        Button('delete')
          .width(130).height(45)
          .onClick(() => {
            this.context.clearRect(0, 0, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('back')
          .width(130).height(45).backgroundColor(Color.Orange)
          .onClick(() => {
            router.back()
          })
      }.margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
  }
}