//
//  HJAlertView.h
//  study
//
//  Created by jzkj on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJAlertView : UIView
/**
 *  底部alert
 *
 *  @param titles      title数组
 *  @param selectIndex 回调block 从0开始
 */
- (void)showBottomAlertViewWithTitles:(NSArray *)titles ClickBtn:(void(^)(NSInteger))selectIndex;
@end
