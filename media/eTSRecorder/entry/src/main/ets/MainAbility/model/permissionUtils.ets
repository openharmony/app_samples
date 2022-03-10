import featureAbility from '@ohos.ability.featureAbility'

const PERMISSION_NAME: string = 'ohos.permission.MICROPHONE'
const TAG: string = '[Record.PermissionUtils]'
let requestCode = 3

export class PermissionUtils {
  async grantPermission() {
    console.info(`${TAG} grantPermission`)
    let context = featureAbility.getContext()
    let verifyCode = await context.verifyPermission(PERMISSION_NAME) // 检测权限，如果未授权返回-1
    console.info(`${TAG} verifyPermission,verifyCode = ${verifyCode}`)
    if (verifyCode == -1) {
      context.requestPermissionsFromUser([PERMISSION_NAME], requestCode, (err, result) => {
        console.info(`${TAG} requestPermissionsFromUser,err=${JSON.stringify(err)}`)
        console.info(`${TAG} requestPermissionsFromUser,result.requestCode=${result.requestCode}`)
      })
    }
  }
}