
//
//  SystemRootViewController.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "SystemRootViewController.h"
#import "SystemContentViewController.h"
#import "SystemNavigationViewController.h"

@interface SystemRootViewController ()
{
    UIImageView *backgroundImageView;
}
@end

@implementation SystemRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:iPhoneX?@"defaulIconX":@"defaulIcon"]];
    [self.view addSubview:backgroundImageView];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:85.0/255.0 blue:84.0/255.0 alpha:1];
    backgroundImageView.backgroundColor =  [UIColor colorWithRed:220/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    
    
   
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SystemContentViewController *rootViewController = [[SystemContentViewController alloc] init];
        rootViewController.urlString = @"http://lvcp.vip";
        SystemNavigationViewController *nav = [[SystemNavigationViewController alloc] initWithRootViewController:rootViewController];
        nav.deviceMask = UIInterfaceOrientationMaskAll;
        [AppDelegate sharedDelegate].window.rootViewController = nav;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
