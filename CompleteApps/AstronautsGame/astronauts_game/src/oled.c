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

#include "cmsis_os2.h"
#include "ohos_types.h"
#include "code_tab.h"
#include "oled.h"
#include "common_log.h"
#include "iot_i2c.h"

#define BITS_NAMBER  8
#define SSD1306_I2C_IDX 0
#define SSD1306_CTRL_CMD 0x00
#define SSD1306_CTRL_DATA 0x40
#define SSD1306_MASK_CONT (0x1<<7)
#define TIME_CONVERSION_PARM 1000
#define SSD1306_WRITEDATA_PARM  2

FontDef g_Font_7x10 = {7, 10, Font7x10};

// Screenbuffer
static uint8 SSD1306_Buffer[SSD1306_BUFFER_SIZE];
// Screen object
static SSD1306_t SSD1306;

void HAL_Delay(uint32 ms)
{
    const uint32 msPerTick = TIME_CONVERSION_PARM / osKernelGetTickFreq(); // 10ms
    if (ms >= msPerTick) {
        osDelay(ms / msPerTick);
    }

    uint32 restMs = ms % msPerTick;
    if (restMs > 0) {
        usleep(restMs * TIME_CONVERSION_PARM);
    }
}

#define TIME_UNITS 1000

uint32 HAL_GetTick(void)
{
    const uint32 msPerTick = TIME_UNITS / osKernelGetTickFreq(); // 10ms
    uint32 tickMs = osKernelGetTickCount() * msPerTick;

    uint32 csPerMs = osKernelGetSysTimerFreq() / TIME_UNITS; // 160K cycle/ms
    uint32 csPerTick = csPerMs * msPerTick; // 1600K cycles/tick
    uint32 restMs = osKernelGetSysTimerCount() % csPerTick / csPerMs;

    return tickMs + restMs;
}

static uint32 ssd1306_SendData(uint8* data, size_t size)
{
    return IoTI2cWrite(SSD1306_I2C_IDX, SSD1306_I2C_ADDR, data, size);
}

static uint32 ssd1306_WiteByte(uint8 regAddr, uint8 byte)
{
    uint8 buffer[] = {regAddr, byte};
    return ssd1306_SendData(buffer, sizeof(buffer));
}

// Send a byte to the command register
void ssd1306_WriteCommand(uint8 byte)
{
    ssd1306_WiteByte(SSD1306_CTRL_CMD, byte);
}

void ssd1306_WriteData(uint8* buffer, size_t buff_size)
{
    uint8 data[SSD1306_WIDTH * SSD1306_WRITEDATA_PARM] = {0};
    for (size_t i = 0; i < buff_size; i++) {
        data[i  *SSD1306_WRITEDATA_PARM] = SSD1306_CTRL_DATA | SSD1306_MASK_CONT;
        data[i * SSD1306_WRITEDATA_PARM + 1] = buffer[i];
    }
    data[(buff_size - 1) * SSD1306_WRITEDATA_PARM] = SSD1306_CTRL_DATA;
    ssd1306_SendData(data, sizeof(data));
}

void ssd1306_SetDisplayOn(const uint8 on)
{
    uint8 value;
    if (on) {
        value = 0xAF;   // Display on
        SSD1306.DisplayOn = 1;
    } else {
        value = 0xAE;   // Display off
        SSD1306.DisplayOn = 0;
    }
    ssd1306_WriteCommand(value);
}

void ssd1306_SetContrast(const uint8  value)
{
    const uint8 kSetContrastControlRegister = 0x81;
    ssd1306_WriteCommand(kSetContrastControlRegister);
    ssd1306_WriteCommand(value);
}

void ssd1306_DrawPixel(uint8 x, uint8 y, SSD1306_COLOR color)
{
    if ((x >= SSD1306_WIDTH) || (y >= SSD1306_HEIGHT)) {
        // Don't write outside the buffer
        return;
    }

    // Check if pixel should be inverted
    if (SSD1306.Inverted) {
        color = (SSD1306_COLOR)!color;
    }

    // Draw in the right color
    if (color == White) {
        SSD1306_Buffer[x + (y / BITS_NAMBER) * SSD1306_WIDTH] |= 1 << (y % BITS_NAMBER);
    } else {
        SSD1306_Buffer[x + (y / BITS_NAMBER) * SSD1306_WIDTH] &= ~(1 << (y % BITS_NAMBER));
    }
}

