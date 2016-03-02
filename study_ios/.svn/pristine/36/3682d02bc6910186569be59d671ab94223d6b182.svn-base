//
//  LoginCore.m
//  study
//
//  Created by mijibao on 15/9/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "LoginCore.h"
#import "MD5Tool.h"
#import "UserInfoList.h"



@implementation LoginCore

//登陆请求
- (void)loginUrlRequestWithUserName:(NSString *)userName
                           passCode:(NSString *)passCode
                            andType:(NSString *)type
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/clientLogin.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"phone"];
    [params setObject:passCode forKey:@"password"];
    [params setObject:type forKey:@"type"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
    {
        if (result)
        {
            NSString *returnResult = [[NSString alloc]init];
            returnResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            if ([returnResult isEqualToString:@"4"] || [returnResult isEqualToString:@"5"]) {
                //登录失败
                if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
                    [self.delegate passLoginResult:returnResult];
                }
            }else{
                //登录成功
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = dataArr[0];
                [self saveInfomation:dic[@"age"] withKey:[AccountManeger loginUserAge]];
                [self saveInfomation:dic[@"city"] withKey:[AccountManeger loginUserCity]];
                [self saveInfomation:dic[@"gender"] withKey:[AccountManeger loginUserGender]];
                [self saveInfomation:dic[@"grade"] withKey:[AccountManeger loginUserGrade]];
                [self saveInfomation:dic[@"id"] withKey:[AccountManeger loginUserId]];
                [self saveInfomation:dic[@"nickname"] withKey:[AccountManeger loginUserNickname]];
                [self saveInfomation:dic[@"password"] withKey:[AccountManeger loginUserPassword]];
                [self saveInfomation:dic[@"phone"] withKey:[AccountManeger loginUserPhone]];
                [self saveInfomation:dic[@"photo"] withKey:[AccountManeger loginUserPhoto]];
                [self saveInfomation:dic[@"picture"] withKey:[AccountManeger loginUserPicture]];
                [self saveInfomation:dic[@"province"] withKey:[AccountManeger loginUserProvince]];
                [self saveInfomation:dic[@"signature"] withKey:[AccountManeger loginUserSignature]];
                [self saveInfomation:dic[@"type"] withKey:[AccountManeger loginUserType]];
                [self saveInfomation:dic[@"school"] withKey:[AccountManeger loginUserSchool]];
                [self saveInfomation:dic[@"subject"] withKey:[AccountManeger loginUserSubject]];
                 [self saveInfomation:dic[@"honors"] withKey:[AccountManeger loginUserHonors]];
                [defaults setBool:YES forKey:[AccountManeger loginStatus]];
                [defaults setObject:userName forKey:KLoginUserTelPhone];
                [[NSNotificationCenter defaultCenter]postNotificationName:KChangeRootView object:nil userInfo:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //网络请求错误
        NSString *errorString = [NSString stringWithFormat:@"%@", error];
        if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
            [self.delegate passLoginResult:errorString];
        }
    }];
}

//获取验证码
- (void)getAcessCodeWithUserPhone:(NSString *)phone
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/phoneCode.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result)
         {
             NSString *returnResult = [[NSString alloc]init];
             returnResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
             if ([returnResult isEqualToString:@"2"]) {
                 if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]) {
                     [self.delegate passPhoneCodeResult:NO returnResult:nil];
                 }
             }else{
                 [[NSUserDefaults standardUserDefaults] setObject:returnResult forKey:kAccessPhoneCode];
                 if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]) {
                     [self.delegate passPhoneCodeResult:YES returnResult:returnResult];
                 }
             }
             NSLog(@"获取到了验证码");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //网络请求错误
         if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]) {
             [self.delegate passPhoneCodeResult:NO returnResult:nil];
         }
     }];
}

- (void)saveInfomation:(id)saveObjec withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *saveString = (saveObjec == [NSNull null] || saveObjec == nil) ? @"" : saveObjec;
    [defaults setObject:saveString forKey:key];
}
@end

