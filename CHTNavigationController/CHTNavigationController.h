//
//  CHTNavigationController.h
//  CHTNavigationControllerDemo
//
//  Created by cht on 2017/4/22.
//  Copyright © 2017年 cht. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  解决自定义leftBarButton后，系统自带手势返回失效的问题
 */
@interface CHTNavigationController : UINavigationController

@end


@interface UIViewController (CHTNavigationBarHidden)

/**
 设置UINavigationBar的显示和隐藏
 */
@property (nonatomic, assign) BOOL cht_prefersNavigationBarHidden;

/**
 设置当前界面是否打开系统边界返回手势
 */
@property (nonatomic, assign) BOOL cht_interactivePopDisabled;

/**
 设置UINavigationBar的颜色
 */
@property (nonatomic, strong) UIColor *cht_barTintColor;

@end
