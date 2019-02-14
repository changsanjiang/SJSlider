//
//  SJSlider.m
//  Pods-SJSlider_Example
//
//  Created by BlueDancer on 2018/5/9.
//

#import "SJSlider.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJSliderImageView : UIImageView
@property (nonatomic, copy) void(^setImageExeBlock)(SJSliderImageView *imageView);
@end

@implementation SJSliderImageView
- (void)setImage:(nullable UIImage *)image {
    [super setImage:image];
    if ( _setImageExeBlock ) _setImageExeBlock(self);
}
@end

@interface SJSlider ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readonly) UIView *containerView;

/// buffer
@property (nonatomic, strong) UIView *bufferProgressView;
@property (nonatomic, strong) UIColor *bufferProgressColor;
@property (nonatomic) BOOL enableBufferProgress;
@property (nonatomic) CGFloat bufferProgress;

/// border
@property (null_resettable, nonatomic, strong) UIColor *borderColor;
@property (nonatomic) BOOL visualBorder;
@property (nonatomic) CGFloat borderWidth;

/// prompt
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic) CGFloat promptSpacing;
@end

#pragma mark -
@implementation SJSlider {
    UILabel *_promptLabel;
    NSLayoutConstraint *_promptLabelBottomConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _setupDefaultValues];
    [self _setupView];
    [self _setupGestrue];
    [self _needUpdateContainerCornerRadius];
    return self;
}

- (void)_setupDefaultValues {
    _animaMaxDuration = 0.5;
    _trackHeight = 8;
    _maxValue = 1;
    _minValue = 0;
    _round = YES;
    _value = 0;
    _thumbOutsideSpace = 0.382;
    self.promptSpacing = 4.0;
    _loadingColor = [UIColor blackColor];
}

- (void)_setupGestrue {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGR:)];
    _pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:_pan];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGR:)];
    _tap.delaysTouchesBegan = YES;
    [self addGestureRecognizer:_tap];
    
    [_tap requireGestureRecognizerToFail:_pan];
    
    _tap.enabled = NO;
}

- (void)handlePanGR:(UIPanGestureRecognizer *)pan {
    CGFloat offset = [pan translationInView:pan.view].x;
    CGFloat add = ( offset / _containerView.bounds.size.width) * ( _maxValue - _minValue );
    [self setValue:self.value + add animated:YES];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch ( pan.state ) {
        case UIGestureRecognizerStateBegan: {
            _isDragging = YES;
            if ( [self.delegate respondsToSelector:@selector(sliderWillBeginDragging:)] ) {
                [self.delegate sliderWillBeginDragging:self];
            }
        }
        case UIGestureRecognizerStateChanged: {
            if ( [self.delegate respondsToSelector:@selector(sliderDidDrag:)] ) {
                [self.delegate sliderDidDrag:self];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            if ( [self.delegate respondsToSelector:@selector(sliderDidEndDragging:)] ) {
                [self.delegate sliderDidEndDragging:self];
            }
            _isDragging = NO;
        }
            break;
        default:
            break;
    }
}

- (void)handleTapGR:(UITapGestureRecognizer *)tap {
    if ( _containerView.frame.size.width == 0 ) return;
    CGFloat point = [tap locationInView:tap.view].x;
    CGFloat value = point / _containerView.frame.size.width * (_maxValue - _minValue);
    if ( _tappedExeBlock ) _tappedExeBlock(self, value);
    else [self setValue:value animated:YES];
}

#pragma mark -

- (void)setRound:(BOOL)round {
    if ( round == _round ) return;
    _round = round;
    [self _needUpdateContainerCornerRadius];
}

- (void)setTrackHeight:(CGFloat)trackHeight {
    _trackHeight = trackHeight;
    [self _needUpdateContainerCornerRadius];
    [self _needUpdateContainerLayout];
}

- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius
                        size:(CGSize)size {
    [self setThumbCornerRadius:thumbCornerRadius size:size thumbBackgroundColor:[UIColor greenColor]];
}

- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius
                        size:(CGSize)size
        thumbBackgroundColor:(UIColor *)thumbBackgroundColor {
    self.thumbImageView.layer.masksToBounds = NO;
    self.thumbImageView.layer.shadowColor = [UIColor colorWithWhite:0.382 alpha:0.614].CGColor;
    self.thumbImageView.layer.shadowOpacity = 1;
    self.thumbImageView.layer.shadowOffset = CGSizeMake(0.001, 0.2);
    self.thumbImageView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:thumbCornerRadius].CGPath;
    self.thumbImageView.layer.cornerRadius = thumbCornerRadius;
    self.thumbImageView.backgroundColor = thumbBackgroundColor;
    [self _updateThumbSize:size];
}

- (void)setValue:(CGFloat)value {
    [self setValue:value animated:NO];
}

