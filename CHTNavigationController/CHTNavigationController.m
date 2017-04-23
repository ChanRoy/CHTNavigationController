//
//  CHTNavigationController.m
//  CHTNavigationControllerDemo
//
//  Created by cht on 2017/4/22.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTNavigationController.h"

#import <objc/runtime.h>

#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface CHTNavigationController ()<UINavigationControllerDelegate>

@end

@implementation CHTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    __weak typeof(self) weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.delegate = weakSelf;
    }
}

//防止push的时候触发滑动手势造成崩溃
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES ){
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

//防止pop的时候触发滑动手势造成崩溃
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES ){
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return  [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES){
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

//加载下个vc后打开手势
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.interactivePopGestureRecognizer.enabled = !viewController.cht_interactivePopDisabled;
    }
    
    //防止在根控制器中push卡死
    // if rootViewController, set delegate nil
    if (navigationController.viewControllers.count == 1) {
        
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIViewController (CHTNavigationBarHidden)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(cht_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)cht_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self cht_viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count) {

        if (FSystemVersion < 10.0) {
            NSInteger count = self.navigationController.viewControllers.count;
            
            if (count > 1) {
                
                BOOL flag = self.cht_prefersNavigationBarHidden && self.navigationController.viewControllers[count-2].cht_prefersNavigationBarHidden;
                
                self.cht_interactivePopDisabled = flag;
            }
        }

        [self.navigationController setNavigationBarHidden:self.cht_prefersNavigationBarHidden animated:animated];
    }

    if (self.cht_barTintColor) {
        
        if (self.navigationController && self.cht_prefersNavigationBarHidden == NO) {
            
            [self cht_getBackView:self.navigationController.navigationBar color:[UIColor yellowColor]];
        }
    }
}

#pragma mark - 设navigationBar的背景颜色
- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (FSystemVersion < 10) {
        
        // <iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            view.backgroundColor = color;
        }else if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]){
            
            //将_UINavigationBarBackground上面的遮罩层隐藏
            view.hidden = YES;
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
    }
    
#ifdef __IPHONE_10_0
    else{
        // >=iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] ||
            [view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
            
            view.backgroundColor = color;
            
            if ([view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
                
                ((UIVisualEffectView *)view).hidden = YES;
                
            }else{
                
                [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                UIView *overlay = [[UIView alloc] initWithFrame:view.bounds];
                overlay.backgroundColor = color;
                overlay.userInteractionEnabled = NO;
                overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                
                [view insertSubview:overlay atIndex:0];
            }
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
        self.navigationController.navigationBar.barTintColor = color;
    }
#endif
}

//add property: prefersNavigationBarHidden
- (BOOL)cht_prefersNavigationBarHidden{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCht_prefersNavigationBarHidden:(BOOL)cht_prefersNavigationBarHidden{
    
    objc_setAssociatedObject(self, @selector(cht_prefersNavigationBarHidden), @(cht_prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//add property: interactivePopDisabled
- (BOOL)cht_interactivePopDisabled{

    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCht_interactivePopDisabled:(BOOL)cht_interactivePopDisabled{
    
    objc_setAssociatedObject(self, @selector(cht_interactivePopDisabled), @(cht_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//add property: barTintColor
- (UIColor *)cht_barTintColor{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCht_barTintColor:(UIColor *)cht_barTintColor{
    
    objc_setAssociatedObject(self, @selector(cht_barTintColor), cht_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

