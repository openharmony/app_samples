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

#ifndef OLED_H
#define OLED_H

#include "ohos_types.h"

#define SSD1306_I2C_ADDR        (0x3C << 1)

// SSD1306 OLED height in pixels
#ifndef SSD1306_HEIGHT
#define SSD1306_HEIGHT          64
#endif

// SSD1306 width in pixels
#ifndef SSD1306_WIDTH
#define SSD1306_WIDTH           128
#endif

#ifndef SSD1306_BUFFER_SIZE
#define SSD1306_BUFFER_SIZE   (SSD1306_WIDTH * SSD1306_HEIGHT / 8)
#endif

// Enumeration for screen colors
typedef enum {
    Black = 0x00, // Black color, no pixel
    White = 0x01  // Pixel is set. Color depends on OLED
} SSD1306_COLOR;
// Struct to store transformations

typedef struct {
    const uint8 FontWidth;    /*!< Font width in pixels */
    uint8 FontHeight;   /*!< Font height in pixels */
    const uint16 *data; /*!< Pointer to data font data array */
} FontDef;

typedef struct {
    uint16 CurrentX;
    uint16 CurrentY;
    uint8 Inverted;
    uint8 Initialized;
    uint8 DisplayOn;
} SSD1306_t;

typedef struct {
    uint8 x;
    uint8 y;
} SSD1306_VERTEX;

void OledInit(void);

void HAL_Delay(uint32 ms);
void ssd1306_Init(void);
void ssd1306_Fill(SSD1306_COLOR color);
void ssd1306_SetCursor(uint8 x, uint8 y);
void ssd1306_UpdateScreen(void);

char ssd1306_DrawChar(char ch, FontDef Font, SSD1306_COLOR color);
char ssd1306_DrawString(char* str, uint32 size, SSD1306_COLOR color);

void ssd1306_DrawPixel(uint8 x, uint8 y, SSD1306_COLOR color);
void ssd1306_DrawLine(uint8 x1, uint8 y1, uint8 x2, uint8 y2, SSD1306_COLOR color);
void ssd1306_DrawPolyline(const SSD1306_VERTEX *par_vertex, uint16 par_size, SSD1306_COLOR color);
void ssd1306_DrawRectangle(uint8 x1, uint8 y1, uint8 x2, uint8 y2, SSD1306_COLOR color);
void ssd1306_DrawArc(uint8 x, uint8 y, uint8 radius, uint16 start_angle, uint16 sweep, SSD1306_COLOR color);
void ssd1306_DrawCircle(uint8 par_x, uint8 par_y, uint8 par_r, SSD1306_COLOR color);
void ssd1306_DrawBitmap(const uint8* bitmap, uint32 size);
void ssd1306_DrawBitmapAtPosition(const uint8* bitmap, uint8 width, uint8 height, int8 xo, int8 yo);

#endif // OLED_H