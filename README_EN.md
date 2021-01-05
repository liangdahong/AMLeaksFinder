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

## Introduction

A small tool for automatically detecting the [controller memory leak] in the project, Just drag the files under the path of `AMLeaksFinder` into the project, the effect is as follows, please be sure to remove the framework when going online, If you are interested, you can talk together.

[中文版🇨🇳](README.md)

## Principle analysis 
- [Principle analysis ](principle.md)

## Cocoapods

```
pod 'AMLeaksFinder', '2.0.5',  :configurations => ['Debug']
```

- If you want to view the reference chain of the controller, import: Facebook's [FBRetainCycleDetector] (https://github.com/facebook/FBRetainCycleDetector) framework. 

```
pod 'FBRetainCycleDetector',  :configurations => ['Debug']
```
