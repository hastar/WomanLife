//
//  FindVC.m
//  WomanLife
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 陈瑞花. All rights reserved.
//

#import "FindVC.h"
#import "FindModel.h"
#import "AsyNetworkTool.h"
#import "FindCell.h"
#import "FindDetailVC.h"
#import "FindSecCell.h"
#import "FindView.h"
#import "UIImageView+WebCache.h"//下载图片
#import "MJRefresh.h"//下拉刷新
#import "MJRefreshComponent.h"//上啦
#import "MBProgressHUD.h"//小菊花
#import "AppDelegate.h"
#import "CDSideBarController.h"
#import "FindDetail2VC.h"


@interface FindVC ()<AsyNetworkToolDelegate,UITableViewDataSource,UITableViewDelegate,CDSideBarControllerDelegate,UIScrollViewDelegate>
{
    CGFloat _w;
    CGFloat _h;
    int page;
    NSString *ID;
    int tag;
    int litm;
    CDSideBarController *sideBar;
}
@property(nonatomic,strong)NSMutableArray *findArray;
@property(nonatomic,strong)NSMutableArray *scorllArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)UIScrollView *myScroll;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)NSTimer *timer;

@end
//俏佳人：
#define FindUrl @"http://t.gexiaojie.com/api.php?_app_key=f722d367b8a96655c4f3365739d38d85&output=json&a=getArticleByTag&c=column&m=index&pg=1&_app_secret=30248115015ec6c79d3bed2915f9e4cc&tag_id="

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _w = [UIScreen mainScreen].bounds.size.width;
    _h = [UIScreen mainScreen].bounds.size.height;
    /*----------------------------------------scrollview------------------------------*/
    self.myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44,_w, _h/3-44)];
    self.myScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self.view addSubview:self.myScroll];
    //关掉自动适配；
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scorllArray = [[NSMutableArray alloc]init];
    self.myScroll.pagingEnabled = YES;
    self.myScroll.delegate = self;
    self.myScroll.bounces = NO;
    //隐藏滚动条
    self.myScroll.showsHorizontalScrollIndicator = NO;
    self.myScroll.showsVerticalScrollIndicator = NO;
    [self setScrollViewImage];
    //添加label
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(_w-50, _h/3-55, 50, 50)];
    self.numLabel.font = [UIFont systemFontOfSize:17];
    self.numLabel.textColor = [UIColor yellowColor];
    self.numLabel.text = [NSString stringWithFormat:@"1/%ld",self.scorllArray.count];
    [self.view addSubview:self.numLabel];
    /*-------------------------------在scrollview上添加点击手势-----------------------------*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.myScroll addGestureRecognizer:tap];
    page = 1;
    self.navigationItem.title = @"美哒哒";
    ID = @"568";
    tag = 0;
    litm = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&size=10",FindUrl,ID];
    AsyNetworkTool *asy1 = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
    asy1.delegate = self;
    self.findArray = [[NSMutableArray alloc]init];
    /*-------------------------------------添加循环播放-------------------------*/
    [self addTimer];
    
    /*-----------------------tablevie-----------------------------*/
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_h/3,_w,_h*2/3-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    /*-----------------菜单控件-------------------*/
    NSArray *imageList = @[[UIImage imageNamed:@"俏佳人"], [UIImage imageNamed:@"居家"], [UIImage imageNamed:@"慧生活"], [UIImage imageNamed:@"领带"],[UIImage imageNamed:@"fashion"],[UIImage imageNamed:@"情商"],[UIImage imageNamed:@"旅游"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
    
    /*---------------------------刷新-------------------------------*/
    [self example01];
    [self upPullUpdata];
}
//开启定时器：
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextImage
{
    int number = self.myScroll.contentOffset.x/_w;
    if (number == 4) {
        number = 0;
        CGFloat x = number * _w;
        self.myScroll.contentOffset = CGPointMake(x, 0);
        number++;
    }else{
        
        number++;
        CGFloat x = number * _w;
        self.myScroll.contentOffset = CGPointMake(x, 0);
    }
}
//移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
}

#pragma -mark scrollview代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int number2 = scrollView.contentOffset.x/_w;
    self.numLabel.text = [NSString stringWithFormat:@"%d/%ld",number2+1,self.scorllArray.count];
    
}

//手势关联方法
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    FindDetail2VC *detail1 = [[FindDetail2VC alloc]init];
    int number = self.myScroll.contentOffset.x/_w;
    FindModel *moel = self.scorllArray[number];
    detail1.fModel = moel;
    [self.navigationController pushViewController:detail1 animated:YES];
}

