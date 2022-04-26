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
import featureAbility from '@ohos.ability.featureAbility'
import router from '@ohos.router'
import Contact from '../model/Contact'
import LiteStore from '../model/LiteStore'
import Logger from '../model/Logger'
import RdbModel from '../model/RdbModel'
import { BottomBtn } from '../common/BottomBtn'
import { ContactItem } from '../common/ContactItem'
import { PopupMenu } from '../common/PopupMenu'
import { SyncState } from '../model/LiteStore'
import { SearchBar } from '../common/SearchBar'
import { TitleBar } from '../common/TitleBar'
import { TABLE_NAME, BUNDLE, ABILITY } from '../model/RdbConst'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private intervalId: number = undefined
  @State contacts: Array<Contact> = []
  @State isMultiCheck: boolean = false
  @State isSelectedAll: boolean = false
  @State state: {
    popupMenu: boolean,
    isDistributed: boolean,
    isFA: boolean,
    selectedIndex: number,
    syncState: string,
    distributedDevice: string
  } = {
    popupMenu: false,
    isDistributed: false,
    isFA: false,
    selectedIndex: 0,
    syncState: SyncState.ManualSync,
    distributedDevice: ''
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    featureAbility.getContext()
      .requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 3, () => {
        Logger.info(TAG, 'grantPermission,requestPermissionsFromUser')
      })
  }

  getWant() {
    featureAbility.getWant((error, want) => {
      Logger.info(TAG, `featureAbility.getWant = ${JSON.stringify(want.parameters)}`)
      if (this.state.isDistributed && want.parameters.isFA === 'EXIT') {
        Logger.info(TAG, 'isFA = EXIT')
        this.state.isFA = false
        this.state.isDistributed = false
        this.state.selectedIndex = 0
        this.state.distributedDevice = ''
        RdbModel.offDataChange()
      }
      if (!this.state.isDistributed && want.parameters.isFA === 'FA') {
        Logger.info(TAG, 'isFA = FA')
        this.state.isFA = true
        this.state.isDistributed = true
        this.state.distributedDevice = want.parameters.device
        featureAbility.startAbility({
          want: {
            bundleName: BUNDLE,
            abilityName: ABILITY,
            deviceId: this.state.distributedDevice,
            parameters: {
              isFA: 'CONNECT'
            }
          }
        })
        Logger.info(TAG, 'onDataChange')
        RdbModel.onDataChange(this.state.distributedDevice, (result) => {
          this.contacts = result
        })
      }
    })
  }

  onPageShow() {
    this.refreshViewState()
  }

  async refreshViewState() {
    await RdbModel.getRdbStore()
    this.intervalId = setInterval(() => {
      this.getWant()
    }, 1000)
    await this.getData()
  }

  getData = async () => {
    Logger.info(TAG, 'getData')
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    this.contacts = await RdbModel.query(predicates)
    let syncState = await LiteStore.getValue()
    this.state.syncState = `${syncState}`
    if (!this.state.isFA && this.state.isDistributed && syncState === SyncState.AutomaticSync) {
      await this.syncData()
    }
  }

  showDeleteDialog() {
    let deleteContacts = []
    this.contacts.forEach((contact) => {
      if (contact.isSelected) {
        deleteContacts.push(contact)
      }
    })
    if (deleteContacts.length == 0) {
      return
    }
    AlertDialog.show({
      message: $r('app.string.delete_contact'),
      primaryButton: {
        value: $r('app.string.sure'),
        fontColor: Color.Red,
        action: async () => {
          await RdbModel.deleteContacts(deleteContacts)
          await this.getData()
          this.quitMultiCheck()
        }
      },
      secondaryButton: {
        value: $r('app.string.cancel'),
        fontColor: Color.Blue,
        action: () => {
        }
      }
    })
  }

  handleClickContact(item, index) {
    Logger.info(TAG, `handleClickContact, item = ${JSON.stringify(item)}`)
    if (this.isMultiCheck) {
      let tempContacts = this.contacts
      this.contacts = []
      tempContacts[index].isSelected = !item.isSelected
      this.contacts = tempContacts
      Logger.info(TAG, `item.isSelected = ${this.contacts[index].isSelected}`)
    } else {
      router.push({
        url: 'pages/ContactEdit',
        params: { contact: item, isInsert: false }
      })
    }
  }

  refreshSelectState(isSelect) {
    this.contacts.forEach((contact) => {
      contact.isSelected = isSelect
    })
  }

  quitMultiCheck() {
    this.isSelectedAll = false
    this.refreshSelectState(this.isSelectedAll)
    this.isMultiCheck = false
  }

  handleBottomBtnClick= (index) => {
    switch (index) {
      case 0:
        this.isSelectedAll = !this.isSelectedAll
        this.refreshSelectState(this.isSelectedAll)
        break
      case 1:
        this.showDeleteDialog()
        break
      case 2:
        this.quitMultiCheck()
        break
      default:
        break
    }
  }
  handleRightBtn = () => {
    this.state.popupMenu = !this.state.popupMenu
  }
  syncData = () => {
    Logger.info(TAG, 'sync data')
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.inAllDevices()
    RdbModel.syncData(predicates)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        Stack() {
          if (this.state.isFA) {
            TitleBar()
          } else {
            TitleBar({ rightBtn: $r('app.media.more'), handleRightBtn: this.handleRightBtn })
          }
          if (this.state.isDistributed && !this.state.isFA && this.state.syncState === SyncState.ManualSync) {
            Row() {
              Blank()
              Image($r('app.media.ic_syncto'))
                .size({ width: 50, height: 60 })
                .onClick(this.syncData)
            }.width('80%')
          }
        }.width('100%')

        Column() {
          SearchBar()
          List() {
            ForEach(this.contacts, (item, index) => {
              ListItem() {
                ContactItem({ contact: item, isMultiCheck: $isMultiCheck })
              }
              .onClick(() => {
                this.handleClickContact(item, index)
              })
            }, item => item.name)
          }
          .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
        }
        .padding({ left: 10, right: 10 })
      }
      .width('100%')
      .height('100%')

      if (this.state.popupMenu) {
        PopupMenu({ state: $state, handleStartAbility: this.syncData })
      }

      BottomBtn({
        isMultiCheck: this.isMultiCheck,
        isSelectedAll: this.isSelectedAll,
        handleBottomBtnClick: this.handleBottomBtnClick
      })

      if (!this.isMultiCheck && !this.state.isFA) {
        Button() {
          Image($r('app.media.add'))
            .height('100%').width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .size({ width: '15%', height: 80 })
        .margin({ right: 20, bottom: 50 })
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          Logger.info(TAG, 'onClick')
          router.push({
            url: 'pages/ContactEdit',
            params: { contact: new Contact(0, '', 0, '', ''), isInsert: true }
          })
        })
      }
    }
    .size({ width: '100%', height: '100%' })
  }

  async onBackPress() {
    Logger.info(TAG, 'onBackPress')
    await featureAbility.startAbility({
      want: {
        bundleName: BUNDLE,
        abilityName: ABILITY,
        deviceId: this.state.distributedDevice,
        parameters: {
          isFA: 'EXIT'
        }
      }
    })
    RdbModel.offDataChange()
  }

  onPageHide() {
    Logger.info(TAG, 'onBackPress')
    clearInterval(this.intervalId)
  }
}