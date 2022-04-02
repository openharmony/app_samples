import ServiceExtension from '@ohos.application.ServiceExtensionAbility'

class ServiceExtAbility extends ServiceExtension {
    onCreate(want) {
        console.info('onCreate want: ' + want.abilityName);
    }

    onRequest(want, startId) {
        console.info('onRequest want: ' + want.abilityName + ',startId: ' + startId);
    }

    onConnect(want) {
        console.info('onConnect want: ' + want.abilityName);
        return null;
    }

    onDisconnect(want) {
        console.info('onDisconnect want: ' + want.abilityName);
    }

    onDestroy() {
        console.info('onDestroy');
    }
}

export default ServiceExtAbility