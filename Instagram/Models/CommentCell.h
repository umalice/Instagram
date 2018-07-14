//
//  CommentCell.h
//  Instagram
//
//  Created by Alice Park on 7/12/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property(nonatomic, strong) Comment *comment;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

-(void) setComment:(Comment *)comment;


@end
