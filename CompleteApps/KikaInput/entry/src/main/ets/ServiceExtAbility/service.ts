import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import ams from '@ohos.application.AppManager'

var conn = -1;
let callBack = {
    onForegroundApplicationChanged: function (appStateData) {
        console.log('kikaInput: onForegroundApplicationChanged');
    },
    onAbilityStateChange: function (abilityStateData) {
        console.log('kikaInput: onAbilityStateChange');
    },
    onExtensionStateChanged: function (abilityStateData) {
        console.log('kikaInput: onExtensionStateChanged');
    },
    onProcessCreate: function (processData) {
        console.log('kikaInput: onProcessCreate');
    },
    onProcessDied: function (processData) {
        console.log('kikaInput: onProcessDied');
    }
}

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