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
#import <objc/message.h>

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

@property (nonatomic, strong, readonly) SJContainerView *containerView;

@property (nonatomic, strong, readonly) UIView *bufferProgressView;

@end






// MARK: SJSlider (SJBufferProgress)

@implementation SJSlider (SJBufferProgress)

- (BOOL)enableBufferProgress {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnableBufferProgress:(BOOL)enableBufferProgress {
    objc_setAssociatedObject(self, @selector(enableBufferProgress), @(enableBufferProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bufferProgressView.hidden = !enableBufferProgress;
    });
    
}

- (UIColor *)bufferProgressColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBufferProgressColor:(UIColor *)bufferProgressColor {
    if ( !bufferProgressColor ) return;
    objc_setAssociatedObject(self, @selector(bufferProgressColor), bufferProgressColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bufferProgressView.backgroundColor = bufferProgressColor;
    });
    
}

- (CGFloat)bufferProgress {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBufferProgress:(CGFloat)bufferProgress {
    if      ( bufferProgress > 1 ) bufferProgress = 1;
    else if ( bufferProgress < 0 ) bufferProgress = 0;
    objc_setAssociatedObject(self, @selector(bufferProgress), @(bufferProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bufferProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(bufferProgress * self.containerView.csj_w);
        }];
    });
    
}

@end




@implementation SJSlider

@synthesize containerView = _containerView;
@synthesize trackImageView = _trackImageView;
@synthesize traceImageView = _traceImageView;
@synthesize thumbImageView = _thumbImageView;
@synthesize bufferProgressView = _bufferProgressView;
@synthesize pan = _pan;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    
    [self _SJSliderSetupUI];
    
    [self _SJSliderInitialize];
    
    [self _SJSliderPanGR];
    
    [self _SJSliderObservers];
    
    return self;
}

// MARK: Setter

- (void)setTrackHeight:(CGFloat)trackHeight {
    _trackHeight = trackHeight;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self.trackHeight);
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


// MARK: 初始化参数

- (void)_SJSliderInitialize {
    
    self.trackHeight = 8.0;
    self.minValue = 0.0;
    self.maxValue = 1.0;
    
    self.enableBufferProgress = NO;
    self.bufferProgress = 0;
    self.bufferProgressColor = [UIColor grayColor];
    
}

// MARK: Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.csj_w * self.rate;
    CGFloat h = self.csj_h;
    _traceImageView.frame = CGRectMake(x, y, w, h);
}

- (CGFloat)rate {
    if ( 0 == self.maxValue - self.minValue ) return 0;
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
    self.value += offset.x * 0.00365;
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
}

// MARK: UI

- (void)_SJSliderSetupUI {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.trackImageView];
    [self.containerView addSubview:self.bufferProgressView];
    [self.containerView addSubview:self.traceImageView];
    [self addSubview:self.thumbImageView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.center.offset(0);
    }];
    
    [_trackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_traceImageView.mas_trailing);
        make.centerY.equalTo(_thumbImageView.superview);
    }];
    
    [_bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.offset(0);
        make.width.offset(0);
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

- (UIView *)bufferProgressView {
    if ( _bufferProgressView ) return _bufferProgressView;
    _bufferProgressView = [UIView new];
    return _bufferProgressView;
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
    _traceImageView.csj_w = self.csj_w * self.rate;
}


@end
