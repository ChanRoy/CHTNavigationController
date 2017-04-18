//
//  QFHKNavigationController.h
//  QFangWangHK
//
//  Created by cht on 17/3/17.
//  Copyright © 2016年 qfangwanghk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  解决自定义leftBarButton后，系统自带手势返回失效的问题
 */
@interface QFHKNavigationController : UINavigationController

@end

@interface UIViewController (CHTNavigationBarHidden)

@property (nonatomic, assign) BOOL cht_prefersNavigationBarHidden;

@property (nonatomic, assign) BOOL cht_interactivePopDisabled;

@end
