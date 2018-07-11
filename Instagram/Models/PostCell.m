//
//  PostCell.m
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"


@implementation PostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePic addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePic setUserInteractionEnabled:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoView.file = post.image;
    [self.photoView loadInBackground];
    self.caption.text = post.caption;
    self.topUsername.text = post.author.username;
    self.bottomUsername.text = post.author.username;
    self.timestamp.text = [NSString stringWithFormat:@"%@", post.createdAt];
    
    NSDate *date = post.createdAt;
    self.timestamp.text = date.timeAgoSinceNow;
    
    self.profilePic.file = post.author[@"pic"];
    [self.profilePic loadInBackground];
    
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    
    [self.delegate postCell:self didTap:self.post.author];
    
}

@end
