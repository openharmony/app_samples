apply plugin: 'com.huawei.ohos.hap'
ohos {
    compileSdkVersion 5
    defaultConfig {
        compatibleSdkVersion 4
    }
    buildTypes {
        release {
            proguardOpt {
                proguardEnabled false
                rulesFiles 'proguard-rules.pro'
            }
        }
    }
}

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar', '*.har'])
}
