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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.slider = [[SJSlider alloc] init];
    
    _slider.frame = CGRectMake(20, 100, 200, 10);
    
    [self.view addSubview:self.slider];
    
    _slider.value = 0.5;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
