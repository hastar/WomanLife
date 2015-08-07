//
//  CDSideBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeVC.h"
@protocol CDSideBarControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end

@interface CDSideBarController : NSObject
{
//    UIView              *_backgroundMenuView;
//    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
    UIView *backView;
}
@property (nonatomic, strong) UIView *backgroundMenuView;
@property (nonatomic, strong) UIButton *menuButton;

@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<CDSideBarControllerDelegate> delegate;

- (CDSideBarController*)initWithImages:(NSArray*)buttonList;
//- (UIButton *)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)insertMenuViewOnView;
@end
