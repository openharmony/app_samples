import router from '@system.router';

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true, true)
  private context: RenderingContext = new RenderingContext(this.settings)

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context).width('90%').height(300).backgroundColor('#00ffff')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('arc')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.arc(485, 440, 150, 0, 6.28);
            this.context.lineWidth = 4;
            this.context.stroke();
          })
        Button('strokeText')
          .width(130).height(45)
          .onClick(() => {
            this.context.font = '100px sans-serif';
            this.context.strokeText("hello World!", 200, 150);
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('closePath')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.moveTo(400, 440);
            this.context.lineTo(485, 290);
            this.context.lineTo(570, 440);
            this.context.lineTo(485, 590);
            this.context.closePath();
            this.context.stroke();
          })
        Button('quadraticCurveTo')
          .width(130).height(45)
          .onClick(() => {
            this.context.beginPath();
            this.context.moveTo(20, 20);
            this.context.quadraticCurveTo(485, 485, 950, 20);
            this.context.stroke();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('textBaseline')
          .width(130).height(45)
          .onClick(() => {
            this.context.moveTo(100, 660);
            this.context.lineTo(900, 660);
            this.context.stroke();
            this.context.font = '50px sans-serif';
            this.context.textBaseline = 'top';
            this.context.fillText('Top', 200, 660)
            this.context.textBaseline = 'bottom';
            this.context.fillText('Bottom', 270, 660);
            this.context.textBaseline = 'middle';
            this.context.fillText('Middle', 450, 660);
            this.context.textBaseline = 'alphabetic';
            this.context.fillText('Alphabetic', 630, 660);
          })
        Button('delete')
          .width(130).height(45)
          .onClick(() => {
            this.context.clearRect(20, 20, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('OtherContext')
          .width(130).height(45)
          .onClick(() => {
            router.push({ uri: 'pages/context' })
          })
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