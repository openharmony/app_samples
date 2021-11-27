/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import prompt from '@system.prompt';
import router from '@system.router';

export default {
  data: {
    autoplay: false, // 是否自动播放
    url: '/common/video/1.mp4', // 视频地址
    controlShow: true, // 是否显示控制栏
    loop: true, // 是否循环播放
    startTime: 2, // 播放开始时间
    speed: 0.3, // 播放速度
    isStart:false
  },
  // 视频准备完成时触发该事件
  prepared(e) {
    this.showPrompt(this.$t('strings.video_duration') + e.duration + this.$t('strings.second'));
  },
  // 视频开始播放
  start() {
    this.showPrompt(this.$t('strings.video_start'));
    this.isStart = true
  },
  // 视频暂停播放
  pause() {
    this.showPrompt(this.$t('strings.video_pause'));
    this.isStart = false
  },
  // 视频播放完成
  finish() {
    this.$element('confirmDialog').show();
  },
  // 拖动进度条调用
  seeked(e) {
    this.showPrompt(this.$t('strings.video_seeked') + e.currenttime + this.$t('strings.second'));
  },
  // 播放进度变化调用
  timeupdate(e) {
  },
  // dialog确定
  confirm() {
    this.$element('video').start();
    this.$element('confirmDialog').close();
  },
  // dialog取消
  cancel() {
    this.$element('confirmDialog').close();
  },
  // 弹框
  showPrompt(msg) {
    prompt.showToast({
      message: msg,
      duration: 1000
    });
  },
  // 点击视频
  onClick() {
    if(this.isStart) {
      this.$element('video').pause()
      this.isStart = false
    }else {
      this.$element('video').start();
      this.isStart = true
    }
  },
  // 长按视频
  longPress(){
    router.replace({uri:'pages/index/index'})
  }
};
