//
//  NewestMainPageFooterView.h
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NewestMainPageFooterStyle) {
    NewestMainPageFooterHome = 1000,
    NewestMainPageFooterBack,
    NewestMainPageFooterGoForward,
    NewestMainPageFooterRefresh
};

@protocol NewestMainPageFooterViewDelegate <NSObject>

@optional

- (void)mainPageFooterIteDidClicked:(NewestMainPageFooterStyle)style;

@end

@interface NewestMainPageFooterView : UIView

@property (nonatomic,assign) id<NewestMainPageFooterViewDelegate>delegate;

@end
