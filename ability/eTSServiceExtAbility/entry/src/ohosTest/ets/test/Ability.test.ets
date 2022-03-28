import {describe, beforeAll, beforeEach, afterEach, afterAll, it, expect} from 'deccjsunit/index'

export default function abilityTest() {
    console.info("abilityTest -- begin")
    describe('ActsAbilityTest', function () {
        console.info("describe -- begin")
        it('String_assertContain_success',0, function () {
            console.info("it begin")
            let a = 'abc'
            let b = 'b'
            expect(a).assertContain(b)
            expect(a).assertEqual(a)
        })
    })
}