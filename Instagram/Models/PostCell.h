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
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@property (weak, nonatomic) IBOutlet UILabel *topUsername;
@property (weak, nonatomic) IBOutlet UILabel *bottomUsername;





@end
