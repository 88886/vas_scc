//
//  PopMenuView.h
//  study
//
//  Created by mijibao on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopMenuView;
@protocol PopMenuViewDelegate <NSObject>

- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popTitle:(NSString *)popTitle;


@end

@interface PopMenuView : UIView

@property (nonatomic, assign) id<PopMenuViewDelegate> delegate; //代理

- (void)popMenuViewWithTitle:(NSString *)title popList:(NSArray *)poplist;

@end
