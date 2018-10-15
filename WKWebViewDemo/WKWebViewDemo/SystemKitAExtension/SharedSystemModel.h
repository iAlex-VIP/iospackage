//
//  SharedSystemModel.h
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedSystemModel : NSObject

+(BOOL)deviceIsPortrait;
+ (NSString *)getStringFrom:(NSDictionary*)dict key:(id)key;

@end
