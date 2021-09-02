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
    batteryProperties() {
        router.push({
            uri: 'pages/batteryProperties/batteryProperties'
        })
    }
}