#define ACSII_CODE_SPACE    32
#define ACSII_RANGE_DEL   127

char ssd1306_DrawChar(char ch, FontDef Font, SSD1306_COLOR color)
{
    uint32 i, b, j;

    // Check if character is valid
    if ((ch < ACSII_CODE_SPACE) || (ch > ACSII_RANGE_DEL - 1))  { return 0;}

    // Check remaining space on current line
    if (SSD1306_WIDTH < (SSD1306.CurrentX + Font.FontWidth) ||
        SSD1306_HEIGHT < (SSD1306.CurrentY + Font.FontHeight)) {
        return 0;
    }
    // Use the font to write
    for (i = 0; i < Font.FontHeight; i++) {
        b = Font.data[(ch - ACSII_CODE_SPACE) * Font.FontHeight + i];
        for (j = 0; j < Font.FontWidth; j++) {
            if ((b << j) & 0x8000) {
                ssd1306_DrawPixel(SSD1306.CurrentX + j, (SSD1306.CurrentY + i), (SSD1306_COLOR) color);
            } else {
                ssd1306_DrawPixel(SSD1306.CurrentX + j, (SSD1306.CurrentY + i), (SSD1306_COLOR)!color);
            }
        }
    }
    // The current space is now taken
    SSD1306.CurrentX += Font.FontWidth;
    return ch;
}

char ssd1306_DrawString(char* str, uint32 size, SSD1306_COLOR color)
{
    // Write until null-byte
    (void)size;
    while (*str) {
        if (ssd1306_DrawChar(*str, g_Font_7x10, color) != *str) {
            // Char could not be written
            return *str;
        }
        // Next char
        str++;
    }

    return *str;
}

void ssd1306_DrawBitmapAtPosition(const uint8* bitmap, uint8 width, uint8 height, int8 xo, int8 yo)
{
    for (uint8  y = 0; y < height; y++) {
        if (yo + y > SSD1306_HEIGHT || yo + y < 0) continue;
        for (uint8  x = 0; x < width; x++) {
            if (xo + x > SSD1306_WIDTH || xo + x < 0) continue;
            uint8  byte = bitmap[(y * width / BITS_NAMBER) + (x / BITS_NAMBER)];
            uint8  bit = byte & (0x80 >> (x % BITS_NAMBER));
            ssd1306_DrawPixel(xo + x, yo + y, bit ? White : Black);
        }
    }
}

// Position the cursor
void ssd1306_SetCursor(uint8 x, uint8 y)
{
    SSD1306.CurrentX = x;
    SSD1306.CurrentY = y;
}

// Fill the whole screen with the given color
void ssd1306_Fill(SSD1306_COLOR color)
{
    /* Set memory */
    uint32 i;

    for (i = 0; i < sizeof(SSD1306_Buffer); i++) {
        SSD1306_Buffer[i] = (color == Black) ? 0x00 : 0xFF;
    }
}

#define DRAW_LINE_CALC_PARM 2
void ssd1306_DrawLine(uint8 x1, uint8 y1, uint8 x2, uint8 y2, SSD1306_COLOR color)
{
    int32 deltaX = abs(x2 - x1);
    int32 deltaY = abs(y2 - y1);
    int32 signX = ((x1 < x2) ? 1 : -1);
    int32 signY = ((y1 < y2) ? 1 : -1);
    int32 error = deltaX - deltaY;

    ssd1306_DrawPixel(x2, y2, color);
    while ((x1 != x2) || (y1 != y2)) {
        ssd1306_DrawPixel(x1, y1, color);
        int32 error2 = error * DRAW_LINE_CALC_PARM;
        if (error2 > -deltaY) {
            error -= deltaY;
            x1 += signX;
        }
        if (error2 < deltaX) {
            error += deltaX;
            y1 += signY;
        }
    }
    return;
}

#define CMD_SAVE_PARM   2

