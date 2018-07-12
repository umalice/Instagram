//
//  Post.h
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *postID;
@property (nonatomic, strong, nonnull) NSString *userID;
@property (nonatomic, strong, nonnull) PFUser *author;

@property (nonatomic, strong, nonnull) NSString *caption;
@property (nonatomic, strong, nonnull) PFFile *image;
@property (nonatomic) int likeCount;
@property (nonatomic) int commentCount;
@property (nonatomic, strong, nonnull) NSMutableArray *likers;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (void) didLike:(Post *_Nullable)post;


@end
