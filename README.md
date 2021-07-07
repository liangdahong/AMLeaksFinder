```js
                         .---.
          __  __   ___   |   |      __.....__                   .
         |  |/  `.'   `. |   |  .-''         '.               .'|
         |   .-.  .-.   '|   | /     .-''"'-.  `.           .'  |
    __   |  |  |  |  |  ||   |/     /________\   \    __   <    |
 .:--.'. |  |  |  |  |  ||   ||                  | .:--.'.  |   | ____         _
/ |   \ ||  |  |  |  |  ||   |\    .-------------'/ |   \ | |   | \ .'       .' |
`" __ | ||  |  |  |  |  ||   | \    '-.____...---.`" __ | | |   |/  .       .   | /
 .'.''| ||__|  |__|  |__||   |  `.             .'  .'.''| | |    /\  \    .'.'| |//
/ /   | |_               '---'    `''-...... -'   / /   | |_|   |  \  \ .'.'.-'  /
\ \._,\ '/                                        \ \._,\ '/'    \  \  \.'   \_.'
 `--'  `"                                          `--'  `"'------'  '---'
                          _______
          .--.   _..._   \  ___ `'.         __.....__
     _.._ |__| .'     '.  ' |--.\  \    .-''         '.
   .' .._|.--..   .-.   . | |    \  '  /     .-''"'-.  `. .-,.--.
   | '    |  ||  '   '  | | |     |  '/     /________\   \|  .-. |
 __| |__  |  ||  |   |  | | |     |  ||                  || |  | |
|__   __| |  ||  |   |  | | |     ' .'\    .-------------'| |  | |
   | |    |  ||  |   |  | | |___.' /'  \    '-.____...---.| |  '-
   | |    |__||  |   |  |/_______.'/    `.             .' | |
   | |        |  |   |  |\_______|/       `''-...... -'   | |
   | |        |  |   |  |                                 |_|
   |_|        '--'   '--'
```
<p align="center">
<img  width="22%" src="https://user-images.githubusercontent.com/12118567/103100340-0f6a8f80-464d-11eb-9cb5-87c8f63e29f1.gif"/>
<img  width="72.5%" src="https://user-images.githubusercontent.com/12118567/89611994-4a904000-d8b1-11ea-8076-b3a754a9db49.png"/>
<p/>
<p align="center">
<a href="#"><img src="https://img.shields.io/badge/platform-iOS-red.svg"></a>
<a href="#"><img src="https://img.shields.io/badge/support-iOS%209%2B%20-blue.svg?style=flat"></a>
<a href="https://github.com/liangdahong/AMLeaksFinder/releases"><img src="https://img.shields.io/cocoapods/v/AMLeaksFinder.svg"></a>
<a href="#"><img src="https://img.shields.io/badge/language-Objective--C-orange.svg"></a>
<a href="https://github.com/liangdahong/AMLeaksFinder/blob/master/LICENSE"><img src="https://img.shields.io/badge/licenses-MIT-red.svg"></a>
</p>

## 介绍

