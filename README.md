# CHTNavigationController

### 自定义NavigationController，主要解决以下问题：

1. 解决自定义`导航栏返回按钮`后系统返回手势失效的问题；
2. 解决从有`UINavigationBar`的界面跳转到没有`UINavigationBar`的界面时的过渡问题；
3. 解决由于以上第2点导致的`UINavigationBar`错乱的问题(针对iOS10以下系统)；
4. 解决`UINavigationBar`的全局颜色设置问题。 

### 效果图如下（iOS10以上能达到完美过渡，但是iOS10以下会有一个小Bug，后面细说）：

![](https://github.com/ChanRoy/CHTNavigationController/blob/master/CHTNavigationControllerDemo.gif)

### 下面简要说明下前面提到的四个问题：

- 解决自定义`导航栏返回按钮`后系统返回手势失效的问题：

主要是继承系统的`UINavigationController`，然后在适当的时候打开和关闭系统的返回手势`interactivePopGestureRecognizer`。

具体可查看`CHTNavigationController.m`，不再赘述。

- 解决从有`UINavigationBar`的界面跳转到没有`UINavigationBar`的界面时的过渡问题：

参考了Sunny大神的[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) 这个库。

利用**runtime**的`method swizzling`改写`UIViewController`的`viewWillAppear`方法，只需在需要隐藏UINavigationBar的viewController中导入头文件：
`#import "CHTNavigationController.h"`，并设置：

```
self.cht_prefersNavigationBarHidden = YES;
```
即可。

- 解决由于以上第2点导致的`UINavigationBar`错乱的问题(针对iOS10以下系统)：

这个Bug可以查看一下`FDFullscreenPopGesture`这个[Issue97](https://github.com/forkingdog/FDFullscreenPopGesture/issues/97)。

具体情况可以看下图：

![bug_gif](https://github.com/ChanRoy/CHTNavigationController/blob/master/CHTNavigationControllerDemo_bug.gif)

简单描述下出现Bug的情况：

>假设有A、B、C、D四个VC，A、D不隐藏导航栏，B、C隐藏导航栏，开始的时候从Apush到B，再从B push到C。这时候使用系统返回手势往回pop到一半但是不要让C完全pop出，不要松开手让C回到原来位置。然后再使用系统返回手势将C出栈。这时候回到A，再从A push到D，会发现**导航栏出现错乱，A的导航栏被带到D的界面上了**。

经过测试，iOS10并没有这个Bug，应该是Apple方面修复了。

对于这个Bug我的处理方式是，判断CHTNavigationController的viewControllers，如果栈顶的两个VC都是隐藏UINavigationBar的，那么将系统的返回手势禁掉，杜绝Bug的发生。

虽然这会造成这个界面的系统返回手势`interactivePopGestureRecognizer`失效，但是折中考虑，还是杜绝Bug比较重要。

各位有更好的方法，欢迎issue。

- 解决`UINavigationBar`的全局颜色设置问题。 

提供一个接口：`cht_barTintColor`方便设置UINavigationBar的颜色。

## 具体使用

1. 使用`CHTNavigationController`替代系统的`UINavigationController`；
2. 引入头文件"#import "CHTNavigationController.h"；
3. 通过`cht_prefersNavigationBarHidden`设置UINavigationBar的显示和隐藏；
4. 通过`cht_interactivePopDisabled`设置当前界面是否打开系统边界返回手势；
5. 通过`cht_barTintColor`设置UINavigationBar的颜色。

## 结语

如有任何问题，欢迎issue。

## License

MIT




