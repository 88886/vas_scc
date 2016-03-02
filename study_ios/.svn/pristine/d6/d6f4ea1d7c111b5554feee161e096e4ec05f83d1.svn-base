//
//  ProblemDetailViewController.m
//  study
//
//  Created by jzkj on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "ProblemDetailViewController.h"
#import <Masonry/Masonry.h>
#import "MyCustomView.h"
#import "CInputView.h"
#import "ChatMsgDTO.h"
#import "JHFacePlist.h"
#import "ChatMsgListManage.h"
#import "MsgSummaryManage.h"
#import "MsgListTableViewCell.h"
#import "UploadFileCore.h"
#import "JHAudioManager.h"
#import "JHCacheManager.h"
#import "HJAlertView.h"
#import "ReviewImageView.h"
#define maxChatWidth 200
#define maximgWidth 113
#define maximgHeight 120
#define vedioimgWidth 110
#define vedioimgHeight 120
@interface ProblemDetailViewController ()<UITableViewDataSource,UITableViewDelegate,InputViewDelegate,MsgListTableViewCellDelegate,xmppDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JZUploadFileDelegate>{
    UILabel *submitLab;//提交问题
    UIView *backview;//遮挡视图
    UIView *avdioView;//录音遮挡图
    BOOL backisShow;//遮挡视图隐藏
    UploadFileCore *uploadData;//上传消息附件
    NSTimer *_audioTime;//录音播放计时器
}
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) CInputView *inputView;  //键盘
@property (nonatomic, strong) NSMutableArray *dataArray;//聊天数据
//消息重复
@property(nonatomic,strong)UIActivityIndicatorView *sendMsgAgain;

@end

