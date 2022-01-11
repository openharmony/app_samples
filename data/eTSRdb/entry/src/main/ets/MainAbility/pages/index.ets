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
import dataRdb from '@ohos.data.rdb'
import router from '@system.router';
import {AddDialog} from '../common/dialog'
import {StudentView} from '../common/studentView'
import {Student} from '../model/student'
import {rdbModel} from '../model/rdbModel'

let self = null
const TABLE_NAME = 'student'

@Entry
@Component
struct Index {
  @State students: Array<Student> = []
  @State editStudent: Student = new Student(0, '', NaN, '')
  @State isInsert: boolean = false
  private index: number = -1
  private rdb = new rdbModel()
  private addDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({ isInsert: this.isInsert, editStudent: this.editStudent, action: this.onAccept }),
    autoCancel: true
  })

  onAccept(isInsert:boolean, student:Student) {
    console.log('[Rdb.index] onAccept isInsert= ' + isInsert + ',student=' + JSON.stringify(student))
    if (isInsert) {
      self.rdb.insertData(student, (id) => {
        student.id = id
        self.students.push(student)
      })
    } else {
      console.log('[Rdb.index] onAccept updateData, index=' + self.index)
      self.rdb.updateData(student)
      let list = self.students
      self.students = []
      list[self.index] = student
      self.students = list
      self.index = -1
    }
  }

  deleteCallBack(student) {
    console.info('[Rdb.index]delete student id=' + student.id)
    let index = self.students.indexOf(student)
    self.students.splice(index, 1)
    self.rdb.deleteByStudent(student)
  }

  aboutToAppear() {
    console.log('[Rdb.index] aboutToAppear')
    self = this
    this.rdb.getRdbStore(() => {
      console.log('[Rdb.index]getRdbStore finish')
      let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
      self.rdb.query(predicates, (result) => {
        console.log('[Rdb.index] queryAll finish')
        self.students = result
      })
    })
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.title"))
          .width('90%')
          .fontColor(Color.White)
          .fontSize(20)
        Button() {
          Image($r('app.media.add'))
            .height(45).width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .width('10%')
        .type(ButtonType.Normal)
        .backgroundColor('#0D9FFB')
        .align(Alignment.End)
        .onClick(() => {
          this.isInsert = true
          this.editStudent = new Student(0, '', NaN, '')
          this.addDialogController.open()
        })
      }
      .height(50).width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 15, right: 15 })

      List() {
        ForEach(this.students, item => {
          ListItem() {
            StudentView({ student: item, deleteCallBack: this.deleteCallBack })
          }
          .onClick(() => {
            this.isInsert = false
            this.index = this.students.indexOf(item)
            this.editStudent = item
            this.addDialogController.open()
          })
        }, item => item.toString())
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })

      Column() {
        Image($r('app.media.search_gray'))
          .height(40).width(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.push({
              uri: 'pages/search'
            })
          })
      }
      .width('100%').height(50)
      .backgroundColor('#F0F0F0')
    }
    .width('100%').height('100%')
  }
}