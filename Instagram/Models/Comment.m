//
//  Comment.m
//  Instagram
//
//  Created by Alice Park on 7/12/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic post, comment, commenter, postID;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postComment: (Post * _Nullable)post withCommenter: (PFUser * _Nullable)commenter withcomment: (NSString * _Nullable)comment withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Comment *newComment = [Comment new];
    
    newComment.post = post;
    newComment.commenter = commenter;
    newComment.comment = comment;
    
    [newComment saveInBackgroundWithBlock: completion];
}

@end
