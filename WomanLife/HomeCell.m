//
//  HomeCell.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell()
{
    CGFloat _w;
    CGFloat _h;
}
@end

@implementation HomeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _w = [UIScreen mainScreen].bounds.size.width;
        self.homeImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, _w/3, 85)];
        [self.contentView addSubview:self.imageView];
        self.titilLabel = [[UILabel alloc]initWithFrame:CGRectMake(_w/3+10, 5, _w-(_w/3+25), 30)];
        self.titilLabel.font = [UIFont systemFontOfSize:16];
        self.titilLabel.numberOfLines = 0;
        self.titilLabel.textColor = [UIColor purpleColor];
        //        self.titilLabel.textColor = [UIColor colorWithRed:137 green:30 blue:169 alpha:1];
        [self.contentView addSubview:self.titilLabel];
        
        self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_w/3+10, 40, _w-(_w/3+25), 40)];
        self.summaryLabel.font = [UIFont systemFontOfSize:13];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.summaryLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
