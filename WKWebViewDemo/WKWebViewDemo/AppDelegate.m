//
//  AppDelegate.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "AppDelegate.h"
#import "SystemNavigationViewController.h"
#import "SystemRootViewController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "UIDevice+DeviceModel.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
  
    
    
    
    
    self.isFirstLoad = YES;
    [self startNetworkMonitoring];
    [self UMpushuSetting:launchOptions];
    SystemRootViewController *rootViewController = [[SystemRootViewController alloc] init];
    SystemNavigationViewController *nav = [[SystemNavigationViewController alloc] initWithRootViewController:rootViewController];
    nav.deviceMask = UIInterfaceOrientationMaskPortrait;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor colorWithRed:220/255.0 green:59/255.0 blue:64/255.0 alpha:1]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)startNetworkMonitoring{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    self.networkStatus = manager.networkReachabilityStatus;
    [manager startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)networkingStatusDidChanged:(NSNotification*)info{
    NSDictionary *inforDict = [info userInfo];
    NSString *statusStr = [SharedSystemModel getStringFrom:inforDict key:AFNetworkingReachabilityNotificationStatusItem];
    if (statusStr == nil || [statusStr blankString]) {
        statusStr = [SharedSystemModel getStringFrom:inforDict key:@"LCNetworkingReachabilityNotificationStatusItem"];
    }
    
    NSInteger status   = [statusStr integerValue];
    if (self.isFirstLoad == YES) {
        self.isFirstLoad = NO;
        self.networkStatus = status;
        return;
    }
    
    if (status == self.networkStatus)return;
    
    self.networkStatus = status;
    if (status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [SystemNetworkDidChangedView thirdGNetworkAlert];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            [SystemNetworkDidChangedView wifiNetworkAlert];
        }else{
            [SystemNetworkDidChangedView otherNetworkAlert];
        }
    }else{
        [SystemNetworkDidChangedView noNetworkAlert];
    }
}

-(void)UMpushuSetting:(NSDictionary *)launchOptions{
    
    [UMessage startWithAppkey:@"5ba9f7c3b465f526a3000682" launchOptions:launchOptions httpsEnable:YES ];
    [UMessage openDebugMode:YES];
    //    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //    [UMessage addLaunchMessageWithWindow:self.window finishViewController:[board instantiateInitialViewController]];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    [UMessage setLogEnabled:YES];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *stringToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"======>%@", stringToken);
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    [UMessage registerDeviceToken:deviceToken];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        //        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
}

@end
