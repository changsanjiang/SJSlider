//
//  SJSlider.m
//  dancebaby
//
//  Created by BlueDancer on 2017/6/12.
//  Copyright © 2017年 hunter. All rights reserved.
//

#import "SJSlider.h"
#import "UIView+Extension.h"
#import <Masonry.h>

@interface SJContainerView : UIView @end

@implementation SJContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJContainerViewSetupUI];
    return self;
}

// MARK: UI

- (void)_SJContainerViewSetupUI {
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = MIN(self.csj_w, self.csj_h) * 0.5;
}

@end



// MARK: 观察处理

@interface SJSlider (DBObservers)

- (void)_SJSliderObservers;

- (void)_SJSliderRemoveObservers;

@end


@interface SJSlider ()

/*!
 *  轨道
 */
@property (nonatomic, strong) UIImageView *trackImageView;

/*!
 *  走过的痕迹
 */
@property (nonatomic, strong) UIImageView *traceImageView;


@property (nonatomic, strong, readonly) SJContainerView *containerView;

@property (nonatomic, assign, readwrite) SJSliderOrientation orientation;

@end

@implementation SJSlider

@synthesize containerView = _containerView;
@synthesize trackImageView = _trackImageView;
@synthesize traceImageView = _traceImageView;
@synthesize thumbImageView = _thumbImageView;
@synthesize pan = _pan;

- (instancetype)initWithOrientation:(SJSliderOrientation)orientation {
    self = [super initWithFrame:CGRectZero];
    if ( !self ) return nil;
    [self _SJSliderSetupUI];
    

    self.orientation = orientation;
    
    if      ( _orientation == SJSliderOrientationSidewards )
        self.thickness = 8.0;
    else if ( _orientation == SJSliderOrientationEndways )
        self.thickness = 100.0;
    
    self.minValue = 0.0;
    self.maxValue = 1.0;
    
    [self _SJSliderPanGR];
    
    [self _SJSliderObservers];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithOrientation:SJSliderOrientationSidewards];
}

// MARK: Setter

- (void)setThickness:(CGFloat)thickness {
    _thickness = thickness;
    if      ( _orientation == SJSliderOrientationSidewards )
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(thickness);
        }];
    else if ( _orientation == SJSliderOrientationEndways )
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(thickness);
        }];
}

- (void)setValue:(CGFloat)value {
    if      ( value < self.minValue ) value = self.minValue;
    else if ( value > self.maxValue ) value = self.maxValue;
    _value = value;
}

// MARK: 生命周期

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self _SJSliderRemoveObservers];
}


// MARK: Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    
    if      ( _orientation == SJSliderOrientationSidewards ) {
        w = self.csj_w * self.rate;
        h = self.csj_h;
    }
    else if ( _orientation == SJSliderOrientationEndways ) {
        w = self.csj_w;
        h = self.csj_h * self.rate;
    }
    
    _traceImageView.frame = CGRectMake(x, y, w, h);
}

- (CGFloat)rate {
    return (self.value - self.minValue) / (self.maxValue - self.minValue);
}

// MARK: PanGR

- (void)_SJSliderPanGR {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGR:)];
    [self addGestureRecognizer:_pan];
}

- (void)handlePanGR:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            if ( ![self.delegate respondsToSelector:@selector(slidingOnSlider:)] ) break;
            [self.delegate slidingOnSlider:self];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            if ( ![self.delegate respondsToSelector:@selector(slidesOnSlider:)] ) break;
            [self.delegate slidesOnSlider:self];
        }
            break;
        default:
            break;
    }
    
    CGPoint offset = [pan translationInView:pan.view];
    if      ( _orientation == SJSliderOrientationSidewards ) {
        self.value += offset.x * 0.00365;
    }
    else if ( _orientation == SJSliderOrientationEndways ) {
        self.value += offset.y * 0.00365;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
}

// MARK: Setter

- (void)setOrientation:(SJSliderOrientation)orientation {
    _orientation = orientation;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.center.offset(0);
    }];
//    if      ( _orientation == SJSliderOrientationSidewards ) {
//        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.offset(0);
//            make.center.offset(0);
//        }];    }
//    else if ( _orientation == SJSliderOrientationEndways ) {
//        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.offset(0);
//            make.center.offset(0);
//        }];
//    }
}


// MARK: UI

- (void)_SJSliderSetupUI {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.trackImageView];
    [self.containerView addSubview:self.traceImageView];
    [self addSubview:self.thumbImageView];
    
    [_trackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_traceImageView.mas_trailing);
        make.centerY.equalTo(_thumbImageView.superview);
    }];
}

- (UIView *)containerView {
    if ( _containerView ) return _containerView;
    _containerView = [SJContainerView new];
    return _containerView;
}

- (UIImageView *)trackImageView {
    if ( _trackImageView ) return _trackImageView;
    _trackImageView = [self imageViewWithImageStr:@""];
    _trackImageView.backgroundColor = [UIColor whiteColor];
    return _trackImageView;
}

- (UIImageView *)traceImageView {
    if ( _traceImageView ) return _traceImageView;
    _traceImageView = [self imageViewWithImageStr:@""];
    _traceImageView.backgroundColor = [UIColor greenColor];
    return _traceImageView;
}

- (UIImageView *)thumbImageView {
    if ( _thumbImageView ) return _thumbImageView;
    _thumbImageView = [self imageViewWithImageStr:@""];
    return _thumbImageView;
}

- (UIImageView *)imageViewWithImageStr:(NSString *)imageStr {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

@end



// MARK: Observers

@implementation SJSlider (DBObservers)

- (void)_SJSliderObservers {
    [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_SJSliderRemoveObservers {
    [self removeObserver:self forKeyPath:@"value"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context  {
    if ( ![keyPath isEqualToString:@"value"] ) return;
    if      ( _orientation == SJSliderOrientationSidewards ) {
        _traceImageView.csj_w = self.csj_w * self.rate;
    }
    else if ( _orientation == SJSliderOrientationEndways ) {
        _traceImageView.csj_h = self.csj_h * self.rate;
    }
}


@end
