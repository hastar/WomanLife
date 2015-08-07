//
//  SecondHCell.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "SecondHCell.h"

@interface SecondHCell()
{
    CGFloat _w;
    CGFloat _h;
}
@end

@implementation SecondHCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _w = [UIScreen mainScreen].bounds.size.width;
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, (_w-10), 30)];
        self.titleL.font = [UIFont systemFontOfSize:16];
        self.titleL.textColor = [UIColor purpleColor];
        [self.contentView addSubview:self.titleL];
        
        self.sImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 35, (_w-10), 100)];
        [self.contentView addSubview:self.sImageView];
        
        self.summaryL = [[UILabel alloc]initWithFrame:CGRectMake(5, 140, (_w-10), 40)];
        self.summaryL.font = [UIFont systemFontOfSize:13];
        self.summaryL.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.summaryL];
        
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
