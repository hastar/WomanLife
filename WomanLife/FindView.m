//
//  FindView.m
//  WomanLife
//
//  Created by 陈瑞花 on 15/7/27.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "FindView.h"

@interface FindView()
{
    CGFloat _w;
    CGFloat _h;
}
@end
@implementation FindView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _w = [UIScreen mainScreen].bounds.size.width;
        _h = [UIScreen mainScreen].bounds.size.height;

//        self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _w, _h/3-44)];
//        self.bottomScrollView.contentSize = CGSizeMake(_w, _h/3-44);
//        [self addSubview:self.bottomScrollView];
        
        self.fimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, _w, _h/3-44)];
        [self addSubview:self.fimageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, _h/3-78, _w-25, 30)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [self.fimageView addSubview:self.titleLabel];

    }
    return self;
}

@end
