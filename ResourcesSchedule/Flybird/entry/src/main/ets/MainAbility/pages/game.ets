/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// @ts-nocheck
import router from '@system.router';
import bundleState from '@ohos.bundleState';
import logger from '../utils/logger'

const TAG = "flybirdDebug"

@Entry
@Component
struct Game {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private isInit: boolean = false;
  private bgOne: ImageBitmap = new ImageBitmap("images/bg.png")
  private pipeNorthOne: ImageBitmap = new ImageBitmap("images/pipeNorth.png")
  private pipeSouthOne: ImageBitmap = new ImageBitmap("images/pipeSouth.png")
  private fgOne: ImageBitmap = new ImageBitmap("images/fg.png")
  private bgTwo: ImageBitmap = new ImageBitmap("images_two/bg.png")
  private pipeNorthTwo: ImageBitmap = new ImageBitmap("images_two/pipeNorth.png")
  private pipeSouthTwo: ImageBitmap = new ImageBitmap("images_two/pipeSouth.png")
  private fgTwo: ImageBitmap = new ImageBitmap("images_two/fg.png")
  private bgThree: ImageBitmap = new ImageBitmap("images_three/bg.png")
  private pipeNorthThree: ImageBitmap = new ImageBitmap("images_three/pipeNorth.png")
  private pipeSouthThree: ImageBitmap = new ImageBitmap("images_three/pipeSouth.png")
  private fgThree: ImageBitmap = new ImageBitmap("images_three/fg.png")
  private bgFour: ImageBitmap = new ImageBitmap("images_four/bg.png")
  private pipeNorthFour: ImageBitmap = new ImageBitmap("images_four/pipeNorth.png")
  private pipeSouthFour: ImageBitmap = new ImageBitmap("images_four/pipeSouth.png")
  private fgFour: ImageBitmap = new ImageBitmap("images_four/fg.png")
  private bgFive: ImageBitmap = new ImageBitmap("images_five/bg.png")
  private pipeNorthFive: ImageBitmap = new ImageBitmap("images_five/pipeNorth.png")
  private pipeSouthFive: ImageBitmap = new ImageBitmap("images_five/pipeSouth.png")
  private fgFive: ImageBitmap = new ImageBitmap("images_five/fg.png")
  private bird: ImageBitmap = new ImageBitmap("images/bird.png");
  private sleep: number = 90;
  @State i: number = 0;
  @State gap: number = 105;
  @State constant: number = 0;
  @State score: number = 0;
  @State bX: number = 10;
  @State bY: number = 150;
  @State gravity: number = 2;
  @State pipe: any [] = [];
  @State birdHeigth: number = 26;
  @State birdWidth: number = 38;
  @State pipeNorthHeight: number = 242;
  @State pipeNorthWidth: number = 52;
  @State cvsHeigth: number = 512;
  @State cvsWidth: number = 288;
  @State fgHeight: number = 160;
  @State fgWidth: number = 306;
  @State scoreTemp: number = 0;
  @State beginTime: number = 0;
  @State endTime: number = 200000000000000;
  @State TAG1: string = "BUNDLE_ACTIVE";
  @State historyTime: number = 0;
  @State pipeLength: number = 125;
  @State isChange: boolean = false;

  draw = () => {
    let id = router.getParams()['id']
    let fg
    let pipeNorth
    let pipeSouth
    let bg
    switch (id) {
      case 1:
        fg = this.bgOne
        pipeNorth = this.pipeNorthOne
        pipeSouth = this.pipeSouthOne
        bg = this.bgOne
        break
      case 2:
        fg = this.bgTwo
        pipeNorth = this.pipeNorthTwo
        pipeSouth = this.pipeSouthTwo
        bg = this.bgTwo
        this.sleep = 70
        break
      case 3:
        fg = this.bgThree
        pipeNorth = this.pipeNorthThree
        pipeSouth = this.pipeSouthThree
        bg = this.bgThree
        this.sleep = 50
        break
      case 4:
        fg = this.bgFour
        pipeNorth = this.pipeNorthFour
        pipeSouth = this.pipeSouthFour
        bg = this.bgFour
        this.sleep = 30
      case 5:
        fg = this.bgFive
        pipeNorth = this.pipeNorthFive
        pipeSouth = this.pipeSouthFive
        bg = this.bgFive
        this.sleep = 10
        break
      default:
        break
    }
    this.realDraw(fg, pipeNorth, pipeSouth, bg);
  }

  realDraw(fg: ImageBitmap, pipeNorth: ImageBitmap, pipeSouth: ImageBitmap, bg: ImageBitmap) {
    let ctx = this.context;
    ctx.clearRect(0, 0, this.cvsWidth, this.cvsHeigth);
    ctx.drawImage(bg, 0, 0, this.cvsWidth, this.cvsHeigth);
    this.drawPipe(ctx, fg, pipeNorth, pipeSouth);

    ctx.drawImage(fg, 0, this.cvsHeigth - this.fgHeight, this.fgWidth, this.fgHeight);
    ctx.drawImage(this.bird, this.bX, this.bY, this.birdWidth, this.birdHeigth);
    this.bY += this.gravity;
    ctx.fillStyle = "#000";
    ctx.font = "20px Verdana";

    if (this.scoreTemp >= this.score) {
      this.scoreTemp = this.scoreTemp
    } else {
      this.scoreTemp = this.score;
    }
    ctx.fillText(`History Highest Score : ${this.scoreTemp}`, 10, this.cvsHeigth - 50);
    ctx.fillText(`Score : ${this.score}`, 10, this.cvsHeigth - 30);
    if (this.historyTime != 0) {
      let min = parseInt((this.historyTime / 1000 / 60).toString(), 10);
      let sec = parseInt(((this.historyTime - min * 1000 * 60) / 1000).toString(), 10);
      ctx.fillText(`historyTime : ${min} min ${sec} s`, 10, this.cvsHeigth - 10);
    }
    else {
      ctx.fillText(`historyTime : 0 min 0 s`, 10, this.cvsHeigth - 10);
    }
    if(this.isChange == true) {
      clearTimeout(timeId);
    }

    setTimeout(this.draw, this.sleep);
  }

