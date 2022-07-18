class GalleryFormConst {
  FORM_PARAM_IDENTITY_KEY: string = 'ohos.extra.param.key.form_identity' // 用于创建卡片ID的标识
  PERMISSIONS: Array<string> = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA']
  permissionState: number = 666 // 权限传递给返回结果的请求码
}

export default new GalleryFormConst()


