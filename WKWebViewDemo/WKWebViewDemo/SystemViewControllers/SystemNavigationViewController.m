
//
//  SystemNavigationViewController.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "SystemNavigationViewController.h"

@interface SystemNavigationViewController ()

@end

@implementation SystemNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.deviceMask = UIInterfaceOrientationMaskAll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.deviceMask;
}

@end
