# AMLeaksFinder 实现原理分析

## 原理介绍

我们的控制器通常从创建到显示到释放要经过一系列的生命周期方法，如下：

```
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil;
- (nullable instancetype)initWithCoder:(NSCoder *)coder;
- (void)loadView;
- (void)loadViewIfNeeded
- (void)viewWillUnload
- (void)viewDidUnload
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)viewWillLayoutSubviews
- (void)viewDidLayoutSubviews
- (void)dealloc{}
```

一般情况，如果控制器没有内存泄露，一般会经过 `viewDidLoad`  和 `dealloc` 方法。

那么我们就可以从上面的 2 个方法入手，如果一个控制器经过了 `viewDidLoad`, 同时在应该释放的时候一直没有  `dealloc`，那么基本可以确定控制器泄露了,那么什么时候是控制器应该释放的时候呢？

总结有如下的时候有相关控制器需要释放：

- UIViewController 有 dismissViewControllerAnimated 操作

- UINavigationController 有 pop 操作

- UINavigationController 触发了 setViewControllers: 
- UINavigationController 触发了 setViewControllers:animated: 

- UITabBarController 触发了 setViewControllers: 
- UITabBarController 触发了 setViewControllers:animated: 

- UIPageViewController 触发了 setViewControllers:direction:animated:completion:

- UISplitViewController 触发了 setViewControllers: 

- ...

那么我们就可以从上面的分析出发，在 viewDidLoad 的时候记录控制器，然后在 dealloc 的时候清除记录，在需要释放的时候把相关控制器标记为将要释放，然后把相关的统计数据呈现出来即可。


## AMLeaksFinder 的处理逻辑

- hook 控制器的 viewDidLoad 方法，同时做相关的逻辑操作，注意不要强引用。
![image](https://user-images.githubusercontent.com/12118567/82640835-dcd36100-9c3d-11ea-8252-a1602aa46baf.png)
![image](https://user-images.githubusercontent.com/12118567/82641054-4bb0ba00-9c3e-11ea-97fc-f1236fed1ae3.png)
![image](https://user-images.githubusercontent.com/12118567/82641065-4fdcd780-9c3e-11ea-805b-77e1eff73cb6.png)

- hook UINavigationController 的 setViewControllers: 和相关 pop 方法，把相关的控制器设置为将要释放【控制器A 需要释放，那么控制器 A 包括它的子子孙孙控制器全部需要释放 】。

![image](https://user-images.githubusercontent.com/12118567/82641110-6420d480-9c3e-11ea-8c23-300050715101.png)

![image](https://user-images.githubusercontent.com/12118567/82641197-8b77a180-9c3e-11ea-8436-0cea58c96ba8.png)
![image](https://user-images.githubusercontent.com/12118567/82641330-c4b01180-9c3e-11ea-8799-a7214738a910.png)

- 在自定义专门统计的 class 的 dealloc 里处理释放的控制器，代码如下：

![image](https://user-images.githubusercontent.com/12118567/82641484-fb862780-9c3e-11ea-98cd-07ed1c58046f.png)

- UI 实时统计出当前统计的控制器数据即可。

- 其中用到了 2 个自定义类，其中 AMMemoryLeakDeallocModel 主要是为了监控控制器的释放，AMMemoryLeakModel 是为了统计数据。


## 参考

- https://github.com/Tencent/MLeaksFinder

