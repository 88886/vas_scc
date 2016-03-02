//
//  ImageRequestCore.m
//  study
//
//  Created by mijibao on 15/10/15.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "ImageRequestCore.h"
#import "UIImageView+MJWebCache.h"

@implementation ImageRequestCore

+ (void)requestImageWithPath:(NSString *)path withImageView:(UIImageView *)imageView placeholderImage:(UIImage *)image
{
    if (path) {
        NSString *imageStr =[JZCommon getFileDownloadPath:path];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image];
    }else{
        [imageView setImage:image];
    }
}

@end
