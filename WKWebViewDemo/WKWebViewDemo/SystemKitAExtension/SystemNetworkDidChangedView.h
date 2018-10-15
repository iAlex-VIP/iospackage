//
//  SystemNetworkDidChangedView.h
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNetworkDidChangedView : NSObject

+(void)wifiNetworkAlert;

+(void)thirdGNetworkAlert;

+(void)noNetworkAlert;

+(void)otherNetworkAlert;


@end