本项目是一款用于自动检测 iOS 项目中【 **`UIView 和 UIViewController 内存泄漏`** 】的工具，只需 `pod 'AMLeaksFinder'` 即可 0 行代码实现自动监控，效果如下，推荐使用 `Cocoapods` 导入，和 [MLeakFinder](https://github.com/Tencent/MLeaksFinder) 的区别可参考 [对比 MLeakFinder](https://github.com/liangdahong/AMLeaksFinder/issues/4) 。

[English 📔](README_EN.md)


## 功能介绍

* [x] 自动监控 **`Controller`** 的泄漏；
* [x] 自动监控 **`View`** 的泄漏；
* [x] 借助 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 快速排查泄漏原因 【 ⚠️ 只在 `ObjC` 上有效 】；
* [x] 监控到泄漏时支持快速查看泄漏的视图【 **`View`**，**`Controller View`**，**`View 的 root View`** 等】；
* [ ] 更多功能欢迎补充。

## Cocoapods

```
pod 'AMLeaksFinder', '2.1.3',  :configurations => ['Debug']

```

- 如果想查看控制器的强引用链，可导入：Facebook 的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 框架即可。

```
pod 'FBRetainCycleDetector',  :configurations => ['Debug']
```

## 直接使用

- 请拖拽 `AMLeaksFinder/AMLeaksFinder` 文件夹的全部内容到项目

- `启用`  和  `禁用`  ` AMLeaksFinder`  请参考  `AMLeaksFinder.h` 的使用说明 (同时 `release` 下为关闭状态)

  -  打开 `MEMORY_LEAKS_FINDER_ENABLED` 宏表示启用 `AMLeaksFinder`

  -  注释 `MEMORY_LEAKS_FINDER_ENABLED` 宏表示关闭 `AMLeaksFinder`
  -  如果希望 `release` 也打开请详看 `AMLeaksFinder.h` 文件的宏定义（建议不要打开 😄 ）
  
## 原理分析 

- [原理分析](principle.md)
- 数据结构图
- ![数据结构图](https://user-images.githubusercontent.com/12118567/120919021-0bf22e80-c6ea-11eb-8f5f-d3d8c14d4666.jpg)

- 项目文件结构
```SWIFT
├── AMLeaksFinder
│   ├── AMLeaksFinder.bundle
│   │   ├── all@2x.png
│   │   ├── all@3x.png
│   │   ├── leaks@2x.png
│   │   └── leaks@3x.png
│   ├── Objects
│   │   ├── Controllers
│   │   │   ├── Model
│   │   │   │   ├── AMMemoryLeakDeallocModel.h
│   │   │   │   ├── AMMemoryLeakDeallocModel.m
│   │   │   │   ├── AMMemoryLeakModel.h
│   │   │   │   └── AMMemoryLeakModel.m
│   │   │   ├── NeedDealloc
│   │   │   │   ├── UINavigationController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIPageViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UISplitViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UITabBarController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIWindow+AMLeaksFinderSwizzleDealloc.m
│   │   │   └── ViewDidLoad
│   │   │       ├── UIViewController+AMLeaksFinderSwizzleViewDidLoad.m
│   │   └── View
│   │       └── Model
│   │           ├── AMViewMemoryLeakDeallocModel.h
│   │           ├── AMViewMemoryLeakDeallocModel.m
│   │           ├── AMViewMemoryLeakModel.h
│   │           └── AMViewMemoryLeakModel.m
│   ├── UI
│   │   ├── AMLeakDataModel.h
│   │   ├── AMLeakDataModel.m
│   │   ├── AMLeakOverviewView.h
│   │   ├── AMLeakOverviewView.m
│   │   ├── AMMemoryLeakView.h
│   │   ├── AMMemoryLeakView.m
│   │   ├── AMMemoryLeakView.xib
│   │   ├── AMSnapedViewViewController.h
│   │   ├── AMSnapedViewViewController.m
│   │   ├── UIViewController+AMLeaksFinderUI.h
│   │   └── UIViewController+AMLeaksFinderUI.m
│   └── Uitis
│       ├── Controller
│       │   ├── UIViewController+AMLeaksFinderTools.h
│       │   └── UIViewController+AMLeaksFinderTools.m
│       └── View
│           ├── UIView+AMLeaksFinderTools.h
│           └── UIView+AMLeaksFinderTools.m
```

## 联系

- 欢迎 [Issues](https://github.com/liangdahong/AMLeaksFinder/issues) 和 [Pull Requests](https://github.com/liangdahong/AMLeaksFinder/pulls)
- 也可以添加微信<img width="20%" src="https://user-images.githubusercontent.com/12118567/86319172-72fb9d80-bc66-11ea-8c6e-8127f9e5535f.jpg"/> 进群吹水。
