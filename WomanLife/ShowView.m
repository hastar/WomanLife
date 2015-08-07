//
//  ShowView.m
//  WomanLife
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "ShowView.h"
@interface ShowView()
{
    CGFloat _w;
    CGFloat _h;
    CGFloat height;
}
@end
@implementation ShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setupSubviews
{
    _w = [UIScreen mainScreen].bounds.size.width;
    _h = [UIScreen mainScreen].bounds.size.height;
    self.backgroundColor = [UIColor colorWithRed:120 green:128 blue:130 alpha:1];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _w, _h-49)];
 
    [self addSubview:self.bottomScrollView];

    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 3, 150, 25)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.bottomScrollView addSubview:self.timeLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 40, 375, 30)];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.bottomScrollView addSubview:self.titleLabel];
    
    self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 85, 45, 25)];
    self.authorLabel.text = @"作者,";
    self.authorLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.bottomScrollView addSubview:self.authorLabel];
    
    self.authorIntroL = [[UILabel alloc]initWithFrame:CGRectMake(50, 85, 320, 25)];
    self.authorIntroL.font = [UIFont fontWithName:@"Helvetica" size:15];
    [self.bottomScrollView addSubview:self.authorIntroL];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 125, _w-14, 50)];
//    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    [self.bottomScrollView addSubview:self.textLabel];
    //此时textlabel。text是空的，所以调用次方法时也是heigt为0；
//    [self adjustSubviewsWithContent];
    
}
//自适应高度
-(void)adjustSubviewsWithContent
{
    CGFloat unchange = 125;
    
    CGRect texrlRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(_w-14, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14]} context:nil];
    height = unchange + texrlRect.size.height;
    self.bottomScrollView.contentSize = CGSizeMake(0, height);
    CGRect textViewRect = self.textLabel.frame;
    textViewRect.size.height = texrlRect.size.height;
    self.textLabel.frame = textViewRect;
    NSLog(@"%f",self.textLabel.frame.size.height);
    
}

-(void)pandungaodu
{
    CGFloat unchange = 125;
    if (height>=6300) {
        CGRect texrlRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(_w-14, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12]} context:nil];
        height = unchange + texrlRect.size.height;
    self.bottomScrollView.contentSize = CGSizeMake(0, height);
    CGRect textViewRect = self.textLabel.frame;
    textViewRect.size.height = texrlRect.size.height;
    self.textLabel.frame = textViewRect;
    NSLog(@"%f",self.textLabel.frame.size.height);
    }
}


@end
