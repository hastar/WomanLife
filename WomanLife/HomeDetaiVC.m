//
//  HomeDetaiVC.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "HomeDetaiVC.h"
#import "MBProgressHUD.h"//小菊花
#import <ShareSDK/ShareSDK.h>


@interface HomeDetaiVC ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

#define HomeDetailPageUrl @"http://t.gexiaojie.com/index.php?m=mobile&c=explorer&a=article&aid="
@implementation HomeDetaiVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置分享按钮
    self.navigationController.navigationBar.hidden = YES;
    UIView *label = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    label.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:236/255.0 alpha:1.0];
    [self.view addSubview:label];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(10, 20, 25, 30);
    [button1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(toback) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:button1];


    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame. size.width, self.view.frame.size.height)];
//    self.webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HomeDetailPageUrl,self.hModel.homeID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    /*-------------------------小菊花-----------------------------------*/
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode  = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.view.frame.size.width-70, 15, 60, 40);
    [button setImage:[UIImage imageNamed:@"radio_share.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toShare:) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:button];

    //1秒后关闭
    [self performSelector:@selector(doRemoveHud) withObject:_webView afterDelay:2];
    
   }

-(void)toback
{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toShare:(id)sender
{      //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"从少女到妈妈，每个女人都需要智慧的生活，在这里“女人慧生活“为你提供品质生活内容，涵盖美哒哒、时尚、居家、慧生活、情感、旅游、晚安美文等。赶快到APP STORE上免费下载吧~"
                                           defaultContent:@"从少女到妈妈，每个女人都需要智慧的生活，在这里“女人慧生活“为你提供品质生活内容，涵盖美哒哒、时尚、居家、慧生活、情感、旅游、晚安美文等。赶快到APP STORE上免费下载吧~"
                                                    image:[ShareSDK imageWithPath:@"/Users/lan/Desktop/demo/ai_comic/1.jpg"]
                                                    title:@"女人慧生活"
                                                      url:@"http://www.mob.com"
                                              description:@"女人慧生活"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                            }];

}
- (void) viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)doRemoveHud
{
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
