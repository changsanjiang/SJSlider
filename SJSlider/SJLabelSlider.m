//
//  SJLabelSlider.m
//  SJSlider
//
//  Created by BlueDancer on 2017/11/20.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJLabelSlider.h"
#import <Masonry/Masonry.h>


@interface SJLabelSlider ()

@end

@implementation SJLabelSlider
@synthesize leftLabel = _leftLabel;
@synthesize rightlabel = _rightlabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self _labelSetupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self _labelSetupView];
    }
    return self;
}

- (void)_labelSetupView {
    [self.leftContainerView addSubview:self.leftLabel];
    [self.rightContainerView addSubview:self.rightlabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->_leftLabel.superview);
    }];
    
    [_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->_rightlabel.superview);
    }];
}

- (UILabel *)leftLabel {
    if ( _leftLabel ) return _leftLabel;
    _leftLabel = [self _createLabel];
    return _leftLabel;
}

- (UILabel *)rightlabel {
    if ( _rightlabel ) return _rightlabel;
    _rightlabel = [self _createLabel];
    return _rightlabel;
}

- (UILabel *)_createLabel {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"0";
    [label sizeToFit];
    return label;
}
- (void)setLeftText:(nullable NSString *)leftText {
    _leftLabel.text = leftText;
}
- (nullable NSString *)leftText {
    return _leftLabel.text;
}

- (void)setRightText:(nullable NSString *)rightText {
    _rightlabel.text = rightText;
}
- (NSString *)rightText {
    return _rightlabel.text;
}

- (void)setLeftTextColor:(nullable UIColor *)leftTextColor {
    _leftLabel.textColor = leftTextColor;
}
- (UIColor *)leftTextColor {
    return _leftLabel.textColor;
}

- (void)setRightTextColor:(nullable UIColor *)rightTextColor {
    _rightlabel.textColor = rightTextColor;
}
- (UIColor *)rightTextColor {
    return _rightlabel.textColor;
}

- (void)setFont:(nullable UIFont *)font {
    _leftLabel.font = font;
    _rightlabel.font = font;
}
- (UIFont *)font {
    return _leftLabel.font;
}
@end
