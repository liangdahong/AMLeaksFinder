```js
     _    __  __ _               _        _____ _           _
    / \  |  \/  | |    ___  __ _| | _____|  ___(_)_ __   __| | ___ _ __
   / _ \ | |\/| | |   / _ \/ _` | |/ / __| |_  | | '_ \ / _` |/ _ \ '__|
  / ___ \| |  | | |__|  __/ (_| |   <\__ \  _| | | | | | (_| |  __/ |
 /_/   \_\_|  |_|_____\___|\__,_|_|\_\___/_|   |_|_| |_|\__,_|\___|_|
```
<p align="center">
<img  width="21.5%" src="https://user-images.githubusercontent.com/12118567/137609767-23755a78-be8e-4310-99c9-bbb037d44bef.gif"/>
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
pod 'AMLeaksFinder', '2.2.3',  :configurations => ['Debug']

```

- 如果想查看控制器的强引用链，可导入：Facebook 的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 框架即可。

```
pod 'FBRetainCycleDetector', :git => 'https://github.com/facebook/FBRetainCycleDetector.git', :branch => 'main', :configurations => ['Debug']
```

## 直接使用

- 请拖拽 `AMLeaksFinder/AMLeaksFinder` 文件夹的全部内容到项目
- 启用 & 关闭 `AMLeaksFinder`
  -  打开 `__AUTO_MEMORY_LEAKS_FINDER_ENABLED__` 宏表示启用
  -  注释 `__AUTO_MEMORY_LEAKS_FINDER_ENABLED__` 宏表示关闭
  
## 数据收集
> 若想收集泄漏相关数据可使用如下 API:
- https://github.com/liangdahong/AMLeaksFinder/blob/master/AMLeaksFinder/AMLeaksFinder.h

```
控制器路径变化 AMLeaksFinder.ViewHasLeakVC viewDidDisappear: 2022-04-04 04:21:06 +0000
控制器路径变化 AMHomeVC viewDidAppear: 2022-04-04 04:21:06 +0000
控制器路径变化 AMPresentHasLeakVC viewDidLoad: 2022-04-04 04:21:07 +0000
控制器路径变化 AMPresentHasLeakVC viewDidAppear: 2022-04-04 04:21:07 +0000
控制器路径变化 AMTabBarController viewDidDisappear: 2022-04-04 04:21:07 +0000
控制器路径变化 BMNavigationController viewDidDisappear: 2022-04-04 04:21:07 +0000
控制器路径变化 AMHomeVC viewDidDisappear: 2022-04-04 04:21:07 +0000
控制器路径变化 AMTabBarController viewDidAppear: 2022-04-04 04:21:08 +0000
控制器路径变化 BMNavigationController viewDidAppear: 2022-04-04 04:21:08 +0000
控制器路径变化 AMHomeVC viewDidAppear: 2022-04-04 04:21:08 +0000
控制器路径变化 AMPresentHasLeakVC viewDidDisappear: 2022-04-04 04:21:08 +0000
⚠️👇🏻
视图泄漏: <UIView: 0x7f9849a214d0; frame = (65 176; 294 348); autoresize = RM+BM; layer = <CALayer: 0x60000090ed00>> 
视图所在控制器 AMLeaksFinder.ViewHasLeakVC 
操作路径:
BMNavigationController(viewDidLoad:) -> 
AMTabBarController(viewDidLoad:) -> 
AMHomeVC(viewDidLoad:) -> 
AMTabBarController(viewDidAppear:) -> 
BMNavigationController(viewDidAppear:) -> 
AMHomeVC(viewDidAppear:) -> 
AMPresentHasLeakVC(viewDidLoad:) -> 
AMPresentHasLeakVC(viewDidAppear:) -> 
AMTabBarController(viewDidDisappear:) -> 
BMNavigationController(viewDidDisappear:) -> 
AMHomeVC(viewDidDisappear:) -> 
AMTabBarController(viewDidAppear:) -> 
BMNavigationController(viewDidAppear:) -> 
AMHomeVC(viewDidAppear:) -> 
AMPresentHasLeakVC(viewDidDisappear:) -> 
AMPresentHasLeakVC(viewDidLoad:) -> 
AMPresentHasLeakVC(viewDidAppear:) -> 
AMTabBarController(viewDidDisappear:) -> 
BMNavigationController(viewDidDisappear:) -> 
AMHomeVC(viewDidDisappear:) -> 
AMTabBarController(viewDidAppear:) -> 
BMNavigationController(viewDidAppear:) -> 
AMHomeVC(viewDidAppear:) -> 
AMPresentHasLeakVC(viewDidDisappear:) -> 
_UIAlertControllerTextFieldViewController(viewDidLoad:) -> 
UIAlertController(viewDidLoad:) -> 
UIAlertController(viewDidAppear:) -> 
UIAlertController(viewDidDisappear:) -> 
AMLeaksFinder.ViewHasLeakVC(viewDidLoad:) -> 
AMHomeVC(viewDidDisappear:) -> 
AMLeaksFinder.ViewHasLeakVC(viewDidAppear:) -> 
AMLeaksFinder.ViewHasLeakVC(viewDidDisappear:) -> 
AMHomeVC(viewDidAppear:) -> 
AMPresentHasLeakVC(viewDidLoad:) -> 
AMPresentHasLeakVC(viewDidAppear:) -> 
AMTabBarController(viewDidDisappear:) -> 
BMNavigationController(viewDidDisappear:) -> 
AMHomeVC(viewDidDisappear:) -> 
AMTabBarController(viewDidAppear:) -> 
BMNavigationController(viewDidAppear:) -> 
AMHomeVC(viewDidAppear:) -> 
AMPresentHasLeakVC(viewDidDisappear:) -> 
⚠️👆🏻
```
  
## 原理分析 

- [原理分析](principle.md)
- 数据结构图
- ![数据结构图](https://user-images.githubusercontent.com/12118567/120919021-0bf22e80-c6ea-11eb-8f5f-d3d8c14d4666.jpg)

- 项目文件结构
```SWIFT
├── AMLeaksFinder
│   ├── AMLeaksFinder.h
│   ├── AMLeaksFinder.m
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
