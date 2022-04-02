import nativerender from "libnativerender.so";
import { ContextType } from "./common/Constants"

const nativeAppLifecycle = nativerender.getContext(ContextType.APP_LIFECYCLE);

export default {
  onCreate() {
    console.info('[LIFECYCLE-App] onCreate')
    nativeAppLifecycle.onCreate();
  },
  onShow() {
    console.info('[LIFECYCLE-App] onShow')
    nativeAppLifecycle.onShow();
  },
  onHide() {
    console.info('[LIFECYCLE-App] onHide')
    nativeAppLifecycle.onHide();
  },
  onDestroy() {
    console.info('[LIFECYCLE-App] onDestroy')
    nativeAppLifecycle.onDestroy();
  },
}