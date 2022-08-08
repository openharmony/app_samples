{
  "module": {
    "name": "${moduleName}_test",
    "type": "feature",
    "srcEntrance": "./ets/Application/AbilityStage.ts",
    "description": "$string:entry_test_desc",
    "mainElement": "TestAbility",
    "deviceTypes": [${deviceTypes ?replace("[","")?replace("]","")}],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:test_pages",
    "uiSyntax": "ets",
    "abilities": [
      {
        "name": "TestAbility",
        "srcEntrance": "./ets/TestAbility/TestAbility.ts",
        "description": "$string:TestAbility_desc",
        "icon": "$media:icon",
        "label": "$string:TestAbility_label",
        "visible": true,
        "skills": [
          {
            "actions": [
              "action.system.home"
            ],
            "entities": [
              "entity.system.home"
            ]
          }
        ]
      }
    ]
  }
}
