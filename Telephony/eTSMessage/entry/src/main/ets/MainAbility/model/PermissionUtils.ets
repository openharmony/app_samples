import featureAbility from '@ohos.ability.featureAbility'
import bundle from '@ohos.bundle'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

const PERMISSION_NAME: string = 'ohos.permission.SEND_MESSAGES'
const TAG: string = '[Permission]'
let requestCode = 3

export async function grantPermission() {
  console.info(`${TAG} grantPermission`)
  let context = featureAbility.getContext()
  let bundleFlag = 0
  let tokenId = undefined
  let userId = 100
  let appInfo = await bundle.getApplicationInfo('ohos.samples.etsmessage', bundleFlag, userId)
  tokenId = appInfo.accessTokenId
  console.info(`${TAG} grantPermission,tokenId=${tokenId}`)
  let atManager = abilityAccessCtrl.createAtManager()
  let result = await atManager.verifyAccessToken(tokenId, PERMISSION_NAME)
  console.info(`${TAG} grantPermission,verifyPermission,result=${result}`)
  if (result == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
    context.requestPermissionsFromUser([PERMISSION_NAME], requestCode, function (result) {
      console.info(`${TAG} grantPermission,requestPermissionsFromUser,result.requestCode=${result.requestCode}`)
    })
  }
}