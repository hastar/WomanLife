//
//  FindSecCell.m
//  WomanLife
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "FindSecCell.h"

@interface FindSecCell()
{
    CGFloat _w;
    CGFloat _h;
}
@end

@implementation FindSecCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _w = [UIScreen mainScreen].bounds.size.width;
        self.findImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, _w/3, 85)];
        [self.contentView addSubview:self.findImage];
        self.titilLabel = [[UILabel alloc]initWithFrame:CGRectMake(_w/3+10, 5, _w-(_w/3+25), 60)];
        self.titilLabel.font = [UIFont systemFontOfSize:14];
        self.titilLabel.numberOfLines = 0;
//        self.titilLabel.textColor = [UIColor blackColor];
        self.titilLabel.textColor = [UIColor purpleColor];
        //        self.titilLabel.textColor = [UIColor colorWithRed:137 green:30 blue:169 alpha:1];
        [self.contentView addSubview:self.titilLabel];
        
        self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_w/3+10, 65, _w-(_w/3+25), 30)];
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
