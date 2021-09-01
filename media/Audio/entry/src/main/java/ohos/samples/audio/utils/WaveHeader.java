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

import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * WaveHeader
 *
 * @since 2021-08-27
 */
public class WaveHeader {
    private static final int BITS_PRE_SAMPLE = 16;

    private static final short BYTE_BIT = 24;

    private static final short SHORT_SIZE = 2;

    private static final short INT_SIZE = 4;

    private static final int BIT = 8;

    public final char[] fileID = {'R', 'I', 'F', 'F'};
    public int fileLength;
    public char[] wavTag = {'W', 'A', 'V', 'E'};
    public char[] FmtHdrID = {'f', 'm', 't', ' '};
    public int FmtHdrLeth;
    public short FormatTag;
    public short Channels;
    public int SamplesPerSec;
    public int AvgBytesPerSec;
    public short BlockAlign;
    public short BitsPerSample;
    public char[] DataHdrID = {'d', 'a', 't', 'a'};
    public int DataHdrLeth;

    public byte[] getHeader() throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        writeChar(bos, fileID);
        writeInt(bos, fileLength);
        writeChar(bos, wavTag);
        writeChar(bos, FmtHdrID);
        writeInt(bos, FmtHdrLeth);
        writeShort(bos, FormatTag);
        writeShort(bos, Channels);
        writeInt(bos, SamplesPerSec);
        writeInt(bos, AvgBytesPerSec);
        writeShort(bos, BlockAlign);
        writeShort(bos, BitsPerSample);
        writeChar(bos, DataHdrID);
        writeInt(bos, DataHdrLeth);
        bos.flush();
        byte[] r = bos.toByteArray();
        bos.close();
        return r;
    }

    private void writeShort(ByteArrayOutputStream bos, int s) throws IOException {
        // write short
        byte[] mybyte = new byte[SHORT_SIZE];
        mybyte[1] = (byte) ((s << BITS_PRE_SAMPLE) >> BYTE_BIT);
        mybyte[0] = (byte) ((s << BYTE_BIT) >> BYTE_BIT);
        bos.write(mybyte);
    }


    private void writeInt(ByteArrayOutputStream bos, int n) throws IOException {
        // write int
        byte[] buf = new byte[INT_SIZE];
        buf[3] = (byte) (n >> BYTE_BIT);
        buf[2] = (byte) ((n << BIT) >> BYTE_BIT);
        buf[1] = (byte) ((n << BITS_PRE_SAMPLE) >> BYTE_BIT);
        buf[0] = (byte) ((n << BYTE_BIT) >> BYTE_BIT);
        bos.write(buf);
    }

    private void writeChar(ByteArrayOutputStream bos, char[] id) {
        for (char c : id) {
            bos.write(c);
        }
    }
}
