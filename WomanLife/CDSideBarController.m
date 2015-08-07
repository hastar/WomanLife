//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"
//#import "AppDelegate.h"
@implementation CDSideBarController

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;

#pragma mark - 
#pragma mark Init

- (CDSideBarController*)initWithImages:(NSArray*)images
{
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(0, 0, 40, 40);
    [_menuButton setImage:[UIImage imageNamed:@"memo.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    int index = 0;
    for (UIImage *image in [images copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 45 + (75 * index), 45, 45);
        if ([UIScreen mainScreen].bounds.size.height==480) {
            button.frame = CGRectMake(25, 45 + (75 * index), 45, 45);
        }
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}

- (void)insertMenuViewOnView
{
    backView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [backView addGestureRecognizer:singleTap];
    
    for (UIButton *button in _buttonList)
    {
        [_backgroundMenuView addSubview:button];
    }
    _backgroundMenuView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 90,[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height==480) {
        _backgroundMenuView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width+10, 0, 75,[UIScreen mainScreen].bounds.size.height);
    }if ([UIScreen mainScreen].bounds.size.height==568) {
        _backgroundMenuView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width+15, 0, 70,[UIScreen mainScreen].bounds.size.height);
    }
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [backView addSubview:_backgroundMenuView];
    
}

#pragma mark - 
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
    
}

- (void)dismissMenu
{
    if (_isOpen)
    {
        _isOpen = !_isOpen;
       [self performDismissAnimation];
        [backView removeFromSuperview];
    }
    
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
    [[UIApplication sharedApplication].delegate.window addSubview:backView];
//    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:backView];
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _menuButton.alpha = 0.0f;
            _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
    
}
//CG_INLINE CGRect
//CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//{
//    //先得到appdelegate
//    AppDelegate *app= [UIApplication sharedApplication].delegate;
//    
//    
//    CGRect rect;
////    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
////    rect.origin.x = x*app.autoSizeScaleX;//原点的X坐标的改变
////    rect.origin.y = y*app.autoSizeScaleY;//原点的Y坐标的改变
////    rect.size.width = width*app.autoSizeScaleX;//宽的改变
////    rect.size.height = height*app.autoSizeScaleY;//搞得改变
//    return rect;
//}
@end
