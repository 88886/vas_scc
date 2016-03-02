//
//  HJAlertView.m
//  study
//
//  Created by jzkj on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "HJAlertView.h"
#import "AppDelegate.h"

@interface HJAlertView (){
//    UIView *backView;//背景视图
}
@property (nonatomic ,copy) void(^selectIndex)(NSInteger);
@end


@implementation HJAlertView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
*  底部alert
*
*  @param titles      title数组
*  @param selectIndex 回调block 从0开始
*/
- (void)showBottomAlertViewWithTitles:(NSArray *)titles ClickBtn:(void(^)(NSInteger))selectIndex{
    self.selectIndex = selectIndex;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - (titles.count + 1) * 47, Main_Width, (titles.count + 1) * 47)];
    alertview.backgroundColor = RGBCOLOR(202, 202, 202);
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 46 * idx, Main_Width, 45);
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
        btn.tag = 140 + idx;
        [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertview addSubview:btn];
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,(titles.count + 1) * 47 -45 , Main_Width, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
    btn.tag = 139;
    [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alertview addSubview:btn];
    [self addSubview:alertview];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:self];
}
- (void)alertBtnClick:(UIButton *)btn{
    [self removeFromSuperview];
    switch (btn.tag){
        case 140:
            _selectIndex(0);
            break;
        case 141:
            _selectIndex(1);
            break;
        case 142:
            _selectIndex(2);
            break;
        case 143:
            _selectIndex(3);
            break;
        case 144:
            _selectIndex(4);
            break;
        default:
            break;
            
    }
}
- (AppDelegate *)appDeleGate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
