//
//  MineViewController.m
//  study
//
//  Created by mijibao on 15/9/2.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "ImageRequestCore.h"
#import "UserInfoViewController.h"
#import "MinePartnerViewController.h"
#import "CollectionViewController.h"
#import "AccountViewController.h"
#import "MineDocumentViewController.h"
#import "SettingsViewController.h"
#import "MineTeacherViewController.h"
#import "MineBuySubjectViewController.h"

@interface MineViewController ()
{

}
@end

@implementation MineViewController
{
    NSArray *_tableTextArr;//表文本内容
    NSArray *_tableImageArr;//表图标名称
    UITableView *_mineTableView;
    NSString *_cellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    _cellIdentifier = @"cellIdentify";
    if ([[UserInfoList loginUserType] isEqualToString:@"S"]) {
        _tableTextArr = @[@"我的伙伴", @"我的收藏", @"我的账户", @"我的文件", @"我购买的课程", @"我上传的课件", @"我关注的老师"];
        _tableImageArr = @[@"Mine_Partner", @"Mine_Collection", @"Mine_Account", @"Mine_Document", @"Mine_BuyCourse", @"Mine_Upload", @"Mine_Attention"];
    }else{
        _tableTextArr = @[@"我的伙伴", @"我的收藏", @"我的账户", @"我的文件", @"我购买的课程", @"我上传的课件"];
        _tableImageArr = @[@"Mine_Partner", @"Mine_Collection", @"Mine_Account", @"Mine_Document", @"Mine_BuyCourse", @"Mine_Upload"];
    }
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [_mineTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark 创建UI
- (void)creatUI
{
    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, Main_Width, Main_Height)style:UITableViewStyleGrouped];
    _mineTableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_mineTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _mineTableView.delegate = self;
    _mineTableView.dataSource = self;
    _mineTableView.scrollEnabled = YES;
    [_mineTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mineTableView];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = (MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.cellLabel.text = _tableTextArr[indexPath.row];
        UIImage *image = [UIImage imageNamed:_tableImageArr[indexPath.row]];
        cell.cellImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [cell.cellImageView setImage:image];
        if (indexPath.row == 6) {
            cell.lineView.backgroundColor = [UIColor clearColor];
        }
    }else{
        cell.cellLabel.text = @"设置";
        UIImage *image = [UIImage imageNamed:@"Mine_Setting"];
        cell.cellImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [cell.cellImageView setImage:image];
        cell.lineView.backgroundColor = [UIColor clearColor];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_tableTextArr count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 210;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 210)];
        headView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        //背景图
        UIImageView *headBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 200)];
        headBackView.backgroundColor = [UIColor clearColor];
        UIImageView *headBottom = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - 84) * 0.5, 65, 84, 84)];
        headBottom.backgroundColor = UIColorFromRGB(0xff7949);
        headBottom.layer.masksToBounds = YES;
        headBottom.layer.cornerRadius = 42;
        //我的头像
        UIImageView *userHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 80, 80)];
        userHeadView.backgroundColor = [UIColor clearColor];
        userHeadView.layer.masksToBounds = YES;
        userHeadView.layer.cornerRadius = 41;
        [headBackView addSubview:headBottom];
        [headBottom addSubview:userHeadView];
        [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPhoto] withImageView:userHeadView placeholderImage:[UIImage imageNamed:@"Mine_Syshead"]];
        [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPicture] withImageView:headBackView placeholderImage:[UIImage imageNamed:@"partner_ default"]];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeadImage)];
        headView.userInteractionEnabled = YES;
        headBackView.userInteractionEnabled = YES;
        headBottom.userInteractionEnabled = YES;
        userHeadView.userInteractionEnabled = YES;
        [userHeadView addGestureRecognizer:gesture];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(headBottom) + 10, Main_Width, 20)];
        nameLabel.text = [UserInfoList loginUserNickname];
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.layer.shadowOpacity = 1.0;
        nameLabel.layer.shadowRadius = 0.0;
        nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        nameLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        [headBackView addSubview:nameLabel];
        [headView addSubview:headBackView];
        return headView;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 10)];
        headView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//点击的是我的伙伴
            MinePartnerViewController *partner = [[MinePartnerViewController alloc] init];
            [self.navigationController pushViewController:partner animated:YES];
        }else if(indexPath.row == 1){//点击的是我的收藏
            CollectionViewController *collection = [[CollectionViewController alloc] init];
            [self.navigationController pushViewController:collection animated:YES];
        }else if (indexPath.row == 2){//点击的是我的账户
            AccountViewController *account = [[AccountViewController alloc] init];
            [self.navigationController pushViewController:account animated:YES];
        }else if (indexPath.row == 3){//点击的我的文件
            MineDocumentViewController *document = [[MineDocumentViewController alloc] init];
            [self.navigationController pushViewController:document animated:YES];
        }else if (indexPath.row == 4){//点击的是我购买的课程
            MineBuySubjectViewController *subject = [[MineBuySubjectViewController alloc] init];
            [self.navigationController pushViewController:subject animated:YES];
        }else if (indexPath.row == 5){//点击的是我上传的课件
        }else if (indexPath.row == 6){//点击的是我关注的老师
            MineTeacherViewController *teacher = [[MineTeacherViewController alloc] init];
            [self.navigationController pushViewController:teacher animated:YES];
        }
    }else if (indexPath.section == 1){//点击的是设置
        SettingsViewController *settings = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:settings animated:YES];
    }
}

#pragma mark 点击用户头像
- (void)tapUserHeadImage{
    NSLog(@"点击用户头像");
    UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}
@end


