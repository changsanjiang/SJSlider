//
//  SJLabelSlider.h
//  SJSlider
//
//  Created by BlueDancer on 2017/11/20.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJCommonSlider.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 *  two label each on the left and right.
 *  You can adjust the spacing by setting `spacing`.
 *
 *  两个标签, 分别在左边和右边.
 *  你可以设置父类中的`spacing`, 来调整他们之间的间距.
 **/
@interface SJLabelSlider : SJCommonSlider
@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *rightlabel;

@property (nonatomic, copy, nullable) NSString *leftText;
@property (nonatomic, copy, nullable) NSString *rightText;
@property (nonatomic, strong, null_resettable) UIColor *leftTextColor;
@property (nonatomic, strong, null_resettable) UIColor *rightTextColor;
@property (nonatomic, strong, null_resettable) UIFont *font;
@end
NS_ASSUME_NONNULL_END
