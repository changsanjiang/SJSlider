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

@property (nonatomic, strong) SJSlider *slider;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.slider = [[SJSlider alloc] init];
    
    _slider.frame = CGRectMake(20, 100, 200, 10);
    
    [self.view addSubview:self.slider];
    
    _slider.value = 0.5;
    
    
    SJSlider *slider = [SJSlider new];
    
    slider.frame = CGRectMake(20, 120, 200, 10);
    
    [self.view addSubview:slider];
    
    slider.value = 0.6;
    
    slider.traceImageView.image = [UIImage imageNamed:@"progress"];
    slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
