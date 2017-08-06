//
//  ViewController.m
//  SJSlider
//
//  Created by BlueDancer on 2017/6/23.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "ViewController.h"
#import "SJSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    SJSlider *slider0 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 100, 200, 10);
        
        [self.view addSubview:slider];
        
        slider.value = 0.5;
        
        slider;
    });
    
    SJSlider *slider1 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 120, 200, 10);
        
        [self.view addSubview:slider];
        
        slider.value = 0.6;
        
        slider.traceImageView.image = [UIImage imageNamed:@"progress"];
        slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
        
        slider;
    });
    
    
    SJSlider *slider2 = ({
        SJSlider *slider = [SJSlider new];
        slider.frame = CGRectMake(20, 140, 200, 10);
        
        [self.view addSubview:slider];
        
        slider.value = 0.6;
        
        slider.traceImageView.image = [UIImage imageNamed:@"progress"];
        
        slider.enableBufferProgress = YES;
        slider.bufferProgress = 0.3;
        
        slider;
    });
    
    NSLog(@"%@ - %@ - %@", slider0, slider1, slider2);
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
