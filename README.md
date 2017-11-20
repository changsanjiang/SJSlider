# SJSlider
滑块视图     

pod 'SJSlider'    

<img src = "https://github.com/changsanjiang/SJSlider/blob/master/SJSliderProjectFile/SJSlider/sample.png">

### 进度(支持 AutoLayout)
<img src = "https://github.com/changsanjiang/SJSlider/blob/master/SJSliderProjectFile/SJSlider/WechatIMG88.png">
```Objective-C
    SJSlider *slider = [SJSlider new];
    [self.view addSubview:slider];
    slider.frame = CGRectMake(20, 100, 200, 10);
    slider.value = 0.5;
```

### 滑块 + 不切圆角
<img src = "https://github.com/changsanjiang/SJSlider/blob/master/SJSliderProjectFile/SJSlider/WechatIMG88.png">
```Objective-C
    SJSlider *slider = [SJSlider new];
    [self.view addSubview:slider];
    slider.isRound = NO;
    slider.frame = CGRectMake(20, 100, 200, 10);
    slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    slider.value = 0.5;
```

### 缓冲
<img src = "https://github.com/changsanjiang/SJSlider/blob/master/SJSliderProjectFile/SJSlider/WechatIMG87.png">
```Objective-C
    SJSlider *slider = [SJSlider new];
    [self.view addSubview:slider];
    slider.isRound = NO;
    slider.frame = CGRectMake(20, 100, 200, 10);
    slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    slider.value = 0.5;
    slider.enableBufferProgress = YES;
    slider.bufferProgress = 0.8;
```

### 左右标签
<img src = "https://github.com/changsanjiang/SJSlider/blob/master/SJSliderProjectFile/SJSlider/WechatIMG89.png">
```Objective-C
    SJButtonSlider *b_slider = [SJButtonSlider new];
    b_slider.frame = CGRectMake(50, 300, 300, 40);
    b_slider.slider.value = 0.3;
    b_slider.slider.thumbImageView.image = [UIImage imageNamed:@"thumb"];
    b_slider.leftText = @"00:00";
    b_slider.rightText = @"12:00";
    b_slider.titleColor = [UIColor whiteColor];
    [self.view addSubview:b_slider];
```
