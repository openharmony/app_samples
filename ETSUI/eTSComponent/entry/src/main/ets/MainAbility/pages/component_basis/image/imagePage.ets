// @ts-nocheck
import  image  from '@ohos.multimedia.image_napi_plugin';
import fileio from '@ohos.fileio';

@Entry
@Component
struct GridItemExample {
  @State uri: string = 'string'
  @State imgId: number = 0
  @State imgNum: number[] = [...Array(6).keys()]
  @State img: string[] = ['/common/rawfile/basi6a16.png', '/common/rawfile/test.jpg', '/common/rawfile/0.bmp', '/common/rawfile/ic_huaweiid.svg', '/common/rawfile/ic_huaweiid.vg']
  @State imgDescribe: string[] = ['png', 'jpg', 'bmp', 'svg', 'network', 'error']
  @State altId: number = 0
  @State altNum: number[] = [...Array(3).keys()]
  @State isAlt: boolean = false
  @State alt: string[] = ['/common/rawfile/loading.gif', '/common/rawfile/loading.jpg', '/common/rawfile/loading.png']
  @State altDescribe: string[] = ['gif', 'jpg', 'png']
  @State objectId: number = 2
  @State objectFitNum: number[] = [...Array(5).keys()]
  @State objectFit: ImageFit[] = [ImageFit.Cover, ImageFit.Contain, ImageFit.Fill, ImageFit.None, ImageFit.ScaleDown]
  @State objectFitDescribe: string[] = ['Cover', 'Contain', 'Fill', 'None', 'ScaleDown']
  @State repeatId: number = 0
  @State repeatNum: number[] = [...Array(4).keys()]
  @State objectRepeat: ImageRepeat[] = [ImageRepeat.NoRepeat, ImageRepeat.X, ImageRepeat.Y, ImageRepeat.XY]
  @State objectRepeatDescribe: string[] = ['NoRepeat', 'X', 'Y', 'XY']
  @State interpolationId: number = 0
  @State interpolationNum: number[] = [...Array(4).keys()]
  @State interpolation: ImageInterpolation[]= [ImageInterpolation.None, ImageInterpolation.High, ImageInterpolation.Medium, ImageInterpolation.Low]
  @State interpolationDescribe: string[] = ['None', 'High', 'Medium', 'Low']
  @State renderModeId: number = 0
  @State renderModeNum: number[] = [...Array(2).keys()]
  @State renderMode: ImageRenderMode[]  = [ImageRenderMode.Original, ImageRenderMode.Template]
  @State renderModeDescribe: string[]= ['Original', 'Template']
  @State sourceId: number = 0
  @State sourceNum: number[] = [...Array(5).keys()]
  @State sourceSize: Array<{
    width: number,
    height: number
  }> = [{ width: 200, height: 100 }, { width: 50, height: 80 }, { width: 0, height: 0 }, {
    width: -100,
    height: -100
  }, { width: 300, height: 320 }]
  @State sourceSizeDescribe: string[] = ['(200,100)', '(50.80)', '(0,0)', '(-100,-100)', '(300,320)']
  @State isSvg: boolean = false
  @State rowsGap: number = 0
  @State barWidth: number = 0
  @State barHeight: number = 0
  @State scrollBarId: number = 0

