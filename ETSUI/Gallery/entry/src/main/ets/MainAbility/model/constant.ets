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

import { FirstNavInfo } from './listItem'

export const FIRST_NAV_LIST = [
  new FirstNavInfo('通用事件', "", 7),
  new FirstNavInfo('通用属性', "", 4),
  new FirstNavInfo('手势处理', "", 6),
  new FirstNavInfo('基础组件', "", 0),
  new FirstNavInfo('容器组件', "", 1),
  new FirstNavInfo("媒体组件", "", 10),
  new FirstNavInfo('绘制组件', "", 3),
  new FirstNavInfo('画布组件', "", 8),
  new FirstNavInfo('动画', "", 2),
  new FirstNavInfo('UI状态管理', "", 5),
  new FirstNavInfo('渲染控制语法', "", 9),
  new FirstNavInfo('杂项', "", -1),
]

const BASIC = [
  { title: 'Blank', uri: "pages/basicComponent/blank/blank" },
  { title: 'Button', uri: "pages/basicComponent/button/button" },
  { title: 'CheckBoxGroup', uri: "pages/basicComponent/checkBoxGroup/checkBoxGroup" },
  { title: 'DataPanel', uri: "pages/basicComponent/dataPanel/dataPanel" },
  { title: 'Divider', uri: "pages/basicComponent/divider/divider" },
  { title: 'Gauge', uri: "pages/basicComponent/gauge/gauge" },
  { title: 'Image', uri: "pages/basicComponent/image/image" },
  { title: 'ImageAnimator', uri: "pages/basicComponent/imageAnimator/imageAnimator" },
  { title: 'Marquee', uri: "pages/basicComponent/marquee/marquee" },
  { title: 'Progress', uri: "pages/basicComponent/progress/progress" },
  { title: 'QRCode', uri: "pages/basicComponent/qrcode/qrcode" },
  { title: 'Radio', uri: "pages/basicComponent/radio/radio" },
  { title: 'Rating', uri: "pages/basicComponent/rating/rating" },
  { title: 'Span', uri: "pages/basicComponent/text/textSpan" },
  { title: 'Slider', uri: "pages/basicComponent/slider/slider" },
  { title: 'Text', uri: "pages/basicComponent/text/text" },
  { title: 'TextArea', uri: "pages/basicComponent/textArea/textArea" },
  { title: 'TextInput', uri: "pages/basicComponent/textInput/textInput" },
  { title: 'Toggle', uri: "pages/basicComponent/toggle/toggle" },
  { title: 'LoadingProgress', uri: "pages/basicComponent/loadingProgress/loadingProgress" },
  { title: 'textClock', uri: "pages/basicComponent/textClock/textClock" },
  { title: 'textTimer', uri: "pages/basicComponent/textTimer/textTimer" },
  { title: 'textPicker', uri: "pages/basicComponent/textPicker/textPicker" },
]

const CONTAINER = [
  { title: 'AlphabetIndexer', uri: "pages/containerComponent/alphabetIndexer/alphabetIndexer" },
  { title: 'Badge', uri: "pages/containerComponent/badge/badge" },
  { title: 'Column', uri: "pages/containerComponent/column/column" },
  { title: 'ColumnSplit', uri: "pages/containerComponent/columnSplit/columnSplit" },
  { title: 'Counter', uri: "pages/containerComponent/counter/counter", },
  { title: 'Flex', uri: "pages/containerComponent/flex/flex" },
  { title: 'GridContainer', uri: "pages/containerComponent/gridContainer/gridContainer" },
  { title: 'GridComputed', uri: "pages/containerComponent/gridComputed/gridComputed" },
  { title: 'List', uri: "pages/containerComponent/list/list" },
  { title: 'Navigator', uri: "pages/containerComponent/navigator/navigator" },
  { title: 'Panel', uri: "pages/containerComponent/panel/panel" },
  { title: 'Row', uri: "pages/containerComponent/row/row" },
  { title: 'RowSplit', uri: "pages/containerComponent/rowSplit/rowSplit" },
  { title: 'Stepper', uri: "pages/containerComponent/stepper/stepper" },
  { title: 'Scroll', uri: "pages/containerComponent/scroll/scroll" },
  { title: 'ScrollBar', uri: "pages/containerComponent/scrollBar/scrollBar" },
  { title: 'SideBarContainer', uri: "pages/containerComponent/sideBarContainer/sideBarContainer" },
  { title: 'Stack', uri: "pages/containerComponent/stack/stack" },
  { title: 'Swiper', uri: "pages/containerComponent/swiper/swiper" },
  { title: 'Tabs&TabContent', uri: "pages/containerComponent/tabs/tabs" },
  { title: 'Navigation', uri: "pages/containerComponent/navigation/navigation" },
  { title: '容器组件模板', uri: "pages/containerComponent/template/containerComponentTemplate" },
]