@implementation ProblemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [UserInfoList loginUserPhone];
    self.chatId = self.userId;
    [XMPPManager sharedManager].delegate = self;
    //消息上传
    uploadData = [[UploadFileCore alloc] init];
    uploadData.delegate = self;
    //消息列表
    self.dataArray = [[ChatMsgListManage shareInstance]readChatMsgList:self.chatId :self.userId :0 :0];
    [self layoutNavigation];
    [self layoutTableView];
    // Do any additional setup after loading the view.
    //新消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReload:) name:kNewMessageNotification object:nil];
    if (self.dataArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemLeftBar"] style:UIBarButtonItemStylePlain target:self action:@selector(backTolistView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemRightBar"] style:UIBarButtonItemStylePlain target:self action:@selector(showBarMenu)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.title = @"问题详情";
}
- (void)layoutTableView{
    __weak __typeof(self) weakSelf = self;
    self.chatTableView = [[UITableView alloc] init];
    [self.view addSubview:self.chatTableView];
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-44);
        
    }];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.backgroundColor = RGBCOLOR(226, 226, 226);
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.inputView = [[CInputView alloc] init];
    [self.view addSubview:_inputView];
    [self.inputView layoutViews];
    _inputView.delegate = self;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chatTableView.mas_bottom);
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(@194);
        make.left.equalTo(weakSelf.view);
    }];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = [UIColor whiteColor];
    submitBtn.layer.cornerRadius = 5;
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@-5);
        make.height.equalTo(@45);
        make.width.equalTo(@136);
    }];
    NSMutableAttributedString *attributestr = [[NSMutableAttributedString alloc] initWithString:@"提交问题\n(限时免费)"];
    [attributestr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff7949), NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
    [attributestr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xbcbcbc), NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(5, 6)];
    submitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 136, 40)];
    submitLab.textAlignment = NSTextAlignmentCenter;
    submitLab.attributedText = attributestr;
    submitLab.numberOfLines = 2;
    [submitBtn addSubview:submitLab];
}
//右上角菜单
- (void)showBarMenu{
    if (!backview) {
        backisShow = YES;
        backview = [UIView new];
        UITapGestureRecognizer *backtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapHiddeView)];
        [backview addGestureRecognizer:backtapGesture];
        [self.view addSubview:backview];
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        backview.backgroundColor = [UIColor clearColor];
        UIImageView *backImage = [UIImageView new];
        backImage.image = [UIImage imageNamed:@"imBarstuimg"];
        [backview addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backview).offset(7);
            make.right.equalTo(backview).offset(-10);
            make.width.equalTo(@90);
            make.height.equalTo(@85);
        }];
        UIButton *changeTea = [self creatImageBtnWithTitlt:@"更换老师" titCloro:[UIColor whiteColor] leftImage:@"imChangeTea"];
        changeTea.tag = 1801;
        [backview addSubview:changeTea];
        [changeTea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.right.equalTo(backImage);
            make.width.equalTo(@90);
            make.height.equalTo(@40);
        }];
        UIButton *showTeacher = [self creatImageBtnWithTitlt:@"老师详情" titCloro:[UIColor whiteColor] leftImage:@"imShowTeaDea"];
        [backview addSubview:showTeacher];
        changeTea.tag = 1802;
        [showTeacher mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@52);
            make.right.equalTo(backImage);
            make.width.equalTo(@90);
            make.height.equalTo(@40);
        }];
        [changeTea addTarget:self action:@selector(naviBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [showTeacher addTarget:self action:@selector(naviBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(2, 45, 86, 1)];
        lineview.backgroundColor = RGBCOLOR(64, 64, 64);
        [backImage addSubview:lineview];
    }
    [self hiddenBackView];
}
- (void)backTapHiddeView{
    backview.hidden = YES;
    backisShow = YES;
}
- (void)naviBarBtnClick:(UIButton *)btn{
    backview.hidden = YES;
    backisShow = YES;
}
//隐藏back视图
- (void)hiddenBackView{
    if (backisShow) {
        backview.hidden = NO;
        backisShow = NO;
    }else{
        backview.hidden = YES;
        backisShow = YES;
    }
}
#pragma mark - 新消息处理
// 接收到新消息通知
- (void)newMessageReload:(NSNotification *)notification{
    
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        ChatMsgDTO *model = [[notification userInfo] objectForKey:@"newMessage"];
        if (![model.fromuid isEqualToString:self.chatId]) {
            return;
        }
        [self.dataArray addObject:model];
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [array1 addObject:path];
        [self.chatTableView insertRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationBottom];
        [self.chatTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    
}
#pragma mark - tabel代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //查询消息发送状态
    ChatMsgDTO *msgDto = (ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row];
    
    //3分钟内不显示时间
    BOOL isShowTime = YES;
    if(indexPath.row > 0){
        NSDate *nowMsgDate = [JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        //获取上一条消息的时间
        NSDate *cellLastTime = [JZCommon stringToDate:((ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row-1]).sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSTimeInterval cha= [ JZCommon timeDifference:cellLastTime :nowMsgDate];
        if(cha / 60 <= 3){
            isShowTime = NO;
        }
    }
    
    BOOL isShowName = NO;
    static NSString *cllID = @"chatCllID";
    MsgListTableViewCell *cell = (MsgListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cllID];
    if (cell) {
        cell.timeLable = nil;
        NSArray *contentArray = cell.contentView.subviews;
        for (UIView *subview in contentArray) {
            [subview removeFromSuperview];
        }
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (!cell){
        cell = [[MsgListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cllID];
    }
    cell.isShowTime = isShowTime;
    //    cell.emojiDic=emojiDic;
    cell.msgDto = msgDto;
    cell.isShowName = isShowName;
    //cell布局并赋值
    [cell initcellView];
    
    //设置长按事件
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    //longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    cell.chatMsgBg.tag = indexPath.row;
    //将长按手势添加到需要实现长按操作的视图里
    [cell.chatMsgBg addGestureRecognizer:longPress];
    
    cell.delegate = self;
    cell.tag = 40000 + indexPath.row;
    //为发送失败按钮增加重新发送事件
    if(0 == msgDto.success){
        self.sendMsgAgain = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.sendMsgAgain.frame = CGRectMake(cell.successViewButton.frame.origin.x, cell.successViewButton.frame.origin.y, cell.successViewButton.frame.size.width, cell.successViewButton.frame.size.height);
        [cell addSubview:self.sendMsgAgain];
        [cell.successViewButton addTarget:self action:@selector(clickSuccessViewButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.successViewButton.tag = indexPath.row;
    }
    else if(msgDto.success == 3)
    {
        //断网显示红点
        Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([r currentReachabilityStatus] == NotReachable) {
            msgDto.success = 0;
        }
        //有网判断时间超过3分钟判定为失败
        else
        {
            NSDate *date=[JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSString * mm = [JZCommon dateToString:date format:@"mm"];
            NSString * HH = [JZCommon dateToString:date format:@"HH"];
            NSString * mm1 = [JZCommon dateToString:[NSDate date] format:@"mm"];
            NSString * HH1 = [JZCommon dateToString:[NSDate date] format:@"HH"];
            if (![HH1 isEqualToString:HH]) {
                msgDto.success = 0;
            }
            else if(([mm1 intValue]-[mm intValue])>3)
            {
                msgDto.success = 0;
            }
        }
    }
    
    if(msgDto.filetype==3){
        //视频 初始化上传
//        if (!cell.uploadFile) {
//            cell.uploadFile = [[JZUploadFile alloc] initHost:[OperatePlist HTTPServerAddress] port:10000];
//            cell.uploadFile.delegate = self;
//        }
//        if (!msgDto.url) {
//            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//            NSString * toMp4Path = [cachPath stringByAppendingFormat:@"/output-%@.mp4", msgDto.msgid];
//            [cell.uploadFile uploadFilePath:toMp4Path fileName:msgDto.msgid];
//            [cell.uploadFile startUpload];
//        }
        CGFloat width=cell.videoImageView.frame.size.width - 5 ;
        CGFloat height=cell.videoImageView.frame.size.height;
        CGFloat labelx = 0;
        if (msgDto.sendtype == 1) {
            labelx = 5;
        }
        UILabel *bottomLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentRight];
        bottomLabel.backgroundColor=[UIColor lightGrayColor];
        bottomLabel.alpha=0.8;
        UILabel *sizeLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentLeft];
        UILabel *longLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentRight];
        sizeLabel.font=[UIFont systemFontOfSize:11];
        longLabel.font=[UIFont systemFontOfSize:11];
        if(msgDto.duration!=nil){
            longLabel.text=[NSString stringWithFormat:@"%02d:%02d",[msgDto.duration intValue]/60,[msgDto.duration intValue]%60];
            longLabel.textColor=[UIColor whiteColor];
        }
        if(msgDto.duration!=nil){
            sizeLabel.text = msgDto.totalsize;
            sizeLabel.textColor=[UIColor whiteColor];
        }
        
        [cell.videoImageView addSubview:bottomLabel];
        [cell.videoImageView addSubview:sizeLabel];
        [cell.videoImageView addSubview:longLabel];
//        if (!msgDto.url) {
//            [uploadData uplaodChatMessage:msgDto];
//        }
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled=YES;
    cell.contentView.backgroundColor = RGBCOLOR(226, 226, 226);
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //查询消息发送状态
    ChatMsgDTO *msgDto=(ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row];
    
    //3分钟内不显示时间
    BOOL isShowTime=YES;
    if(indexPath.row>0){
        NSDate *nowMsgDate=[JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        //获取上一条消息的时间
        NSDate *cellLastTime=[JZCommon stringToDate:((ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row-1]).sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSTimeInterval cha=[JZCommon timeDifference:cellLastTime :nowMsgDate];
        if(cha/60<=3){
            isShowTime=NO;
        }
    }
    BOOL isShowName=NO;
    
    CGFloat height=0;
    
    switch (msgDto.filetype) {
            //通知
        case 99:{
            CGSize msgSize = [JZCommon getTextSize:msgDto.content textFont:14 textMaxWidth:300];
            height= msgSize.height-20;
            break;
        }
            //文本
        case 0:{
            height = [[MsgListTableViewCell new] heightForMessageContent:msgDto.content].height;
            break;
        }
            //语音
        case 1:
            height=20;
            break;
            //图片
        case 2:{
            CGSize maxSize = {maximgWidth,maximgHeight};
            UIImage * cacheImg = [UIImage imageWithContentsOfFile:msgDto.localpath];
            if (!cacheImg) {
                cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JZCommon getFileDownloadPath:msgDto.url]];
            }
            CGSize imageSize=cacheImg.size;
            CGSize imgSize = [JZCommon imgScaleSize:imageSize :maxSize];
            height = imgSize.height-15;
            break;
        }
            //视频
        case 3:
            height = vedioimgHeight+15;
            break;
        default:
            height = 20;
            break;
            
    }
    if(isShowTime){
        height=height+65;
    }else{
        height=height+40;
    }
    if (isShowName) {
        height=height+20;
    }
    return height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self inputViewHeightChanged:0 duration:0.1];
}

#pragma mark - 语音播放 cell代理
-(void)playVoiceMessage:(MsgListTableViewCell *)cell {
    
//    if ([self appDelegate].isHasBackgroundMusic) {
//        //程序进入后台音乐开启
//        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
//        MPMusicPlaybackState playbackState = musicPlayer.playbackState;
//        if (playbackState == MPMusicPlaybackStatePlaying) {
//            [musicPlayer pause];
//        }
//    }
    [[JHAudioManager sharedInstance] audioStop];
    for (int i = 0; i < self.dataArray.count ; i++) {   //循环一次
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MsgListTableViewCell *testCell = (MsgListTableViewCell *)[self.chatTableView  cellForRowAtIndexPath:indexPath];
        if (testCell.msgDto.filetype == 1 && testCell.msgDto.msgid != cell.msgDto.msgid) {
            if ([testCell.soundImageView isAnimating]) {
                [testCell.soundImageView stopAnimating];
            }
        }
    }
    
    ChatMsgDTO *msg = cell.msgDto;
    if ([cell.soundImageView isAnimating]) {  // 判断是否正在播放
        [cell.soundImageView stopAnimating];
    } else {
        [JHAudioManager sharedInstance].Cancelblock = ^{
            //时间倒计时
            _audioTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi:) userInfo:cell repeats:YES];
        };
        [[JHAudioManager sharedInstance] changeMode];
        [[JHAudioManager sharedInstance] recordPlayChatMessage:msg];
        //如果标记为未读，则更改状态为已读
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",cell.msgDto.isread]]) {
            cell.msgDto.isread = @"1";
            [[ChatMsgListManage shareInstance]saveSendMsgRead:cell.msgDto];
            [cell hideReddot];
        }
        [cell.soundImageView startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:[msg.duration floatValue] target:self selector:@selector(stopPlayingAnimating:) userInfo:cell.soundImageView repeats:NO];
    }
    
}
- (void)daojishi:(NSTimer*)time{
    MsgListTableViewCell *cell = (MsgListTableViewCell*) time.userInfo;
    NSString *str = cell.audioTimeLengthLabel.text;
    NSInteger strtime = [[str substringToIndex:str.length-1] integerValue];
    [cell audioTimeLengthLabel].text = [NSString stringWithFormat:@"%ld ''",(long)strtime-1];
    if (strtime <= 1) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        [cell audioTimeLengthLabel].text = [NSString stringWithFormat:@"%ld ''",(long)[cell.msgDto.duration integerValue]];
        [_audioTime invalidate];
        _audioTime = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        return;
    }
}
- (void)stopPlayingAnimating:(NSTimer *)time {
    
    [time.userInfo stopAnimating];
}

#pragma mark 展示照片 加载完成
- (void)reloadImageInLoadSuccess{
    CGPoint point = self.chatTableView.contentOffset;
    [self.chatTableView reloadData];
    self.chatTableView.contentOffset = point;
}
#pragma mark - CInputView delegate

- (void)inputViewHeightChanged:(CGFloat)height duration:(CGFloat)duration
{
    __weak __typeof(self) weakSelf = self;
    // 告诉self.view约束需要更新
//    CGPoint contentPoint = self.chatTableView.contentOffset;
    [self.view setNeedsUpdateConstraints];
    [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.chatTableView.contentSize.height > Main_Height - height - 64) {
            make.top.equalTo(weakSelf.view).with.offset(-height);
        }
        make.bottom.equalTo(weakSelf.view).with.offset(-44 - height);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

//  录音动画
- (void)showRecordAnimation{
    if(!avdioView){
        avdioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height-44)];
        UIImageView *audioBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"chat_recording_back"]];
        audioBackImage.size = (CGSize){100 , 80};
        UIImageView *audioImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"chat_recording"]];
        audioImage.size = (CGSize){69 * (50 / 107.0),50};
        audioImage.center = audioBackImage.center = avdioView.center;
        [avdioView addSubview:audioBackImage];
        [avdioView addSubview:audioImage];
        [[self appDelegate].window addSubview:avdioView];
    }
}
- (void)stopRecordAnimation{
    [avdioView removeFromSuperview];
    
}
#pragma mark - 录音完成 + 更多按钮
- (void)postSoundWithUrlString:(NSString *)localpath andRecordTime:(NSString *)duration withRecordData:(NSData *)recData{
    [self stopRecordAnimation];
    ChatMsgDTO *msg = [[ChatMsgDTO alloc] init];
    msg.filetype = 1;
    msg.localpath=localpath;
    msg.fromuid=self.userId;
//    msg.sendName = sendname;
//    msg.receiverName = chatname;
    msg.touid=self.chatId;
    msg.sendtime=[JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.sendtype=0;
    msg.msgid=[JZCommon GUID];
    msg.duration = duration;
    msg.success =3;
    //保存本地数据
    [self savechatMsg:msg];
    //上传至文件服务器
    [uploadData uplaodChatMessage:msg];
}

//  更多代理
- (void)moveViewActionWithType:(MoreViewActionType)type{ //0 相册 1视频
    UIImagePickerController *controller=[[UIImagePickerController alloc]init];
    controller.delegate=self;
    NSArray *titlesArr = @[];
    if (type == MoreViewActionPhoto) {
        titlesArr = @[@"拍照",@"相册"];
    }else{
        titlesArr = @[@"录像",@"视频库"];
    }
    [[[HJAlertView alloc] init]showBottomAlertViewWithTitles:titlesArr ClickBtn:^(NSInteger index) {
        if (type == MoreViewActionPhoto) {
            if (index == 0) {
                BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (!isCamera) {
                    NSLog(@"没有摄像头");
                    return ;
                }
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                //拒绝访问相机弹出提示框
                if(authStatus == AVAuthorizationStatusDenied){
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"开启摄像头出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
            }else{
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
            }
        }else{
            if (index == 0) {
                BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (!isCamera) {
                    NSLog(@"没有摄像头");
                    return ;
                }
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                //拒绝访问相机弹出提示框
                if(authStatus == AVAuthorizationStatusDenied){
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"开启摄像头出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置图像选取控制器的类型为动态图像
                controller.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, nil];
                //设置摄像图像品质
                controller.videoQuality = UIImagePickerControllerQualityTypeMedium;
            }else{
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeMovie];
                controller.mediaTypes = mediaTypes;
            }
        }
        [self presentViewController:controller animated:YES completion:^(void){
            //NSLog(@"Picker View Controller is presented");
        }];
    }];
}
#pragma mark - 查看图片
- (void)showImageInMsgListTableViewCell:(MsgListTableViewCell *)cell{
    ReviewImageView *showImageview = [[ReviewImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) message:cell.msgDto];
    showImageview.recordVideo = ^(NSDictionary *dic){
        [self postSoundWithUrlString:dic[@"localPath"] andRecordTime:dic[@"recordTime"] withRecordData:dic[@"recordData"]];

    };
    [[self appDelegate].window addSubview:showImageview];
}

#pragma mark - 相机选择完成的回调    图片和视频的发送
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak ProblemDetailViewController* weakSelf = self;
    //ios7相册和相机都是从这里取照片
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]){
        UIImage *uploadImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        uploadImage=[image fixOrientation];
        ChatMsgDTO *msg=[[ChatMsgDTO alloc]init];
        msg.msgid=[JZCommon GUID];
        
        //保存缓存
//        UIImage *ThumbnailImage=[self imageWithImage:uploadImage scaledToSize:CGSizeMake(uploadImage.size.width/3, uploadImage.size.height/3)];
//        NSString *ThumbnailStr=[[JHCacheManager sharedInstance] saveImage:ThumbnailImage imageName:[CommonCore GUID] userid:self.userId];
        //保存本地消息
        msg.filetype = 2;
        msg.localpath = [[JHCacheManager sharedInstance] saveImage:uploadImage imageName:[JZCommon GUID] userid:self.userId];
        msg.thumbnail = msg.localpath;
        msg.fromuid = self.userId;
        msg.touid = self.chatId;
        msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        msg.sendtype = 0;
        msg.chatType = 0;
        
        msg.isread=@"1";
        msg.success=3;
        //保存本地数据
        [self savechatMsg:msg];
        [uploadData uplaodChatMessage:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        });
    }
    //视频
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        //视频地址
        NSURL *videoURL=info[UIImagePickerControllerMediaURL];
        NSData *videoData=[NSData dataWithContentsOfURL:videoURL];
        //得到MP4第一帧
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = self.view.frame.size;
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
        UIImage *VideoImg=[UIImage imageWithCGImage:img];
        //图片本地路径
        NSString *VideoImgStr = [[JHCacheManager sharedInstance] saveImage:VideoImg imageName:[JZCommon GUID] userid:self.userId];
        NSString *msgid = [JZCommon GUID];
        //保存本地消息
        ChatMsgDTO *msg = [[ChatMsgDTO alloc]init];
        msg.filetype = 3;
        msg.fromuid = self.userId;
        msg.touid = self.chatId;
        msg.thumbnail = VideoImgStr;//本地缩略图
        msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        msg.sendtype = 0;
        msg.chatType = 0;
        msg.msgid = msgid;
        msg.isread = @"1";
        msg.success = 3;
        //断网显示红点
        Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([r currentReachabilityStatus] == NotReachable) {
            msg.success = 0;
            //提示用户;
        }
        //            //更新本地消息
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString * toMp4Path = [cachPath stringByAppendingFormat:@"/output-%@.mp4", msg.msgid];
        
        [videoData writeToFile:toMp4Path atomically:YES];
        //            [NSString stringWithFormat:@"%dKB",[msgDto.totalsize intValue]/1024]
        NSInteger mp4size = [self getFileSize:toMp4Path];
        NSString *fileSize = @"";
        NSString *videoLen = @"";
        if (mp4size > 1024 * 1024) {
            fileSize = [NSString stringWithFormat:@"%.1fMB", mp4size / (1024 * 1024.0)];
        }else if (mp4size > 1024){
            fileSize = [NSString stringWithFormat:@"%ldKB", mp4size / 1024];
        }else{
            fileSize = [NSString stringWithFormat:@"%ldB", mp4size];
        }
        videoLen = [NSString stringWithFormat:@"%.0f",[self getVideoDuration:[NSURL fileURLWithPath:toMp4Path]]];//毫秒上传
        msg.totalsize = fileSize;
        msg.duration = videoLen;
        msg.localpath = toMp4Path;
        msg.content = toMp4Path;//解码后的路径
        //保存本地数据
        [self savechatMsg:msg];
        [uploadData uplaodChatMessage:msg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            }];
