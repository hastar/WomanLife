//
//  ShowView.h
//  WomanLife
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowView : UIView
@property(nonatomic,strong)UIScrollView *bottomScrollView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *authorLabel;
@property(nonatomic,strong)UILabel *authorIntroL;
@property(nonatomic,strong)UILabel *textLabel;




- (void)setupSubviews;

- (void)adjustSubviewsWithContent;
-(void)pandungaodu;
@end
