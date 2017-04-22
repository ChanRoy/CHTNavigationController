# CHTNavigationController

自定义NavigationController，主要解决以下问题：

1. 解决自定义`导航栏返回按钮`后系统返回手势失效的问题；
2. 解决从有`UINavigationBar`的界面跳转到没有`UINavigationBar`的界面时的过渡问题；
3. 解决由于以上第2点导致的`UINavigationBar`错乱的问题(针对iOS10以下系统)；
4. 解决`UINavigationBar`的全局颜色设置问题。 

效果图如下（iOS10以上能达到完美过渡，但是iOS10以下会有一个小Bug，后面细说）：

![](https://github.com/ChanRoy/CHTNavigationController/blob/master/CHTNavigationControllerDemo.gif)

下面简要说明下前面提到的四个问题：

- 解决自定义`导航栏返回按钮`后系统返回手势失效的问题：

主要是继承系统的`UINavigationController`，然后在适当的时候打开和关闭系统的返回手势`interactivePopGestureRecognizer`。

具体可查看`CHTNavigationController.m`，不再赘述。

- 解决从有`UINavigationBar`的界面跳转到没有`UINavigationBar`的界面时的过渡问题：

未完待续。。。