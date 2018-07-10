//
//  PostCell.m
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "PostCell.h"


@implementation PostCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoView.file = post[@"image"];
    [self.photoView loadInBackground];
    self.caption.text = post[@"caption"];
    self.topUsername.text = post[@"userID"];
    self.bottomUsername.text = post[@"userID"];
}

@end
