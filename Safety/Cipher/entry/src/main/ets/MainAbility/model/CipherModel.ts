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

import cipher from '@system.cipher'
import Logger from './Logger'

const TAG: string = '[CipherModel]'
const AES_ENCRYPT_KEY: string = 'NDM5Qjk2UjAzMEE0NzVCRjlFMkQwQkVGOFc1NkM1QkQ='
const RSA_ENCRYPT_KEY: string = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDc7GR2MrfAoefES+wrs1ns2afT\n' +
'eJXSfIkEHfPXG9fVFjaws1ho4KcZfsxlA0+SXvc83f2SVGCuzULmM2lxxRCtcUN/\n' +
'h7SoaYEeluhqFimL2AEjfSwINHCLqObJkcjCfoZpE1JCehPiDOJsyT50Auc08h/4\n' +
'jHQfanyC1nc62LqUCQIDAQAB'
const RSA_DECRYPT_KEY: string = 'MIICXgIBAAKBgQCx414QSP3RsYWYzf9mkBMiBAXo6S7Lpva1fKlcuVxjoFC1iMnz\n' +
'D4mC0uiL4k5MNi43J64c7dbqi3qAJjdAtuwQ6NZJ+Enz0RzmVFh/4yk6lmqRzuEF\n' +
'QqhQqSZzaLq6sq2N2G0Sv2Xl3sLvqAfe2HNm2oBwjBpApTJ3TeneOo6Z5QIDAQAB\n' +
'AoGBAKPNtoRQcklxqo+2wQP0j2m3Qqnib1DggjVEgb/8f/LNYQSI3U2QdROemryU\n' +
'u3y6N3xacZ359PktTrRKfH5+8ohmHGhIuPAnefp6bLvAFUcl4t1xm74Cow62Kyw3\n' +
'aSbmuTG98dxPA1sXD0jiprdtsq2wQ9CoKNyY7/d/pKoqxNuBAkEA4GytZ60NCTj9\n' +
'w24jACFeko5YqCFY/TTLoc4SQvWtFMnimRPclLZhtUIK0P8dib71UFedx+AxklgL\n' +
'A5gjcfo+2QJBAMrqiwyCh3OQ5DhyRPDwt87x1/jg5fy4hhete2ufSf2FoQCVqO+w\n' +
'PKoljdXmJeS6rGgzGibstuHLrP3tcIho4+0CQD3ZFWzF/xq0jxKlrpWhnJuNCRfE\n' +
'oO6e9yNvVA8J/5oEDSOcmqSNIp4+RhbUx8InUxnCG6Ryv5aSFu71pYcKrPkCQQCL\n' +
'RUGcm3ZGTnslduB0knNF+V2ndwzDUQ7P74UXT+PjurTPhujFYiuxCEd6ORVnEOzG\n' +
'M9TORIgdH8MjIbWsGnndAkEAw9yURDaorE8IYPLF2IEn09g1uzvWPs3phDb6smVx\n' +
'8GfqIdUNf+aCG5TZK/kXBF1sqcsi7jXMAf4jBlejVbSVZg=='

export class CipherModel {
  rsaEncrypt(message: string, callback) {
    let result: Object | string = undefined
    cipher.rsa({
      // 加密
      action: 'encrypt',
      // 待加密的文本内容
      text: message,
      // base64编码后的加密公钥
      key: RSA_ENCRYPT_KEY,
      transformation: 'RSA/None/OAEPWithSHA256AndMGF1Padding',
      success: (info) => {
        result = info
        Logger.info(TAG, `result = ${JSON.stringify(result)}`)
        callback(result)
      },
      fail: (data, code) => {
        result = 'Error!'
        Logger.info(TAG, `cipher.rsa encrypt fail ${JSON.stringify(code)}: ${JSON.stringify(data)}`)
        callback(result)
      },
      complete: () => {
        Logger.info(TAG, `encrypt is success`)
      }
    })
  }

  rsaDecrypt(message: string, callback) {
    let result: Object | string = undefined
    cipher.rsa({
      // 解密：
      action: 'decrypt',
      // 待解密的内容
      text: message,
      // base64编码后的解密私钥
      key: RSA_DECRYPT_KEY,
      success: (info) => {
        result = info
        Logger.info(TAG, `result = ${JSON.stringify(result)}`)
        callback(result)
      },
      fail: (data, code) => {
        result = 'Error!'
        Logger.info(TAG, `cipher.rsa decrypt fail ${JSON.stringify(code)}: ${JSON.stringify(data)}`)
        callback(result)
      },
      complete: () => {
        Logger.info(TAG, `encrypt is success`)
      }
    })
  }

  aesEncrypt(message: string, callback) {
    let result: Object | string = undefined
    cipher.aes({
      // 加密
      action: 'encrypt',
      // 待加密的文本内容
      text: message,
      // base64编码后的密钥
      key: AES_ENCRYPT_KEY,
      transformation: 'AES/CBC/PKCS5Padding',
      ivOffset: 0,
      ivLen: 16,
      success: (info) => {
        result = info
        Logger.info(TAG, `result = ${JSON.stringify(result)}`)
        callback(result)
      },
      fail: (data, code) => {
        result = 'Error!'
        Logger.info(TAG, `cipher.aes encrypt fail ${JSON.stringify(code)}: ${JSON.stringify(data)}`)
        callback(result)
      },
      complete: () => {
        Logger.info(TAG, `encrypt is success`)
      }
    })
  }

  aesDecrypt(message: string, callback) {
    let result: Object | string = undefined
    cipher.aes({
      // 解密：
      action: 'decrypt',
      // 待解密的内容，是base64编码后的一段二进制值
      text: message,
      // base64编码后的密钥
      key: AES_ENCRYPT_KEY,
      transformation: 'AES/CBC/PKCS5Padding',
      ivOffset: 0,
      ivLen: 16,
      success: (info) => {
        result = info
        Logger.info(TAG, `data = ${JSON.stringify(result)}`)
        callback(result)
      },
      fail: (data, code) => {
        result = 'Error!'
        Logger.info(TAG, `cipher.aes encrypt fail ${JSON.stringify(code)}: ${JSON.stringify(data)}`)
        callback(result)
      },
      complete: () => {
        Logger.info(TAG, `encrypt is success`)
      }
    })
  }
}