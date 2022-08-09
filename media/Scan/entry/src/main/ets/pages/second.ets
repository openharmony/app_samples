import {ScanPage} from "@ohos/scan-component"

@Entry
@Component
struct Second {
  @State message: string = 'Hello World'

  build() {
    Column(){
      ScanPage()
    }

  }
}