/*=-------------------------------scrollview网络请求------------------------------*/
-(void)sendScrollViewReques
{
    NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?filter=isFocus&start=0&limit=5";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = diction[@"result"];
    for (NSDictionary *dic1 in array) {
        FindModel *findModel = [[FindModel alloc]init];
        NSDictionary *dic2 = dic1[@"article"];
        findModel.findID = dic2[@"articleId"];
        findModel.findTitle = dic2[@"title"];
        findModel.DetailUrl = dic2[ @"url"];
        NSArray *array2 = dic1[@"image"];
        NSDictionary *dic3 = array2[0];
        findModel.pictureUrl = dic3[@"url"];
        [self.scorllArray addObject:findModel];
    }
}

/*--------------------------再scrollview上添加数据与图片-----------------------*/
-(void)setScrollViewImage
{
    [self sendScrollViewReques];
    self.myScroll.contentSize = CGSizeMake(_w*self.scorllArray.count,0);
    for (int i = 0; i<self.scorllArray.count; i++) {
        FindView *fview = [[FindView alloc]initWithFrame:CGRectMake(i*_w, 0,_w,_h/3-44)];
        fview.tag = 10000 + i;
        [self.myScroll addSubview:fview];
        FindModel *findmodel = self.scorllArray[i];
        [fview.fimageView sd_setImageWithURL:[NSURL URLWithString:findmodel.pictureUrl] placeholderImage:[UIImage imageNamed:@"daban"]];
        fview.titleLabel.text = findmodel.findTitle;
    }
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
    [self menuButtonClicked:7];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    [self performSelector:@selector(doReloaddata) withObject:nil afterDelay:1.3];
}
-(void)doReloaddata
{
    [self.tableView reloadData];
    //停止刷新图表
    [self.tableView.header endRefreshing];
}
/*------------------------上下拉刷新--------------------------------------------*/

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
    litm+=10;
    NSString *str1 = @"http://t.gexiaojie.com/api.php?_app_key=f722d367b8a96655c4f3365739d38d85&output=json&a=getArticleByTag&c=column&m=index&pg=";
    NSString *str2 = @"&_app_secret=30248115015ec6c79d3bed2915f9e4cc&tag_id=";
    switch (tag) {
        case 0:
        {
            //俏佳人
            ID = @"568";
            NSString *urlStr = [NSString stringWithFormat:@"%@%d%@%@&size=10",str1,page,str2,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
        }
            break;
        case 1:
        {
            //居家
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=3&filter=byCategoryGroup&start=0&limit=";
            NSString *string = [NSString stringWithFormat:@"%@%d",urlString,litm];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:string];
            asy.delegate = self;
        }
            break;
        case 2:{
            //慧生活
            ID = @"566";
            NSString *urlStr = [NSString stringWithFormat:@"%@%d%@%@&size=10",str1,page,str2,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
        }
            break;
        case 3:{
            //骨干
            ID = @"563";
            NSString *urlStr = [NSString stringWithFormat:@"%@%d%@%@&size=10",str1,page,str2,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
        }
            break;
        case 4:{
            //时尚
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=1&filter=byCategoryGroup&start=0&limit=";
            NSString *string = [NSString stringWithFormat:@"%@%d",urlString,litm];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:string];
            asy.delegate = self;
        }
            break;
        case 5:{
            
            //情感
            
            ID = @"565";
            NSString *urlStr = [NSString stringWithFormat:@"%@%d%@%@&size=10",str1,page,str2,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
        }
            break;
        case 6:{
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=4&filter=byCategoryGroup&start=0&limit=";
            NSString *string = [NSString stringWithFormat:@"%@%d",urlString,litm];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:string];
            asy.delegate = self;
        }
            break;
        default:
            break;
    }
    
}
-(void)doShangReloadData
{
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
}


