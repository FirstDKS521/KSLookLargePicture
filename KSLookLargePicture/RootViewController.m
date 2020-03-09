//
//  RootViewController.m
//  KSLookLargePicture
//
//  Created by aDu on 2019/11/24.
//  Copyright © 2019 aDu. All rights reserved.
//

#import "RootViewController.h"
#import "KSLargeImageView.h"
#import <SDWebImage.h>

static NSString *imgUrl = @"http://img.sccnn.com/bimg/341/15387.jpg";
@interface RootViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看大图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgView = [UIImageView new];
    _imgView.frame = CGRectMake(50, 100, 150, 90);
    _imgView.userInteractionEnabled = YES;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [_imgView addGestureRecognizer:tap];
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
//    pinchGR.delegate = self; //
    [_imgView addGestureRecognizer:pinchGR];
    
    [self.view addSubview:_imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 230, 100, 45);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"查看大图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    NSLog(@"");
}

- (void)tap {
    
}

- (void)clickBtn {
    [KSLargeImageView showLargeView:imgUrl];
}

@end
