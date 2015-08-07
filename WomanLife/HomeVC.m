//
//  HomeVC.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "HomeVC.h"
#import "AsyNetworkTool.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "SecondHCell.h"
#import "HomeDetaiVC.h"
#import "UIImageView+WebCache.h"//下载图片
#import "MJRefresh.h"//下拉刷新
#import "MJRefreshComponent.h"//上啦
#import "MBProgressHUD.h"//小菊花
#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationDrop.h"

@interface HomeVC ()<AsyNetworkToolDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _w;
    CGFloat _h;
    int page;
}
@property(nonatomic,strong)NSMutableArray *homeArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

#define BaseUrl @"http://t.gexiaojie.com/api.php?_app_key=f722d367b8a96655c4f3365739d38d85&output=json&a=artlistV2&c=column&pg=1&_app_secret=30248115015ec6c79d3bed2915f9e4cc&size=7"

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"caidan"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    
    
    _w = [UIScreen mainScreen].bounds.size.width;
    _h = [UIScreen mainScreen].bounds.size.height;
    page = 1;
    self.navigationItem.title = @"精选";
    self.homeArray = [[NSMutableArray alloc]init];
    AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:BaseUrl];
    asy.delegate = self;
    
    /*-------------------------tableview--------------------------------------*/
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,_w,_h-113) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    /*-------------------------小菊花-----------------------------------*/
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode  = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    //1秒后关闭
    [self performSelector:@selector(doRemoveHud) withObject:_tableView afterDelay:1];
    [self example01];
    [self upPullUpdata];
    
}
//弹出视图执行的方法
- (void) leftAction:(UIBarButtonItem*)button
{
    PopupView *view = [PopupView defaultPopuView];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
        
    }];
}
//小菊花：
-(void)doRemoveHud
{
    [self.hud hide:YES];
}
/*-----------------------------下拉刷新------------------------------*/
- (void)example01
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    //添加数据
    //如果在此remove，会导致cell。count为空，会崩溃；
//    [self.homeArray removeAllObjects];
    AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:BaseUrl];
    asy.delegate = self;
    page = 1;
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    [self performSelector:@selector(doReloaddata) withObject:nil afterDelay:1.3];
}
-(void)doReloaddata
{
    [self.tableView reloadData];
    //停止刷新图表
    [self.tableView.header endRefreshing];
}

/*-----------------------------------上拉刷新--------------------------------*/
- (void)upPullUpdata
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOnceData)];
}
// 上拉加载更多数据
- (void)loadOnceData
{
    // 1.添加数据
    [self getDataWithPage];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    [self performSelector:@selector(doShangReloadData) withObject:nil afterDelay:1];
}
-(void)getDataWithPage
{
    page++;
    NSString *str = [NSString stringWithFormat:@"http://t.gexiaojie.com/api.php?_app_key=f722d367b8a96655c4f3365739d38d85&output=json&a=artlistV2&c=column&pg=%d&_app_secret=30248115015ec6c79d3bed2915f9e4cc&size=7",page];
    AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:str];
    asy.delegate = self;
}
-(void)doShangReloadData
{
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
}



//网络请求：
-(void)asyResult:(id)result
{
    //在此加入判断条件，下拉刷新就不会重叠数据：
    if (page == 1) {
        [self.homeArray removeAllObjects];
    }
    NSDictionary *dic = result;
    NSDictionary *dic1 = dic[@"content"];
    NSArray *array = dic1[@"artlist"];
    //因为不是在同一界面显示不同数据请求回来的cell，所以不会叠加，如果在此处remove了，上啦刷新每次就只能显示当前页面了；
//    [self.homeArray removeAllObjects];
    for (NSDictionary *dic2 in array) {
        HomeModel *hModel = [[HomeModel alloc]init];
        hModel.homeTitle = dic2[@"title"];
        hModel.homeID = dic2[@"tid"];
        hModel.type = dic2[@"type"];
        hModel.homeSummary = dic2[@"summary"];
        hModel.pictureUrl = dic2[@"cover"];
        NSString *a = [[NSString alloc] initWithFormat:@"%@",hModel.type];
        if ([a isEqualToString:@"2"]) {
        }else
            [self.homeArray addObject:hModel];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *home = self.homeArray[indexPath.row];
    //    NSLog(@"%@",home.type);
    NSString *a = [[NSString alloc] initWithFormat:@"%@",home.type];
    if ([a isEqualToString:@"1"]) {
        static NSString *cellindefier = @"Cell";
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindefier];
        if (cell == nil) {
            cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellindefier];
                    }
#warning -一定要写在if外否则cell混乱：
        cell.titilLabel.text = home.homeTitle;
        cell.summaryLabel.text = home.homeSummary;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:home.pictureUrl] placeholderImage:[UIImage imageNamed:@"daban.png"]];

        return cell;
    }else{
        static NSString *cellindefier2 = @"second";
        SecondHCell *seCell = [tableView dequeueReusableCellWithIdentifier:cellindefier2];
        if (seCell == nil) {
            seCell = [[SecondHCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellindefier2];
        }
        seCell.titleL.text = home.homeTitle;
        seCell.summaryL.text = home.homeSummary;
        [seCell.sImageView sd_setImageWithURL:[NSURL URLWithString:home.pictureUrl] placeholderImage:[UIImage imageNamed:@"daban.png"]];
        return seCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeDetaiVC *hDetailVC = [[HomeDetaiVC alloc]init];
    HomeModel *home = self.homeArray[indexPath.row];
    hDetailVC.hModel = home;
    [self.navigationController pushViewController:hDetailVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *home = self.homeArray[indexPath.row];
    NSString *a = [[NSString alloc] initWithFormat:@"%@",home.type];
    if ([a isEqualToString:@"1"]) {
        return 100;
    }else
        return 180;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
}

@end
