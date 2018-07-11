//
//  ProfileCell.m
//  Instagram
//
//  Created by Alice Park on 7/10/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "ProfileCell.h"
#import "Post.h"

@implementation ProfileCell

- (void)setPost:(Post *)post {
    _post = post;
    self.photoView.file = post.image;
    [self.photoView loadInBackground];
}


@end
