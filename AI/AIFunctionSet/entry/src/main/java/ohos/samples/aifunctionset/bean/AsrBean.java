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

package ohos.samples.aifunctionset.bean;

import java.util.List;

/**
 * AsrBean
 */

public class AsrBean {
    private List<Result> result;

    private String resultType;

    public void setResult(List<Result> result) {
        this.result = result;
    }

    public List<Result> getResult() {
        return result;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public String getResultType() {
        return resultType;
    }

    /**
     * Speech recognition result
     */
    public static class Result {
        private double confidence;

        private String ori_word;

        private String pinyin;

        private String word;

        public void setConfidence(double confidence) {
            this.confidence = confidence;
        }

        public double getConfidence() {
            return confidence;
        }

        public void setOriWord(String ori_word) {
            this.ori_word = ori_word;
        }

        public String getOriWord() {
            return ori_word;
        }

        public void setPinyin(String pinyin) {
            this.pinyin = pinyin;
        }

        public String getPinyin() {
            return pinyin;
        }

        public void setWord(String word) {
            this.word = word;
        }

        public String getWord() {
            return word;
        }
    }
}