- (void)setValue:(CGFloat)value_new animated:(BOOL)animated {
    CGFloat value_old = _value;
    if      ( value_new < _minValue ) value_new = _minValue;
    else if ( value_new > _maxValue ) value_new = _maxValue;

    if ( _minValue >= _maxValue || value_new == _value || isnan(value_new) || isinf(value_new) )
        return;
    _value = value_new;
    
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    if ( animated ) {
        CGFloat duration = 0;
        if ( animated ) duration = [self _calculateAnimaDuration:value_new - value_old];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animated ? duration : 0];
        [self _needUpdateTraceLayout];
        [UIView commitAnimations];
    }
    else {
        [self _needUpdateTraceLayout];
    }
}

/// add 此次增加的值
- (CGFloat)_calculateAnimaDuration:(CGFloat)add {
    add = ABS(add);
    CGFloat sum = _maxValue - _minValue;
    if ( isnan(sum) || sum <= 0 ) sum = 0.001;
    CGFloat scale = add / sum;
    return _animaMaxDuration * scale + 0.08/**/;
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    if ( isLoading ) [self.indicatorView startAnimating];
    else [self.indicatorView stopAnimating];
}

- (void)setLoadingColor:(UIColor *)loadingColor {
    _loadingColor = loadingColor;
    _indicatorView.color = loadingColor;
}

#pragma mark -
- (void)_setupView {
    _containerView = [UIView new];
    _containerView.clipsToBounds = YES;
    
    SJSliderImageView *(^makeImageView)(void) = ^SJSliderImageView *{
        SJSliderImageView *imageView = [SJSliderImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeCenter;
        return imageView;
    };
    
    _traceImageView = makeImageView();
    _trackImageView = makeImageView();
    _thumbImageView = makeImageView();
    __weak typeof(self) _self = self;
    [(SJSliderImageView *)_thumbImageView setSetImageExeBlock:^(SJSliderImageView * _Nonnull imageView) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        imageView.bounds = (CGRect){CGPointZero, imageView.image.size};
        [self _needUpdateThumbLayout];
    }];
    
    [self addSubview:_containerView];
    [_containerView addSubview:self.trackImageView];
    [_containerView addSubview:self.traceImageView];
    [self addSubview:self.thumbImageView];
    
    _traceImageView.backgroundColor = [UIColor greenColor];
    _trackImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _needUpdateContainerLayout];
}

- (UIActivityIndicatorView *)indicatorView {
    if ( _indicatorView ) return _indicatorView;
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    [_thumbImageView addSubview:_indicatorView];
    _indicatorView.color = self.loadingColor;
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_thumbImageView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_thumbImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_thumbImageView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_thumbImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self _needUpdateIndicatorTransform];
    return _indicatorView;
}

#pragma mark - slider
- (void)_needUpdateContainerLayout {
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    CGFloat maxW = self.frame.size.width;
    CGFloat maxH = self.frame.size.height;
    
    CGFloat containerW = maxW - _expand * 2;
    CGFloat contaienrH = _trackHeight;
    _containerView.bounds = (CGRect){0, 0, containerW, contaienrH};
    _containerView.center = (CGPoint){maxW * 0.5, maxH * 0.5};
    [self _needUpdateTrackLayout];
    if ( self.enableBufferProgress ) [self _needUpdateBufferLayout];
}

- (void)_needUpdateContainerCornerRadius {
    if ( _round ) _containerView.layer.cornerRadius = _trackHeight * 0.5;
    else _containerView.layer.cornerRadius = 0.0;
}

- (void)_needUpdateTrackLayout {
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    CGFloat trackW = _containerView.frame.size.width;
    CGFloat trackH = _containerView.frame.size.height;
    _trackImageView.frame = CGRectMake(0, 0, trackW, trackH);
    [self _needUpdateTraceLayout];
}

- (void)_needUpdateTraceLayout {
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    if ( isnan(_value) ||
         isnan(_maxValue) ||
         isnan(_minValue) ) {
        return;
    }
    
    if ( isinf(_value) ||
         isinf(_maxValue) ||
         isinf(_minValue) ) {
        return;
    }
    
    if ( _maxValue <= _minValue ) {
        return;
    }
    
    CGFloat maxW = _containerView.frame.size.width;
    CGFloat sum = _maxValue - _minValue;
    CGFloat traceW = maxW * (_value - _minValue) / sum;
    CGFloat traceH = _containerView.frame.size.height;
    _traceImageView.frame = CGRectMake(0, 0, traceW, traceH);
    [self _needUpdateThumbLayout];
}