void ssd1306_UpdateScreen(void)
{
    // Write data to each page of RAM. Number of pages
    uint8 cmd[] = {
        0X21,   // Set column start and end addresses
        0X00,   // Column start address 0
        0X7F,   // Column end address 127
        0X22,   // Set page start and end addresses
        0X00,   // Column start address 0
        0X07,   // Column end address 7
    };
    uint32 count = 0;
    uint8 data[sizeof(cmd) * CMD_SAVE_PARM + SSD1306_BUFFER_SIZE + 1] = {};

    // copy cmd
    for (uint32 i = 0; i < sizeof(cmd) / sizeof(cmd[0]); i++) {
        data[count++] = SSD1306_CTRL_CMD | SSD1306_MASK_CONT;
        data[count++] = cmd[i];
    }

    // copy frame data
    data[count++] = SSD1306_CTRL_DATA;
    if (memcpy_s(&data[count], sizeof(SSD1306_Buffer), SSD1306_Buffer, sizeof(SSD1306_Buffer)) != 0) {
        LOG_E("Copy the SSD1306_Buffer failed.\n");
    }
    count += sizeof(SSD1306_Buffer);

    // send to i2c bus
    uint32 retval = ssd1306_SendData(data, count);
    if (retval != OHOS_SUCCESS) {
        LOG_E("ssd1306_UpdateScreen send frame data failed: %d!\r\n", retval);
    }
}

#define TIMES_FOR_VOLTAGE_STABLE 100

void ssd1306_Init(void)
{
    // Wait for the screen to boot
    HAL_Delay(TIMES_FOR_VOLTAGE_STABLE);

    // Init OLED
    ssd1306_SetDisplayOn(0); // display off
    ssd1306_WriteCommand(0x20); // Set Memory Addressing Mode
    ssd1306_WriteCommand(0x00); // 00b,Horizontal Addressing Mode; 01b,Vertical Addressing Mode
    ssd1306_WriteCommand(0xB0); // Set Page Start Address for Page Addressing Mode,0-7
    ssd1306_WriteCommand(0xC8); // Set COM Output Scan Direction
    ssd1306_WriteCommand(0x00); // ---set low column address
    ssd1306_WriteCommand(0x10); // ---set high column address
    ssd1306_WriteCommand(0x40); // --set start line address - CHECK
    ssd1306_SetContrast(0xFF);
    ssd1306_WriteCommand(0xA1); // --set segment re-map 0 to 127 - CHECK
    ssd1306_WriteCommand(0xA6); // --set normal color
    ssd1306_WriteCommand(0xA8); // --set multiplex ratio(1 to 64) - CHECK
    ssd1306_WriteCommand(0x3F); //
    ssd1306_WriteCommand(0xA4); // 0xa4,Output follows RAM content;0xa5,Output ignores RAM content
    ssd1306_WriteCommand(0xD3); // -set display offset - CHECK
    ssd1306_WriteCommand(0x00); // -not offset
    ssd1306_WriteCommand(0xD5); // --set display clock divide ratio/oscillator frequency
    ssd1306_WriteCommand(0xF0); // --set divide ratio
    ssd1306_WriteCommand(0xD9); // --set pre-charge period
    ssd1306_WriteCommand(0x11); // 0x22 by default
    ssd1306_WriteCommand(0xDA); // --set com pins hardware configuration - CHECK
    ssd1306_WriteCommand(0x12);
    ssd1306_WriteCommand(0xDB); // --set vcomh
    ssd1306_WriteCommand(0x30); // 0x20,0.77xVcc, 0x30,0.83xVcc
    ssd1306_WriteCommand(0x8D); // --set DC-DC enable
    ssd1306_WriteCommand(0x14);
    ssd1306_SetDisplayOn(1); // --turn on SSD1306 panel

    ssd1306_Fill(Black); // Clear screen
    ssd1306_UpdateScreen(); // Flush buffer to screen
    SSD1306.CurrentX = 0; // Set default values for screen object
    SSD1306.CurrentY = 0;
    SSD1306.Initialized = 1;
}

#define SHOW_GAME_START_Y_1  10
#define SHOW_GAME_START_Y_2  30
#define OLED_VOLTAGE_STABLE_TIME 300

void OledInit(void)
{
    HAL_Delay(OLED_VOLTAGE_STABLE_TIME);
    ssd1306_Init();
    ssd1306_Fill(Black);
    ssd1306_SetCursor(0, SHOW_GAME_START_Y_1);
    ssd1306_DrawString("== Game Start ==", sizeof("== Game Start =="), White);
    ssd1306_SetCursor(0, SHOW_GAME_START_Y_2);
    ssd1306_DrawString("Press button USER", sizeof("Press button USER"), White);

    uint32 start = HAL_GetTick();
    ssd1306_UpdateScreen();
    uint32 end = HAL_GetTick();
    LOG_I("ssd1306_UpdateScreen time cost: %d ms.\r\n", end - start);
}