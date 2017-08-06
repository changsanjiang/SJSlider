//
//  UIView+Extension.h
//  CSJQQMusic
//
//  Created by ya on 12/21/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat csj_x;
@property (nonatomic, assign) CGFloat csj_y;
@property (nonatomic, assign) CGFloat csj_w;
@property (nonatomic, assign) CGFloat csj_h;
@property (nonatomic, assign) CGFloat csj_centerX;
@property (nonatomic, assign) CGFloat csj_centerY;

@property (nonatomic, strong, readonly) UIImage *csj_currentSnapshot;
@property (nonatomic, strong, readonly) UIViewController *csj_viewController;

 // MARK: -  设置中心点
- (void)csj_centerWithView:(UIView *)view;

 // MARK: -  ⚠️ 视图底部 用OC 画虚线, 需要把代码拷贝到 drawRect中.
- (void)csj_lyXuXian;

 // MARK: -  切圆
- (void)csj_cornerRadius;

@end