  drawPipe(ctx: CanvasRenderingContext2D, fg: ImageBitmap, pipeNorth: ImageBitmap, pipeSouth: ImageBitmap) {
    for (let i = 0; i < this.pipe.length; i++) {
      this.constant = this.pipeNorthHeight + this.gap;
      ctx.drawImage(pipeNorth, this.pipe[i].x, this.pipe[i].y, this.pipeNorthWidth, this.pipeNorthHeight);
      ctx.drawImage(pipeSouth, this.pipe[i].x, this.pipe[i].y + this.constant, this.pipeNorthWidth, this.pipeNorthHeight);
      this.pipe[i].x--;
      if (this.pipe[i].x === this.pipeLength) {
        this.pipe.push(
          {
            x: this.cvsWidth,
            y: Math.floor(Math.random() * this.pipeNorthHeight) - this.pipeNorthHeight + 5,
          }
        )
      }
      if (this.bX + this.birdWidth >= this.pipe[i].x
      && this.bX <= this.pipe[i].x + this.pipeNorthWidth
      && (this.bY <= this.pipe[i].y + this.pipeNorthHeight
      || this.bY + this.birdHeigth >= this.pipe[i].y + this.constant)
      || this.bY + this.birdHeigth >= this.cvsHeigth - this.fgHeight) {
        this.showDialog();
        ctx.drawImage(fg, 0, this.cvsHeigth - this.fgHeight, this.fgWidth, this.fgHeight);
        ctx.drawImage(this.bird, this.bX, this.bY, this.birdWidth, this.birdHeigth);
        ctx.fillText(`History Highest Score : ${this.scoreTemp}`, 10, this.cvsHeigth - 50);
        ctx.fillText(`Score : ${this.score}`, 10, this.cvsHeigth - 30);
        if (this.historyTime != 0) {
          let min = parseInt((this.historyTime / 1000 / 60).toString(), 10);
          let sec = parseInt(((this.historyTime - min * 1000 * 60) / 1000).toString(), 10);
          ctx.fillText(`historyTime : ${min} min ${sec} s`, 10, this.cvsHeigth - 10);
        } else {
          ctx.fillText(`historyTime : 0 min 0 s`, 10, this.cvsHeigth - 10);
        }
        this.restart();
        clearTimeout(timeId);
      }
      if (this.pipe[i].x === 5) {
        this.score++;
      }
      if (this.pipe.length % 4 === 0) {
        this.pipe.shift();
      }
    }
  }

  showDialog() {
    AlertDialog.show({
      message: 'over',
      primaryButton: {
        value: '重新一次',
        action: () => {
          this.restart();
          var draw_func = this.draw;
          var timeId = setTimeout(draw_func, this.sleep);
        }
      },
      secondaryButton: {
        value: '返回',
        action: () => {
          router.back()
        }
      },
      cancel: () => {
        this.restart();
        var draw_func = this.draw();
        var timeId = setTimeout(draw_func, this.sleep);
      }
    })
  }

  restart() {
    this.pipe = [];
    this.pipe[0] = {
      x: this.cvsWidth,
      y: 0
    };
    this.constant = 0;
    this.score = 0;
    this.bY = 150;
  }

  moveUp() {
    this.bY -= 20;
  }

  onBackPress(){
    this.isChange = true;
    router.back();
    return true;
  }

  showHistoryScore() {
    bundleState.queryBundleStateInfos(Number(this.beginTime), Number(this.endTime), (err, res) => {
      if (err.code === 0) {
        logger.log(this.TAG1 + "queryBundleStateInfos1 callback success,result size = " + res.length);
        let i = 1;
        for (let key in res) {
          logger.log(this.TAG1 + 'queryBundleStateInfos1 callback i : ' + i);
          logger.log(this.TAG1 + 'queryBundleStateInfos1 callback result : ' + JSON.stringify(res[key]));
          if (res[key].bundleName.includes('flybird')) {
            this.historyTime = res[key].abilityInFgTotalTime
          }
          i++;
        }
      } else {
        logger.log(this.TAG1 + 'queryBundleStateInfos1 callback failed,because: ' + JSON.stringify(err));
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width(280)
        .height(512)
        .onReady(() => {
          logger.log(TAG + "onReady ");
          let id = router.getParams()
          logger.log(TAG + "prams id " + id + id['id']);
          this.pipe[0] = {
            x: this.cvsWidth,
            y: 0,
          }
          this.showHistoryScore();
          var draw_func = this.draw();
          let timeId = setTimeout(draw_func, this.sleep);
        })
        .onClick((event: ClickEvent) => {
          this.moveUp()
        })
    }
    .width('100%')
    .height('100%')
  }
}