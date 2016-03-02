//
//  XMPPManager.h
//  XMPPTest
//
//  Created by mijibao on 15/9/22.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "ChatMsgDTO.h"
//#import "MessageModel.h"
@protocol xmppDelegate <NSObject>

- (void)sendMessageIsSuccess:(XMPPMessage*)message;

@end

@interface XMPPManager : NSObject

// 单例入口
+ (instancetype)sharedManager;
// 连接
- (BOOL)connect;
// 断开连接
- (BOOL)disconnect;
// 上线
- (void)goOnline;
// 下线
- (void)goOffline;
// 注销连接设置
- (void)teardownStream;
// 发送消息
- (void)sendMessage:(ChatMsgDTO *)model;
@property (nonatomic ,weak) id<xmppDelegate>delegate;
@end
