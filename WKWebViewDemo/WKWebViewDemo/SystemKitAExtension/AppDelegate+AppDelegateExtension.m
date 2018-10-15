//
//  AppDelegate+AppDelegateExtension.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "AppDelegate+AppDelegateExtension.h"

@implementation AppDelegate (AppDelegateExtension)

+(AppDelegate*)sharedDelegate{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

@end
