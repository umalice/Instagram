//
//  PostCell.h
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (strong, nonatomic) Post *post;

@end
