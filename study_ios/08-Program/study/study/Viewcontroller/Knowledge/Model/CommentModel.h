//
//  CommentModel.h
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *image;      //照片
@property (nonatomic, copy) NSString *name;       //名字
@property (nonatomic, copy) NSString *time;       //时间
@property (nonatomic, copy) NSString *content;    //内容
@property (nonatomic, strong) NSDictionary *dict; //字典

@end