- (void)_needUpdateThumbLayout {
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    if ( CGSizeEqualToSize(CGSizeZero, _thumbImageView.bounds.size) ) {
        return;
    }
    
    CGFloat height = self.frame.size.height;
    
    CGFloat thumbW = _thumbImageView.frame.size.width;
    CGFloat outside = ceil(_thumbImageView.frame.size.width * _thumbOutsideSpace);
    CGFloat minCenterX = _expand - outside + thumbW * 0.5;
    CGFloat maxCenterX = _containerView.bounds.size.width - thumbW * 0.5 + outside + _expand;

    CGFloat tracePosition = _traceImageView.frame.size.width + _expand;
    if ( tracePosition <= minCenterX ) tracePosition = minCenterX;
    else if ( tracePosition >= maxCenterX ) tracePosition = maxCenterX;
    _thumbImageView.center = CGPointMake(tracePosition, height * 0.5);
}

- (void)_updateThumbSize:(CGSize)size {
    _thumbImageView.bounds = (CGRect){CGPointZero, size};
    [self _needUpdateThumbLayout];
    [self _needUpdateIndicatorTransform];
}

- (void)_needUpdateIndicatorTransform {
    _indicatorView.transform = CGAffineTransformMakeScale(_thumbImageView.bounds.size.width / 16 * 0.6, _thumbImageView.bounds.size.height / 16 * 0.6);
}

#pragma mark - buffer

- (void)setEnableBufferProgress:(BOOL)enableBufferProgress {
    if ( enableBufferProgress == _enableBufferProgress ) return;
    _enableBufferProgress = enableBufferProgress;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( enableBufferProgress ) {
            UIView *bufferView = [self bufferProgressView];
            [self.containerView insertSubview:bufferView aboveSubview:self.trackImageView];
            bufferView.frame = CGRectMake(0, 0, 0, self.containerView.frame.size.height);
            CGFloat bufferProgress = self.bufferProgress;
            if ( 0 != bufferProgress ) [self _needUpdateBufferLayout];
        }
        else {
            [[self bufferProgressView] removeFromSuperview];
        }
    });
}

@synthesize bufferProgressColor = _bufferProgressColor;
- (UIColor *)bufferProgressColor {
    if ( _bufferProgressColor ) return _bufferProgressColor;
    return [UIColor grayColor];
}

- (void)setBufferProgressColor:(UIColor *)bufferProgressColor {
    _bufferProgressColor = bufferProgressColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bufferProgressView.backgroundColor = bufferProgressColor;
    });
}

@synthesize bufferProgress = _bufferProgress;
- (void)setBufferProgress:(CGFloat)bufferProgress {
    if ( isnan(bufferProgress) ) return;
    if ( bufferProgress < 0 ) bufferProgress = 0;
    else if ( bufferProgress > 1 ) bufferProgress = 1;
    _bufferProgress = bufferProgress;
    [self _needUpdateBufferLayout];
}

@synthesize bufferProgressView = _bufferProgressView;
- (UIView *)bufferProgressView {
    if ( _bufferProgressView ) return _bufferProgressView;
    _bufferProgressView = [UIView new];
    _bufferProgressView.backgroundColor = self.bufferProgressColor;
    return _bufferProgressView;
}

- (void)_needUpdateBufferLayout {
    if ( CGSizeEqualToSize(CGSizeZero, self.bounds.size) ) {
        return;
    }
    
    UIView *bufferView = [self bufferProgressView];
    CGFloat width = self.bufferProgress * self.containerView.frame.size.width;
    CGRect frame = bufferView.frame;
    frame.size.height = self.containerView.frame.size.height;
    frame.size.width = width;
    bufferView.frame = frame;
}


#pragma mark - border

@synthesize visualBorder = _visualBorder;
- (void)setVisualBorder:(BOOL)visualBorder {
    if ( _visualBorder == visualBorder ) return;
    if ( visualBorder ) {
        _containerView.layer.borderColor = _borderColor.CGColor;
        _containerView.layer.borderWidth = _borderWidth;
    }
    else {
        _containerView.layer.borderColor = nil;
        _containerView.layer.borderWidth = 0;
    }
}

@synthesize borderColor = _borderColor;
- (void)setBorderColor:(UIColor * __nullable)borderColor {
    _borderColor = borderColor;
    if ( _visualBorder ) _containerView.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    if ( _borderColor ) return _borderColor;
    return [UIColor lightGrayColor];
}

@synthesize borderWidth = _borderWidth;
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    if ( _visualBorder ) _containerView.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    CGFloat width = [objc_getAssociatedObject(self, _cmd) doubleValue];
    if ( width != 0 ) return width;
    return 0.4;
}

#pragma mark - prompt

- (UILabel *)promptLabel {
    if ( _promptLabel ) return _promptLabel;
    _promptLabel = [[UILabel alloc] init];
    [self addSubview:_promptLabel];
    _promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_traceImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:_promptLabelBottomConstraint = [NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_thumbImageView attribute:NSLayoutAttributeTop multiplier:1 constant:-_promptSpacing]];
    return _promptLabel;
}

- (void)setPromptSpacing:(CGFloat)promptSpacing {
    _promptSpacing = promptSpacing;
    _promptLabelBottomConstraint.constant = -promptSpacing;
}
@end
NS_ASSUME_NONNULL_END
