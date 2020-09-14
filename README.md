<p align="center">
    <img  width="24%" src="https://user-images.githubusercontent.com/12118567/89614777-be354b80-d8b7-11ea-8af5-8400157f8fd4.gif"/>
    <img  width="72.5%" src="https://user-images.githubusercontent.com/12118567/89611994-4a904000-d8b1-11ea-8076-b3a754a9db49.png"/>
<p/>
<p align="center">
<a href="https://en.wikipedia.org/wiki/IOS"><img src="https://img.shields.io/badge/platform-iOS-red.svg"></a>
<a href="https://en.wikipedia.org/wiki/IOS_8"><img src="https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat"></a>
<a href="https://github.com/liangdahong/AMLeaksFinder/releases"><img src="https://img.shields.io/cocoapods/v/AMLeaksFinder.svg"></a>
<a href="https://en.wikipedia.org/wiki/Objective-C"><img src="https://img.shields.io/badge/language-Objective--C-orange.svg"></a>
<a href="https://github.com/liangdahong/AMLeaksFinder/blob/master/LICENSE"><img src="https://img.shields.io/badge/licenses-MIT-red.svg"></a>
</p>

## 介绍

本项目是一款用于自动检测项目中【控制器内存泄漏】的工具，只需要把 `AMLeaksFinder` 路径下的文件拖入项目即可，效果如下，在上线时请务必移除，推荐使用 Cocoapods 导入 ，如果你感兴趣可以一起聊聊。

[English 📔](README_EN.md)

## 原理分析 
- [原理分析](principle.md)

## Cocoapods

```
pod 'AMLeaksFinder', '1.2.6',  :configurations => ['Debug']
```

- 如果想查看控制器的强引用链，导入：Facebook 的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector) 框架即可。

```
pod 'FBRetainCycleDetector',  :configurations => ['Debug']
```

## 联系
- 欢迎 [issues](https://github.com/liangdahong/AMLeaksFinder/issues) 和 [PR](https://github.com/liangdahong/AMLeaksFinder/pulls)
- 也可以添加微信<img width="20%" src="https://user-images.githubusercontent.com/12118567/86319172-72fb9d80-bc66-11ea-8c6e-8127f9e5535f.jpg"/> 进微信群交流群。
