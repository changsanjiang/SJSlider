//
//  SJSlider.m
//  dancebaby
//
//  Created by BlueDancer on 2017/6/12.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJSlider.h"

#import <Masonry/Masonry.h>

#import <objc/message.h>




@interface UIView (SJExtension)
@property (nonatomic, assign) CGFloat csj_x;
@property (nonatomic, assign) CGFloat csj_y;
@property (nonatomic, assign) CGFloat csj_w;
@property (nonatomic, assign) CGFloat csj_h;
@end


@implementation UIView (SJExtension)
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
@end





@interface SJContainerView : UIView
/*!
 *  default is YES.
 */
@property (nonatomic, assign, readwrite) BOOL isRound;
@end

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
    if ( _isRound ) self.layer.cornerRadius = MIN(self.csj_w, self.csj_h) * 0.5;
    else self.layer.cornerRadius = 0;
}

- (void)setIsRound:(BOOL)isRound {
    _isRound = isRound;
    if ( _isRound ) self.layer.cornerRadius = MIN(self.csj_w, self.csj_h) * 0.5;
    else self.layer.cornerRadius = 0;
}

@end



// MARK: 观察处理

@interface SJSlider (DBObservers)

- (void)_SJSliderObservers;

- (void)_SJSliderRemoveObservers;

@end




@interface SJSlider ()

@property (nonatomic, strong, readonly) SJContainerView *containerView;

@end







@implementation SJSlider

@synthesize containerView = _containerView;
@synthesize trackImageView = _trackImageView;
@synthesize traceImageView = _traceImageView;
@synthesize thumbImageView = _thumbImageView;
@synthesize pan = _pan;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    
    [self _SJSliderObservers];
    
    [self _SJSliderSetupUI];
    
    [self _SJSliderInitialize];
    
    [self _SJSliderPanGR];
    
    
    return self;
}

// MARK: Setter

- (void)setIsRound:(BOOL)isRound {
    _isRound = isRound;
    _containerView.isRound = isRound;
}

- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius size:(CGSize)size {
    [self setThumbCornerRadius:thumbCornerRadius size:size thumbBackgroundColor:[UIColor greenColor]];
}

- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius
                        size:(CGSize)size
        thumbBackgroundColor:(UIColor *)thumbBackgroundColor {
    self.thumbImageView.layer.cornerRadius = thumbCornerRadius;
    self.thumbImageView.backgroundColor = thumbBackgroundColor;
    if ( 0 != thumbCornerRadius ) {
        self.thumbImageView.layer.masksToBounds = NO;
        self.thumbImageView.layer.shadowColor = [UIColor colorWithWhite:0.382 alpha:0.614].CGColor;
        self.thumbImageView.layer.shadowOpacity = 1;
        self.thumbImageView.layer.shadowOffset = CGSizeMake(0.001, 0.2);
        self.thumbImageView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:thumbCornerRadius].CGPath;
        [self.thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(size);
        }];
    }
    else {
        self.thumbImageView.layer.masksToBounds = YES;
        self.thumbImageView.layer.shadowOpacity = 0;
        [_thumbImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_thumbImageView.superview);
            make.centerX.equalTo(_traceImageView.mas_trailing);
        }];
    }
}

- (void)setTrackHeight:(CGFloat)trackHeight {
    if ( trackHeight == _trackHeight ) return;
    _trackHeight = trackHeight;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(trackHeight);
    }];
}

- (void)setValue:(CGFloat)value {
    if ( isnan(value) ) return;
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
    self.borderWidth = 0.4;
    self.borderColor = [UIColor lightGrayColor];
    self.isRound = YES;
    
    self.enableBufferProgress = NO;
    self.bufferProgress = 0;
    self.bufferProgressColor = [UIColor grayColor];
    
}

- (CGFloat)rate {
    if ( 0 == _maxValue - _minValue ) return 0;
    return (_value - _minValue) / ( _maxValue - _minValue);
}

// MARK: PanGR

- (void)_SJSliderPanGR {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGR:)];
    [self addGestureRecognizer:_pan];
}

- (void)handlePanGR:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            _isDragging = YES;
            if ( ![self.delegate respondsToSelector:@selector(sliderWillBeginDragging:)] ) break;
            [self.delegate sliderWillBeginDragging:self];
        }
        case UIGestureRecognizerStateChanged: {
            if ( ![self.delegate respondsToSelector:@selector(sliderDidDrag:)] ) break;
            [self.delegate sliderDidDrag:self];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            _isDragging = NO;
            if ( ![self.delegate respondsToSelector:@selector(sliderDidEndDragging:)] ) break;
            [self.delegate sliderDidEndDragging:self];
        }
            break;
        default:
            break;
    }
    CGFloat offset = [pan translationInView:pan.view].x;
    self.value += ( offset / _containerView.csj_w) * ( _maxValue - _minValue );
    [pan setTranslation:CGPointZero inView:pan.view];
}

