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

package ohos.samples.networkmanagement.utils;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Global thread pool
 */
public class ThreadPoolUtil {
    private static final int CORE_COUNT = 10;

    private static final int THREAD_COUNT = 20;

    private static final int WORK_QUEUE_SIZE = 50;

    private static final long KEEP_ALIVE = 10L;

    private static final AtomicInteger THREAD_ID = new AtomicInteger(1);

    private static  final ThreadPoolExecutor executor = new ThreadPoolExecutor(CORE_COUNT, THREAD_COUNT, KEEP_ALIVE,
        TimeUnit.SECONDS, new ArrayBlockingQueue<>(WORK_QUEUE_SIZE), new CommonThreadFactory());

    private ThreadPoolUtil() {
    }

    /**
     * Submit task to execute
     *
     * @param task runnable task
     */
    public static void submit(Runnable task) {
        executor.submit(task);
    }

    /**
     * ThreadFactory
     *
     */
    static class CommonThreadFactory implements ThreadFactory {
        @Override
        public Thread newThread(Runnable runnable) {
            String threadName;
            if (THREAD_ID.get() == Integer.MAX_VALUE) {
                threadName = "threadpool-common-" + THREAD_ID.getAndSet(1);
            } else {
                threadName = "threadpool-common-" + THREAD_ID.incrementAndGet();
            }
            return new Thread(runnable, threadName);
        }
    }
}

