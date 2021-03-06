//
//  DetailsViewController.m
//  Instagram
//
//  Created by Alice Park on 7/10/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "DetailsViewController.h"
#import "ParseUI.h"
#import "DateTools.h"
#import "CommentViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomUsername;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    
    self.usernameLabel.text = self.post.userID;
    self.bottomUsername.text = self.post.userID;
    self.photoView.file = self.post.image;
    [self.photoView loadInBackground];
    
    self.captionLabel.text = self.post.caption;
    
    if(self.post.likers == nil) {
        self.numLikes.text = @"0";
    } else {
        self.numLikes.text = [NSString stringWithFormat:@"%lu", self.post.likers.count];
    }
    
    PFUser *currUser = [PFUser currentUser];
    
    if([self.post.likers containsObject:currUser.objectId]) {
        
        [self.likeButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
        
    } else {
        
        [self.likeButton setImage:[UIImage imageNamed:@"white_heart_icon"] forState:UIControlStateNormal];
    }
    
    NSDate *date =self.post.createdAt;
    self.timeStamp.text = date.timeAgoSinceNow;
    
    self.profilePic.file = self.post.author[@"pic"];
    [self.profilePic loadInBackground];
    self.photoView.layer.borderWidth = 0.5f;
    self.photoView.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (IBAction)didTapLike:(id)sender {
    
    [self.post didLike:self.post];
    [self refreshData];
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextViewController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"commentDetailSegue"]) {
        
        CommentViewController *commentController = (CommentViewController *)nextViewController;
        commentController.post = self.post;

    }
}


@end