//            [self.inputTool initInputTextState];
        });
    }
}



#pragma mark - 发送文字消息及消息上传
- (void)sendMessageToChat:(NSString *)text {
    
    NSString *content = [[JHFacePlist sharedInstance]formatMsgText:text];
    ChatMsgDTO *msg = [[ChatMsgDTO alloc]init];
    msg.content = content;
    msg.filetype = 0;
    msg.url = nil;
    msg.fromuid = self.userId;
    msg.touid = self.chatId;
    msg.sendtype = 0;
    msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.msgid = [JZCommon GUID];
    msg.localpath = nil;
    msg.chatType = 0;
    msg.success = 3;
    //本地保存
    [self savechatMsg:msg];
    //发送文本消息
    [self sendContent:msg];
    
}
#pragma mark---公共方法 保存数据 上传文件代理

//保存消息
- (void)savechatMsg:(ChatMsgDTO *)msg {
    //聊天记录进入后,按正常的聊天
    //    self.searchType=0;
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self.dataArray addObject:msg];
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [array1 addObject:path];
        [self.chatTableView insertRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationBottom];
        [self.chatTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    //子线程保存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存消息表
        [[ChatMsgListManage shareInstance]saveChatMsg:msg];
        //保存消息汇总信息
        [[MsgSummaryManage shareInstance] dealMsgSummary:msg :self.chatId];
        
    });
    
    //设置为有新消息
    //    [self appDelegate].isHaveNewMsg=YES;
    
}

