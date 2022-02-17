import router from '@system.router'

export default {
    deviceInfo() {
        router.push({
            uri: 'pages/deviceInfo/deviceInfo'
        })
    },
    systemProperties() {
        router.push({
            uri: 'pages/systemProperties/systemProperties'
        })
    },
    batteryInfo() {
        router.push({
            uri: 'pages/batteryInfo/batteryInfo'
        })
    }
}