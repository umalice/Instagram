//
//  Post.m
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "Post.h"

@implementation Post
    @dynamic postID, userID, author, caption, image, likeCount, commentCount, likers;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: (UIImage * _Nullable)image withCaption: (NSString * _Nullable)caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.userID = newPost.author.username;
    
    if(newPost.author[@"numPosts"] == nil) {
        newPost.author[@"numPosts"] = [NSNumber numberWithInteger:1];
    } else {
        int newNum = [newPost.author[@"numPosts"] intValue] + 1;
        newPost.author[@"numPosts"] = [NSNumber numberWithInteger:newNum];

    }

    newPost.caption = caption;
    newPost.likeCount = 0;
    newPost.commentCount = 0;
    newPost.likers = [NSMutableArray new];
    
    [newPost saveInBackgroundWithBlock: completion];
    [newPost.author saveInBackground];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (!imageData) {
        return nil;
    }

    return [PFFile fileWithName:@"image.png" data:imageData];
}


- (void) didLike:(Post *)post {
    
    PFUser *currUser = [PFUser currentUser];
    
    //already likes the post
    if([post.likers containsObject:currUser.objectId]) {
        
        [post.likers removeObject:currUser.objectId];
        post.likeCount--;
        
    } else {
        
        [post.likers addObject:currUser.objectId];
        post.likeCount++;
    }
    
    [post setObject:post.likers forKey:@"likers"];
    [post saveInBackground];
    
    
}


@end
