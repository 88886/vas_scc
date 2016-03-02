//
//  MineDocumentViewController.m
//  study
//
//  Created by mijibao on 16/1/29.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MineDocumentViewController.h"
#import "MineDocumentTableViewCell.h"

@interface MineDocumentViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *_cellIdentifier = @"cellIdentifier";

@implementation MineDocumentViewController
{
    NSArray *_documentArray;//文档数据
    NSMutableDictionary *_classfyDictionary;//按照type分类汇总后的数据
    UITableView *_tableView;
    NSMutableDictionary *_sectionOpen;//记录当前数据展示还是关闭
    UIView *_moreView;//编辑视图
    BOOL _isEdit;//当前是否处于编辑页面
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButton:@"编辑"];
    [self initData];
    [self setSectionResult];
    [self creatNavgation];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)creatNavgation
{
    self.title = @"我的文件";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, Main_Width, Main_Height - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_tableView registerClass:[MineDocumentTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_classfyDictionary allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_sectionOpen[[self sortContactKey][section]] isEqualToString:@"0"]) {
        return 0;
    }else{
        return  [self contactsArrayForSection:section].count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineDocumentTableViewCell *cell = (MineDocumentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[MineDocumentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    [cell changeFrameWithEdit:_isEdit];
    NSDictionary *dictionary = [self contactsArrayForSection:indexPath.section][indexPath.row];
    cell.titleLabel.text = dictionary[@"title"];
    cell.byteLabel.text = dictionary[@"byte"];
    cell.timeLabel.text = dictionary[@"time"];
    if ([dictionary[@"type"] isEqualToString:@"WORD"]) {
        [cell.typeImageView setImage:[UIImage imageNamed:@"Document_Word"]];
    }else if ([dictionary[@"type"] isEqualToString:@"EXCEL"])
    {
        [cell.typeImageView setImage:[UIImage imageNamed:@"Document_Excel"]];
    }else{
         [cell.typeImageView setImage:[UIImage imageNamed:@"Document_Pdf"]];
    }
    NSInteger count = [self contactsArrayForSection:indexPath.section].count;
    if (indexPath.row == count -1 ) {
        [cell.lineView removeFromSuperview];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 40)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(18, 0, 40, 40)];
    btn.tag = section;
    btn.selected = YES;
    [btn addTarget:self action:@selector(showRow:) forControlEvents:UIControlEventTouchUpInside];
    headview.backgroundColor = [UIColor whiteColor];
    [headview addSubview:btn];
    UIImageView *openImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 9, 9)];
    if (![_sectionOpen[[self sortContactKey][section]] isEqualToString:@"0"]){
       [openImage setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"Document_Open"].CGImage scale:1 orientation:UIImageOrientationRight]];
    }else{
        [openImage setImage:[UIImage imageNamed:@"Document_Open"]];
    }
    [btn addSubview:openImage];
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btn), 0, 80, 40)];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.textColor = UIColorFromRGB(0x373737);
    keyLabel.font = [UIFont systemFontOfSize:13];
    keyLabel.text = [self sortContactKey][section];
    [headview addSubview:keyLabel];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, Main_Width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [headview addSubview:lineView];
    return headview;
}

- (void)showRow:(UIButton *)btn
{
    NSString *keyString = [self sortContactKey][btn.tag];
    if ([_sectionOpen[keyString] isEqualToString:@"0"]) {
        [_sectionOpen setObject:@"1" forKey:keyString];
    }else{
        [_sectionOpen setObject:@"0" forKey:keyString];
    }
    [_tableView reloadData];
}

- (void)setRightBarButton:(NSString *)string{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xff7949);
}

#pragma mark 点击编辑按钮
- (void)editBtnClicked
{
    NSLog(@"点击了编辑按钮");
    _isEdit = YES;
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 45)];
    _moreView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Width * 0.5 - 0.5, 40)];
    [self setImage:@"Collection_Cancel" forBtn:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelDeleteDoc) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(MaxX(cancelBtn) + 1, 0, Main_Width * 0.5 - 0.5, 40)];
    [deleteBtn addTarget:self action:@selector(makeSureDeleteDoc) forControlEvents:UIControlEventTouchUpInside];
    [self setImage:@"Collection_Delete" forBtn:deleteBtn];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Main_Width * 0.5 - 0.5, 5, 1, 35)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_moreView addSubview:lineView];
    [self.view addSubview:_moreView];
    _tableView.frame = CGRectMake(0, 55, Main_Width, Main_Height - 104);
    [_tableView reloadData];

}

//撤销编辑
- (void)cancelDeleteDoc
{
    _isEdit = NO;
    [_moreView removeFromSuperview];
    _tableView.frame = CGRectMake(0, 10, Main_Width, Main_Height - 64);
    [_tableView reloadData];
}

- (void)makeSureDeleteDoc
{
    NSLog(@"确认删除文件");
}

- (void)initData
{
    _isEdit = NO;
    _documentArray = @[@{@"title":@"文言文阅读技巧", @"type":@"WORD", @"byte":@"25.09k", @"time":@"2016-01-22"},@{@"title":@"中国近代史", @"type":@"WORD", @"byte":@"25.09k", @"time":@"2016-01-22"},@{@"title":@"地理环境", @"type":@"PDF", @"byte":@"25.09k", @"time":@"2016-01-22"},@{@"title":@"化学公式", @"type":@"EXCEL", @"byte":@"25.09k", @"time":@"2016-01-22"},@{@"title":@"文言文阅读技巧", @"type":@"WORD", @"byte":@"25.09k", @"time":@"2016-01-22"},@{@"title":@"文言文阅读技巧", @"type":@"EXCEL", @"byte":@"25.09k", @"time":@"2016-01-22"}];
    _classfyDictionary = [self classifyContacts:_documentArray];
}

- (NSMutableDictionary *)classifyContacts:(NSArray *)array
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in array) {
        NSString *type = dic[@"type"];
        NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
        if (type != nil && type.length) {
            tmpArr = [resultDict objectForKey:type];
            if (tmpArr) {
                [tmpArr addObject:dic];
            } else {
                NSMutableArray *newArr = [NSMutableArray arrayWithObjects:dic, nil];
                [resultDict setObject:newArr forKey:type];
            }
        }
    }
    return resultDict;
}

- (void)setSectionResult
{//设置section的关闭，0代表关，1代表开
    _sectionOpen = [[NSMutableDictionary alloc] init];
    NSArray *array = [_classfyDictionary allKeys];
    for (NSString *keyString in array) {
        [_sectionOpen setObject:@"0" forKey:keyString];
    }
}

- (NSMutableArray *)contactsArrayForSection:(NSInteger)section
{
    //获取某一个首字母下所有的伙伴信息
    NSArray *keys = [self sortContactKey];
    NSString *key = keys[section];
    return (NSMutableArray *)_classfyDictionary[key];
}

- (NSArray *)sortContactKey
{
    //对首字母进行排序
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_classfyDictionary];
    NSArray *keyArray = [dic allKeys];
    NSArray *sortedArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    return sortedArray;
}

- (void)setImage:(NSString *)imagename forBtn:(UIButton *)btn
{
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    UIImage *image = [UIImage imageNamed:imagename];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [_moreView addSubview:btn];
}


- (void)choseDocumentTodelete:(UIButton *)btn
{
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"Document_Chose"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"Collection_More"] forState:UIControlStateNormal];
    }
    btn.selected = !btn.selected;
}
@end
