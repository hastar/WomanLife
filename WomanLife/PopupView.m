//
//  PopupView.m
//  LastRow
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 Yan. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"

#import "UIImageView+WebCache.h"
@interface PopupView ()
{
    CGFloat _w;
    CGFloat _h;
}
@end
@implementation PopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _w = [UIScreen mainScreen].bounds.size.width;
        _h = [UIScreen mainScreen].bounds.size.height;
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;

        self.backgroundColor =[UIColor colorWithRed:255/255.0 green:250/250.0 blue:240/250.0 alpha:1.000];
        CGFloat w = self.frame.size.width;
        
        UIButton *aboutUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aboutUsButton.frame = CGRectMake(w/4, 80*_h/667, w/2, 30*_h/667);
        [aboutUsButton setTitleColor:[UIColor colorWithWhite:0.375 alpha:1.000] forState:UIControlStateNormal];
        [aboutUsButton addTarget:self action:@selector(aboutUsAction:) forControlEvents:UIControlEventTouchUpInside];
        [aboutUsButton setTitle:@"关于我们" forState:UIControlStateNormal];
        [self addSubview:aboutUsButton];

        UIButton *liabilityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        liabilityButton.frame = CGRectMake(w/4,110*_h/667, w / 2, 30*_h/667);
        [liabilityButton setTitleColor:[UIColor colorWithWhite:0.375 alpha:1.000] forState:UIControlStateNormal];
        [liabilityButton addTarget:self action:@selector(liabilityAction:) forControlEvents:UIControlEventTouchUpInside];
        [liabilityButton setTitle:@"免责声明" forState:UIControlStateNormal];
        [self addSubview:liabilityButton];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(w/4,50*_h/667, w / 2, 30*_h/667);
        [clearButton setTitleColor:[UIColor colorWithWhite:0.375 alpha:1.000] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setTitle:@"清除缓存" forState:UIControlStateNormal];
        [self addSubview:clearButton];
        
      
        //清楚缓存提示板
        self.view = [[UIView alloc] initWithFrame:frame];
        self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/250.0 blue:240/250.0 alpha:1.000];
        self.view.layer.cornerRadius = 15;
        self.view.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _w,20*_h/667)];
        label.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/250.0 blue:240/250.0 alpha:1.000];
        label.text = @"清除成功";
        label.textAlignment = NSTextAlignmentCenter;//设置文本在label中显示的位置，这里为居中
        label.textColor = [UIColor colorWithWhite:0.375 alpha:1.000];
        label.center = self.view.center;
        label.font = [UIFont systemFontOfSize:16*_h/667];
        [self.view addSubview:label];
        
    }
    return self;
}

- (void) clearAction:(UIButton*)button
{
    //清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    //显示
    [self addSubview:self.view];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showClean) userInfo:nil repeats:NO];
}
- (void)showClean
{
    [self.view removeFromSuperview];
}
- (void) aboutUsAction:(UIButton*)button
{

    _innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200*_w/375, 200*_h/665)];
    _innerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/250.0 blue:240/250.0 alpha:1.000];
    _innerView.layer.cornerRadius = 15;
    _innerView.layer.masksToBounds = YES;
    CGFloat w = _innerView.frame.size.width;
    CGFloat h = _innerView.frame.size.height;

    
    [self addSubview:_innerView];
    
    UILabel *aboutUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*_w/375, 5, w -30*_w/375, h-30*_h/665)];
    aboutUsLabel.text = @"     从少女到妈妈，每个女人都需要智慧的生活，在这里“女人慧生活“为你提供品质生活内容，涵盖美哒哒、时尚、居家、慧生活、情感、旅游、晚安美文等。";
    aboutUsLabel.font = [UIFont systemFontOfSize:14];
    aboutUsLabel.numberOfLines  = 0;
    aboutUsLabel.textAlignment = NSTextAlignmentCenter;
    aboutUsLabel.textColor = [UIColor colorWithWhite:0.375 alpha:1.000];

    [_innerView addSubview:aboutUsLabel];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, h - 40, w , 20*_h);
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setTitleColor:[UIColor colorWithWhite:0.375 alpha:1.000] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(removeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"返回" forState:UIControlStateNormal];
    [_innerView addSubview:button1];

    
}


- (void) removeViewAction:(UIButton*)button
{
    [_innerView removeFromSuperview];
}


- (void) liabilityAction:(UIButton*)button
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;

    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/250.0 blue:240/250.0 alpha:1.000];
    [self addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, self.frame.size.height-150*_h/665)];
    label1.text = @"免责声明";
    label1.textColor = [UIColor colorWithWhite:0.375 alpha:1.000];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15*_w/375, 45*_h/665, self.frame.size.width-30, self.frame.size.height-70*_h/665)];
    label2.numberOfLines = 0;
    label2.text = @"   本app所有数据均来源于网络。仅限于观看，学习，娱乐请勿用于商业用途！";
    label2.textColor = [UIColor colorWithWhite:0.375 alpha:1.000];
    label2.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:label1];
    [view addSubview:label2];
}

+ (instancetype) defaultPopuView
{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 200*[UIScreen mainScreen].bounds.size.width/375, 200*[UIScreen mainScreen].bounds.size.height/665)];
}

@end
