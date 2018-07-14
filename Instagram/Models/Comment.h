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

@property (nonatomic, strong) Post * _Nullable post;
@property (nonatomic, strong) PFUser * _Nullable commenter;
@property (nonatomic, strong) NSString * _Nullable comment;
@property (nonatomic, strong, nonnull) NSString *postID;

+ (void) postComment: (Post * _Nullable)post withCommenter: (PFUser * _Nullable)commenter withcomment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end
