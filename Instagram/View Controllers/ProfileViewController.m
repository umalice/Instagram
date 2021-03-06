//
//  ProfileViewController.m
//  Instagram
//
//  Created by Alice Park on 7/10/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIKit/UIKit.h>
#import "ProfileCell.h"
#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EditViewController.h"
#import "Post.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *numPostsLabel;

@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) BOOL isMoreData;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    if(self.currUser == nil) {
        self.currUser = [PFUser currentUser];
    }
    
    [self fetchPosts];
    [self refreshData];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (postersPerLine - 1))) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.editButton.layer.borderWidth = 0.5f;
    self.editButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    
    if(self.currUser.username == [PFUser currentUser].username) {
        [self.editButton setTitle:@"Edit profile" forState:UIControlStateNormal];
    } else {
        [self.editButton setTitle:@"Message" forState:UIControlStateNormal];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];


}

- (void)viewDidAppear:(BOOL)animated {
    
    [self refreshData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadMoreData{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    Post *lastPost = self.posts[self.posts.count - 1];
    NSDate *lastDate = lastPost.createdAt;
    [query whereKey:@"createdAt" lessThan:lastDate];
    query.limit = 20;
    
    [query whereKey:@"author" equalTo:self.currUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            [self.posts addObjectsFromArray:posts];
            [self.currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"Saved!");
                    
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
            
            self.isMoreDataLoading = NO;
            [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
            [self.collectionView reloadData];
            [self refreshData];
            
            if(posts.count <= 20) {
                self.isMoreData = NO;
            }
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if((!self.isMoreDataLoading) && self.isMoreData){

        int scrollViewContentHeight = self.collectionView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
            self.isMoreDataLoading = YES;
            [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
            [self loadMoreData];
        }
        
    }
}

- (void)refreshData {
    
    if(self.currUser[@"name"] == nil) {
        self.currUser[@"name"] = self.currUser.username;
    }

    if(self.currUser[@"bio"] == nil) {
        self.currUser[@"bio"] =  @"i love codepath (placeholder)";
    }
    
    if(self.currUser[@"numPosts"] == nil) {
        self.currUser[@"numPosts"] = [NSNumber numberWithInteger:0];
    }
    
    if(self.currUser[@"pic"] == nil) {
        NSData *placeholderImageData = UIImagePNGRepresentation([UIImage imageNamed:@"image_placeholder"]);
        self.currUser[@"pic"] = [PFFile fileWithName:@"pic.png" data:placeholderImageData];
    }
    
    [self.currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Saved!");
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
    self.navigationItem.title = self.currUser.username;
    self.nameLabel.text = self.currUser[@"name"];
    self.bioLabel.text = self.currUser[@"bio"];
    self.profilePic.file = self.currUser[@"pic"];
    [self.profilePic loadInBackground];
    self.numPostsLabel.text = [NSString stringWithFormat:@"%@", self.currUser[@"numPosts"]];
    
    
    
}

- (void)fetchPosts {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query whereKey:@"author" equalTo:self.currUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            self.isMoreData = YES;
            
            [self.currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"Saved!");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
            
            [self.collectionView reloadData];
            [self refreshData];
            [self.refreshControl endRefreshing];

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextViewController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
        
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        
        Post *post = self.posts[indexPath.row];
        
        DetailsViewController *detailController = (DetailsViewController *)nextViewController;
        
        detailController.post = post;
        
    } else if([segue.identifier isEqualToString:@"myEditSegue"]) {
        
        EditViewController *editController = (EditViewController *)nextViewController.topViewController;

        editController.currUser = self.currUser;
        
    }
        
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    
    [cell setPost:self.posts[indexPath.row]];
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.posts count];
}

- (IBAction)didLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
}

    
@end
    
