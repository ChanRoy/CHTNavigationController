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

@property (nonatomic, assign) BOOL cht_prefersNavigationBarHidden;

@property (nonatomic, assign) BOOL cht_interactivePopDisabled;

@end
