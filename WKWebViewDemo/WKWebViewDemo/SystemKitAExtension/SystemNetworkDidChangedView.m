//
//  SystemNetworkDidChangedView.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "SystemNetworkDidChangedView.h"

#define NetworkDisconnectedTitle        @"网络连接已断开"
#define ConnectedByOtherConnectedTitle  @"已连接互联网"
#define ConnectedBy3GConnectedTitle     @"当前为运营商网络"
#define ConnectedByWifiTitle            @"已连接到本地WiFi"


@implementation SystemNetworkDidChangedView

+(void)noNetworkAlert{
    [self showViewWithTitle:NetworkDisconnectedTitle
                  withImage:[UIImage imageNamed:@"configWeilianjie"]
        withBackgroundColor:ConfigSixteenColor(0x999999, 1)];
}

+(void)otherNetworkAlert{
    [self showViewWithTitle:ConnectedByOtherConnectedTitle
                  withImage:[UIImage imageNamed:@"configYilianjie"]
        withBackgroundColor:ConfigSixteenColor(0xfb7272, 1)];
}

+(void)thirdGNetworkAlert{
    [self showViewWithTitle:ConnectedBy3GConnectedTitle
                  withImage:[UIImage imageNamed:@"configFengwo"]
        withBackgroundColor:ConfigSixteenColor(0xfc6363, 1)];
}

+(void)wifiNetworkAlert{
    [self showViewWithTitle:ConnectedByWifiTitle
                  withImage:[UIImage imageNamed:@"configWuxianwang"]
        withBackgroundColor:ConfigSixteenColor(0xfb7272, 1)];
}

+(UIView*)showViewWithTitle:(NSString*)title withImage:(UIImage*)image withBackgroundColor:(UIColor*)color{
    UIView *view = [[AppDelegate sharedDelegate].window viewWithTag:6688];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, -ConfigHeight, ConfigWidth, hConfigNaviBarHeight)];
        [view setTag:6688];
        [[AppDelegate sharedDelegate].window addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, cStatusBarHeight+(cNaviBarABXHeight - 30)*0.5, 30, 30)];
        [view addSubview:imageView];
        [imageView setTag:111];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, imageView.frame.origin.y, ConfigWidth - 70, 25)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:18]];
        [label setTag:222];
        [view addSubview:label];
    }
    
    [view setBackgroundColor:color];
    
    UIImageView *imageView = [view viewWithTag:111];
    if (imageView) {
        [imageView setImage:image];
    }
    
    UILabel *label = [view viewWithTag:222];
    if (label) {
        [label setText:title];
        label.centerY = imageView.centerY;
    }
    
    [self showView];
    
    return view;
}


+ (void)networkAlerViewDismiss{
    UIView *view = [[AppDelegate sharedDelegate].window viewWithTag:6688];
    if (view) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             view.frame = CGRectMake(0, -hConfigNaviBarHeight, ConfigWidth, hConfigNaviBarHeight);
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

+ (void)showView{
    UIView *view = [[AppDelegate sharedDelegate].window viewWithTag:6688];
    if (view) {
        view.frame = CGRectMake(0, - hConfigNaviBarHeight, ConfigWidth, hConfigNaviBarHeight);
        [UIView animateWithDuration:0.25
                         animations:^{
                             view.frame = CGRectMake(0, 0, ConfigWidth, hConfigNaviBarHeight);
                         }
                         completion:^(BOOL finished) {
                             [self performSelector:@selector(networkAlerViewDismiss)
                                        withObject:nil
                                        afterDelay:1.5];
                         }];
    }
}

@end