const ANIMATION = [
  { title: '属性动画', uri: "pages/animation/attrAnimation/attrAnimation" },
  { title: '显式动画', uri: "pages/animation/showAnimation/showAnimation" },
  { title: '页面间转场', uri: "pages/animation/traAnimation/traAnimationFrom" },
  { title: '组件内转场', uri: "pages/animation/componentTransition/componentTransition" },
  { title: '共享元素转场', uri: "pages/animation/shareElementTransition/shareElementTransitionFrom" },
  { title: '路径动画', uri: "pages/animation/pathAnimation/pathAnimation" },
  { title: '矩阵变换', uri: "pages/animation/matrixTransition/matrixTransition" },
  { title: '插值计算', uri: "pages/animation/interpolation/interpolation" },
]

const DRAW = [
  { title: '绘制组件', uri: "pages/drawComponent/circlePath/circlePath" }
]
const MEDIA = [
  { title: 'video', uri: "pages/media/video/video" },
  { title: 'web', uri: "pages/media/web/browser" }
]
const COMMON_PROPERTIES = [
  { title: '尺寸设置', uri: "pages/commonProperties/layoutWeight/layoutWeight" },
  { title: '位置设置', uri: "pages/commonProperties/position/position" },
  { title: '边框设置', uri: "pages/commonProperties/border/border" },
  { title: '背景设置', uri: "pages/commonProperties/background/background" },
  { title: '颜色渐变', uri: "pages/commonProperties/colorGradient/colorGradient" },
  { title: '盒模型', uri: "pages/commonProperties/boxModel/boxModel" },
  { title: '浮层', uri: "pages/commonProperties/overlay/overlay" },
  { title: '图形变换', uri: "pages/commonProperties/transform/transform" },
  { title: '形状裁剪', uri: "pages/commonProperties/shapeClip/shapeClip" },
  { title: 'Popup控制', uri: "pages/commonProperties/popup/popup" },
  { title: 'Dialog', uri: "pages/commonProperties/dialog/dialog" },
  { title: '焦点控制', uri: "pages/commonProperties/focus/focus" },
  { title: '菜单', uri: "pages/commonProperties/menu/menu" }
]

const UI_STATE_MANAGEMENT = [
  { title: '@State&@Link&@Prop', uri: "pages/uiStateManagement/management/index" },
  { title: '@Observed&@ObjectLink', uri: "pages/uiStateManagement/categoriesManagement/application" },
  { title: 'AppStorage', uri: "pages/uiStateManagement/management/appStorage" },
]
const GESTURE = [
  { title: '基础手势', uri: "pages/gesture/basicGesture" },
  { title: 'SwipeGesture', uri: "pages/gesture/swipeGesture" },
  { title: '绑定手势方法', uri: "pages/gesture/gestureMethod" },
]
const GENERAL_EVENT = [
  { title: '点击事件', uri: "pages/generalEvent/clickEvent" },
  { title: '点击事件', uri: "pages/generalEvent/clickBall" },
  { title: '触摸事件', uri: "pages/generalEvent/touchEvent"},
  { title: '触摸事件', uri: "pages/generalEvent/gestureLock"},
  { title: '挂载卸载事件', uri: "pages/generalEvent/appearEvent"},
  { title: '拖拽事件', uri: "pages/generalEvent/dragEvent"},
  { title: '按键事件', uri: "pages/generalEvent/keyEvent"},
  { title: '按键事件', uri: "pages/generalEvent/keybordEvent"},
  { title: '鼠标事件', uri: "pages/generalEvent/mouseEvent"}
]
const CANVAS = [
  { title: 'Canvas', uri: "pages/canvasComponent/canvas" }
]

const RENDER_CONTROL_SYNTAX=[
  { title: '条件渲染', uri: "pages/renderControlSyntax/conditionalRendering/conditionalRendering" },
  { title: '循环渲染', uri: "pages/renderControlSyntax/conditionsLoops/conditionsLoops" },
  { title: '数据懒加载', uri: "pages/renderControlSyntax/lazyForEach/lazyForEach" },
]

export const SECOND_NAV_LIST = [BASIC, CONTAINER, ANIMATION, DRAW, COMMON_PROPERTIES, UI_STATE_MANAGEMENT,GESTURE,GENERAL_EVENT,CANVAS,RENDER_CONTROL_SYNTAX,MEDIA]
