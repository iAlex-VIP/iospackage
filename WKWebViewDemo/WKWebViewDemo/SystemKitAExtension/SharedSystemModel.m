//
//  SharedSystemModel.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "SharedSystemModel.h"

@implementation SharedSystemModel

+(BOOL)deviceIsPortrait{
    UIInterfaceOrientation interface = [UIApplication sharedApplication].statusBarOrientation;
    if (interface == UIInterfaceOrientationLandscapeLeft || interface == UIInterfaceOrientationLandscapeRight) {// 横屏
        return NO;
    }
    return YES;
}

+ (NSString *)getStringFrom:(NSDictionary*)dict key:(id)key{
    NSString *string = @"";
    if (dict && [dict objectForKey:key]) {
        string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
    }
    if (string == nil || [string blankString]) {
        string = @"";
    }
    return string;
}

@end