// MARK: UI

- (void)_SJSliderSetupUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.trackImageView];
    [self.containerView addSubview:self.traceImageView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.centerY.offset(0);
    }];
    
    [_trackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_traceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.offset(0);
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
    _traceImageView.frame = CGRectZero;
    _traceImageView.backgroundColor = [UIColor greenColor];
    return _traceImageView;
}

- (UIImageView *)thumbImageView {
    if ( _thumbImageView ) return _thumbImageView;
    _thumbImageView = [self imageViewWithImageStr:@""];
    [self addSubview:_thumbImageView];
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_thumbImageView.superview);
        make.centerX.equalTo(_traceImageView.mas_trailing);
    }];
    return _thumbImageView;
}

- (UIImageView *)imageViewWithImageStr:(NSString *)imageStr {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    imageView.contentMode = UIViewContentModeCenter;
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

static NSLayoutConstraint *__traceWidthConstraint;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context  {
    if ( ![keyPath isEqualToString:@"value"] ) return;
    CGFloat sub = _maxValue - _minValue;
    if ( sub == 0 ) return;
    if ( __traceWidthConstraint ) {
        [self.containerView removeConstraint:__traceWidthConstraint];
    }
    
    __traceWidthConstraint = [NSLayoutConstraint constraintWithItem:self.traceImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeWidth multiplier:self.value / sub constant:0];
    [self.containerView addConstraint:__traceWidthConstraint];
}

@end





#pragma mark - Buffer

@implementation SJSlider (SJBufferProgress)

- (BOOL)enableBufferProgress {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnableBufferProgress:(BOOL)enableBufferProgress {
    if ( enableBufferProgress == self.enableBufferProgress ) return;
    objc_setAssociatedObject(self, @selector(enableBufferProgress), @(enableBufferProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( enableBufferProgress ) {
            [self.containerView insertSubview:[self bufferProgressView] aboveSubview:self.trackImageView];
            [[self bufferProgressView] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.bottom.offset(0);
            }];
            CGFloat bufferProgress = self.bufferProgress;
            if ( 0 != bufferProgress ) self.bufferProgress = bufferProgress; // update
        }
        else {
            [[self bufferProgressView] removeFromSuperview];
        }
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

static NSLayoutConstraint *bufferProgressWidthConstraint;
- (void)setBufferProgress:(CGFloat)bufferProgress {
    if ( isnan(bufferProgress) ) return;
    if      ( bufferProgress > 1 ) bufferProgress = 1;
    else if ( bufferProgress < 0 ) bufferProgress = 0;
    objc_setAssociatedObject(self, @selector(bufferProgress), @(bufferProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( !self.bufferProgressView.superview ) return ;
        if ( bufferProgressWidthConstraint ) {
            [self.containerView removeConstraint:bufferProgressWidthConstraint];
        }
        bufferProgressWidthConstraint = [NSLayoutConstraint constraintWithItem:[self bufferProgressView] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self containerView] attribute:NSLayoutAttributeWidth multiplier:bufferProgress constant:0];
        [self.containerView addConstraint:bufferProgressWidthConstraint];
    });
}

- (UIView *)bufferProgressView {
    UIView *bufferProgressView = objc_getAssociatedObject(self, _cmd);
    if ( bufferProgressView ) return bufferProgressView;
    bufferProgressView = [UIView new];
    objc_setAssociatedObject(self, _cmd, bufferProgressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bufferProgressView;
}

@end



#pragma mark - Border


@implementation SJSlider (BorderLine)

- (void)setVisualBorder:(BOOL)visualBorder {
    if ( self.visualBorder == visualBorder ) return;
    objc_setAssociatedObject(self, @selector(visualBorder), @(visualBorder), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( visualBorder ) {
        _containerView.layer.borderColor = self.borderColor.CGColor;
        _containerView.layer.borderWidth = self.borderWidth;
    }
    else {
        _containerView.layer.borderColor = nil;
        _containerView.layer.borderWidth = 0;
    }
}

- (BOOL)visualBorder {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, @selector(borderColor), borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( self.visualBorder ) _containerView.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    objc_setAssociatedObject(self, @selector(borderWidth), @(borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( self.visualBorder ) _containerView.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

@end

