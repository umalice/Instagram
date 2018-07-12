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
    
    UITapGestureRecognizer *topUserTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    UITapGestureRecognizer *bottomUserTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    [self.profilePic addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePic setUserInteractionEnabled:YES];
    
    [self.topUsername addGestureRecognizer:topUserTapGestureRecognizer];
    [self.topUsername setUserInteractionEnabled:YES];
    
    [self.bottomUsername addGestureRecognizer:bottomUserTapGestureRecognizer];
    [self.bottomUsername setUserInteractionEnabled:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

}

- (void)refreshData {
    
   self.numLikes.text = [NSString stringWithFormat:@"%i", self.post.likeCount];
    
    PFUser *currUser = [PFUser currentUser];
    
    if([self.post.likers containsObject:currUser.objectId]) {
        
        [self.likeButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
        
    } else {
        
        [self.likeButton setImage:[UIImage imageNamed:@"white_heart_icon"] forState:UIControlStateNormal];
    }
    
}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoView.file = post.image;
    [self.photoView loadInBackground];
    self.caption.text = post.caption;
    self.topUsername.text = post.author.username;
    self.bottomUsername.text = post.author.username;
    self.timestamp.text = [NSString stringWithFormat:@"%@", post.createdAt];
    
    if(post.likers == nil) {
        self.numLikes.text = @"0";
    } else {
        self.numLikes.text = [NSString stringWithFormat:@"%i", self.post.likeCount];
    }
    
    NSDate *date = post.createdAt;
    self.timestamp.text = date.timeAgoSinceNow;
    
    self.profilePic.file = post.author[@"pic"];
    [self.profilePic loadInBackground];
    
    self.photoView.layer.borderWidth = 0.5f;
    self.photoView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self refreshData];
    
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    
    [self.delegate postCell:self didTap:self.post.author];
    
}

- (IBAction)didTapLike:(id)sender {
    
    [self.post didLike:self.post];
    [self refreshData];
    
}




@end
