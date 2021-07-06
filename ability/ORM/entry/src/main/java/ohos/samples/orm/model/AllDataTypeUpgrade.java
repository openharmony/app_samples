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

package ohos.samples.orm.model;

import ohos.data.orm.Blob;
import ohos.data.orm.Clob;
import ohos.data.orm.OrmObject;
import ohos.data.orm.annotation.Entity;
import ohos.data.orm.annotation.PrimaryKey;

import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

/**
 * AllDataTypeUpgrade
 *
 * @since 2021-06-15
 */
@Entity(tableName = "AllDataType")
public class AllDataTypeUpgrade extends OrmObject {
    @PrimaryKey(autoGenerate = true)
    private int id;

    private Integer integerValue;

    private Long longValue;

    private Short shortValue;

    private Boolean booleanValue;

    private Double doubleValue;

    private Float floatValue;

    private String stringValue;

    private Blob blobValue;

    private Clob clobValue;

    private Byte byteValue;

    private Date dateValue;

    private Time timeValue;

    private Timestamp timestampValue;

    private Calendar calendarValue;

    private Character characterValue;

    private int primIntValue;

    private long primLongValue;

    private short primShortValue;

    private float primFloatValue;

    private double primDoubleValue;

    private boolean primBooleanValue;

    private byte primByteValue;

    private char primCharValue;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getIntegerValue() {
        return integerValue;
    }

    public void setIntegerValue(Integer integerValue) {
        this.integerValue = integerValue;
    }

    public Long getLongValue() {
        return longValue;
    }

    public void setLongValue(Long longValue) {
        this.longValue = longValue;
    }

    public Short getShortValue() {
        return shortValue;
    }

    public void setShortValue(Short shortValue) {
        this.shortValue = shortValue;
    }

    public Boolean getBooleanValue() {
        return booleanValue;
    }

    public void setBooleanValue(Boolean booleanValue) {
        this.booleanValue = booleanValue;
    }

    public Double getDoubleValue() {
        return doubleValue;
    }

    public void setDoubleValue(Double doubleValue) {
        this.doubleValue = doubleValue;
    }

    public Float getFloatValue() {
        return floatValue;
    }

    public void setFloatValue(Float floatValue) {
        this.floatValue = floatValue;
    }

    public String getStringValue() {
        return stringValue;
    }

    public void setStringValue(String stringValue) {
        this.stringValue = stringValue;
    }

    public Blob getBlobValue() {
        return blobValue;
    }

    public void setBlobValue(Blob blobValue) {
        this.blobValue = blobValue;
    }

    public Clob getClobValue() {
        return clobValue;
    }

    public void setClobValue(Clob clobValue) {
        this.clobValue = clobValue;
    }

    public Byte getByteValue() {
        return byteValue;
    }

    public void setByteValue(Byte byteValue) {
        this.byteValue = byteValue;
    }

    public Date getDateValue() {
        return dateValue;
    }

    public void setDateValue(Date dateValue) {
        this.dateValue = dateValue;
    }

    public Time getTimeValue() {
        return timeValue;
    }

    public void setTimeValue(Time timeValue) {
        this.timeValue = timeValue;
    }

    public Timestamp getTimestampValue() {
        return timestampValue;
    }

    public void setTimestampValue(Timestamp timestampValue) {
        this.timestampValue = timestampValue;
    }

    public Calendar getCalendarValue() {
        return calendarValue;
    }

    public void setCalendarValue(Calendar calendarValue) {
        this.calendarValue = calendarValue;
    }

    public Character getCharacterValue() {
        return characterValue;
    }

    public void setCharacterValue(Character characterValue) {
        this.characterValue = characterValue;
    }

    public int getPrimIntValue() {
        return primIntValue;
    }

    public void setPrimIntValue(int primIntValue) {
        this.primIntValue = primIntValue;
    }

    public long getPrimLongValue() {
        return primLongValue;
    }

    public void setPrimLongValue(long primLongValue) {
        this.primLongValue = primLongValue;
    }

    public short getPrimShortValue() {
        return primShortValue;
    }

    public void setPrimShortValue(short primShortValue) {
        this.primShortValue = primShortValue;
    }

    public float getPrimFloatValue() {
        return primFloatValue;
    }

    public void setPrimFloatValue(float primFloatValue) {
        this.primFloatValue = primFloatValue;
    }

    public double getPrimDoubleValue() {
        return primDoubleValue;
    }

    public void setPrimDoubleValue(double primDoubleValue) {
        this.primDoubleValue = primDoubleValue;
    }

    public boolean isPrimBooleanValue() {
        return primBooleanValue;
    }

    public void setPrimBooleanValue(boolean primBooleanValue) {
        this.primBooleanValue = primBooleanValue;
    }

    public byte getPrimByteValue() {
        return primByteValue;
    }

    public void setPrimByteValue(byte primByteValue) {
        this.primByteValue = primByteValue;
    }

    public char getPrimCharValue() {
        return primCharValue;
    }

    public void setPrimCharValue(char primCharValue) {
        this.primCharValue = primCharValue;
    }
}
