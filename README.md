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

本项目是一款用于自动检测 iOS 项目中【 **`控制器内存泄漏`**，  **`UIView 内存泄漏`** 】的工具，只需 `pod` 导入 `AMLeaksFinder` 即可 0 行代码实现自动监控，效果如下，推荐使用 `Cocoapods` 导入，和 [MLeakFinder](https://github.com/Tencent/MLeaksFinder) 的区别可参考 [对比 MLeakFinder](https://github.com/liangdahong/AMLeaksFinder/issues/4) 。

[English 📔](README_EN.md)


## 功能介绍

* [x] 自动监控 **`Controller`** 的泄漏；
* [x] 自动监控 **`View`** 的泄漏；
* [x] 借助 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 快速排查泄漏原因 【 ⚠️ 只在 `ObjC` 上有效 】；
* [x] 监控到泄漏时支持快速查看泄漏的视图【 **`View`**，**`Controller View`**，**`View 的 root View`** 等】；
* [ ] 更多功能欢迎补充。

## Cocoapods

```
pod 'AMLeaksFinder', '2.0.6',  :configurations => ['Debug']

```

- 如果想查看控制器的强引用链，可导入：Facebook 的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 框架即可。

```
pod 'FBRetainCycleDetector',  :configurations => ['Debug']
```

## 原理分析 

- [原理分析](principle.md)

- ![image](https://user-images.githubusercontent.com/12118567/105628096-dbfe6900-5e75-11eb-901c-58639c8a1a37.png)

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
│   │   │   │   ├── UINavigationController+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   ├── UINavigationController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIPageViewController+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   ├── UIPageViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UISplitViewController+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   ├── UISplitViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UITabBarController+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   ├── UITabBarController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIViewController+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   ├── UIViewController+AMLeaksFinderSwizzleDealloc.m
│   │   │   │   ├── UIWindow+AMLeaksFinderSwizzleDealloc.h
│   │   │   │   └── UIWindow+AMLeaksFinderSwizzleDealloc.m
│   │   │   └── ViewDidLoad
│   │   │       ├── UIViewController+AMLeaksFinderSwizzleViewDidLoad.h
│   │   │       └── UIViewController+AMLeaksFinderSwizzleViewDidLoad.m
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
