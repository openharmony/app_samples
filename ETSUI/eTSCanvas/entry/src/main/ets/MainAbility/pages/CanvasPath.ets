import router from '@system.router';

@Entry
@Component
struct PathExample {
  private path2Da: Path2D = new Path2D()
  private path2Dc: Path2D = new Path2D()
  private path2Df: Path2D = new Path2D()
  private path2De: Path2D = new Path2D()
  private path2Db: Path2D = new Path2D("M250 190 L150 350 L350 350 Z")
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
            this.context.save();
            this.path2Da.arc(485, 440, 150, 0, 6.28);
            this.context.stroke(this.path2Da);
            this.context.restore();
          })
        Button('bezierCurveTo')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.path2Da.moveTo(20, 20);
            this.path2Da.quadraticCurveTo(485, 485, 950, 20);
            this.context.stroke(this.path2Da);
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('bezierCurveTo')
          .width(130).height(45)
          .onClick(() => {
            this.path2Da.moveTo(400, 100);
            this.path2Da.bezierCurveTo(400, 200, 600, 200, 600, 100);
            this.context.stroke(this.path2Da)
          })
        Button('arcTo')
          .width(130).height(45)
          .onClick(() => {
            this.path2Dc.arcTo(150, 20, 150, 70, 50)
            this.context.stroke(this.path2Dc)
          })
      }.margin({ top: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('ellipse')
          .width(130).height(45)
          .onClick(() => {
            this.context.restore();
            this.path2De.ellipse(400, 130, 50, 100, Math.PI * 0.15, Math.PI * 0.45, Math.PI)
            this.context.stroke(this.path2De);
            this.context.save();

          })
        Button('rect')
          .width(130).height(45)
          .onClick(() => {
            this.context.save();
            this.path2Df.rect(20, 440, 100, 100)
            this.context.stroke(this.path2Df);
            this.context.restore();
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('closePath')
          .width(130).height(45)
          .onClick(() => {
            this.path2Da.moveTo(400, 440);
            this.path2Da.lineTo(485, 290);
            this.path2Da.lineTo(570, 440);
            this.path2Da.lineTo(485, 590);
            this.path2Da.closePath();
            this.context.stroke(this.path2Da);
          })
        Button('delete')
          .width(130).height(45)
          .onClick(() => {
            this.context.clearRect(0, 0, 950, 950)
          })
      }.margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('addPath')
          .width(130).height(45)
          .onClick(() => {
            this.path2Da.addPath(this.path2Db)
            this.context.stroke(this.path2Da)
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