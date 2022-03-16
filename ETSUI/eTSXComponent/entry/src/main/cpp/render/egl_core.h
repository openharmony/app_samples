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

#ifndef _GL_CORE_
#define _GL_CORE_

#include <GLES/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>

#include <string>

class EGLCore {
public:
    EGLCore(std::string& id) : id_(id) {};
    void GLContextInit(void* window, int w, int h);
    void ChangeShape();
    void DrawTriangle();
    void ChangeColor();

public:
    std::string id_;
    int width_;
    int height_;

private:
    void Update();
    bool checkGlError(const char* op);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint CreateProgram(const char *vertexShader, const char *fragShader);

    EGLNativeWindowType mEglWindow;
    EGLDisplay mEGLDisplay = EGL_NO_DISPLAY;
    EGLConfig mEGLConfig = nullptr;
    EGLContext mEGLContext = EGL_NO_CONTEXT;
    EGLContext mSharedEGLContext = EGL_NO_CONTEXT;
    EGLSurface mEGLSurface = nullptr;
    GLuint mProgramHandle;
};

#endif // _GL_CORE_
