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

import fileIo from '@ohos.fileio'
import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@system.prompt'

const writeContent = 'hello, fileIo'
let context = featureAbility.getContext()
let path
context.getOrCreateLocalDir().then((e) => {
  path = e + '/files'
  console.log('FileIo =' + path)
})

@Entry
@Component
struct Index {
  @State result: string = ''
  @State newPath: string = ''
  @State readText: string = ''
  @State fd: number = 0
  private options: Resource [] = [
    $r('app.string.create_fileIo'),
    $r('app.string.rename_fileIo'),
    $r('app.string.write_fileIo'),
    $r('app.string.read_fileIo'),
    $r('app.string.delete_fileIo')
  ]
 private stream: fileIo.Stream

  create_fileIo() {
    this.result = path + '/xxx.txt'
    this.fd = fileIo.openSync(this.result, 0o2 | 0o100, 0o666)
    prompt.showToast({ message: 'create_file success =>' + this.result, duration: 2000 })
    console.log('FileIo fd =' + this.fd)
    fileIo.close(this.fd)
  }

  rename_fileIo() {
    this.newPath = path + '/FileIo.txt'
    fileIo.renameSync(this.result, this.newPath)
    prompt.showToast({ message: 'rename_file success =>' + this.newPath, duration: 2000 })
  }

  write_fileIo() {
    let writeFd = fileIo.openSync(this.newPath, 0o2 | 0o100, 0o666)
    this.stream = fileIo.fdopenStreamSync(writeFd, "r+")
    let writelength = this.stream.writeSync(writeContent, {
      offset: 0,
      length: writeContent.length,
      position: 0,
      encoding: 'utf-8'
    })
    prompt.showToast({ message: 'write_fileIo success =>' + 'hello, fileIo', duration: 2000 })
    console.log('FileIo WriteLength = ' + writelength)
    this.stream.close()
    fileIo.close(writeFd)
  }

  read_fileIo() {
    let readFd = fileIo.openSync(this.newPath, 0o0)
    this.stream = fileIo.fdopenStreamSync(readFd, "r")
    let buf = new ArrayBuffer(4096)
    let length = this.stream.readSync(buf, { offset: 0, length: writeContent.length, position: 0 })
    this.readText = String.fromCharCode.apply(null, new Uint8Array(buf))
    prompt.showToast({ message: 'read_fileIo success', duration: 2000 })
    console.log('FileIo buf = ' + this.readText)
    console.log('FileIo length = ' + length)
    this.stream.close()
    fileIo.close(readFd)
  }

  delete_fileIo() {
    fileIo.unlinkSync(this.newPath)
    prompt.showToast({ message: 'delete_file success', duration: 2000 })
  }

  build() {
    Column() {
      Text($r("app.string.title"))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })
      Scroll() {
        Column() {
          ForEach(this.options, item => {
            Button() {
              Text(item)
                .fontSize(19)
                .fontWeight(FontWeight.Bold)
                .padding({ left: 10, right: 10 })
                .width('100%')
                .textAlign(TextAlign.Center)
            }.type(ButtonType.Capsule)
            .backgroundColor('#0D9FFB')
            .margin({ top: 15 })
            .onClick(() => {
              var index = this.options.indexOf(item)
              switch (index) {
                case 0:
                  this.create_fileIo()
                  break
                case 1:
                  this.rename_fileIo()
                  break
                case 2:
                  this.write_fileIo()
                  break
                case 3:
                  this.read_fileIo()
                  break
                case 4:
                  this.delete_fileIo()
                  break
                default:
                  prompt.showToast({ message: 'error', duration: 2000 })
                  break
              }
            })
          }, item => JSON.stringify(item))

          Text(this.readText)
            .width('100%')
            .height(200)
            .backgroundColor('#DFDFDF')
            .fontSize(20)
            .margin({ top: 20 })
            .textAlign(TextAlign.Start)
            .padding(10)
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%').height('100%')
      .padding(15)
    }
  }
}