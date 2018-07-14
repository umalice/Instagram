//
//  CommentCell.m
//  Instagram
//
//  Created by Alice Park on 7/12/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "CommentCell.h"
#import "DateTools.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment {
    
    //profilePic, usernameLabel, commentLabel, timeStamp
    _comment = comment;
    self.usernameLabel.text = comment.commenter.username;
    self.commentLabel.text = comment.comment;
    
    NSDate *date = comment.createdAt;
    self.timeStamp.text = date.shortTimeAgoSinceNow;
    
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.file = comment.commenter[@"pic"];
    [self.profilePic loadInBackground];
    
    
    
}

@end
