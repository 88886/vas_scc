//
//  AppDelegate.m
//  study
//
//  Created by mijibao on 16/1/14.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "XMPPManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (instancetype)init
{
    if (self = [super init]) {
        _qq = [QQ new];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self createRootViewCon];//创建根视图
    //copy数据库
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"study.sqlite"];
    NSLog(@"==================%@",path);
    //copy the sqlite file to documents directory
    if(![fm fileExistsAtPath:path]){
        NSString *pathInBundle = [[NSBundle mainBundle] pathForResource:@"study" ofType:@"sqlite"];
        NSError *error;
        [fm copyItemAtPath:pathInBundle toPath:path error:&error];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createRootViewCon) name:KChangeRootView object:nil];
    // 百度地图API
    if (![[[BMKMapManager alloc] init] start:@"YQMgOZ5fkUGKTYH4UhDKCoAV" generalDelegate:nil]) {
        NSLog(@"manager strat filed!");
    }
    
    BOOL enable=[CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status=[CLLocationManager authorizationStatus];
    CLLocationManager *_manager = [[CLLocationManager alloc] init];
    [_manager requestAlwaysAuthorization];
    
    if(!enable || status<3){
        //请求权限
        [_manager requestWhenInUseAuthorization];
        
    }
    /**
     *  微信支付
     */
    //1.导入微信支付SDK,注册微信支付 wx06b53d4240a34e64
    //2.设置微信APPID为URL Schemes
    //3.导入微信支付依赖的类库,发起支付，调起微信支付
    //4.处理支付结果
//    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"ios weixin Pay Demo"];
 
    /**
     *  友盟分享
     */
    //设置友盟appKey  wxdc1e388c3822c80b
    [UMSocialData setAppKey:@"56af73fee0f55a9704002922"];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx06b53d4240a34e64" appSecret:@"4250b2d20fdcca664126af5a0a39e538" url:@"http://www.umeng.com/social"];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:@"1104693963" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //
    
    return YES;
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:self];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        NSLog(@"调用其它SDK");
    }
    return result;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)createRootViewCon{
    if ([UserInfoList loginStatus]) {
        [[XMPPManager sharedManager] connect];
        RootViewController *rootVC = [[RootViewController alloc] init];
        self.window.rootViewController = rootVC;
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        self.window.rootViewController = login;
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

@end
