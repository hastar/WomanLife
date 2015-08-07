//
//  AsyNetworkTool.m
//  CarInformation
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 qinmuchun. All rights reserved.
//

#import "AsyNetworkTool.h"
//对于一些私有的属性或者方法，没必要在.h接口文件中公开的尽量写在延展中，有助于代码的封装和别人的使用
@interface AsyNetworkTool ()
//用来接收数据的data
@property(nonatomic,strong)NSMutableData *recevieData;
@end

@implementation AsyNetworkTool

-(id)initWithUrlString:(NSString *)urlString
{
    if ([super init])
    {
        //1、根据参数传递过来的URL字符串创建URL对象
        NSURL *url = [NSURL URLWithString:urlString];
        //2、根据URL对象封装requset请求对象
        NSURLRequest *requset = [NSURLRequest requestWithURL:url];
        //3、发送请求并且设置代理
        [NSURLConnection connectionWithRequest:requset delegate:self];
    }
    return self;
}
//4、异步请求类的协议方法的实现
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //初始化接收数据的data
    self.recevieData = [[NSMutableData alloc] init];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //拼接数据
    [self.recevieData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.recevieData options:NSJSONReadingMutableContainers error:nil];
   
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(asyResult:)])
    {
        [self.delegate asyResult:dic];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"啊哦" message:@"可能是网络连接失败，请检查网络后刷新页面。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
