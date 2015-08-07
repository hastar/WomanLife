//
//  AppDelegate.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowVC.h"
#import "MyVC.h"
#import "FindVC.h"
#import "HomeVC.h"
//以下为分享功能的相关头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>
#import <ShareSDK/ShareSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeVC *home = [[HomeVC alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    homeNav.tabBarItem.title = @"精选";
    UIImage *image = [UIImage imageNamed:@"精选"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.image = image;

    
    ShowVC *show = [[ShowVC alloc]init];
    UINavigationController *showNav = [[UINavigationController alloc]initWithRootViewController:show];
    showNav.tabBarItem.title = @"美文";
    showNav.tabBarItem.image = [UIImage imageNamed:@"美文"];
    
    FindVC *find = [[FindVC alloc]init];
    UINavigationController *findNav = [[UINavigationController alloc]initWithRootViewController:find];
    findNav.tabBarItem.title = @"发现";
    UIImage *image1 = [UIImage imageNamed:@"发现"];
//    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.tabBarItem.image = image1;
    MyVC *my = [[MyVC alloc]init];
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:my];
    myNav.tabBarItem.title = @"我的";
    NSArray *array = @[homeNav,findNav,showNav];
    UITabBarController *rootTab = [[UITabBarController alloc]init];
    rootTab.viewControllers = array;
    self.window.rootViewController = rootTab;
    [[UITabBar appearance]setTintColor:[UIColor colorWithRed:84/255.0 green:213/255.0 blue:192/255.0 alpha:1.0]];
    
#pragma -mark以下为分享功能的相关代码
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
    //    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
    //                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
    //                              redirectUri:@"http://www.sharesdk.cn"
    //                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    //
    //    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    //    [ShareSDK connectQZoneWithAppKey:@"100371282"
    //                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    //
    //    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    //    [ShareSDK connectQQWithQZoneAppKey:@"801312852"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    //
    //    //添加微信应用  http://open.weixin.qq.com
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
    //                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
    //                           wechatCls:[WXApi class]];
    
    
    //    //添加豆瓣应用  注册网址 http://developers.douban.com
    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
                            appSecret:@"e32896161e72be91"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    
    //添加人人网应用 注册网址  http://dev.renren.com
    //    [ShareSDK connectRenRenWithAppId:@"226427"
    //                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
    //                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
    //                   renrenClientClass:[RennClient class]];
    //
    




    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
