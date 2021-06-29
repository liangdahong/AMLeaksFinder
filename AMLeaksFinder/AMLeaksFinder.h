//    MIT License
//
//    Copyright (c) 2020 梁大红
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

// 👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
/// 如下宏只可选择其一打开

/// 启用内存泄漏监控
#define MEMORY_LEAKS_FINDER_ENABLED

/// 禁止内存泄漏监控
// #define MEMORY_LEAKS_FINDER_DISABLE

// 👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆

/// =========================================================
/// =========================================================
/// =========================================================
#if DEBUG
    #ifdef MEMORY_LEAKS_FINDER_ENABLED
        #ifndef __AUTO_MEMORY_LEAKS_FINDER_ENABLED__
            #define __AUTO_MEMORY_LEAKS_FINDER_ENABLED__
        #endif
    #endif
#endif
/// =========================================================
/// =========================================================
/// =========================================================
