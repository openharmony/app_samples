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

package ohos.samples.audio.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;

/**
 * ShellUtils
 *
 * @since 2021-08-27
 */
public class ShellUtils {
    private static final String TAG = ShellUtils.class.getName();

    private static final int HEADER_SIZE = 44;

    private static final int SAMPLE_RATE = 44100;

    private static final int BUFFER_SIZE = 1024 * 4;

    private static final int CHANNEL = 2;

    private static final int BITS_PRE_SAMPLE = 16;

    private static final int BIT = 8;

    private static final short FORMAT_TAG = 0x0001;

    private ShellUtils() {
    }

    /**
     * tranPcmToWavFile
     *
     * @param pcmFile File
     * @param wavPath String
     */
    public static void tranPcmToWavFile(File pcmFile, String wavPath) {
        try {
            FileInputStream fis = new FileInputStream(pcmFile);
            FileOutputStream fos = new FileOutputStream(wavPath);
            int PCMSize = 0;
            byte[] buf = new byte[BUFFER_SIZE];
            int size = fis.read(buf);
            while (size != -1) {
                PCMSize += size;
                size = fis.read(buf);
            }
            fis.close();

            // 填入参数，比特率等等。这里用的是16位双声道 44100 hz
            WaveHeader header = new WaveHeader();

            // 长度字段 = 内容的大小（PCMSize) + 头部字段的大小(不包括前面4字节的标识符RIFF以及fileLength本身的4字节)
            header.fileLength = PCMSize + (HEADER_SIZE - BIT);
            header.FmtHdrLeth = BITS_PRE_SAMPLE;
            header.BitsPerSample = BITS_PRE_SAMPLE;
            header.Channels = CHANNEL;
            header.FormatTag = FORMAT_TAG;
            header.SamplesPerSec = SAMPLE_RATE;
            header.BlockAlign = (short) (header.Channels * header.BitsPerSample / BIT);
            header.AvgBytesPerSec = header.BlockAlign * header.SamplesPerSec;
            header.DataHdrLeth = PCMSize;
            byte[] h = header.getHeader();
            assert h.length == HEADER_SIZE; // WAV标准，头部应该是44字节
            fos.write(h, 0, h.length); // write header

            // write data stream
            FileInputStream file = new FileInputStream(pcmFile);
            size = file.read(buf);
            while (size != -1) {
                fos.write(buf, 0, size);
                size = file.read(buf);
            }
            file.close();
            fos.close();
            Files.deleteIfExists(pcmFile.toPath());
        } catch (IOException e) {
            HiLogUtils.error(TAG, e.getMessage());
        }
    }
}