  build() {
    Column() {
      if (this.uri == 'string') {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Image(this.img[this.imgId])
            .alt(this.alt[this.altId])
            .objectFit(this.objectFit[this.objectId])
            .objectRepeat(this.objectRepeat[this.repeatId])
            .interpolation(this.interpolation[this.interpolationId])
            .renderMode(this.renderMode[this.renderModeId])
            .sourceSize(this.sourceSize[this.sourceId])
            .width(350)
            .height(300)
            .onComplete((e) => {
              console.log('www data  complete  ' + JSON.stringify(e))
            })
            .onError(() => {
              console.info('www data  error  ' + '图片加载错误')
            })
            .onFinish(() => {
              console.log('www data  finish  ' + '图片加载完成')
            })
        }
        .height('45%')
        .width('90%')
        .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })
      } else {
        image_PixelMapPage()
      }

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Button('uri:string')
          .fontSize(15)
          .onClick(() => {
            this.uri = 'string'
          })
        Button('uri:PixelMap')
          .fontSize(15)
          .visibility(Visibility.Hidden)
          .onClick(() => {
            this.uri = 'PixelMap'
          })


      }
      .margin({ top: 5, bottom: 5 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('图片uri及格式')
              .width('100%')
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontSize(15)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5)

          ForEach(this.imgNum, item => {
            GridItem() {
              Button(this.imgDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.imgId = item
                  if (item == 5) {
                    this.isAlt = true
                  } else {
                    this.isAlt = false
                  }
                  if (item == 3) {
                    this.isSvg = true
                  } else {
                    this.isSvg = false
                  }
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('缩放类型')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5)

          ForEach(this.objectFitNum, item => {
            GridItem() {
              Button(this.objectFitDescribe[`${item}`])
                .fontSize(15)
                .width('100%')

                .onClick(() => {
                  this.objectId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('重复样式')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.repeatNum, item => {
            GridItem() {
              Button(this.objectRepeatDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.repeatId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('插值效果')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.interpolation, item => {
            GridItem() {
              Button(this.interpolationDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.repeatId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('渲染模式')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.renderModeNum, item => {
            GridItem() {
              Button(this.renderModeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.repeatId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('解码尺寸')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.sourceNum, item => {
            GridItem() {
              Button(this.sourceSizeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.repeatId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('占位图格式')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.altNum, item => {
            GridItem() {
              Button(this.altDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.repeatId = item
                })
            }
          }, item => item.toString())
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .scrollBarWidth(this.barWidth)
        .scrollBar(BarState.Auto)
        .onScrollIndex((e) => {
          console.log('www data ' + e)
          prompt.showToast({
            message: String(e),
            duration: 2000
          })
        })
      }.height('45%')
      .width('100%')
    }.width('100%').margin({ top: 5 })
  }
}


@Component
struct image_PixelMapPage {
  @State pixmapObj: PixelMap = undefined
  @State pixmapObj1: PixelMap = undefined
  @State pixmapObj2: PixelMap = undefined
  @State pixmapObj3: PixelMap = undefined
  @State show: number= 0

  private aboutToAppear(): void  {
    console.error(' ---------before----- PixelMapNapi createImageSource ');
    this.testImage1()
    console.error(' ---------after----- PixelMapNapi createImageSource ');
  }

  build() {

    Column() {
      Text("test Image PixelMap")
        .width(150)
        .height(50)
        .margin(10)

      Image(this.pixmapObj)
        .width(300)
        .height(300)
        .backgroundColor('rgb(255, 0, 0)')
        .border({ width: 2, color: 'rgb(0, 255, 0)', radius: 10, style: BorderStyle.Dashed })
        .objectFit(ImageFit.Contain)
        .objectRepeat(ImageRepeat.XY)
        .renderMode(ImageRenderMode.Template)
        .onClick((event) => {
          if (this.show == 0) {
            this.pixmapObj = this.pixmapObj1;
            this.show =+1;
            console.info("cd test pixmap" + this.show);
          }
          else if (this.show == 1) {
            this.pixmapObj = this.pixmapObj2;
            this.show =+1;
            console.info("cd test pixmap" + this.show);
          }
          else if (this.show == 2) {
            this.pixmapObj = this.pixmapObj3;
            this.show =+1;
            console.info("cd test pixmap" + this.show);
          }
          else {
            this.pixmapObj = this.pixmapObj;
            this.show = 0;
            console.info("cd test pixmap" + this.show);
          }
        });

      // 这里是column的结尾
    }.alignItems(HorizontalAlign.Center)
    .width(500)
    .height(2000)
  }

  testImage1() {
    console.error('PixelMapNapi testImage');
    var fd1 = fileio.openSync("/system/test1.png");
    var fd2 = fileio.openSync("/system/test2.jpg");
    var fd3 = fileio.openSync("/system/test3.bmp");
    var fd4 = fileio.openSync("/system/test4.webp");
    let opts = {
      "sampleSize": 1,
      "rotateDegrees": 0,
      "editable": false,
      "desiredSize": {
        "width": 0,
        "height": 0
      },
      "desiredRegion": {
        "size": {
          "width": 0,
          "height": 0
        },
        "x": 0,
        "y": 0
      },
      "desiredPixelFormat": 3,
    };
    image.createPixelMap(fd1, 0, opts).then((data) => {
      this.pixmapObj = data;
    }).catch((InfoErr) => {
      console.error('PixelMapNapi CreatePixelByFd  error msg is ' + InfoErr.message);
    });
    image.createPixelMap(fd2, 0, opts).then((data) => {
      this.pixmapObj1 = data;
    }).catch((InfoErr) => {
      console.error('PixelMapNapi CreatePixelByFd  error msg is ' + InfoErr.message);
    });
    image.createPixelMap(fd3, 0, opts).then((data) => {
      this.pixmapObj2 = data;
    }).catch((InfoErr) => {
      console.error('PixelMapNapi CreatePixelByFd  error msg is ' + InfoErr.message);
    });
    image.createPixelMap(fd4, 0, opts).then((data) => {
      this.pixmapObj3 = data;
    }).catch((InfoErr) => {
      console.error('PixelMapNapi CreatePixelByFd  error msg is ' + InfoErr.message);
    });
  }
}
