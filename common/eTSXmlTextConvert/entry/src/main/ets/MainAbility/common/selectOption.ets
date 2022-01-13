/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import xml from '@ohos.xml'
import convertXml from '@ohos.convertxml'

@Component
export struct SelectOption {
  private options: Resource[] = [$r('app.string.serializer'), $r('app.string.parser'), $r('app.string.convert')]
  @Link outputs: string
  @Link inputs: string

  serializerNode() {
    let arrayBuffer = new ArrayBuffer(1024)
    let serializer = new xml.XmlSerializer(arrayBuffer)
    serializer.setDeclaration()
    serializer.setNamespace('h', 'https://developer.harmonyos.com/')
    serializer.startElement('note')
    serializer.setAttributes('importance', 'high')
    serializer.addEmptyElement('b')
    serializer.setCommnet('contact information')
    serializer.setText('ZhangSan 18712345678')
    serializer.setCData('CData')
    serializer.setDocType('DocType')
    serializer.endElement()
    let array = new Uint8Array(arrayBuffer)
    let serializerStr = ''
    for (let i = 0; i < array.length; ++i) {
      serializerStr = serializerStr + String.fromCodePoint(array[i])
    }
    this.outputs = serializerStr
  }

  parserNode() {
    let arrayBuffer = new ArrayBuffer(this.inputs.length * 2)
    let bufView = new Uint8Array(arrayBuffer);
    let strLen = this.inputs.length;
    for (let k = 0; k < strLen; ++k) {
      bufView[k] = this.inputs.charCodeAt(k);
    }
    let parser = new xml.XmlPullParser(arrayBuffer)
    let arr = {}
    let i = 0

    function func(key, info) {
      arr[i] = `key:${key}, value:${info.getDepth()} ${info.getColumnNumber()} ` +
               `${info.getLineNumber()} ${info.getAttributeCount()} ${info.getName()} ` +
               `${info.getText()} ${info.isEmptyElementTag()} ${info.isWhitespace()}\n`
      i++
      return true
    }

    let options = { supportDoctype: true, ignoreNameSpace: true, tokenValueCallbackFunction: func }
    parser.parse(options)
    let str = ''
    for (let j = 0; j < i; ++j) {
      str = str + arr[j]
    }
    this.outputs = str
  }

  convertNode() {
    let convert = new convertXml.ConvertXML()
    let result = convert.convert(this.inputs, { compact: false, ignoreDeclaration: true })
    this.outputs = result
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center,
        wrap: FlexWrap.Wrap
      }) {
        ForEach(this.options, item => {
          Button() {
            Text(item)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .width('70%')
          }
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .padding(5)
          .margin({ top: 10 })
          .onClick(() => {
            let index = this.options.indexOf(item)
            switch (index) {
              case 0:
                this.serializerNode()
                break
              case 1:
                this.parserNode()
                break
              case 2:
                this.convertNode()
                break
              default:
                break
            }
          })
        }, item => JSON.stringify(item))
      }.width('100%')
    }.width('100%')
  }
}