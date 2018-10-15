//
//  NSString+StringExtension.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "NSString+StringExtension.h"

@implementation NSString (StringExtension)

- (BOOL)blankString{
    if (![self isKindOfClass:[NSString class]] ){
        return  YES;
    }
    if ([self isEqual:[NSNull null]]){
        return  YES;
    }
    if (self == NULL || [self isEqual:nil] || [self isEqual:Nil] || self == nil){
        return  YES;
    }
    if([self isEqualToString:@"(null)"]){
        return  YES;
    }
    if([self isEqualToString:@"<null>"]){
        return  YES;
    }
    if (self.length == 0 || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return  YES;
    }
    return NO;
}


@end
