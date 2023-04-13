//
//  ViewController.m
//  SJSlider
//
//  Created by BlueDancer on 2017/6/23.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "ViewController.h"
#import "SJSlider.h"
#import "SJLabelSlider.h"
#import "SJButtonSlider.h"
#import <Masonry.h>

@interface ViewController ()<SJSliderDelegate>

@end

@implementation ViewController {
    SJSlider *slider3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    // 普通状态
    SJSlider *slider0 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 100, 200, 10);
        [self.view addSubview:slider];
        slider.value = 0.1;
        slider.minValue = 0.5;
        slider.maxValue = 1.5;
        slider;
    });

    SJSlider *slider1 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 150, 200, 10);
        [self.view addSubview:slider];

        slider.value = 0.6;

        slider.traceImageView.image = [UIImage imageNamed:@"progress"];
        slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            slider.round = NO;
        });

        slider;
    });


    SJSlider *slider2 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 200, 200, 10);

        [self.view addSubview:slider];

        slider.value = 0.3;

        slider.traceImageView.image = [UIImage imageNamed:@"progress"];

        slider.bufferProgress = 0.8;


        /// show border line.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            slider.borderColor = [UIColor redColor];
            slider.borderWidth = 2;
            slider.round = NO;

            /// hidden border line.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                slider.round = YES;

                /// show
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    slider.round = NO;
                });

            });
        });

        slider;
    });

    SJLabelSlider *l_slider = [SJLabelSlider new];
    l_slider.frame = CGRectMake(50, 250, 300, 40);
    l_slider.slider.value = 0.3;
    l_slider.slider.traceImageView.image = [UIImage imageNamed:@"progress"];
    l_slider.slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    l_slider.leftLabel.text = @"0";
    l_slider.rightlabel.text = @"12";
    l_slider.rightlabel.textColor = l_slider.leftLabel.textColor = [UIColor whiteColor];
    l_slider.spacing = 20; // item spacing
    [self.view addSubview:l_slider];


    SJButtonSlider *b_slider = [SJButtonSlider new];
    b_slider.frame = CGRectMake(50, 300, 300, 40);
    b_slider.leftText = @"00";
    b_slider.rightText = @"00";
    b_slider.slider.value = 0.3;
    b_slider.slider.traceImageView.image = [UIImage imageNamed:@"progress"];
//    b_slider.slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    b_slider.leftText = @"00:00";
    b_slider.rightText = @"12:00";
    b_slider.titleColor = [UIColor whiteColor];
    b_slider.spacing = 20; // item spacing
    [b_slider.slider setThumbCornerRadius:8 size:CGSizeMake(16, 16)];
    [self.view addSubview:b_slider];


    NSLog(@"%@ - %@ - %@", slider0, slider1, slider2);

    
    
    
    
    
    slider3 = [SJSlider new];
    slider3.frame = CGRectMake(50, 350, 300, 80);
    slider3.backgroundColor = [UIColor colorWithWhite:0.382 alpha:0.614];

    // set thumb
    slider3.thumbImageView.backgroundColor = [UIColor yellowColor];
    [slider3 setThumbCornerRadius:20 size:CGSizeMake(40, 40)];

    // track height
    slider3.trackHeight = 8;

    // border
    slider3.borderColor = [UIColor purpleColor];
    slider3.delegate = self;
    [self.view addSubview:slider3];

    slider3.expand = 30;             // 左右区域扩大30
    slider3.thumbOutsideSpace = 0;   // 拇指越界比例
    slider3.minValue = 0;
    slider3.maxValue = 400;
    
    slider3.promptLabel.textColor = [UIColor whiteColor];
    slider3.promptLabel.font = [UIFont boldSystemFontOfSize:14];
    slider3.promptSpacing = 6;
    
    // 开启点击跳转
    slider3.tap.enabled = YES;
    
    // 正在加载
    slider3.isLoading = YES;
    
    slider3.loadingColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buffer:(UISlider *)sender {
    slider3.bufferProgress = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sliderWillBeginDragging:(SJSlider *)slider {
    slider.promptLabel.hidden = NO;
    slider.promptLabel.text = [NSString stringWithFormat:@"%.02f", slider.value];
}

- (void)sliderDidDrag:(SJSlider *)slider {
    slider.promptLabel.text = [NSString stringWithFormat:@"%.02f", slider.value];
}

- (void)sliderDidEndDragging:(SJSlider *)slider {
    slider.promptLabel.hidden = YES;
}

@end
