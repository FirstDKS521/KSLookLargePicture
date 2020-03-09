//
//  KSLargeImageView.m
//  KSLookLargePicture
//
//  Created by aDu on 2019/11/24.
//  Copyright © 2019 aDu. All rights reserved.
//

#import "KSLargeImageView.h"
#import <SDWebImage.h>

@interface KSLargeImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation KSLargeImageView

+ (void)showLargeView:(NSString *)imgUrl {
    KSLargeImageView *largeView = [KSLargeImageView new];
    [largeView setImgUrl:imgUrl];
}

- (void)setImgUrl:(NSString *)imgUrl {
//    self = [super init];
//    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self addSubview:self.scrollView];
        __weak __typeof(self) weakSelf = self;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.image = image;
        }];
//    }
//    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imgView.image = image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat maxHeight = self.scrollView.bounds.size.height;
    CGFloat maxWidth = self.scrollView.bounds.size.width;
    //如果图片尺寸大于view尺寸，按比例缩放
    if (width > maxWidth || height > width) {
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if (ratio < maxRatio) {
            width = maxWidth;
            height = width*ratio;
        } else {
            height = maxHeight;
            width = height / ratio;
        }
    }
    self.imgView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
}

- (void)handleDoubleTap1:(UITapGestureRecognizer *)recongnizer {
    if (recongnizer.numberOfTouchesRequired == 2) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer {
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.scrollView.zoomScale == self.scrollView.minimumZoomScale;
            CGFloat scale = zoomOut?self.scrollView.maximumZoomScale:self.scrollView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.zoomScale = scale;
                if (zoomOut) {
                    CGFloat x = touchPoint.x*scale - self.scrollView.bounds.size.width / 2;
                    CGFloat maxX = self.scrollView.contentSize.width-self.scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.scrollView.bounds.size.height / 2;
                    CGFloat maxY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark ====== UIScrollViewDelegate ======
//指定缩放UIScrolleView时，缩放UIImageView来适配
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

//缩放后让图片显示到屏幕中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imgView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

#pragma mark ====== init ======
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = self.bounds;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;//最大缩放倍数
        _scrollView.minimumZoomScale = 1;//最小缩放倍数
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap1:)];
        _singleTap.delegate = self;
        [_scrollView addGestureRecognizer:_singleTap];
    }
    return _scrollView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.userInteractionEnabled = YES;
        self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [_doubleTap setNumberOfTapsRequired:2];
        [_imgView addGestureRecognizer:_doubleTap];//添加双击手势
        
        [_singleTap requireGestureRecognizerToFail:_doubleTap];
        [self.scrollView addSubview:_imgView];
    }
    return _imgView;
}

@end
