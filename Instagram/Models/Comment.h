//
//  Comment.h
//  Instagram
//
//  Created by Alice Park on 7/12/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) PFUser *commenter;
@property (nonatomic, strong) NSString *comment;

@end
