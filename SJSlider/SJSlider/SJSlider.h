//
//  SJSlider.h
//  dancebaby
//
//  Created by BlueDancer on 2017/6/12.
//  Copyright © 2017年 hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJSliderDelegate;

@interface SJSlider : UIView

/*!
 *  轨道
 */
@property (nonatomic, strong, readonly) UIImageView *trackImageView;

/*!
 *  走过的痕迹
 */
@property (nonatomic, strong, readonly) UIImageView *traceImageView;

/*!
 *  拇指
 */
@property (nonatomic, strong, readonly) UIImageView *thumbImageView;

/*!
 *  当前进度值
 */
@property (nonatomic, assign, readwrite) CGFloat value;

/*!
 *  设置轨道高度. default is 8.0;
 */
@property (nonatomic, assign, readwrite) CGFloat trackHeight;

/*!
 *  最小值. default is 0.0;
 */
@property (nonatomic, assign, readwrite) CGFloat minValue;

/*!
 *  最大值. default is 1.0;
 */
@property (nonatomic, assign, readwrite) CGFloat maxValue;


@property (nonatomic, weak) id <SJSliderDelegate>delegate;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *pan;


@end


@protocol SJSliderDelegate <NSObject>

- (void)slidingOnSlider:(SJSlider *)slider;

- (void)slidesOnSlider:(SJSlider *)slider;

@end
