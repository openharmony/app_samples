import Ability from '@ohos.application.Ability'

import {Core, ExpectExtend, InstrumentLog} from 'deccjsunit/index'
import testsuite from '../test/List.test'

export default class TestAbility extends Ability {
    onCreate(want, launchParam) {
        console.log("TestAbility onCreate")
        console.info("start run testcase!!!!")
        console.info('onShow finish')
        const core = Core.getInstance()
        const expectExtend = new ExpectExtend({
            id: 'extend'
        })
        const instrumentLog = new InstrumentLog({
            id: 'report', unity: 'true'
        })
        core.addService('expect', expectExtend)
        core.addService('report', instrumentLog)
        core.init()
        core.subscribeEvent('spec', instrumentLog)
        core.subscribeEvent('suite', instrumentLog)
        core.subscribeEvent('task', instrumentLog)
        const configService = core.getDefaultService('config')
        configService.setConfig(this)
        testsuite()
        console.info("testsuite()")
        core.execute()
        console.info("core.execute()")
    }

    onDestroy() {
        console.log("TestAbility onDestroy")
    }

    onWindowStageCreate(windowStage) {
        console.log("TestAbility onWindowStageCreate")
        windowStage.setUIContent(this.context, "TestAbility/pages/index", null)
        globalThis.abilityContext = this.context;
    }

    onWindowStageDestroy() {
        console.log("TestAbility onWindowStageDestroy")
    }

    onForeground() {
        console.log("TestAbility onForeground")
    }

    onBackground() {
        console.log("TestAbility onBackground")
    }
};