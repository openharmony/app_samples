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
import dataRdb from '@ohos.data.rdb'
import router from '@system.router'
import { AddDialog } from '../common/AddDialog'
import { StudentView } from '../common/StudentView'
import { Student } from '../model/Student'
import { rdbModel } from '../model/RdbModel'
import { TABLE_NAME, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst'

const TAG = '[Rdb.Index]'

@Entry
@Component
struct Index {
  @State students: Array<Student> = []
  @State editStudent: Student = new Student(0, '', NaN, '')
  @State isInsert: boolean = false
  private index: number = -1
  private rdb = new rdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS)
  private addDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({ isInsert: this.isInsert, editStudent: this.editStudent, action: this.onAccept.bind(this) }),
    autoCancel: true
  })

  onAccept(isInsert:boolean, student:Student) {
    console.log(`${TAG}onAccept isInsert:${this.isInsert}, student:${JSON.stringify(student)}`)
    if (isInsert) {
      this.rdb.insertData(student, (id) => {
        student.id = id
        this.students.push(student)
      })
    } else {
      console.log(`${TAG}onAccept updateData, index:${this.index}`)
      this.rdb.updateData(student)
      let list = this.students
      this.students = []
      list[this.index] = student
      this.students = list
      this.index = -1
    }
  }

  deleteCallBack(student) {
    console.log(`${TAG}delete student id:${student.id}`)
    let index = this.students.indexOf(student)
    this.students.splice(index, 1)
    this.rdb.deleteByStudent(student)
  }

  aboutToAppear() {
    console.log(`${TAG}aboutToAppear`)
    this.rdb.getRdbStore(function(){
      console.log(`${TAG}getRdbStore finish`)
      let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
      this.rdb.query(predicates, function(result){
        console.log(`${TAG}queryAll finish`)
        this.students = result
      }.bind(this))
    }.bind(this))
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.title"))
          .width('90%')
          .fontColor(Color.White)
          .fontSize(25)
        Button() {
          Image($r('app.media.add'))
            .height('100%').width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .width('12%')
        .height('100%')
        .type(ButtonType.Normal)
        .backgroundColor('#0D9FFB')
        .align(Alignment.End)
        .onClick(() => {
          this.isInsert = true
          this.editStudent = new Student(0, '', NaN, '')
          this.addDialogController.open()
        })
      }
      .height('8%')
      .width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 15, right: 15 })
      .constraintSize({ minHeight: 50 })

      List() {
        ForEach(this.students, item => {
          ListItem() {
            StudentView({ student: item, deleteCallBack: this.deleteCallBack.bind(this) })
          }
          .onClick(() => {
            this.isInsert = false
            this.index = this.students.indexOf(item)
            this.editStudent = new Student(item.id, item.name, item.age, item.phone)
            this.addDialogController.open()
          })
        }, item => item.toString())
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })

      Row() {
        Image($r('app.media.search_gray'))
          .height(40).width('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.push({
              uri: 'pages/Search'
            })
          })
      }
      .width('100%').height('8%')
      .backgroundColor('#F0F0F0')
      .constraintSize({ minHeight: 50 })
    }
    .width('100%').height('100%')
  }
}