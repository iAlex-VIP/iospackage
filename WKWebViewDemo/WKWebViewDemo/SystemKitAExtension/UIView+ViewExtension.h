//
//  UIView+ViewExtension.h
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewExtension)

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign,readonly) CGFloat maxWidth;
@property (nonatomic,assign,readonly) CGFloat maxHeight;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

@end
