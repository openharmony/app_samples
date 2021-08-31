package ohos.samples.audio.utils;

import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.Objects;

/**
 * HiLogUtils
 *
 * @since 2021-08-27
 */
public class HiLogUtils {
    private static final String APP_NAME = "Audio";
    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, APP_NAME);
    public static final String LOG_FORMAT = "%{public}s:%{public}s";

    private HiLogUtils() {
    }

    public static void info(String className, String msg) {
        HiLog.info(LABEL_LOG, LOG_FORMAT, getLogPrefix(className), msg);
    }

    public static void error(String className, String msg) {
        HiLog.error(LABEL_LOG, LOG_FORMAT, getLogPrefix(className), msg);
    }

    private static String getLogPrefix(String tag) {
        Thread currentThread = Thread.currentThread();
        String threadName = currentThread.getName();
        StackTraceElement[] stackTraceElements = currentThread.getStackTrace();
        int lineNum = 0;
        for (int index = 0; index < stackTraceElements.length; index++) {
            if (Objects.equals(stackTraceElements[index].getClassName(), HiLogUtils.class.getName())
                    && stackTraceElements.length > index + 1
                    && !Objects.equals(stackTraceElements[index + 1].getClassName(), HiLogUtils.class.getName())) {
                lineNum = stackTraceElements[index + 1].getLineNumber();
            }
        }
        return "[" + threadName + "]" + "(" + tag + ".java" + lineNum + ")";
    }
}