#pragma mark - 发送消息

//发送消息内容   判断有没网
- (void)sendContent:(ChatMsgDTO *)msg {
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable){
        //更新消息发送状态
        msg.success=0;
//        [self reloadCell:msg.msgid];
        //子线程保存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ChatMsgListManage shareInstance] saveSendMsgSuccess:msg];
        });
    }
    else{
        //子线程保存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[XMPPManager sharedManager] sendMessage:msg];
        });
        
    }
}
#pragma mark - 发送成功代理
- (void)sendMessageIsSuccess:(XMPPMessage *)message{
    //    NSString *msg = [[message elementForName:@"body"] stringValue];
    //    NSString *type = [[message elementForName:@"messageType"] stringValue];
    if (message.isErrorMessage) {
        return;
    }
    if ([[[message elementForName:@"messageIsSuccess"] stringValue] integerValue] == 1){
        NSString *msgid = [[message attributeForName:@"id"] stringValue]; //huizhi
        for (ChatMsgDTO * chatmsg in self.dataArray) {
            if ([chatmsg.msgid isEqualToString:msgid]) {
                chatmsg.success = 1;
                NSInteger indexcell = [self.dataArray indexOfObject:chatmsg];
                //            将收到消息更新到数据库
                [[ChatMsgListManage shareInstance] saveSendMsgSuccess:chatmsg];
                MsgListTableViewCell *cell = (MsgListTableViewCell*)[self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexcell inSection:0]];
                [cell.avi stopAnimating];
                return;
                
            }
        }
    }else{
        NSString *msgid = [[message attributeForName:@"id"] stringValue]; 
        for (ChatMsgDTO * chatmsg in self.dataArray) {
            if ([chatmsg.msgid isEqualToString:msgid]) {
                chatmsg.success = 0;
                NSInteger indexcell = [self.dataArray indexOfObject:chatmsg];
                //            将收到消息更新到数据库
                [[ChatMsgListManage shareInstance] saveSendMsgSuccess:chatmsg];
                MsgListTableViewCell *cell = (MsgListTableViewCell*)[self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexcell inSection:0]];
                [cell.avi stopAnimating];
                if (!cell.successViewButton) {
                    cell.successViewButton=[[UIButton alloc]initWithFrame:CGRectMake(cell.chatMsgBg.frame.origin.x-20, cell.chatMsgBg.frame.origin.y+(cell.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                    [cell.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:cell.successViewButton];
                }
                else {
                    [cell.successViewButton setFrame:CGRectMake(cell.chatMsgBg.frame.origin.x-20, cell.chatMsgBg.frame.origin.y+(cell.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                    [cell.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
                }
                if (cell.msgDto.filetype == 1) {
                    CGRect btnframe = cell.successViewButton.frame;
                    btnframe.origin.x -= 35;
                    cell.successViewButton.frame = btnframe;
                }
                [cell.successViewButton addTarget:self action:@selector(clickSuccessViewButton:) forControlEvents:UIControlEventTouchUpInside];
                cell.successViewButton.tag=indexcell;
                return;
                
            }
        }
    }
}

- (void)clickSuccessViewButton:(UIButton *)btn{
    
}


#pragma mark -跳转操作
- (void)backTolistView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建button方法
- (UIButton *)creatImageBtnWithTitlt:(NSString *)title titCloro:(UIColor *)color leftImage:(NSString *)imagename{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 70)];
    return btn;
    
}
#pragma mark - 视频工具类
//获取视频时长
- (CGFloat)getVideoDuration:(NSURL *)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}
//获取视频大小
- (NSInteger)getFileSize:(NSString *)path {
    NSFileManager * filemanager=[[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
        return -1;
}
- (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
