# AMLeaksFinder 实现原理分析

## 原理介绍

所谓**内存泄漏**，通俗讲就是 **该释放** 的时候一直 **得不到释放**。

控制器通常从 **创建** 到 **显示** 到 **释放**  要经过一系列的 **生命周期** 方法，大概如下：

```objective-c
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

一般情况，如果控制器没有内存泄漏，一般会经过 `viewDidLoad`  和 `dealloc` 方法。

我们可以从上面的 `2` 个方法入手，如果一个控制器经过了 `viewDidLoad`,  同时在 **应该释放** 的时候一直没有  **dealloc**，那么基本可以确定控制器泄漏了【当然有特殊情况，如：在一些特殊场景下开发者特意不让其释放】，问题来了，什么时候是控制器应该释放的时候呢 ？

触发了如下方法的时候可以基本确定相关控制器需要释放【欢迎补充】：

---

- `UIViewController` 触发了 `dismissViewControllerAnimated:completion:` 

---

- `UINavigationController` 触发了 `popViewControllerAnimated: `

- `UINavigationController` 触发了 `popToViewController:animated: `

- `UINavigationController` 触发了 `popToRootViewControllerAnimated: `

- `UINavigationController` 触发了 `setViewControllers:`

- `UINavigationController` 触发了 `setViewControllers:animated:`

---

- `UITabBarController` 触发了 `setViewControllers:`

- `UITabBarController` 触发了 `setViewControllers:animated:` 

---

- `UIPageViewController` 触发了 `setViewControllers:direction:animated:completion:`

---

- `UISplitViewController` 触发了 `setViewControllers:` 

---

- `UIWindow` 触发了 `rootViewController`

---

- ...等。

我们可以从上面的分析出发，在 `viewDidLoad` 的时候记录控制器，然后在控制器  `dealloc` 的时候清除记录，在需要释放的时候把相关控制器标记为将要释放，然后把相关的统计数据呈现出来即可。


## AMLeaksFinder 的处理逻辑

- `hook` 控制器的 `viewDidLoad` 方法，同时做相关的逻辑操作，注意不要强引用。

![image](https://user-images.githubusercontent.com/12118567/82640835-dcd36100-9c3d-11ea-8252-a1602aa46baf.png)
![image](https://user-images.githubusercontent.com/12118567/82641054-4bb0ba00-9c3e-11ea-97fc-f1236fed1ae3.png)
![image](https://user-images.githubusercontent.com/12118567/82641065-4fdcd780-9c3e-11ea-805b-77e1eff73cb6.png)

- `hook` `UINavigationController` 的 `setViewControllers:` 和相关 `pop` 方法，把相关的控制器设置为将要释放【 `控制器A需要释放，那么控制器 A 包括它的子子孙孙控制器全部需要释放` 】。

![image](https://user-images.githubusercontent.com/12118567/82641110-6420d480-9c3e-11ea-8c23-300050715101.png)
![image](https://user-images.githubusercontent.com/12118567/82641197-8b77a180-9c3e-11ea-8436-0cea58c96ba8.png)
![image](https://user-images.githubusercontent.com/12118567/82641330-c4b01180-9c3e-11ea-8799-a7214738a910.png)

- 在自定义专门监控控制器释放的 `class` 的 `dealloc` 里处理相关逻辑，代码如下：

![image](https://user-images.githubusercontent.com/12118567/82641484-fb862780-9c3e-11ea-98cd-07ed1c58046f.png)

- `UI` 实时统计出当前统计的控制器数据即可。
- 其中用到了 `2` 个自定义类，其中 `AMMemoryLeakDeallocModel` 主要是为了监控控制器的释放，`AMMemoryLeakModel` 是为了统计数据。

## 更多

- 更多详细内容请查询源码 https://github.com/liangdahong/AMLeaksFinder

## 参考

- https://github.com/Tencent/MLeaksFinder

