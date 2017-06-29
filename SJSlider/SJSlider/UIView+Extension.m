//
//  UIView+Extension.m
//  CSJQQMusic
//
//  Created by ya on 12/21/16.
//  Copyright © 2016 ya. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


- (UIViewController *)csj_viewController {

    if ([self isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)self;
        UIResponder *responder = view.nextResponder;
        while ( ![responder isKindOfClass:[UIViewController class]] ) {
            if ( [responder isMemberOfClass:[UIResponder class]] ) {
                return nil;
            }
            responder = responder.nextResponder;
        }
        return (UIViewController *)responder;
    }

    return nil;
}

 /// 截当前视图, 返回Image.
- (UIImage *)csj_currentSnapshot {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    UIImage *result = nil;
    if ( [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES] ) {
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return result;
}

 /// 视图底部 用OC 画虚线. ⚠️ 需要把代码拷贝到 drawRect中.
- (void)csj_lyXuXian {

    CGRect  rect        = self.bounds;
    CGFloat width       = rect.size.width;
    CGFloat height      = rect.size.height;
    CGFloat gapSpace    = 4.0;
    CGFloat length      = width - gapSpace * 2;
    NSInteger count     = length * 0.5;
    CGFloat startX      = gapSpace;

    UIBezierPath *path  = [UIBezierPath bezierPath];
    for (int i = 0; i < count * 0.5; i ++) {
        [path moveToPoint:CGPointMake(startX + i * 2.0,
                                      height)];

        [path addLineToPoint:CGPointMake(startX + (i + 1) * 2.0,
                                         height)];
        startX += 2.0;
        [path setLineWidth:6.0 / [UIScreen mainScreen].scale];

        /// 颜色
        [UIColor.redColor set];

        /// 绘制
        [path stroke];
    }
}


- (void)setCsj_x:(CGFloat)csj_x {
    CGRect frame    = self.frame;
    frame.origin.x  = csj_x;
    self.frame      = frame;
}
- (CGFloat)csj_x {
    return self.frame.origin.x;
}


- (void)setCsj_y:(CGFloat)csj_y {
    CGRect frame    = self.frame;
    frame.origin.y  = csj_y;
    self.frame      = frame;
}
- (CGFloat)csj_y {
    return self.frame.origin.y;
}


- (void)setCsj_w:(CGFloat)csj_w {
    CGRect frame        = self.frame;
    frame.size.width    = csj_w;
    self.frame          = frame;
}
- (CGFloat)csj_w {
    return self.frame.size.width;
}


- (void)setCsj_h:(CGFloat)csj_h {
    CGRect frame        = self.frame;
    frame.size.height   = csj_h;
    self.frame          = frame;
}
- (CGFloat)csj_h {
    return self.frame.size.height;
}

- (void)csj_centerWithView:(UIView *)view {
    self.center = CGPointMake(view.csj_w * 0.5, view.csj_h * 0.5);
}

- (void)setCsj_centerX:(CGFloat)csj_centerX {
    CGPoint center  = self.center;
    center.x        = csj_centerX;
    self.center     = center;
}
- (CGFloat)csj_centerX {
    return self.center.x;
}


- (void)setCsj_centerY:(CGFloat)csj_centerY {
    CGPoint center  = self.center;
    center.y        = csj_centerY;
    self.center     = center;
}
- (CGFloat)csj_centerY {
    return self.center.y;
}

- (void)csj_cornerRadius {
    CGFloat max = MAX(self.csj_w, self.csj_h);
    self.layer.cornerRadius  = max * 0.5;
    self.clipsToBounds       = YES;
}

@end
