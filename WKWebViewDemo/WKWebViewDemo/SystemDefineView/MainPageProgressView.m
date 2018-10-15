//
//  MainPageProgressView.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "MainPageProgressView.h"

@implementation MainPageProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)ConfigSixteenColor(0x5de5b3, 1.0).CGColor,
                                 (__bridge id)ConfigSixteenColor(0x1dc889, 1.0).CGColor,
                                 (__bridge id)ConfigSixteenColor(0x06b977, 1.0).CGColor];
        gradientLayer.frame      = CGRectMake(0, 0, ConfigWidth, self.frame.size.height);
        gradientLayer.locations  = @[@0.2,@0.4, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint   = CGPointMake(1.0, 0);
        [self.layer addSublayer:gradientLayer];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}
@end
