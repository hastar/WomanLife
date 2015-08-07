//
//  ShowVC.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "ShowVC.h"
#import "AsyNetworkTool.h"
#import "ShowView.h"

@interface ShowVC ()<AsyNetworkToolDelegate,UIScrollViewDelegate>
{
    CGFloat with;
    CGFloat heig;
    int aCount;
    int maxCount;
    ShowView *showV;
  
}
@property(nonatomic,strong)UIScrollView *myScroll;
@end

@implementation ShowVC
#define ShowUrl @"http://182.92.9.95:8080/goodNightServer/MaxIdManageServlet?order=get"
#define ShowDetaiUrl @"http://182.92.9.95:8080/goodNightServer/ArticlePageServlet?id="
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"背景2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景2"]];
    self.navigationItem.title = @"每日美文";
    NSURL *url = [NSURL URLWithString:ShowUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSNumber *artCount = dic[@"articlePageMaxId"];
    aCount = [artCount intValue];
    maxCount = aCount;
    with = [UIScreen mainScreen].bounds.size.width;
    heig = [UIScreen mainScreen].bounds.size.height;
    showV = [[ShowView alloc]initWithFrame:CGRectMake(0, 0, with, heig-49)];
    
    [showV setupSubviews];
   showV.backgroundColor = [UIColor colorWithRed:181/255.0 green:218/255.0 blue:194/255.0 alpha:1.0];
//    showV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景2.png"]];
    [self.view addSubview:showV];
    NSString *str1 = [NSString stringWithFormat:@"%@%d",ShowDetaiUrl,aCount];
    NSLog(@"%@",str1);
    NSURL *url1 = [NSURL URLWithString:str1];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    showV.timeLabel.text = dic1[@"date"];
    NSLog(@"%@",showV.timeLabel.text);
    showV.titleLabel.text = dic1[@"title"];
    NSLog(@"%@",showV.titleLabel.text);
    showV.authorIntroL.text = dic1[@"author"];
    showV.textLabel.text = dic1[@"text"];
    NSLog(@"%@",showV.textLabel.text);
    showV.bottomScrollView.delegate = self;
    [showV adjustSubviewsWithContent];
//    [showV pandungaodu];
    
    //添加轻扫手势
    //（因为默认为1。必须刷卡的手指的数量默认是uiswipegesturerecognizerdirectionright。刷击所需方向。多方向可他们是否会导致相同的行为（例如，指定UITableView刷卡删除），所以分开写；
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionLeft;
    [showV addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(yousaoAction:)];
    swipe2.direction = UISwipeGestureRecognizerDirectionRight;
    [showV addGestureRecognizer:swipe2];
    
    /*
     //scrollview,在此处不适用
     self.myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,with , heig)];
     self.myScroll.backgroundColor = [UIColor grayColor];
     [self.view addSubview:self.myScroll];
     self.myScroll.contentSize = CGSizeMake(with*10, heig);
     self.myScroll.pagingEnabled = YES;
     
     for (int i = 0; i<10; i++) {
     showV.tag = 10000 +i;
     showV = [[ShowView alloc]initWithFrame:CGRectMake(i*with, 0, with, heig)];
     [showV setupSubviews];
     showV.backgroundColor = [UIColor purpleColor];
     NSString *string = [NSString stringWithFormat:@"%@%d",ShowDetaiUrl,aCount];
     NSLog(@"%@",string);
     NSString *str = [NSString stringWithFormat:@"%@%d",ShowDetaiUrl,aCount];
     NSLog(@"%@",str);
     NSURL *url = [NSURL URLWithString:str];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     showV.timeLabel.text = dic1[@"date"];
     NSLog(@"%@",showV.timeLabel.text);
     showV.titleLabel.text = dic1[@"title"];
     NSLog(@"%@",showV.titleLabel.text);
     showV.authorIntroL.text = dic1[@"author"];
     showV.textLabel.text = dic1[@"text"];
     showV.bottomScrollView.delegate = self;
     --aCount;
     [self.myScroll addSubview:showV];
     }
     
     */
}

-(void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    if (aCount==(maxCount-10)) {
        NSLog(@"无更多内容");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无更多内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

    }else
    {
        aCount--;
        NSLog(@"-----------  当前  %d",aCount);
        NSString *str1 = [NSString stringWithFormat:@"%@%d",ShowDetaiUrl,aCount];
        NSURL *url1 = [NSURL URLWithString:str1];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        showV.timeLabel.text = dic1[@"date"];
        NSLog(@"%@",showV.timeLabel.text);
        showV.titleLabel.text = dic1[@"title"];
        NSLog(@"%@",showV.titleLabel.text);
        showV.authorIntroL.text = dic1[@"author"];
        showV.textLabel.text = dic1[@"text"];
        NSLog(@"%@",showV.textLabel.text);
        showV.bottomScrollView.delegate = self;
        [showV adjustSubviewsWithContent];
//        [showV pandungaodu];
        
        
    }
    
    
}

-(void)yousaoAction:(UISwipeGestureRecognizer *)swipeaction
{
    
    if (aCount==maxCount) {
        
        NSLog(@"已是最新内容");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已是最新内容，请向左轻扫到上一篇文章" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

        
    }else
    {
        aCount ++;
        NSLog(@"-----------  当前  %d",aCount);
        NSString *str1 = [NSString stringWithFormat:@"%@%d",ShowDetaiUrl,aCount];
        NSURL *url1 = [NSURL URLWithString:str1];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        showV.timeLabel.text = dic1[@"date"];
        NSLog(@"%@",showV.timeLabel.text);
        showV.titleLabel.text = dic1[@"title"];
        NSLog(@"%@",showV.titleLabel.text);
        showV.authorIntroL.text = dic1[@"author"];
        showV.textLabel.text = dic1[@"text"];
        NSLog(@"%@",showV.textLabel.text);
        showV.bottomScrollView.delegate = self;
        [showV adjustSubviewsWithContent];
//        [showV pandungaodu];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
