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

@interface ViewController ()

@end

@implementation ViewController {
    SJSlider *slider3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
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
        slider.fixThumb = 4;
        [self.view addSubview:slider];

        slider.value = 0.6;

        slider.traceImageView.image = [UIImage imageNamed:@"progress"];
        slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            slider.isRound = NO;
        });

        slider;
    });


    SJSlider *slider2 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 200, 200, 10);

        [self.view addSubview:slider];

        slider.value = 0.3;

        slider.traceImageView.image = [UIImage imageNamed:@"progress"];

        slider.enableBufferProgress = YES;
        slider.bufferProgress = 0.8;


        /// show border line.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            slider.visualBorder = YES;
            slider.borderColor = [UIColor redColor];
            slider.borderWidth = 2;
            slider.isRound = NO;

            /// hidden border line.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                slider.visualBorder = NO;
                slider.isRound = YES;

                /// show
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    slider.visualBorder = YES;
                    slider.isRound = NO;
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
    l_slider.slider.fixThumb = 4;
    l_slider.leftLabel.text = @"0";
    l_slider.rightlabel.text = @"12";
    l_slider.rightlabel.textColor = l_slider.leftLabel.textColor = [UIColor whiteColor];
    l_slider.spacing = 20; // item spacing
    [self.view addSubview:l_slider];


    SJButtonSlider *b_slider = [SJButtonSlider new];
    b_slider.frame = CGRectMake(50, 300, 300, 40);
    b_slider.slider.value = 0.3;
    b_slider.slider.traceImageView.image = [UIImage imageNamed:@"progress"];
    b_slider.slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    b_slider.slider.fixThumb = 4;
    b_slider.leftText = @"00:00";
    b_slider.rightText = @"12:00";
    b_slider.titleColor = [UIColor whiteColor];
    b_slider.spacing = 20; // item spacing
    [self.view addSubview:b_slider];


    NSLog(@"%@ - %@ - %@", slider0, slider1, slider2);

    slider3 = [SJSlider new];
    slider3.frame = CGRectMake(50, 350, 300, 40);
    slider3.backgroundColor = [UIColor colorWithWhite:0.382 alpha:0.614];

    // set thumb
    slider3.thumbImageView.backgroundColor = [UIColor yellowColor];
    [slider3 setThumbCornerRadius:8 size:CGSizeMake(16, 16)];

    // track height
    slider3.trackHeight = 8;

    // border
    slider3.visualBorder = YES;
    slider3.borderColor = [UIColor purpleColor];
    [self.view addSubview:slider3];


    slider3.minValue = 0;
    slider3.maxValue = 400;
    slider3.value = 50;

    // buffer
    slider3.enableBufferProgress = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buffer:(UISlider *)sender {
    slider3.bufferProgress = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
