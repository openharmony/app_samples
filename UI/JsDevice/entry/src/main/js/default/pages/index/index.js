import router from '@ohos.router'

export default {
    deviceInfo() {
        router.push({
            url: 'pages/deviceInfo/deviceInfo'
        })
    },
    systemProperties() {
        router.push({
            url: 'pages/systemProperties/systemProperties'
        })
    },
    batteryInfo() {
        router.push({
            url: 'pages/batteryInfo/batteryInfo'
        })
    }
}