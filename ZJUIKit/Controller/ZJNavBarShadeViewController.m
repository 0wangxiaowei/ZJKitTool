//
//  ZJNavBarShadeViewController.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/31.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "ZJNavBarShadeViewController.h"
#import "ZJBaseTableViewCell.h"
#import "ZJExpandHeader.h"
#import "ZJNavigationBar.h"

@interface ZJNavBarShadeViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNavigationBarDelegate>

@property(nonatomic ,strong) UITableView        *mainTable;
@property(nonatomic ,strong) UIImageView        *imageV;

@property(nonatomic ,strong) ZJNavigationBar    *zj_navigationBar;

@property (nonatomic, strong) ZJExpandHeader    *expandHander;
@end

@implementation ZJNavBarShadeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllView];
}


-(void)setUpAllView{
    [self.view addSubview:self.mainTable];
    
    UIEdgeInsets contentInset = self.mainTable.contentInset;
    contentInset.top = 0;
    self.mainTable.contentInset = contentInset;
    self.zj_navigationBar.zj_title = @"导航栏渐变";

    _expandHander = [ZJExpandHeader expandWithScrollView:self.mainTable expandView:self.imageV];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat kNaviBarHeight =  -self.zj_navigationBar.height;
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (contentOffset.y <= kNaviBarHeight) {
        
        _zj_navigationBar.lineView.hidden = YES;
        [self.zj_navigationBar zj_setNavBarTint:kWhiteColor navBackColor:kClearColor];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else if (contentOffset.y >kNaviBarHeight && contentOffset.y < 0){

        UIColor *backColor = [kWhiteColor colorWithAlphaComponent:(1 - contentOffset.y / kNaviBarHeight)];
        
        UIColor *shadeColor = [kBlackColor colorWithAlphaComponent:(1 - contentOffset.y / kNaviBarHeight)];
        UIColor *lineColor = [kLightGrayColor colorWithAlphaComponent:(1 - contentOffset.y / kNaviBarHeight)];
        
        _zj_navigationBar.lineView.hidden = NO;
        _zj_navigationBar.lineView.backgroundColor = lineColor;
        [self.zj_navigationBar zj_setNavBarTint:shadeColor navBackColor:backColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else if (contentOffset.y >= 0){
        

        [self.zj_navigationBar zj_setNavBarTint:kBlackColor navBackColor:kWhiteColor];
        _zj_navigationBar.lineView.hidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark  - ZJNavigationBarDelegate
-(void)zj_navigationBarLeftBtnAction:(UIButton *)sender{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)zj_navigationBarRightBtnAction:(UIButton *)sender{
    NSLog(@"---->点击了确定按钮");
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJBaseTableViewCell *cell = [ZJBaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc =[[UIViewController alloc]init];
    vc.view.backgroundColor = kWhiteColor;
    vc.title = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZJTableViewControllerDeallocNotification" object:self];
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.image = kImageName(@"004");
    }
    return _imageV;
}

-(UITableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [[UIView alloc]init];
        _mainTable.rowHeight = 50;
    }
    return _mainTable;
}



-(ZJNavigationBar *)zj_navigationBar{
    if (!_zj_navigationBar) {
        _zj_navigationBar = [[ZJNavigationBar alloc]initWithFrame:CGRectMake(0, 00, kScreenWidth, 64)];
        _zj_navigationBar.backgroundColor = kClearColor;
        _zj_navigationBar.delegate = self;
        _zj_navigationBar.lineView.hidden = YES;
        [self.view addSubview:_zj_navigationBar];
    }
    return _zj_navigationBar;
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
