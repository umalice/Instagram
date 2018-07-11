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

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomUsername;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    
    self.usernameLabel.text = self.post[@"userID"];
    self.bottomUsername.text = self.post[@"userID"];
    self.photoView.file = self.post[@"image"];
    self.captionLabel.text = self.post[@"caption"];
    
    NSDate *date =self. post.createdAt;
    self.timeStamp.text = date.timeAgoSinceNow;
    [self.photoView loadInBackground];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
