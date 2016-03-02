//
//  PartnerInfoOneTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoOneTableViewCell.h"

@implementation PartnerInfoOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //行标签
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSString *string = @"所获荣誉：";
        CGSize size = [string sizeWithAttributes:dic];
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 , 0, size.width, widget_height(70))];
        _signLabel.textAlignment = NSTextAlignmentLeft;
        _signLabel.font = [UIFont systemFontOfSize:13];
        _signLabel.textColor = UIColorFromRGB(0x656565);
        [self.contentView addSubview:_signLabel];
        //内容
        _contentText = [[UITextView alloc] initWithFrame:CGRectMake(MaxX(_signLabel), 3, Main_Width -  widget_width(280), widget_height(70))];
        _contentText.textAlignment = NSTextAlignmentLeft;
        _contentText.font = [UIFont systemFontOfSize:13];
        _contentText.textColor = UIColorFromRGB(0x8e8e8e);
        _contentText.scrollEnabled = NO;
        _contentText.userInteractionEnabled = NO;
        _contentText.showsVerticalScrollIndicator = NO;
        _contentText.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_contentText];
    }
    return self;
}


@end
