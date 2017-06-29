//
//  SJSlider.h
//  dancebaby
//
//  Created by BlueDancer on 2017/6/12.
//  Copyright © 2017年 hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SJSliderOrientation) {
    /*!
     *  横着
     */
    SJSliderOrientationSidewards = 0,
    
    /*!
     *  竖着
     */
    SJSliderOrientationEndways,
};

@protocol SJSliderDelegate;

@interface SJSlider : UIView

@property (nonatomic, assign, readonly) SJSliderOrientation orientation;

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
 *  设置轨道厚度. default is 8.0;
 */
@property (nonatomic, assign, readwrite) CGFloat thickness;

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

- (instancetype)initWithOrientation:(SJSliderOrientation)orientation;

@end


@protocol SJSliderDelegate <NSObject>

- (void)slidingOnSlider:(SJSlider *)slider;

- (void)slidesOnSlider:(SJSlider *)slider;

@end
