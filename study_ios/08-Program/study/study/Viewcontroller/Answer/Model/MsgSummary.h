//
//  MsgSummary.h
//  jinherIU
//  消息汇总表实体
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MsgSummary : NSObject

@property (nonatomic, copy) NSString * ownerid;//所有者id
@property (nonatomic, copy) NSString * chatid;//聊天对象  //关注屏蔽时为 userid
@property (nonatomic, assign) NSInteger chartype;//聊天类型
@property (nonatomic, copy) NSString * toptime;//置顶时间 暂时改为消息来源
@property (nonatomic, copy) NSDate * date;//发送时间
@property (nonatomic, copy) NSString * content;//发送内容
@property (nonatomic, assign) NSInteger filetype;//文件了下
@property (nonatomic, assign) NSInteger count;//新消息数
@property (nonatomic, assign) BOOL istop;//是否置顶
@property (nonatomic, copy) NSString* isRead;//已读1，未读0
@property (nonatomic, copy) NSString* state;//成功1，失败0
@property (nonatomic, copy) NSString*msgid;//消息id
@property (nonatomic, copy) NSString* chatphoto;//聊天对象头像

@property (nonatomic) NSInteger segmentIndex;//选择的下标
@property (nonatomic, copy) NSString* nickname;//昵称
@property (nonatomic, copy) NSString* signature;//签名
@property (nonatomic, copy) NSString* totalDay;// 天数
@property (nonatomic, copy) NSString* totalFeed;// 瞬间

@end