/*----------------菜单代理事件-----------------------------*/
- (void)menuButtonClicked:(int)index
{
    NSLog(@"----------------%d",index);
    switch (index) {
        case 0:
        {
            tag = 0;
            self.navigationItem.title = @"美哒哒";
            //俏佳人
            ID = @"568";
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&size=10",FindUrl,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
            page = 1;
        }
            break;
        case 1:
        {   tag = 1;
            //居家
            self.navigationItem.title = @"居家";
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=3&filter=byCategoryGroup&start=0&limit=10";
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlString];
            asy.delegate = self;
            litm = 10;
        }
            break;
        case 2:{
            tag = 2;
            self.navigationItem.title = @"慧生活";
            //慧生活
            ID = @"566";
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&size=10",FindUrl,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
            page = 1;
            
            
        }
            break;
        case 3:{
            tag = 3;
            //骨干
            self.navigationItem.title = @"白骨精";
            ID = @"563";
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&size=10",FindUrl,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
            page =1;
        }
            break;
        case 4:{
            tag = 4;
            
            //时尚
            self.navigationItem.title = @"时尚";
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=1&filter=byCategoryGroup&start=0&limit=10";
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlString];
            asy.delegate = self;
            litm = 10;
            
        }
            break;
        case 5:{
            tag = 5;
            //情感
            self.navigationItem.title = @"情感";
            ID = @"565";
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&size=10",FindUrl,ID];
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlStr];
            asy.delegate = self;
            page = 1;
        }
            break;
        case 6:{
            tag = 6;
            self.navigationItem.title = @"旅游";
            NSString *urlString = @"http://api.meitianapp.com/api/v1/articles?param=4&filter=byCategoryGroup&start=0&limit=10";
            AsyNetworkTool *asy = [[AsyNetworkTool alloc]initWithUrlString:urlString];
            asy.delegate = self;
            litm = 10;
        }
            break;
        default:
            break;
    }
    //置顶
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
}
/*-----------------------------添加菜单---------------------*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sideBar.menuButton];
    [sideBar insertMenuViewOnView];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)doRemoveHud
{
    [self.hud hide:YES];
}

/*------------------------------数据请求----------------------*/
-(void)asyResult:(id)result
{
    NSDictionary *dic = result;
    
    if (tag == 0 || tag == 2 || tag == 3  || tag == 5) {
        if (page == 1) {
            [self.findArray removeAllObjects];
        }
        NSDictionary *dic1 = dic[@"content"];
        NSArray *array = dic1[@"artlist"];
        for (NSDictionary *dic2 in array) {
            FindModel *fModel = [[FindModel alloc]init];
            fModel.findTitle = dic2[@"title"];
            fModel.findID = dic2[@"tid"];
            fModel.findSummary = dic2[@"summary"];
            fModel.pictureUrl = dic2[@"cover"];
            [self.findArray addObject:fModel];
        }
        
    }
    else if(tag == 1|| tag == 4 ||tag == 6){
        if (litm > 50) {
            UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未找到更多的资讯" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [aView show];
            return ;
        }
        [self.findArray removeAllObjects];
        NSArray *array = dic[@"result"];
        for (NSDictionary *dic1 in array) {
            FindModel *model = [[FindModel alloc]init];
            NSDictionary *dic2 = dic1[@"article"];
            model.findID = dic2[@"articleId"];
            model.findTitle = dic2[@"title"];
            model.DetailUrl = dic2[ @"url"];
            NSArray *array2 = dic1[@"image"];
            NSDictionary *dic3 = array2[0];
            model.pictureUrl = dic3[@"url"];
            NSDictionary *dic4 = dic1[@"author"];
            model.findSummary = dic4[@"name"];
            [self.findArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

//tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.findArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindModel *fmodel = self.findArray[indexPath.row];
    
    if (tag == 0 || tag == 2 || tag == 3  || tag == 5){
        static NSString *cellinder = @"Cell";
        FindCell *cell = [tableView dequeueReusableCellWithIdentifier:cellinder];
        if (cell == nil) {
            cell = [[FindCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellinder];
        }
        cell.titilLabel.text = fmodel.findTitle;
        cell.summaryLabel.text = fmodel.findSummary;
        [cell.findImage sd_setImageWithURL:[NSURL URLWithString:fmodel.pictureUrl] placeholderImage:[UIImage imageNamed:@"daban"]];
        return cell;
    }
    else
    {
        static NSString *cellinder1 = @"second";
        FindSecCell *secCell = [tableView dequeueReusableCellWithIdentifier:cellinder1];
        if (secCell == nil) {
            secCell = [[FindSecCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellinder1];
        }
        secCell.titilLabel.text = fmodel.findTitle;
        [secCell.findImage sd_setImageWithURL:[NSURL URLWithString:fmodel.pictureUrl] placeholderImage:[UIImage imageNamed:@"daban"]];
        secCell.summaryLabel.text = fmodel.findSummary;
        return secCell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tag == 1|| tag == 4 ||tag == 6) {
        FindDetail2VC *detail = [[FindDetail2VC alloc]init];
        FindModel *model = self.findArray[indexPath.row];
        detail.fModel = model;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        FindDetailVC *fDetailVC = [[FindDetailVC alloc]init];
        FindModel *model = self.findArray[indexPath.row];
        fDetailVC.fModel = model;
        [self.navigationController pushViewController:fDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
