//
//  AsyNetworkTool.h
//  CarInformation
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 qinmuchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol AsyNetworkToolDelegate <NSObject>

-(void)asyResult:(id)result;

@end
@interface AsyNetworkTool : NSObject<NSURLConnectionDataDelegate,UIAlertViewDelegate>
@property(weak,nonatomic)id<AsyNetworkToolDelegate> delegate;
#pragma -mark 根据一个URL创建一个异步请求类的对象
-(id)initWithUrlString:(NSString *)urlString;
@end
