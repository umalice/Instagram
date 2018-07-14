//
//  HomeViewController.m
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PostCell.h"
#import "ProfileViewController.h"
#import "MBProgressHUD.h"
#import "CommentViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate, UIScrollViewDelegate, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) BOOL isMoreData;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tabBarController.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram banner"]];
    CGSize imageSize = CGSizeMake(90, 30);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    
    self.banner.frame = CGRectMake(marginX, imageSize.height/2 - 5, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:self.banner];
    
}

- (void)viewDidAppear:(BOOL)animated {

    [self.banner setValue:@NO forKeyPath:@"hidden"];
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

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
                
            [self.posts addObjectsFromArray:posts];
            self.isMoreDataLoading = NO;
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            [self.tableView reloadData];
            
            if(posts.count < 20) {
                self.isMoreData = NO;
            }
            
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if((!self.isMoreDataLoading) && self.isMoreData){
        
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            [self loadMoreData];
        }
        
    }
}

- (void)fetchPosts {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            self.isMoreData = YES;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)didLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
}

- (IBAction)didCompose:(id)sender {
    
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];

    [cell setPost:self.posts[indexPath.row]];
    cell.delegate = self;
    
    return cell;
    
}

- (void)postCell:(PostCell *)postCell didTap:(PFUser *)user{
    
    [self performSegueWithIdentifier:@"otherProfileSegue" sender:user];
    
}

- (void)postCell:(PostCell *)postCell didComment:(NSString *)postID{
    
    [self performSegueWithIdentifier:@"commentSegue" sender:postID];
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    UINavigationController *realController = (UINavigationController *)viewController;
    
    if([realController.topViewController isKindOfClass:[HomeViewController class]]) {

        HomeViewController *selectedController = (HomeViewController *)realController.topViewController;
        [selectedController.tableView setContentOffset:CGPointZero animated:YES];
        
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextViewController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"otherProfileSegue"]){
        
        ProfileViewController *profileController = (ProfileViewController *)nextViewController;
        profileController.currUser = sender;
        [self.banner setValue:@YES forKeyPath:@"hidden"];
        
    } else if([segue.identifier isEqualToString:@"commentSegue"]) {
        
        CommentViewController *commentController = (CommentViewController *)nextViewController;
        commentController.post = sender;
        [self.banner setValue:@YES forKeyPath:@"hidden"];
    }
    
}




@end
