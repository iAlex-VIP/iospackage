//
//  UIView+ViewExtension.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "UIView+ViewExtension.h"

@implementation UIView (ViewExtension)

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)maxWidth{
    return (self.x+self.width);
}

- (CGFloat)maxHeight{
    return (self.y+self.height);
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setX:(CGFloat)originX{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)setY:(CGFloat)originY{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}
@end
