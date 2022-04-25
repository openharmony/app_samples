import lock from '@ohos.runninglock';

@Component
export struct LockSwitch {

  private islock:boolean = false
  @Link output:Resource
  @Link isComTime:boolean

  build() {
    Row() {
      Text($r("app.string.sleepLockSwitch"))
        .fontSize(20)
        .fontColor('#0D9FFB')
        .width('30%')
        .margin({ left: '22%' })
        .fontWeight(FontWeight.Bold)
      Toggle({ type: ToggleType.Switch, isOn: this.islock })
        .width(70)
        .height(30)
        .margin({left:'20%',right:10})
        .onChange(()=>{
          this.islock = !(this.islock)
          lock.createRunningLock("running_lock_test", lock.RunningLockType.BACKGROUND)
            .then(lock=>{
              lock.isUsed()
              if (this.islock === true) {
                this.output = $r("app.string.stopSleep")
                this.isComTime = false
                lock.lock(1000);
              } else {
                lock.unlock()
                this.output = $r("app.string.turnSleep")
                this.isComTime = true
              }
            })
            .catch(error => {
              console.log('create runningLock test error: ' + error);
            })
        })
    }
    .width('100%')
    .height(50)
    .margin({ top: 10 })
  }
}