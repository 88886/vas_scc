//
//  CommentTabelViewCell.m
//  study
//
//  Created by mijibao on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentTabelViewCell.h"

#define kContentFont [UIFont systemFontOfSize:13] //内容字体

@interface CommentTabelViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView; //评论照片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;  //评论名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  //评论时间
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;  //评论内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight; //评论内容高度

@end

@implementation CommentTabelViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:  reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:2];
    }
    return self;
}

//设置cell内容和高度
- (void)setMessage:(CommentModel *)message {
    _message = message;
    _headImageView.image = [UIImage imageNamed:message.image];
    _nameLabel.text = message.name;
    _timeLabel.text = message.time;
    NSDictionary *attributes = @{NSFontAttributeName:kContentFont};
   CGSize contentSize = [_message.content boundingRectWithSize:CGSizeMake(WIDTH(_contentLabel), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    _commentHeight.constant = contentSize.height+10;
    _cellHeight = _contentLabel.frame.origin.y + contentSize.height+10;
    _contentLabel.text = message.content;

}

@end
